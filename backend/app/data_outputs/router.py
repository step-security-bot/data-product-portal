from uuid import UUID

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.core.auth.auth import get_authenticated_user
from app.data_outputs.schema import DataOutput, DataOutputCreate
from app.data_outputs.service import DataOutputService
from app.database.database import get_db_session
from app.users.schema import User

router = APIRouter(prefix="/data_outputs", tags=["data_outputs"])


@router.get("")
def get_data_outputs(db: Session = Depends(get_db_session)) -> list[DataOutput]:
    return DataOutputService().get_data_outputs(db)


@router.get("/{id}")
def get_data_output(id: UUID, db: Session = Depends(get_db_session)) -> DataOutput:
    return DataOutputService().get_data_output(id, db)


@router.post(
    "",
    responses={
        200: {
            "description": "DataOutput successfully created",
            "content": {
                "application/json": {
                    "example": {"id": "random id of the new data_output"}
                }
            },
        },
    },
)
def create_data_output(
    data_output: DataOutputCreate, db: Session = Depends(get_db_session)
) -> dict[str, UUID]:
    return DataOutputService().create_data_output(data_output, db)


@router.post(
    "/{id}/dataset/{dataset_id}",
    responses={
        400: {
            "description": "Dataset not found",
            "content": {
                "application/json": {"example": {"detail": "Dataset not found"}}
            },
        },
        404: {
            "description": "Data Product not found",
            "content": {
                "application/json": {"example": {"detail": "Data Product id not found"}}
            },
        },
    },
)
def link_dataset_to_data_output(
    id: UUID,
    dataset_id: UUID,
    authenticated_user: User = Depends(get_authenticated_user),
    db: Session = Depends(get_db_session),
):
    return DataOutputService().link_dataset_to_data_output(
        id, dataset_id, authenticated_user, db
    )


@router.delete(
    "/{id}/dataset/{dataset_id}",
    responses={
        400: {
            "description": "Dataset not found",
            "content": {
                "application/json": {"example": {"detail": "Dataset not found"}}
            },
        },
        404: {
            "description": "Data Product not found",
            "content": {
                "application/json": {"example": {"detail": "Data Product id not found"}}
            },
        },
    },
)
def unlink_dataset_from_data_output(
    id: UUID,
    dataset_id: UUID,
    authenticated_user: User = Depends(get_authenticated_user),
    db: Session = Depends(get_db_session),
):
    return DataOutputService().unlink_dataset_from_data_output(
        id, dataset_id, authenticated_user, db
    )