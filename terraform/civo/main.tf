terraform {
  backend "s3" {
    bucket   = "k1-state-store-spotlight-0vzcwy"
    key      = "terraform/civo/terraform.tfstate"
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
      version = "= 1.1.0"
    }
  }
}
provider "civo" {
  region = "lon1"
}

locals {
  cluster_name         = "spotlight"
  kube_config_filename = "../../../kubeconfig"
}

resource "civo_network" "kubefirst" {
  label = local.cluster_name
}

resource "civo_firewall" "kubefirst" {
  name                 = local.cluster_name
  network_id           = civo_network.kubefirst.id
  create_default_rules = true
}

resource "civo_kubernetes_cluster" "kubefirst" {
  name                = local.cluster_name
  network_id          = civo_network.kubefirst.id
  firewall_id         = civo_firewall.kubefirst.id
  kubernetes_version  = "1.28.7-k3s1"
  write_kubeconfig    = true
  pools {
    label      = local.cluster_name
    size       = "g4s.kube.large"
    node_count = tonumber("6") # tonumber() is used for a string token value
  }
}

resource "local_file" "kubeconfig" {
  content  = civo_kubernetes_cluster.kubefirst.kubeconfig
  filename = local.kube_config_filename
}
