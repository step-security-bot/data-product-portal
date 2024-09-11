from app.data_outputs.data_output_types import DataOutputTypes
from app.data_products.schema import DataProduct
from app.shared.schema import ORMModel


class GlueDataOutput(ORMModel):
    glue_database: str
    table_prefixes: list[str]
    configuration_type: DataOutputTypes = DataOutputTypes.GlueDataOutput

    def validate_configuration(self, data_product: DataProduct):
        pass

    def on_create(self):
        pass