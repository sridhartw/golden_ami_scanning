import json
import os
import boto3


def lambda_handler(event, context):
    message = event['Records'][0]['Sns']['Message']
    print(message)
    jsonVal = json.loads(message);
    print(jsonVal)
    assessmentArn = jsonVal['run']
    template = jsonVal['template']
    region = os.environ["AWS_DEFAULT_REGION"]
    inspector = boto3.client('inspector', region)
    findingArns = inspector.list_findings(assessmentRunArns=[jsonVal['run']], maxResults=500)
    countInfo = 0
    countHigh = 0
    countMedium = 0
    countLow = 0
    for findingArn in findingArns['findingArns']:
        finding = inspector.describe_findings(findingArns=[findingArn])
        for result in finding['findings']:
            if result['severity'] == 'Informational':
                countInfo = countInfo + 1
            if result['severity'] == 'Low':
                countLow = countLow + 1
            if result['severity'] == 'Medium':
                countMedium = countMedium + 1
            if result['severity'] == 'High':
                countHigh = countHigh + 1
    print("Total CVEs found:" + str(countHigh))
    existingTemplates = inspector.describe_assessment_templates(assessmentTemplateArns=[template])
    print(existingTemplates['assessmentTemplates'][0]['name'])
    amiIdOriginal = existingTemplates['assessmentTemplates'][0]['name']
    index = int(amiIdOriginal.find('/'))
    suffix = amiIdOriginal[index + 1:]

    ssm = boto3.client('ssm', region)
    counts = "Inspector findings found: High[" + str(countHigh) + "]" + ", Medium[" + str(
        countMedium) + "]" + ", Low[" + str(countLow) + "]" + ", Info[" + str(countInfo) + "]"

    ParamName = '/GoldenAMI/' + suffix + '/NumCVEs'
    ssm.put_parameter(Name=ParamName, Value=counts, Type='String', Overwrite=True)

    ParamName = '/GoldenAMI/' + suffix + '/assessmentLink'
    link = "Link - https://" + region + ".console.aws.amazon.com/inspector/home?region=" + region + "#/run?filter={\"assessmentRunArns\":\"" + assessmentArn + "\"}"
    ssm.put_parameter(Name=ParamName, Value=link, Type='String', Overwrite=True)
    return jsonVal['run']
