1. Create a project on GCP (Google Cloud Platform)

2.Create a Service account for the project
    2.1 IAM & Admin -> Service Accounts
        >> Google Cloud IAM and Admin Service accoun
          >> In my case, I have kept the name "gcp-terraform-acc"
          
3. Assign additional roles to the Service Account
  3.1 Add Project --> Owner role
    Now you have created your service account and in the third step we are going to create our first role for the service account.
    In the roles dropdown look for Project and inside project add Owner role.

    Project --> Owner

    Google Cloud add project owner role


  3.2 Add Compute --> Compute admin role
    The next role which we need is Compute Admin Role available inside Compute

    Compute Engine --> Compute Admin Role

    Google Cloud add compute admin role

  3.3 Add Compute --> Compute Network Admin
    The third role which you need to add is Compute Network Admin available inside Compute

    Compute Engine --> Compute Network Admin

    Google Cloud add compute network admin role for service account

4. Generate Keys for Service Account
    After adding the roles now we need to generate the keys for the authorization. We are going to use these keys from our Terrafrom module later.

    From the service account list select the account which you have created (In my case the service account name is gcp-terrafrom-acc) and then click on the 3 dots options.

    Google Cloud select account for keys creation
    Now you need to look for the manage keys options -

     Google Cloud manage keys >>> Under the Keys section click on ADD KEY -> Create New Key
    Google Cloud select account for keys creation
    In the next option, you need to select the type of key. For the current example, we are going to select the JSON.

  Google Cloud select key as JSON
  Now you need to download the key and save it somewhere onto your local computer. (It would be nice if you could rename the file JSON keys file, I have renamed it - gcp-account.json but you can choose any name of your choice)

5. Prepare terraform file "main.tf"
  Now we are going to write our first Terrafrom script. Create a file named main.tf

  5.1 Add the provider details
    As you know we are going to provision the virtual machine on Google, so we need to select the provider as google.

provider "google" {
     credentials = file("gcp-account.json")
     project     = "gcp-terraform-307119"
     region      = "europe-west4"
     zone        = "europe-west4-a"
}

Few points to take care -
gcp-account.json - It is the JSON key file which we have downloaded in Step 4 . Please save the gcp-account.json at the same location where you have created main.tf
project - You need to mention the Project ID from your google console
region && zone - Select the region and zone which is near from your current location

   5.2 Add "google_compute_instance" instance
      Since we aim to create a Virtual Machine on Google Cloud Platform, so we need to add google_compute_instance configuration.

resource "google_compute_instance" "default" {
  name         = "test"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }
}

Few points to take care -
name - You can keep the name of your virtual instance as per your choice
machine_type - I have chosen e2-micro but you can choose from - e2-small, e2-medium, e2-standard-2 etc.
boot_disk - Here you need to mention the host OS and I have opted for - debian-cloud/debian-9
network_interface - This configuration is needed for getting the IP address of the virtual machine.

6. Run - terraform init, terraform plan, terraform apply
    Now we have completed all the pre-requisites needed for provisioning the Virtual Machine(VM) on Google Cloud.

  The first command which we are going to run is -

  6.1 terraform init
    The first command we need to run is -

    terraform init 

This command is going to download all the required dependencies based on the provider name mentioned in the main.tf. In the current example the provider name is Google so it is going to install Google's terraform dependencies onto your laptop.

You should see something similar in your console -

Initializing the backend...

Initializing provider plugins...
- Reusing the previous version of hashicorp/google from the dependency lock file
- Installing hashicorp/google v3.59.0...
- Installed hashicorp/google v3.59.0 (signed by HashiCorp)

Terraform has been successfully initialized! 


 6.2 terraform plan
    The second command which we are going to run is -

terraform plan 

This command tells you -

How many resources are going to be created
How many resources are going to be destroyed
How many resources are going to change.
Note - terraform plan never creates the VM on google plan, it just tells you what it is going to perform.

As you know this is our first example so the terraform plan is going to create 1 resource for us.

Here is the output of the command -

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # google_compute_instance.default will be created
  + resource "google_compute_instance" "default" {
      + can_ip_forward       = false
      + cpu_platform         = (known after apply)
      + current_status       = (known after apply)
      + deletion_protection  = false
      + guest_accelerator    = (known after apply)
      + id                   = (known after apply)
      + instance_id          = (known after apply)
      + label_fingerprint    = (known after apply)
      + machine_type         = "e2-micro"
      + metadata_fingerprint = (known after apply)
      + min_cpu_platform     = (known after apply)
      + name                 = "test"
      + project              = (known after apply)
      + self_link            = (known after apply)
      + tags_fingerprint     = (known after apply)
      + zone                 = (known after apply)

      + boot_disk {
          + auto_delete                = true
          + device_name                = (known after apply)
          + disk_encryption_key_sha256 = (known after apply)
          + kms_key_self_link          = (known after apply)
          + mode                       = "READ_WRITE"
          + source                     = (known after apply)

          + initialize_params {
              + image  = "debian-cloud/debian-9"
              + labels = (known after apply)
              + size   = (known after apply)
              + type   = (known after apply)
            }
        }

      + confidential_instance_config {
          + enable_confidential_compute = (known after apply)
        }

      + network_interface {
          + name               = (known after apply)
          + network            = "default"
          + network_ip         = (known after apply)
          + subnetwork         = (known after apply)
          + subnetwork_project = (known after apply)

          + access_config {
              + nat_ip       = (known after apply)
              + network_tier = (known after apply)
            }
        }

      + scheduling {
          + automatic_restart   = (known after apply)
          + on_host_maintenance = (known after apply)
          + preemptible         = (known after apply)

          + node_affinities {
              + key      = (known after apply)
              + operator = (known after apply)
              + values   = (known after apply)
            }
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------

6.3 terraform apply
  The final command which we are going to run is terraform apply.

  This command is going to install/setup the virtual machine on Google Cloud.

terraform apply 

After running the above command you should see the following message on your terminal


Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

google_compute_instance.default: Creating...
google_compute_instance.default: Still creating... [10s elapsed]
google_compute_instance.default: Creation complete after 15s [id=projects/gcp-terraform-307119/zones/europe-west4-a/instances/test]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
BASH
If you see a similar message on your terminal which means it is has provisioned the Virtual Machine successfully on Google Cloud.

(If you face issue - Error creating service account: googleapi: Error 403: Identity and Access Management (IAM) API has not been used in project 46864460xxxx before or it is disabled - Click here for troubleshooting)


7. Verify your Setup
  Now at last we are going to verify it by actually logging into the Google Cloud.

  Navigate to Compute Engine -> VM Instances

  You should see a virtual machine running


  Verify virtual machine by running on google cloud
  Congratulations! You have successfully provisioned your first Virtual machine running on Google Cloud using Terraform.


8. Destroy Virtual Machine
    You can destroy the virtual machine running on Google Cloud using the following command

terraform destroy 
