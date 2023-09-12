
# Github_Logger Project

This project is able to monitor when PR was merged to the given repo, parsing the information
that being accepted by the GIT API, and presenting the information regarding the repo and the 
files that were changed/added/deleted by the specific PR.

The above mentioend process is achieved by a dedicated python code, running by a dedicated Lambda function
on AWS.
## Prerequisites

To use this project, make sure to meet the following prerequisites:
To use this project, you should make sure to have the following:

* AWS Access Key / Secret Key available.
* GitHub Token with the appropriate permissions to modify files/updating repos, creating and merging PR, etc.
* Terraform Client that will create the project.
## Cost, Load and Security

#### Cost 

We are using the following AWS services:

* **Lambda** -  Very low cost, that is calculated based on the Run-Time and invokation number.
In our project, the run time is very short(avg of 113.013 ms).

* **CloudWatch** - Considering that we don't save anything else besides the logs(we are not cloning the repo) 
the cost of the CloudWatch in our region(eu-west-3/Paris) is $0.5985 per GB.

#### Load

The queries that we are sending are very short(as mentioned above) and thus we are not having an high load
for our services.
In addition, the payload we are getting from the API-Request is small, which is another fact regarding
the minimum required load.

#### Security

The only security Key we are using in our project(considering the user already configured his ENV VARs with the AWS Keys)
is the GIT_Token, which is not hard coded in our resources.
The user is inserting the Token at the first time we are running 'terraform apply' and then, the Token is saved
under an ENV variable that is being referenced in the 'main.py'.


## Project's Files

* **main.tf** - This is the main file of our project, contains all the resources we are configuring in our AWS Cloud provider. **For example:** aws_iam_role related resources, lambda_function, etc.

* **main.py** - This is the file that contain the Python code that is being running by the Lambda function once triggerd.Using this code, we are able to get the required information once there was PR that was merged to the given repo, by parsing the API payload.The API payload was taken from GIT_Docs, and the VARs we are using inside the API request is based on:

    -- Parsed API Payload, using JSON Formatting.

    -- ENV vars that were added to the Lambda function.

* **github.tf** - This is the file which contains all the git-related resources we are configuring in our project. **For example:** github_repository, github_webhook, etc.

* **vars.tf** - This file contains all the vars we are using in our project and their values. **Please note** that before running the ***'terraform apply'*** for the first time, some of the values will be empty, as they need to be filled by the User's input. **For example:** github_token

* **output.tf** - This file contains the values that will be printed after using ***'terraform apply/plan'*** for an easier/faster reference for the user.

## Step-by-step guide

Clone this repo using 'git-clone':
```bash
git clone https://github.com/eladbe96/SRE-Task-Final.git
```
Install terraform on your client:
```bash
https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
```
Install and configure AWS CLI on your client:
```bash
https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
```
```bash
https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
```
Authenticate the Terraform AWS provider using your IAM credentials:
```bash
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
```
Move to folder of the cloned repository:
```bash
cd SRE-Task-Final
```
Initialize the directory and validate your configuration:
```bash
terraform init
terraform validate
```
Apply the configuration:
```bash
terraform apply
```
![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)

![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
