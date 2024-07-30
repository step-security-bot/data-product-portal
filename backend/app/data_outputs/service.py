from datetime import datetime
from uuid import UUID

import pytz
from fastapi import HTTPException, status
from sqlalchemy.orm import Session

from app.core.aws.refresh_infrastructure_lambda import RefreshInfrastructureLambda
from app.data_outputs.model import DataOutput as DataOutputModel
from app.data_outputs.model import ensure_data_output_exists
from app.data_outputs.schema import DataOutput, DataOutputCreate, DataOutputToDB
from app.data_outputs.schema_union import DataOutputMap
from app.data_outputs_datasets.enums import DataOutputDatasetLinkStatus
from app.data_outputs_datasets.model import (
    DataOutputDatasetAssociation as DataOutputDatasetAssociationModel,
)
from app.data_product_memberships.enums import DataProductUserRole
from app.datasets.enums import DatasetAccessType
from app.datasets.model import ensure_dataset_exists
from app.users.schema import User


class DataOutputService:
    @staticmethod
    def ensure_owner(authenticated_user: User, data_output: DataOutput):
        if authenticated_user.is_admin:
            return

        data_product_membership = next(
            (
                membership
                for membership in data_output.owner.memberships
                if membership.user_id == authenticated_user.id
            ),
            None,
        )
        if (
            data_product_membership is None
            or data_product_membership.role != DataProductUserRole.OWNER
        ):
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Only owners can execute this operation",
            )

    def get_data_outputs(self, db: Session) -> list[DataOutput]:
        data_outputs = db.query(DataOutputModel).all()
        parsed_data_outputs = []
        for data_output in data_outputs:
            parsed_data_output = data_output
            parsed_data_output.configuration = DataOutputMap[
                data_output.configuration_type
            ].model_validate_json(data_output.configuration)
            parsed_data_outputs.append(parsed_data_output)
        return parsed_data_outputs

    def get_data_output(self, id: UUID, db: Session) -> DataOutput:
        return db.query(DataOutputModel).filter(DataOutputModel.id == id).first()

    def create_data_output(
        self, data_output: DataOutputCreate, db: Session
    ) -> dict[str, UUID]:
        data_output = DataOutputToDB(
            name=data_output.name,
            description=data_output.description,
            external_id=data_output.external_id,
            owner_id=data_output.owner_id,
            configuration=data_output.configuration.model_dump_json(),
            configuration_type=data_output.configuration.configuration_type,
        )
        data_output = DataOutputModel(**data_output.parse_pydantic_schema())

        db.add(data_output)
        db.commit()

        # config.on_create()
        RefreshInfrastructureLambda().trigger()
        return {"id": data_output.id}

    def link_dataset_to_data_output(
        self, id: UUID, dataset_id: UUID, authenticated_user: User, db: Session
    ):
        dataset = ensure_dataset_exists(dataset_id, db)
        data_output = ensure_data_output_exists(id, db)
        self.ensure_owner(authenticated_user, data_output)

        if dataset.id in [
            link.dataset_id
            for link in data_output.dataset_links
            if link.status != DataOutputDatasetLinkStatus.DENIED
        ]:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"Dataset {dataset_id} already exists in data product {id}",
            )
        approval_status = (
            DataOutputDatasetLinkStatus.PENDING_APPROVAL
            if dataset.access_type != DatasetAccessType.PUBLIC
            else DataOutputDatasetLinkStatus.APPROVED
        )

        dataset_link = DataOutputDatasetAssociationModel(
            dataset_id=dataset_id,
            status=approval_status,
            requested_by=authenticated_user,
            requested_on=datetime.now(tz=pytz.utc),
        )
        data_output.dataset_links.append(dataset_link)
        db.commit()
        db.refresh(data_output)
        RefreshInfrastructureLambda().trigger()
        return {"id": dataset_link.id}

    def unlink_dataset_from_data_output(
        self, id: UUID, dataset_id: UUID, authenticated_user: User, db: Session
    ):
        ensure_dataset_exists(dataset_id, db)
        data_output = ensure_data_output_exists(id, db)
        self.ensure_owner(authenticated_user, data_output)
        data_output_dataset = next(
            (
                dataset
                for dataset in data_output.dataset_links
                if dataset.dataset_id == dataset_id
            ),
            None,
        )
        if not data_output_dataset:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Data product dataset for data output {id} not found",
            )
        data_output.dataset_links.remove(data_output_dataset)
        db.commit()
        RefreshInfrastructureLambda().trigger()