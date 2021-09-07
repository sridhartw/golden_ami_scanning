import boto3
import json
from dateutil import parser
import dateutil
import datetime
import collections
import os
import time
import botocore


def lambda_handler(event, context):
    region = os.environ['AWS_DEFAULT_REGION']
    ssm = boto3.client('ssm', region)
    instanceIDsVal = event['instanceIDs']
    instanceIDs = instanceIDsVal.split(',')
    for id in instanceIDs:
        ssm.send_command(InstanceIds=[id], DocumentName='AmazonInspector-ManageAWSAgent',
                         Parameters={'Operation': ['Install']})
    inspector = boto3.client('inspector', region)
    time.sleep(120)
    millis = int(round(time.time() * 1000))
    existingTemplates = inspector.list_assessment_templates(filter={'namePattern': 'ContinuousAssessment'})
    assessmentTemplateArn = existingTemplates.get('assessmentTemplateArns')[0]
    run = inspector.start_assessment_run(assessmentTemplateArn=assessmentTemplateArn,
                                         assessmentRunName='ContinuousAssessment' + '-' + str(millis))
    return 'Done'
