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
    sourceRegion = os.environ['AWS_DEFAULT_REGION']
    s3 = boto3.resource('s3')
    prodName = event['productNameAndVersion']
    prodOS = event['productOSAndVersion']
    bucketName = event['bucketName']
    s3FilePrefix = event['templateFileName']
    version = event['versionToBeDeleted']
    amiRegionMappingParamName = event['amiRegionMappingParamName']
    prefix = '/GoldenAMI/' + prodOS + '/' + prodName + '/' + version
    s3 = boto3.resource('s3')
    masterAmis = '/GoldenAMI/latest'
    bucket = s3.Bucket(bucketName)
    bucket.delete_objects(Delete={'Objects': [{'Key': s3FilePrefix + '/versions/' + version}]})
    ssm = boto3.client('ssm', sourceRegion)
    amiIDRegionMapping = ''
    params = [prefix + '/latestInstance', prefix + '/LatestAssessmentRunARN', prefix + '/NumCVEs',
              prefix + '/assessmentLink', prefix + '/assessmentTemplateARN']
    try:
        amiIDRegionMapping = ssm.get_parameter(Name=amiRegionMappingParamName)['Parameter']['Value']
    except botocore.exceptions.ClientError as e:
        if e.response['Error']['Code'] == 'ParameterNotFound':
            amiID = ssm.get_parameter(Name=prefix)['Parameter']['Value']
            ec2 = boto3.client('ec2')
            ec2.deregister_image(ImageId=amiID)
            time.sleep(5)
            snaps = ec2.describe_snapshots()
            for snap in snaps['Snapshots']:
                if amiID in snap['Description']:
                    ec2.delete_snapshot(SnapshotId=snap['SnapshotId'])
            ssm.delete_parameters(Names=params)
            try:
                temp = ssm.get_parameter(Name=masterAmis)['Parameter']['Value']
                temp = temp.replace(amiID + ',', '').replace(',' + amiID, '').replace(amiID, '')
                if len(temp) == 0:
                    ssm.delete_parameters(Names=[masterAmis])
                else:
                    ssm.put_parameter(Name=masterAmis, Type='String', Value=temp, Overwrite=True)
                return 'Done'
            except botocore.exceptions.ClientError as e:
                if e.response['Error']['Code'] == 'ParameterNotFound':
                    print('This indicates that the active amis are not present')
            return 'Done'
    mappingJSON = json.loads(amiIDRegionMapping)
    for region, amiID in mappingJSON.items():
        sc = boto3.client('servicecatalog', region)
        products = sc.search_products_as_admin(ProductSource='ACCOUNT')
        for product in products['ProductViewDetails']:
            productName = product['ProductViewSummary']['Name']
            if productName == prodName + '-' + prodOS:
                productID = product['ProductViewSummary']['ProductId']
                provisioningArtifacts = sc.list_provisioning_artifacts(ProductId=productID)[
                    'ProvisioningArtifactDetails']
                if len(provisioningArtifacts) == 1:
                    sc.delete_product(Id=productID)
                else:
                    for artifact in provisioningArtifacts:
                        if artifact['Name'] == version:
                            sc.delete_provisioning_artifact(ProductId=productID, ProvisioningArtifactId=artifact['Id'])
        ec2 = boto3.client('ec2', region)
        ec2.deregister_image(ImageId=amiID)
        time.sleep(5)
        snaps = ec2.describe_snapshots()
        for snap in snaps['Snapshots']:
            if amiID in snap['Description']:
                ec2.delete_snapshot(SnapshotId=snap['SnapshotId'])
        ssm = boto3.client('ssm', region)
        ssm.delete_parameters(Names=[prefix])
        temp = ssm.get_parameter(Name=masterAmis)['Parameter']['Value']
        temp = temp.replace(amiID + ',', '').replace(',' + amiID, '').replace(amiID, '')
        if len(temp) == 0:
            ssm.delete_parameters(Names=[masterAmis])
        else:
            ssm.put_parameter(Name=masterAmis, Type='String', Value=temp, Overwrite=True)
        if region == sourceRegion:
            ssm.delete_parameters(Names=params)
    return 'Done'
