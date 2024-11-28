terraform {
  backend "s3" {
    bucket   = "k1-state-store-spotlight-0vzcwy"
    key      = "terraform/vault/terraform.tfstate"
    endpoint = "https://objectstore.lon1.civo.com"

    region = "lon1"

    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    force_path_style            = true
  }
  required_providers {
    civo = {
      source = "civo/civo"
    }
    vault = {
      source = "hashicorp/vault"
    }
  }
}

# export CIVO_TOKEN=$MYTOKEN is set 
provider "civo" {
  region = "lon1"
}

provider "vault" {
  skip_tls_verify = "true"
}
