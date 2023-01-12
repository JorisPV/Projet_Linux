# Variable définissant la région GRA11 pour les instances
variable "region_GRA11" {
  default = "GRA11"
  type    = string
}

# Variable définissant la région SBG5 pour les instances
variable "region_SBG5" {
  default = "SBG5"
  type    = string
}

# Variable définissant la région GRA pour la DB
variable "region_DB" {
  default = "GRA"
  type    = string
}

# Liste des régions disponible
variable "regions" {
   default = ["GRA11","SBG5"]
   type    = list
}

# Nombre d'instance Backend
variable "nombre_instance_backend" {
   type = number
   default = 3
}

# Nom de l'instance Frontend
variable "instance_name_front" {
  type     = string 
  default  = "front_eductive20"
}

# Nom de l'instance Backend GRA
variable "instance_name_gra" {
  type     = string 
  default  = "backend_eductive20_gra"
}

# Nom de l'instance Backend SBG
variable "instance_name_sbg" {
  type    = string
  default = "backend_eductive20_sbg"
}

# Nom utilisateur DB
variable "name_db" {
  type    = string
  default = "tp"
}

# Nom du service
variable "service_name" {
  type    = string
}

# Nom de l'image
variable "image_name"{
  type    = string 
  default = "Debian 11"
}

# Définition de la taille d'une instance
variable "flavor_name_instance" {
  type    = string 
  default = "s1-2"
}

# Définition de la taille d'une BDD
variable "flavor_name_bdd" {
  type    = string 
  default = "db1-4"
}

# Définition du plan de la DB
variable "plan_bdd" {
  type    = string 
  default = "essential"
}

# VLAN ID
variable "vlan_id" {
  type    = number
  default = 20
}

# Définition du VLAN
variable "vlan_dhcp_network" {
  type = string
  default = "192.168.20.0/24"
}

# Début du DHCP
variable "vlan_dhcp_start" {
  type = string
  default = "192.168.20.100"
}

# Fin du DHCP
variable "vlan_dhcp_end" {
  type = string
  default = "192.168.20.200"
}
