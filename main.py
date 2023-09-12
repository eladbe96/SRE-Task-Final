#Importing the required modules:
import requests
import json
import os
import logging


#This block of code handling the JSON Multi-line logs for CloudWatch.
#https://stackoverflow.com/questions/50233013/aws-lambda-logs-to-one-json-line
class FormatterJSON(logging.Formatter):
    def format(self, record):
        record.message = record.getMessage()
        if self.usesTime():
            record.asctime = self.formatTime(record, self.datefmt)
        j = {
            'time': '%(asctime)s.%(msecs)dZ' % dict(asctime=record.asctime, msecs=record.msecs),
            'message': record.message
        }
        return json.dumps(j)


logger = logging.getLogger()
logger.setLevel('INFO')

formatter = FormatterJSON(
    '[%(levelname)s]\t%(asctime)s.%(msecs)dZ\t%(levelno)s\t%(message)s\n',
    '%Y-%m-%dT%H:%M:%S'
)
# Replace the LambdaLoggerHandler formatter :
logger.handlers[0].setFormatter(formatter)

#This block of code is running by the Lambda function, when there is a trigger.
def lambda_handler(event, context):

#Parsing the event data to JSON format:
    body_data = json.loads(event['body'])

#Checking for the state of the PR if it was merged.
#If it does, we are starting to get the information we need using GIT_API.
    if 'action' in body_data:
        if body_data['action'] == 'closed' and body_data['pull_request']['merged']:
            
            repo_name = os.environ.get("REPO_NAME")
            git_token = os.environ.get("GIT_PAT")
            pr_number = body_data['number']
            repo_full_name = body_data["pull_request"]["head"]["repo"]["full_name"]
            print(f'The pull request #{pr_number} to {repo_name} was merged!')
            url = f'https://api.github.com/repos/{repo_full_name}/pulls/{pr_number}/files'

            headers = {
                'Accept': 'application/vnd.github+json',
                'Authorization': f'Bearer {git_token}',
                'X-GitHub-Api-Version': '2022-11-28'
            }
            response = requests.get(url, headers=headers)
            response_json = response.json()
            changed_files = json.dumps(response_json, indent=4, ensure_ascii=False)
            changed_files = json.loads(changed_files)

            for item in changed_files:
                file = "Filename:", item.get("filename")
                additions = "Additions:", item.get("additions")
                deleted = "Deletions:", item.get("deletions")
                modified = "Total Modifications:", item.get("changes")
                logger.info(f'{file}{additions}{deleted}{modified}')
                # logger.info(additions)
                # logger.info(deleted)
                # logger.info(modified)

            #logger.info(changed_files)
        else:
            return {'statusCode': 200, 'body': json.dumps("The pull request isn't merged")}
   
    else:
        return { 'statusCode': 200,'body': json.dumps("The event doesn't match the Lambda function")}
