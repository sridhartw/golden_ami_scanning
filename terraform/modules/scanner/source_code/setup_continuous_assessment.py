import json
import urllib.parse
import boto3
import time
import os
from os import environ


def lambda_handler(event, context):
    amisParamName = event['AMIsParamName'];
    instanceType = event['instanceType'];
    region = os.environ['AWS_DEFAULT_REGION']
    ec2 = boto3.client('ec2', region)
    ssm = boto3.client('ssm', region)
    inspector = boto3.client('inspector', region)
    amisJson = ssm.get_parameter(Name=amisParamName)['Parameter']['Value']
    items = amisJson.split(',')
    instanceIDs = ''
    for entry in items:
        images = ec2.describe_images(ImageIds=[entry], DryRun=False)
        if 'Tags' in images['Images'][0]:
            tags = images['Images'][0]['Tags']
            tags.append({'Key': 'continuous-assessment-instance', 'Value': 'true'})
            response = ec2.run_instances(ImageId=entry, SubnetId=environ['subnet_id'],
                                         IamInstanceProfile={'Arn': environ['managed_instance_iam_role']},
                                         SecurityGroupIds=[environ['security_group_id']], InstanceType=instanceType,
                                         DryRun=False, MaxCount=1, MinCount=1,
                                         TagSpecifications=[{'ResourceType': 'instance', 'Tags': tags}])
        else:
            response = ec2.run_instances(ImageId=entry, SubnetId=environ['subnet_id'],
                                         IamInstanceProfile={'Arn': environ['managed_instance_iam_role']},
                                         SecurityGroupIds=[environ['security_group_id']], InstanceType=instanceType,
                                         DryRun=False, MaxCount=1, MinCount=1,
                                         TagSpecifications=[{'ResourceType': 'instance', 'Tags': [
                                             {'Key': 'continuous-assessment-instance', 'Value': 'true'},
                                             {'Key': 'AMI-Type', 'Value': 'Golden'}]}])
        if len(instanceIDs) == 0:
            instanceIDs = response['Instances'][0]['InstanceId']
        else:
            instanceIDs = instanceIDs + ',' + response['Instances'][0]['InstanceId']
    assessmentTemplateArn = '';
    rules = inspector.list_rules_packages();

    millis = int(round(time.time() * 1000))
    existingTemplates = inspector.list_assessment_templates(filter={'namePattern': 'ContinuousAssessment'})
    print('Total templates found:' + str(len(existingTemplates['assessmentTemplateArns'])))
    if len(existingTemplates['assessmentTemplateArns']) == 0:
        template = inspector.create_assessment_template(assessmentTargetArn=environ["continuous_assessment_target"],
                                                        assessmentTemplateName='ContinuousAssessment',
                                                        durationInSeconds=3600,
                                                        rulesPackageArns=rules['rulesPackageArns'])
        assessmentTemplateArn = template['assessmentTemplateArn']
        response = inspector.subscribe_to_event(event='ASSESSMENT_RUN_COMPLETED',
                                                resourceArn=template['assessmentTemplateArn'],
                                                topicArn=environ["continuous_assessment_complete_topic"])
        print('Template Created:' + template['assessmentTemplateArn'])
        time.sleep(20)
    ssm.start_automation_execution(DocumentName=environ["run_continuous_inspection"],
                                   Parameters={'instanceIDs': [instanceIDs]})
    return 'Assessment started'
