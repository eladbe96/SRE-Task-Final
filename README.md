![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)
![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![Grafana](https://img.shields.io/badge/grafana-%23F46800.svg?style=for-the-badge&logo=grafana&logoColor=white)

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

## Usage/Examples

Once a pull request was merged to your repo, check for your logs via one of the following:

* CloudWatch logs
* AWS cli 
* External log viewer(for example: Grafan)

To check via AWS cli, you can use the following command:
```bash
aws logs filter-log-events --log-group-name "/aws/lambda/function_name" | less
```
In our case, the function name is "github_logger:
```bash
aws logs filter-log-events --log-group-name "/aws/lambda/github_logger" | less
```

### Grafana example:

To view the logs via Grafana, access the below link for the installation according to your Operating System:

```bash
https://grafana.com/grafana/download
```
#### Login
* Open your web browser and go to ***http://localhost:3000/***.
* The default HTTP port that Grafana listens to is 3000 unless you have configured a different port.
* On the sign-in page, enter admin for the username and password.
* Click Sign in.
* If successful, you will see a prompt to change the password.
* Click OK on the prompt and change your password.

#### Adding Data source:

To access the CloudWatch logs via Grafana dashboard, follow the instructions below:

* Click **Connections** in the left-side menu.
* Under Your connections, click **Data sources**.
* Enter **CloudWatch** in the search bar.
* Click **CloudWatch**.
* Fill the required displayed configuration.

#### Import Lambda dashboard

* Click Dashboards in the left-side menu.
* Click New and select Import in the dropdown menu.

Perform one of the following steps:

* Upload a dashboard JSON file
* Paste a Grafana.com dashboard URL
* Copy the dashboard's ID

The import process enables you to change the name of the dashboard, pick the data source you want the dashboard to use(CloudWatch in our case), and specify any metric prefixes (if the dashboard uses any).


### Accesing the logs

* Click Dashboards in the left-side menu.
* Click New and select **New Dashboard**
* In the next screen, select **Add Visualization"
* Select the **CloudWatch** Data source
* On the right-side menu, select **Table** instead of **Time-series**
* On the bottom left-side, under the **Query** section, make sure to configure the query as below:

![Alt text](SRE-Task-Final/Screenshots/Grafana_Query.png?raw=true "Grafana example")

