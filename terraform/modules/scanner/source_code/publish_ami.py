import boto3
import json
from dateutil import parser
import dateutil
import datetime
import collections
import os
import time


def lambda_handler(event, context):
    sourceRegion = os.environ['AWS_DEFAULT_REGION']
    s3 = boto3.resource('s3')
    prodName = event['productNameAndVersion']
    prodOS = event['productOSAndVersion']
    bucket = event['bucketName']
    s3FilePrefix = event['templateFileName']
    version = event['versionToBeCreated']
    amiRegionMappingParamName = event['amiRegionMappingParamName']
    filepath = '/tmp/' + s3FilePrefix
    object = s3.Object(bucket, s3FilePrefix)
    text = object.get()['Body'].read().decode('utf-8')
    amiIDParamPath = '/GoldenAMI/' + prodOS + '/' + prodName + '/' + event['versionToBeCreated']
    text = text.replace('AMI_ID_TO_REPLACE', amiIDParamPath)
    with open(filepath, mode='w', encoding='utf-8') as file:
        file.write(text)
    s3.meta.client.upload_file(filepath, bucket, s3FilePrefix + '/versions/' + version)
    ssm = boto3.client('ssm', os.environ['AWS_DEFAULT_REGION'])
    amiIDRegionMapping = ssm.get_parameter(Name=amiRegionMappingParamName)['Parameter']['Value']
    mappingJSON = json.loads(amiIDRegionMapping)
    for region, amiID in mappingJSON.items():
        sc = boto3.client('servicecatalog', region)
        scProduct = ''
        products = sc.search_products_as_admin(ProductSource='ACCOUNT')
        for product in products['ProductViewDetails']:
            productName = product['ProductViewSummary']['Name']
            if productName == prodName + '-' + prodOS:
                scProduct = product['ProductViewSummary']['ProductId']
                sc.create_provisioning_artifact(ProductId=scProduct, Parameters={'Name': version,
                                                                                 'Description': 'This is version ' + version,
                                                                                 'Info': {
                                                                                     'LoadTemplateFromURL': 'https://s3.amazonaws.com/' + bucket + '/' + s3FilePrefix + '/versions/' + version},
                                                                                 'Type': 'CLOUD_FORMATION_TEMPLATE'},
                                                IdempotencyToken=str(round(time.time() * 1000)))
        if scProduct == '':
            print('SC product not found, creating a product')
            result = sc.create_product(Name=prodName + '-' + prodOS, Owner='CCOE',
                                       ProductType='CLOUD_FORMATION_TEMPLATE',
                                       Description='This product can be used to launch ' + prodName + ' in ' + prodOS + ' environment.',
                                       Tags=[{'Key': 'ProductName', 'Value': prodName + '-' + prodOS}],
                                       ProvisioningArtifactParameters={'Name': version,
                                                                       'Description': 'This is version ' + version,
                                                                       'Info': {
                                                                           'LoadTemplateFromURL': 'https://s3.amazonaws.com/' + bucket + '/' + s3FilePrefix + '/versions/' + version},
                                                                       'Type': 'CLOUD_FORMATION_TEMPLATE'},
                                       IdempotencyToken=str(round(time.time() * 1000)))
    return 'Done'
