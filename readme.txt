Details of Terraform setup and execution: (LOCAL environment setup)

1.	Authentication - using Environment variables
	
	Provide credentials using following commands to setup the env variables used for running the script:
	$ export AWS_ACCESS_KEY_ID="anaccesskey"
	$ export AWS_SECRET_ACCESS_KEY="asecretkey"
	$ export AWS_DEFAULT_REGION="us-west-2"

2.	Make sure Terraform is installed, verify by executing following:
	
	$ terraform --version
		Terraform v0.11.11
		+ provider.aws v1.55.0
		+ provider.template v1.0.0


3.	Browse to the Terraform scripts directory and execute init, which will install the AWS provider
	
	$ terraform init

		Initializing provider plugins...
		- Checking for available provider plugins on https://releases.hashicorp.com...
		- Downloading plugin for provider "aws" (1.9.0)...

		# ...

		Terraform has been successfully initialized!


4.	Apply the configuration:

	$ terraform apply

5.	Use this branch for Local AWS account setup

6.	This has changes to remove the Route53 changes for domain naming

7.	------------------IMP--------------------
	After runnning the terraform apply, goto the lambdas and update the environment.login variable to point to the correct endpoint
	-------------------------------

