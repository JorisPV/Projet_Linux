variable "region_GRA11" { # Variable définissant la région GRA11 pour les instances
  default = "GRA11"
  type    = string
}

variable "region_SBG5" { # Variable définissant la région SBG5 pour les instances
  default = "SBG5"
  type    = string
}

variable "region_DB" { # Variable définissant la région GRA pour la DB
  default = "GRA"
  type    = string
}

variable "regions" { # Liste des régions disponible
   default = ["GRA11","SBG5"]
   type    = list
}

variable "nombre_instance_backend" { # Nombre d'instance Backend
   type = number
   default = 3
}

variable "instance_name_front" { # Nom de l'instance Frontend
  type     = string 
  default  = "front_eductive20"
}

variable "instance_name_gra" { # Nom de l'instance Backend GRA
  type     = string 
  default  = "backend_eductive20_gra"
}

variable "instance_name_sbg" { # Nom de l'instance Backend SBG
  type    = string
  default = "backend_eductive20_sbg"
}

variable "name_db" { # Nom utilisateur DB
  type    = string
  default = "tp"
}

variable "service_name" { # Nom du service
  type    = string
}

variable "image_name"{ # Nom de l'image
  type    = string 
  default = "Debian 11"
}

variable "flavor_name_instance" { # Définition de la taille d'une instance
  type    = string 
  default = "s1-2"
}

variable "flavor_name_bdd" { # Définition de la taille d'une BDD
  type    = string 
  default = "db1-4"
}

variable "plan_bdd" { # Définition du plan de la DB
  type    = string 
  default = "essential"
}

variable "vlan_id" { # VLAN ID
  type    = number
  default = 20
}

variable "vlan_dhcp_network" { # Définition du VLAN
  type = string
  default = "192.168.20.0/24"
}

variable "vlan_dhcp_start" { # Début du DHCP
  type = string
  default = "192.168.20.100"
}

variable "vlan_dhcp_end" { # Fin du DHCP
  type = string
  default = "192.168.20.200"
}
