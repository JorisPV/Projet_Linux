#Création de la key SSH pour GRA

resource "openstack_compute_keypair_v2" "Keypair_GRA11" {
  provider   = openstack.ovh
  name       = "sshkey_eductive20"
  public_key = file("~/.ssh/id_rsa.pub")
  region     = var.region_GRA11
}

#Création de la key SSH pour SBG

resource "openstack_compute_keypair_v2" "Keypair_SBG5" {
  provider   = openstack.ovh
  name       = "sshkey_eductive20"
  public_key = file("~/.ssh/id_rsa.pub")
  region     = var.region_SBG5
}

#Création de notre instance FrontEnd

resource "openstack_compute_instance_v2" "Frontend" {
  count       = 1	  # Nombre d'instance Front			
  name        = var.instance_name_front # Nom de l'instance
  provider    = openstack.ovh        # Nom du fournisseur
  image_name  = var.image_name       # Nom de l'image
  flavor_name = var.flavor_name_instance      # Nom du type d'instance
  region      = var.region_GRA11     # Nom de la régions
  key_pair    = openstack_compute_keypair_v2.Keypair_GRA11.name
  network {
    name      = "Ext-Net"
  }
  network {
	name = ovh_cloud_project_network_private.network.name
  }
   depends_on = [ovh_cloud_project_network_private_subnet.subnet]

 }

#Création de nos instances Backend GRA11

resource "openstack_compute_instance_v2" "Backend_GRA11" {
  count       = var.nombre_instance_backend    # Nombre d'instance backend		
  name        = "${var.instance_name_gra}_${count.index+1}"  # Nom de l'instance
  provider    = openstack.ovh        # Nom du fournisseur
  image_name  = var.image_name       # Nom de l'image
  flavor_name = var.flavor_name_instance      # Nom du type d'instance
  region      = var.region_GRA11     # Nom de la régions
  key_pair    = openstack_compute_keypair_v2.Keypair_GRA11.name
  network {
	name = "Ext-Net"
  }
  network {
	name = ovh_cloud_project_network_private.network.name
  }
  depends_on = [ovh_cloud_project_network_private_subnet.subnet]
}

#Création de nos instances Backend SBG5

resource "openstack_compute_instance_v2" "Backend_SBG5" {
  count       = var.nombre_instance_backend    # Nombre d'instance backend		
  name        = "${var.instance_name_sbg}_${count.index+1}"  # Nom de l'instance
  provider    = openstack.ovh        # Nom du fournisseur
  image_name  = var.image_name       # Nom de l'image
  flavor_name = var.flavor_name_instance      # Nom du type d'instance
  region      = var.region_SBG5     # Nom de la région
  key_pair    = openstack_compute_keypair_v2.Keypair_SBG5.name
  network {
    name      = "Ext-Net"
  }
  network {
	name = ovh_cloud_project_network_private.network.name
  }
  depends_on = [ovh_cloud_project_network_private_subnet.subnet]

  }

#Création de notre DataBase

resource "ovh_cloud_project_database" "db_eductive20" {
  service_name = var.service_name
  description  = var.name_db # Nom de la DB
  engine       = "mysql" # BDD de type MYSQL
  version      = "8" # Version
  plan         = var.plan_bdd # Definir le plan de la BDD
  nodes {
    region = var.region_DB # Definir la region de la BDD
  }
  flavor = var.flavor_name_bdd # Definir la taille de la BDD
}

# Création de notre utilisateur TP pour notre BDD

resource "ovh_cloud_project_database_user" "db_eductive20" {
  service_name = ovh_cloud_project_database.db_eductive20.service_name
  engine       = "mysql"
  cluster_id   = ovh_cloud_project_database.db_eductive20.id
  name         = "eductive20"
}

# Création de notre DB nommé Terraform

resource "ovh_cloud_project_database_database" "database" {
  service_name  = ovh_cloud_project_database.db_eductive20.service_name
  engine        = ovh_cloud_project_database.db_eductive20.engine
  cluster_id    = ovh_cloud_project_database.db_eductive20.id
  name          = "wordpress"
}

# Autorisation des IPS de GRA11

resource "ovh_cloud_project_database_ip_restriction" "db_eductive20_gra" {
  count        = length(openstack_compute_instance_v2.Backend_GRA11)
  service_name = ovh_cloud_project_database.db_eductive20.service_name
  engine       = ovh_cloud_project_database.db_eductive20.engine
  cluster_id   = ovh_cloud_project_database.db_eductive20.id
  ip           = "${openstack_compute_instance_v2.Backend_GRA11[count.index].access_ip_v4}/32"
}

# Autorisation des IPS de SBG5

resource "ovh_cloud_project_database_ip_restriction" "db_eductive20_sbg" {
  count        = length(openstack_compute_instance_v2.Backend_SBG5)
  service_name = ovh_cloud_project_database.db_eductive20.service_name
  engine       = ovh_cloud_project_database.db_eductive20.engine
  cluster_id   = ovh_cloud_project_database.db_eductive20.id
  ip           = "${openstack_compute_instance_v2.Backend_SBG5[count.index].access_ip_v4}/32"
}

# Création d'un réseau privé

 resource "ovh_cloud_project_network_private" "network" {
    name         = "vrack_private_network_20"  # Nom du réseau
    service_name = var.service_name #Nom du service
    regions      = var.regions    # Nom de la région
    provider     = ovh.ovh     # Nom du fournisseur
    vlan_id      = var.vlan_id    # Identifiant du vlan pour le vRrack
 }

resource "ovh_cloud_project_network_private_subnet" "subnet" {
    count        = length(var.regions)
    service_name = var.service_name
    network_id   = ovh_cloud_project_network_private.network.id
    start        = var.vlan_dhcp_start                          # Première IP du sous réseau
    end          = var.vlan_dhcp_end                            # Dernière IP du sous réseau
    network      = var.vlan_dhcp_network
    dhcp         = true                                         # Activation du DHCP
    region       = var.regions[count.index]
    provider     = ovh.ovh                                      # Nom du fournisseur
    no_gateway   = true                                         # Pas de gateway par defaut
 }

# Inventaire Ansible

 resource "local_file" "inventory" {
  filename = "../ansible/inventory.yml"
  content = templatefile("inventory.tmpl",
    {
      backend_gra = [for k, p in openstack_compute_instance_v2.Backend_GRA11: p.access_ip_v4],
      backend_sbg = [for k, p in openstack_compute_instance_v2.Backend_SBG5: p.access_ip_v4],
      frontend = openstack_compute_instance_v2.Frontend[0].access_ip_v4
      host = ovh_cloud_project_database.db_eductive20.endpoints[0].domain
      user = ovh_cloud_project_database_user.db_eductive20.name,
      port = ovh_cloud_project_database.db_eductive20.endpoints[0].port
      mdp = ovh_cloud_project_database_user.db_eductive20.password
      wordpress = ovh_cloud_project_database_database.database.name,
    }
  )
}
