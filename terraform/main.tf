module "bronze" {
    source = "./modules/s3"
    project_name = var.project_name
    environment = var.environment
    layer = "bronze"
}

module "silver" {
    source = "./modules/s3"
    project_name = var.project_name
    environment = var.environment
    layer = "silver"
}

module "gold" {
    source = "./modules/s3"
    project_name = var.project_name
    environment = var.environment
    layer = "gold"
}

module "lambda" {
    source = "./modules/lambda"
    project_name = var.project_name
    environment = var.environment
    source_code_path = "../src/ingestion"
    layer_path = "../lambda_layer"
    runtime = "python3.12"
    timeout = 300
    memory = 512
    bronze_bucket_arn = module.bronze.bucket_arn
    environment_variables = {
        BRONZE_BUCKET = module.bronze.bucket_name
    }
    lambda_assets_bucket = "chris-yfinance-pipeline-tf-state-381492137321-ap-southeast-2-an"
}
