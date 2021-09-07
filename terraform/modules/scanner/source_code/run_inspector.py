import json
import urllib.parse
import boto3
import time
import os


def lambda_handler(event, context):
    amiId = event['AMI-ID']
    instanceId = event['instanceId']
    productOS = event.get('productOS')
    productName = event.get('productName')
    productVersion = event.get('productVersion')
    topicArn = event['topicArn']
    fullName = amiId + '-' + productOS + '/' + productName + '/' + productVersion
    region = os.environ["AWS_DEFAULT_REGION"]

    ec2Source = boto3.resource('ec2', region)
    inspector = boto3.client('inspector', region)
    ssm = boto3.client('ssm', region)
    rules = inspector.list_rules_packages();
    ParamName = '/GoldenAMI/' + productOS + '/' + productName + '/' + productVersion + '/latestInstance'
    ssm.put_parameter(Name=ParamName, Value=instanceId, Type='String', Overwrite=True)
    millis = int(round(time.time() * 1000))
    existingTemplates = inspector.list_assessment_templates(
        filter={'namePattern': amiId + '-' + productOS + '/' + productName + '/' + productVersion})
    print("Total length found:" + str(len(existingTemplates['assessmentTemplateArns'])))
    if len(existingTemplates['assessmentTemplateArns']) == 0:
        resGroup = inspector.create_resource_group(resourceGroupTags=[
            {'key': 'Type', 'value': amiId + '-' + productOS + '/' + productName + '/' + productVersion}])
        target = inspector.create_assessment_target(assessmentTargetName=fullName,
                                                    resourceGroupArn=resGroup['resourceGroupArn'])
        template = inspector.create_assessment_template(assessmentTargetArn=target['assessmentTargetArn'],
                                                        assessmentTemplateName=amiId + '/' + productOS + '/' + productName + '/' + productVersion,
                                                        durationInSeconds=900,
                                                        rulesPackageArns=rules['rulesPackageArns'])
        assessmentTemplateArn = template['assessmentTemplateArn']
        response = inspector.subscribe_to_event(event='ASSESSMENT_RUN_COMPLETED',
                                                resourceArn=template['assessmentTemplateArn'], topicArn=topicArn)
        print("Template Created:" + template['assessmentTemplateArn'])
        ParamName = '/GoldenAMI/' + productOS + '/' + productName + '/' + productVersion + '/assessmentTemplateARN'
        ssm.put_parameter(Name=ParamName, Value=template['assessmentTemplateArn'], Type='String', Overwrite=True)
    else:
        assessmentTemplateArn = existingTemplates.get('assessmentTemplateArns')[0]

    time.sleep(10)
    run = inspector.start_assessment_run(assessmentTemplateArn=assessmentTemplateArn,
                                         assessmentRunName=fullName + "" - "" + str(millis))
    ParamName = '/GoldenAMI/' + productOS + '/' + productName + '/' + productVersion + '/LatestAssessmentRunARN'
    ssm.put_parameter(Name=ParamName, Value=run['assessmentRunArn'], Type='String', Overwrite=True)
    return "Done"
