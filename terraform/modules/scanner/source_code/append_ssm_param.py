import json
import boto3
import botocore


def lambda_handler(event, context):
    paramName = event['parameterName'];
    amiIDVal = event['valueToBeCreatedOrAppended']
    print(amiIDVal)
    amiID = amiIDVal.replace("\\r\\n", "\n")
    print(amiID)
    ssm = boto3.client('ssm')
    try:
        AMIIdsParam = ssm.get_parameter(Name=paramName)
        AMIIds = AMIIdsParam['Parameter']['Value']
        AMIIds = AMIIds + ',' + amiID
        ssm.put_parameter(Name=paramName, Type='String', Value=AMIIds, Overwrite=True)
    except botocore.exceptions.ClientError as e:
        if e.response['Error']['Code'] == 'ParameterNotFound':
            ssm.put_parameter(Name=paramName, Type='String', Value=amiID, Overwrite=True)
    return 'appended parameter %s with value %s.' % (paramName, amiID)