{
  "description": "This automation document triggers golden AMI build decommissioning workflow",
  "schemaVersion": "0.3",
  "assumeRole": "${automation_service_role}",
  "parameters": {
    "bucketName": {
      "type": "String",
      "description": "This parameter contains name of the bucket in which CFT template file is stored",
      "default": "${ami_config_bucket}"
    },
    "templateFileName": {
      "type": "String",
      "description": "The CFT template file-name used for creating the Service Catalog product",
      "default": "simpleEC2-SSMParamInput.json"
    },
    "productName": {
      "type": "String",
      "description": "The syntax of this parameter is ProductName-ProductVersion",
      "default": "${resource-prefix}"
    },
    "productOSAndVersion": {
      "type": "String",
      "description": "The syntax of this parameter is OSName-OSVersion",
      "default": "${default_ami}"
    },
    "buildVersion": {
      "type": "String",
      "description": "Golden AMI build number to be decommissioned.",
      "default": "1.0"
    },
    "MetadataParamName": {
      "type": "String",
      "description": "This parameter points to an SSM parameter used for storing some process specific metadata. Do not change the default value.",
      "default": "/GoldenAMI/{{productOSAndVersion}}/{{productName}}/{{buildVersion}}/temp"
    }
  },
  "mainSteps": [
    {
      "name": "DecommissionAMIVersionLambda",
      "action": "aws:invokeLambdaFunction",
      "timeoutSeconds": 1200,
      "maxAttempts": 1,
      "onFailure": "Abort",
      "inputs": {
        "FunctionName": "${decommision_ami_version_lambda}",
        "Payload": "{\"bucketName\":\"{{ bucketName }}\", \"amiRegionMappingParamName\":\"{{ MetadataParamName }}\", \"templateFileName\":\"{{templateFileName}}\", \"versionToBeDeleted\":\"{{ buildVersion }}\", \"productOSAndVersion\":\"{{ productOSAndVersion }}\", \"productNameAndVersion\":\"{{ productName }}\"}"
      }
    }
  ]
}