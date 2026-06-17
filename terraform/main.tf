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