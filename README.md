



# terraform-openstack-create-instnace-modules

> Before You Begin
> 
> Prepare
> 
> Start Terraform

## Before You Begin
To successfully perform this tutorial, you must have the following:

   * [openstack install guide](https://docs.openstack.org/install-guide/)
	   * When installing, make sure to install the Identity as v3.

## Prepare
Prepare your environment for authenticating and running your Terraform scripts. Also, gather the information your account needs to authenticate the scripts.

### Install Terraform
   Install the latest version of Terraform **v1.3.0+**:

   1. In your environment, check your Terraform version.
      ```script
      terraform -v
      ```

      If you don't have Terraform **v1.3.0+**, then install Terraform using the following steps.

   2. From a browser, go to [Download Latest Terraform Release](https://www.terraform.io/downloads.html).

   3. Find the link for your environment and then follow the instructions for your environment. Alternatively, you can perform the following steps. Here is an example for installing Terraform v1.3.3 on Linux 64-bit.

   4. In your environment, create a temp directory and change to that directory:
      ```script
      mkdir temp
      ```
      ```script
      cd temp
      ```

   5. Download the Terraform zip file. Example:
      ```script
      wget https://releases.hashicorp.com/terraform/1.3.3/terraform_1.3.3_linux_amd64.zip
      ```

   6. Unzip the file. Example:
      ```script
      unzip terraform_1.3.3_linux_amd64.zip
      ```

   7. Move the folder to /usr/local/bin or its equivalent in Mac. Example:
      ```script
      sudo mv terraform /usr/local/bin
      ```

   8. Go back to your home directory:
      ```script
      cd
      ```

   9. Check the Terraform version:
      ```script
      terraform -v
      ```

      Example: `Terraform v1.3.3 on linux_amd64`.

### Get API-Key
   We need the provider information below to use the nhn terraform.
   * **auth_url**
	   - The Identity authentication URL.
   * **region**
	   -   The region of the OpenStack cloud to use.
   * **application_credential_id**
	   - The ID of an application credential to authenticate with. An application_credential_secret has to bet set along with this parameter.
   * **application_credential_name**
	   - The name of an application credential to authenticate with.
   * **application_credential_secret**
	   - The secret of an application credential to authenticate with.
   
	![Account User](https://raw.githubusercontent.com/ZConverter-samples/terraform-openstack-create-instnace-modules/master/images/credential_info.png)

##  Start Terraform

* To use terraform, you must have a terraform file of command written and a terraform executable.
* You should create a folder to use terraform, create a `terraform.tf` file, and enter the contents below.
	```
	#Define required providers
	terraform {
		required_version  =  ">= 1.3.0"
		required_providers {
			openstack  =  {
				source = "terraform-provider-openstack/openstack"
				version = "1.48.0"
			}
		}
	}

	#Configure the OpenStack Provider
	provider  "openstack" {
		user_name  = var.terraform_data.provider.user_name
		auth_url  = var.terraform_data.provider.auth_url
		application_credential_name  = var.terraform_data.provider.application_credential_name
		application_credential_id  = var.terraform_data.provider.application_credential_id
		application_credential_secret  = var.terraform_data.provider.application_credential_secret
		region  = var.terraform_data.provider.region
	}
	
	#variable
	variable  "terraform_data" {
		type  =  object({
			provider = object({
				auth_url = string
				application_credential_name = string
				application_credential_id = string
				application_credential_secret = string
				region = string
			})
			vm_info = object({
				vm_name = string
				OS_name = string
				OS_boot_size = number
				flavor_name = string
				create_key_pair_name = string
				private_network_name = string
				external_network_name = string
				security_group_name = optional(string,null)
				create_security_group_name = optional(string,null)
				create_security_group_rules = optional(list(object({
					direction = optional(string,null)
					ethertype = optional(string,null)
					protocol = optional(string,null)
					port_range_min = optional(string,null)
					port_range_max = optional(string,null)
					remote_ip_prefix = optional(string,null)
				})),null)
				user_data_file_path = optional(string,null)
				additional_volumes = optional(list(number),[])
			})
		})
	}

	#create_instance
	module  "create_nhn_instance" {
		source  =  "git::https://github.com/ZConverter-samples/terraform-openstack-create-instnace-modules.git"
		region  =  var.terraform_data.provider.region
		vm_name  =  var.terraform_data.vm_info.vm_name
		OS_name  =  var.terraform_data.vm_info.OS_name
		OS_boot_size  =  var.terraform_data.vm_info.OS_boot_size
		flavor_name  =  var.terraform_data.vm_info.flavor_name
		create_key_pair_name  =  var.terraform_data.vm_info.create_key_pair_name
		private_network_name  =  var.terraform_data.vm_info.private_network_name
		external_network_name  =  var.terraform_data.vm_info.external_network_name
		security_group_name  =  null
		create_security_group_name  =  var.terraform_data.vm_info.create_security_group_name
		create_security_group_rules  =  var.terraform_data.vm_info.create_security_group_rules
		user_data_file_path  =  var.terraform_data.vm_info.user_data_file_path
		volume  =  var.terraform_data.vm_info.additional_volumes
	}
   ```
* After creating the nhn_terraform.json file to enter the user's value, you must enter the contents below. 
* ***The openstack_terraform.json below is an example of a required value only. See below the Attributes table for a complete example.***
* ***There is an attribute table for input values under the script, so you must refer to it.***
	```
	{
		"terraform_data" : {
			"provider" : {
				"auth_url" : "https://***.***.***.***:5000",
				"application_credential_name" : "terraform",
				"application_credential_id" : "52cb3430939**********************",
				"application_credential_secret" : "***********************",
				"region" : "RegionOne"
			},
			"vm_info" : {
				"vm_name" : "test",
				"OS_name" : "centos7",
				"OS_boot_size" : 20,
				"flavor_name" : "m1.medium",
				"create_key_pair_name" : "terraform",
				"private_network_name" : "private_network",
				"external_network_name" : "external_network",
				"create_security_group_name" : "sg_list",
				"create_security_group_rules" : [{
					"direction" : "ingress",
					"ethertype" : "IPv4",
					"protocol" : "tcp",
					"port_range_min" : "22",
					"port_range_max" : "22",
					"remote_ip_prefix" : "0.0.0.0/0"
				}],
				"user_data_file_path" : "./userdata.sh",
				"additional_volumes" : [20]
			}
		}
	}
	```
### Attribute Table
|Attribute|Data Type|Required|Default Value|Description|
|---------|---------|--------|-------------|-----------|
| terraform_data.provider.auth_url | string | yes | none |The auth_url you recorded in the memo during the [preparation step](#get-api-key).|
| terraform_data.provider.application_credential_name | string | yes | none |The application_credential_name you recorded in the memo during the [preparation step](#get-api-key).|
| terraform_data.provider.application_credential_id | string | yes | none |The application_credential_id you recorded in the memo during the [preparation step](#get-api-key).|
| terraform_data.provider.application_credential_secret | string | yes | none |The application_credential_secret you recorded in the memo during the [preparation step](#get-api-key).|
| terraform_data.provider.region | string | yes | none |The region you recorded in the memo during the [preparation step](#get-api-key).|
| terraform_data.vm_info.vm_name | string | yes | none |The name of the instance you want to create.|
| terraform_data.vm_info.OS_name | string | yes | none |The name of the OS you uploaded.|
| terraform_data.vm_info.OS_boot_size | number | no | none |Boot volume size of the instance you want to create.|
| terraform_data.vm_info.flavor_name| string | yes | none |Flavor types defined in your open stack.|
| terraform_data.vm_info.private_network_name | string | yes | none | The name of the Private Network you want to use.|
| terraform_data.vm_info.external_network_name | string | yes | none | The name of the Public Network you want to use.|
| terraform_data.vm_info.create_security_group_name | string | no | none | The name of the Security-Group to create.|
| terraform_data.vm_info.create_security_group_rules | list | no | none |	When you need to create ingress and egress rules.|
| terraform_data.vm_info.create_security_group_rules.[*].direction | stirng | conditional | none | Either "ingress" or "egress"|
| terraform_data.vm_info.create_security_group_rules.[*].ethertype | string | conditional | none | Either "IPv4" or "IPv6" |
| terraform_data.vm_info.create_security_group_rules.[*].protocol | string | conditional | none | Enter a supported protocol name |
| terraform_data.vm_info.create_security_group_rules.[*].port_range_min | string | conditional | none | Minimum Port Range (Use only when using udp, tcp protocol) |
| terraform_data.vm_info.create_security_group_rules.[*].port_range_max | string | conditional | none | Maximum Port Range (Use only when using udp, tcp protocol) |
| terraform_data.vm_info.create_security_group_rules.[*].remote_ip_prefix | string | conditional | none | CIDR (ex : 0.0.0.0/0) |
| terraform_data.vm_info.ssh_public_key | string | conditional | none | ssh public key to use when using Linux-based OS. (Use only one of the following: ssh_public_key, ssh_public_key_file_path) |
| terraform_data.vm_info.ssh_public_key_file | string | conditional | none | Absolute path of ssh public key file to use when using Linux-based OS. (Use only one of the following: ssh_public_key, ssh_public_key_file_path) |
| terraform_data.vm_info.user_data_file_path | string | conditional | none | Absolute path of user data file path to use when cloud-init. |
| terraform_data.vm_info.additional_volumes | string | conditional | none | Use to add a block volume. Use numeric arrays. |

* **Go to the file path of Terraform.exe and Initialize the working directory containing the terraform configuration file.**

   ```
   terraform init
   ```
   * **Note**
       -chdir : When you use a chdir the usual way to run Terraform is to first switch to the directory containing the `.tf` files for your root module (for example, using the `cd` command), so that Terraform will find those files automatically without any extra arguments. (ex : terraform -chdir=\<terraform data file path\> init)

* **Creates an execution plan. By default, creating a plan consists of:**
  * Reading the current state of any already-existing remote objects to make sure that the Terraform state is up-to-date.
  * Comparing the current configuration to the prior state and noting any differences.
  * Proposing a set of change actions that should, if applied, make the remote objects match the configuration.
   ```
   terraform plan -var-file=<Absolute path of nhn_terraform.json>
   ```
  * **Note**
	* -var-file : When you use a var-file Sets values for potentially many [input variables](https://www.terraform.io/docs/language/values/variables.html) declared in the root module of the configuration, using definitions from a ["tfvars" file](https://www.terraform.io/docs/language/values/variables.html#variable-definitions-tfvars-files). Use this option multiple times to include values from more than one file.
     * The file name of vars.tfvars can be changed.

* **Executes the actions proposed in a Terraform plan.**
   ```
   terraform apply -var-file=<Absolute path of nhn_terraform.json> -auto-approve
   ```
* **Note**
	* -auto-approve : Skips interactive approval of plan before applying. This option is ignored when you pass a previously-saved plan file, because Terraform considers you passing the plan file as the approval and so will never prompt in that case.
