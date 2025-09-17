# Include the root Terragrunt configuration  
include "root" {
  path = find_in_parent_folders()
}

# Specify the Terraform module source
terraform {
    source = "../../../modules//resource-group"
    extra_arguments "custom_vars" {
    commands = [
      "apply",
      "plan", 
      "import",
      "push",
      "refresh"
    ]

    arguments = [
      "-var-file=${get_terragrunt_dir()}/terraform.tfvars"
    ]
  }

}