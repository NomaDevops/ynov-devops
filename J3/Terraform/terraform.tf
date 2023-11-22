resource "azurerm_resource_group" "rg" {
  name     = "rg"
  location = "France Central"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "exampleaks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "local_file" "kube_config" {
  content  = azurerm_kubernetes_cluster.aks.kube_config_raw
  filename = ".kube/config"
}

resource "helm_release" "nginx_ingress" {
  name             = "nginx-ingress-controller"
  namespace        = "nginx-ingress-controller"
  create_namespace = true
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "nginx-ingress-controller"
  version          = "9.4.1"
  force_update     = true
  set {
    name  = "controller.service.annotations.service.beta.kubernetes.io/azure-load-balancer-health-probe-request-path"
    value = "/healthz"
  }

  set {
    name  = "controller.service.externalTrafficPolicy"
    value = "Local"
  }

  depends_on = [
    azurerm_kubernetes_cluster.aks,
    local_file.kube_config
  ]

  lifecycle {
    replace_triggered_by = [
      local_file.kube_config,
      azurerm_kubernetes_cluster.aks
    ]
  }
}

resource "helm_release" "redis" {
  name             = "redis"
  namespace        = "redis"
  create_namespace = true
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "redis"
  version          = "v17.9.2"
  force_update     = true

  set {
    name  = "global.redis.password"
    value = "plop"
  }

  set {
    name  = "replica.replicaCount"
    value = 1
  }

  depends_on = [
    azurerm_kubernetes_cluster.aks,
    local_file.kube_config
  ]

  lifecycle {
    replace_triggered_by = [
      local_file.kube_config,
      azurerm_kubernetes_cluster.aks
    ]
  }
}

resource "helm_release" "kubecost" {
  repository = "https://kubecost.github.io/cost-analyzer/"
  chart = "cost-analyzer"
  name = "cost-analyzer"
  create_namespace = true
  namespace = "kubecost"
  cleanup_on_fail = true
  force_update = true

  set_sensitive {
    name = "kubecostToken"
    value = "to_replace"
  }

  set {
    name = "ingress.enabled"
    value = "true"
  }

  set {
    name = "ingress.className"
    value = "nginx"
  }

  set_list {
    name = "ingress.hosts"
    value = ["cost-analyzer.local"]
  }

  lifecycle {
    replace_triggered_by = [
      local_file.kube_config,
      azurerm_kubernetes_cluster.aks
    ]
  }
  
}