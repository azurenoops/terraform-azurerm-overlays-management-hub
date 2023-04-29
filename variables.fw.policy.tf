# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#####################################
# Firewall Policy Configuration    ##
#####################################

variable "application_rule_collection" {
  default     = {}
  description = <<EOD
    application_rule_collection = [
        {
            name     = "default_app_rules"
            priority = 500
            action   = "Allow"
            rules = [
                {
                    name              = "default_app_rules_rule1"
                    source_addresses  = ["10.0.0.0/24"]
                    destination_fqdns = ["www.google.co.uk"]
                    protocols         = [
                        {
                            type = "http"
                            port = 80
                        },
                        {
                            type = "https"
                            port = 443
                        }
                    ]
                },
                {
                    name                  = "default_app_rules_rule2"
                    source_addresses      = ["10.0.0.0/24"]
                    destination_fqdn_tags = ["Windows Update"]
                    protocols             = [
                        {
                            type = "https"
                            port = 443
                        },
                        {
                            type = "http"
                            port = 80
                        },
                    ]
                }
            ]
        },
        {
            name     = "ASE_app_rules"
            priority = 600
            action   = "Allow"
            rules = [
                {
                    name                  = "ASE_app_rules_rule1"
                    source_addresses      = ["10.0.0.0/24"]
                    destination_fqdn_tags = ["App Service Environment (ASE)"]
                    protocols             = [
                        {
                            type = "https"
                            port = 443
                        }
                    ]
                }
            ]
        }
    ]
EOD
}


variable "network_rule_collection" {
  default     = {}
  description = <<EOD
    network_rule_collections = [
        {
            name = "default_network_rules"
            priority = "500"
            action = "Allow"
            rules = [
                {
                    name                  = "default_network_rules_AllowRDP" 
                    protocols             = ["TCP"]
                    source_addresses      = ["10.0.0.1"]
                    destination_addresses = ["192.168.0.21"]
                    destination_ports     = ["3389"]
                },
                {
                    name                  = "default_network_rules_AllowSSH" 
                    protocols             = ["TCP"]
                    source_addresses      = ["10.0.0.1"]
                    destination_addresses = ["192.168.0.22"]
                    destination_ports     = ["22"]
                }
            ]
        }
    ]
EOD
}

variable "nat_rule_collections" {
  default     = {}
  description = <<EOD
    name     = nat_rule_collection1
    priority = "300"
    action   = "Dnat"     # Only 'Dnat' is possible
    rules    = [
        {
            name                = "nat_rule_collection1_rule1"
            protocols           = ["TCP"]
            source_addresses    = ["10.0.0.1", "10.0.0.2"]
            destination_address = "192.168.1.1"
            destination_ports   = ["80"]
            translated_address  = "192.168.0.1"
            translated_port     = "8080"
        }
    ]
EOD
}
