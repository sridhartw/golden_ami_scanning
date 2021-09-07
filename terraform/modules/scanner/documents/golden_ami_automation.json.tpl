{
  "description": "This automation document triggers Golden AMI creation workflow.",
  "schemaVersion": "0.3",
  "assumeRole": "${automation_service_role}",
  "parameters": {
    "sourceAMIid": {
      "type": "String",
      "description": "Source/Base AMI to be used for generating your golden AMI",
      "default": "{{ssm:/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2}}"
    },
    "productName": {
      "type": "String",
      "description": "The syntax of this parameter is ProductName-ProductVersion.",
      "default": "${resource-prefix}"
    },
    "productOSAndVersion": {
      "type": "String",
      "description": "The syntax of this parameter is OSName-OSVersion",
       "default": "${default_ami}"
    },
    "ApproverARN": {
      "type": "String",
      "description": "AWS authenticated principals who are able to either approve or reject the Golden AMI. You can specify principals by using an AWS Identity and Access Management (IAM) user name, IAM user ARN, IAM role ARN, or an IAM assume role user ARN.",
      "default": "${approver_arn}"
    },
    "ApproverNotificationArn": {
      "type": "String",
      "description": "SNS Topic ARN on which a notification would be published once the golden AMI candidate is ready for validation.",
      "default": "${approver_topic_arn}"
    },
    "AMIVersion": {
      "type": "String",
      "description": "Golden AMI Build version number to be created.",
      "default": "1.0"
    },
    "subnetId": {
      "type": "String",
      "default": "${subnet_id}",
      "description": "Subnet in which instances will be launched."
    },
    "securityGroupId": {
      "type": "String",
      "default": "${security_group}",
      "description": "Security Group that will be attached to the instance. By Default a security group without any inbound access is attached"
    },
    "instanceType": {
      "type": "String",
      "description": "A compatible instance-type for launching an instance",
      "default": "${instance_type}"
    },
    "targetAMIname": {
      "type": "String",
      "description": "Name for the golden AMI to be created",
      "default": "{{productName}}-{{productOSAndVersion}}-{{AMIVersion}}"
    },
    "ManagedInstanceProfile": {
      "type": "String",
      "description": "Instance Profile. Do not change the default value.",
      "default": "${managed_instance_profile}"
    },
    "SSMInstallationUserData": {
      "type": "String",
      "description": "Base64 encoded SSM installation user-data.",
      "default": "IyEvYmluL2Jhc2gNCg0KZnVuY3Rpb24gZ2V0X2NvbnRlbnRzKCkgew0KICAgIGlmIFsgLXggIiQod2hpY2ggY3VybCkiIF07IHRoZW4NCiAgICAgICAgY3VybCAtcyAtZiAiJDEiDQogICAgZWxpZiBbIC14ICIkKHdoaWNoIHdnZXQpIiBdOyB0aGVuDQogICAgICAgIHdnZXQgIiQxIiAtTyAtDQogICAgZWxzZQ0KICAgICAgICBkaWUgIk5vIGRvd25sb2FkIHV0aWxpdHkgKGN1cmwsIHdnZXQpIg0KICAgIGZpDQp9DQoNCnJlYWRvbmx5IElERU5USVRZX1VSTD0iaHR0cDovLzE2OS4yNTQuMTY5LjI1NC8yMDE2LTA2LTMwL2R5bmFtaWMvaW5zdGFuY2UtaWRlbnRpdHkvZG9jdW1lbnQvIg0KcmVhZG9ubHkgVFJVRV9SRUdJT049JChnZXRfY29udGVudHMgIiRJREVOVElUWV9VUkwiIHwgYXdrIC1GXCIgJy9yZWdpb24vIHsgcHJpbnQgJDQgfScpDQpyZWFkb25seSBERUZBVUxUX1JFR0lPTj0idXMtZWFzdC0xIg0KcmVhZG9ubHkgUkVHSU9OPSIke1RSVUVfUkVHSU9OOi0kREVGQVVMVF9SRUdJT059Ig0KDQpyZWFkb25seSBTQ1JJUFRfTkFNRT0iYXdzLWluc3RhbGwtc3NtLWFnZW50Ig0KIFNDUklQVF9VUkw9Imh0dHBzOi8vYXdzLXNzbS1kb3dubG9hZHMtJFJFR0lPTi5zMy5hbWF6b25hd3MuY29tL3NjcmlwdHMvJFNDUklQVF9OQU1FIg0KDQppZiBbICIkUkVHSU9OIiA9ICJjbi1ub3J0aC0xIiBdOyB0aGVuDQogIFNDUklQVF9VUkw9Imh0dHBzOi8vYXdzLXNzbS1kb3dubG9hZHMtJFJFR0lPTi5zMy5jbi1ub3J0aC0xLmFtYXpvbmF3cy5jb20uY24vc2NyaXB0cy8kU0NSSVBUX05BTUUiDQpmaQ0KDQppZiBbICIkUkVHSU9OIiA9ICJ1cy1nb3Ytd2VzdC0xIiBdOyB0aGVuDQogIFNDUklQVF9VUkw9Imh0dHBzOi8vYXdzLXNzbS1kb3dubG9hZHMtJFJFR0lPTi5zMy11cy1nb3Ytd2VzdC0xLmFtYXpvbmF3cy5jb20vc2NyaXB0cy8kU0NSSVBUX05BTUUiDQpmaQ0KDQpjZCAvdG1wDQpGSUxFX1NJWkU9MA0KTUFYX1JFVFJZX0NPVU5UPTMNClJFVFJZX0NPVU5UPTANCg0Kd2hpbGUgWyAkUkVUUllfQ09VTlQgLWx0ICRNQVhfUkVUUllfQ09VTlQgXSA7IGRvDQogIGVjaG8gQVdTLVVwZGF0ZUxpbnV4QW1pOiBEb3dubG9hZGluZyBzY3JpcHQgZnJvbSAkU0NSSVBUX1VSTA0KICBnZXRfY29udGVudHMgIiRTQ1JJUFRfVVJMIiA+ICIkU0NSSVBUX05BTUUiDQogIEZJTEVfU0laRT0kKGR1IC1rIC90bXAvJFNDUklQVF9OQU1FIHwgY3V0IC1mMSkNCiAgZWNobyBBV1MtVXBkYXRlTGludXhBbWk6IEZpbmlzaGVkIGRvd25sb2FkaW5nIHNjcmlwdCwgc2l6ZTogJEZJTEVfU0laRQ0KICBpZiBbICRGSUxFX1NJWkUgLWd0IDAgXTsgdGhlbg0KICAgIGJyZWFrDQogIGVsc2UNCiAgICBpZiBbWyAkUkVUUllfQ09VTlQgLWx0IE1BWF9SRVRSWV9DT1VOVCBdXTsgdGhlbg0KICAgICAgUkVUUllfQ09VTlQ9JCgoUkVUUllfQ09VTlQrMSkpOw0KICAgICAgZWNobyBBV1MtVXBkYXRlTGludXhBbWk6IEZpbGVTaXplIGlzIDAsIHJldHJ5Q291bnQ6ICRSRVRSWV9DT1VOVA0KICAgIGZpDQogIGZpIA0KZG9uZQ0KDQppZiBbICRGSUxFX1NJWkUgLWd0IDAgXTsgdGhlbg0KICBjaG1vZCAreCAiJFNDUklQVF9OQU1FIg0KICBlY2hvIEFXUy1VcGRhdGVMaW51eEFtaTogUnVubmluZyBVcGRhdGVTU01BZ2VudCBzY3JpcHQgbm93IC4uLi4NCiAgLi8iJFNDUklQVF9OQU1FIiAtLXJlZ2lvbiAiJFJFR0lPTiINCmVsc2UNCiAgZWNobyBBV1MtVXBkYXRlTGludXhBbWk6IFVuYWJsZSB0byBkb3dubG9hZCBzY3JpcHQsIHF1aXR0aW5nIC4uLi4NCmZp"
    },
    "PreUpdateScript": {
      "type": "String",
      "description": "(Optional) URL of a script to run before updates are applied. Default (\"none\") is to not run a script.",
      "default": "none"
    },
    "PostUpdateScript": {
      "type": "String",
      "description": "(Optional) URL of a script to run after package updates are applied. Default (\"none\") is to not run a script.",
      "default": "none"
    },
    "IncludePackages": {
      "type": "String",
      "description": "(Optional) Only update these named packages. By default (\"all\"), all available updates are applied.",
      "default": "all"
    },
    "ExcludePackages": {
      "type": "String",
      "description": "(Optional) Names of packages to hold back from updates, under all conditions. By default (\"none\"), no package is excluded.",
      "default": "none"
    }
  },
  "mainSteps": [
    {
      "name": "startInstances",
      "action": "aws:runInstances",
      "timeoutSeconds": 3600,
      "maxAttempts": 1,
      "onFailure": "Abort",
      "inputs": {
        "ImageId": "{{ sourceAMIid }}",
        "InstanceType": "{{instanceType}}",
        "MinInstanceCount": 1,
        "MaxInstanceCount": 1,
        "SubnetId": "{{ subnetId }}",
        "SecurityGroupIds": [
          "{{ securityGroupId }}"
        ],
        "UserData": "{{SSMInstallationUserData}}",
        "IamInstanceProfileName": "{{ ManagedInstanceProfile }}"
      }
    },
    {
      "name": "updateSSMAgent",
      "action": "aws:runCommand",
      "maxAttempts": 3,
      "onFailure": "Abort",
      "timeoutSeconds": 14400,
      "inputs": {
        "DocumentName": "AWS-UpdateSSMAgent",
        "InstanceIds": [
          "{{ startInstances.InstanceIds }}"
        ]
      }
    },
    {
      "name": "describeInstance",
      "action": "aws:executeAwsApi",
      "onFailure": "Abort",
      "inputs": {
        "Service": "ec2",
        "Api": "DescribeInstances",
        "InstanceIds": [
          "{{ startInstances.InstanceIds }}"
        ]
      },
      "outputs": [
        {
          "Name": "Platform",
          "Selector": "$.Reservations[0].Instances[0].Platform",
          "Type": "String"
        }
      ],
      "nextStep": "branchOnInstancePlatform"
    },
    {
      "name": "branchOnInstancePlatform",
      "action": "aws:branch",
      "inputs": {
        "Choices": [
          {
            "NextStep": "installWindowsUpdates",
            "Variable": "{{ describeInstance.Platform }}",
            "StringEquals": "windows"
          },
          {
            "NextStep": "updateOSSoftware",
            "Variable": "{{ describeInstance.Platform }}",
            "StringEquals": "linux"
          }
        ],
        "Default": "updateOSSoftware"
      }
    },
    {
      "name": "installWindowsUpdates",
      "action": "aws:runCommand",
      "maxAttempts": 3,
      "onFailure": "Abort",
      "timeoutSeconds": 14400,
      "inputs": {
        "DocumentName": "AWS-InstallWindowsUpdates",
        "InstanceIds": [
          "{{ startInstances.InstanceIds }}"
        ]
      },
      "nextStep": "stopInstance"
    },
    {
      "name": "updateOSSoftware",
      "action": "aws:runCommand",
      "maxAttempts": 3,
      "timeoutSeconds": 3600,
      "onFailure": "Abort",
      "inputs": {
        "DocumentName": "AWS-RunShellScript",
        "InstanceIds": [
          "{{startInstances.InstanceIds}}"
        ],
        "Parameters": {
          "commands": [
            "set -e",
            "[ -x \"$(which wget)\" ] && get_contents='wget $1 -O -'",
            "[ -x \"$(which curl)\" ] && get_contents='curl -s -f $1'",
            "eval $get_contents https://aws-ssm-downloads-{{global:REGION}}.s3.amazonaws.com/scripts/aws-update-linux-instance > /tmp/aws-update-linux-instance",
            "chmod +x /tmp/aws-update-linux-instance",
            "/tmp/aws-update-linux-instance --pre-update-script '{{PreUpdateScript}}' --post-update-script '{{PostUpdateScript}}' --include-packages '{{IncludePackages}}' --exclude-packages '{{ExcludePackages}}' 2>&1 | tee /tmp/aws-update-linux-instance.log"
          ]
        }
      },
      "nextStep": "stopInstance"
    },
    {
      "name": "stopInstance",
      "action": "aws:changeInstanceState",
      "timeoutSeconds": 1200,
      "maxAttempts": 1,
      "onFailure": "Abort",
      "inputs": {
        "InstanceIds": [
          "{{ startInstances.InstanceIds }}"
        ],
        "DesiredState": "stopped"
      }
    },
    {
      "name": "createImage",
      "action": "aws:createImage",
      "timeoutSeconds": 1200,
      "maxAttempts": 1,
      "onFailure": "Continue",
      "inputs": {
        "InstanceId": "{{ startInstances.InstanceIds }}",
        "ImageName": "{{ targetAMIname }}",
        "NoReboot": true,
        "ImageDescription": "AMI created by EC2 Automation"
      }
    },
    {
      "name": "TagTheAMI",
      "action": "aws:createTags",
      "timeoutSeconds": 1200,
      "maxAttempts": 1,
      "onFailure": "Continue",
      "inputs": {
        "ResourceType": "EC2",
        "ResourceIds": [
          "{{ createImage.ImageId }}"
        ],
        "Tags": [
          {
            "Key": "ProductOSAndVersion",
            "Value": "{{productOSAndVersion}}"
          },
          {
            "Key": "ProductName",
            "Value": "{{productName}}"
          },
          {
            "Key": "version",
            "Value": "{{AMIVersion}}"
          },
          {
            "Key": "AMI-Type",
            "Value": "Golden"
          }
        ]
      }
    },
    {
      "name": "terminateFirstInstance",
      "action": "aws:changeInstanceState",
      "timeoutSeconds": 1200,
      "maxAttempts": 1,
      "onFailure": "Continue",
      "inputs": {
        "InstanceIds": [
          "{{ startInstances.InstanceIds }}"
        ],
        "DesiredState": "terminated"
      }
    },
    {
      "name": "createInstanceFromNewImage",
      "action": "aws:runInstances",
      "timeoutSeconds": 1200,
      "maxAttempts": 1,
      "onFailure": "Abort",
      "inputs": {
        "ImageId": "{{ createImage.ImageId }}",
        "InstanceType": "{{instanceType}}",
        "MinInstanceCount": 1,
        "MaxInstanceCount": 1,
        "SubnetId": "{{ subnetId }}",
        "SecurityGroupIds": [
          "{{ securityGroupId }}"
        ],
        "IamInstanceProfileName": "{{ ManagedInstanceProfile }}"
      }
    },
    {
      "name": "InstallInspector",
      "action": "aws:runCommand",
      "maxAttempts": 3,
      "timeoutSeconds": 3600,
      "onFailure": "Abort",
      "inputs": {
        "DocumentName": "AmazonInspector-ManageAWSAgent",
        "InstanceIds": [
          "{{ createInstanceFromNewImage.InstanceIds }}"
        ],
        "Parameters": {
          "Operation": "Install"
        }
      }
    },
    {
      "name": "TagNewinstance",
      "action": "aws:createTags",
      "timeoutSeconds": 1200,
      "maxAttempts": 1,
      "onFailure": "Continue",
      "inputs": {
        "ResourceType": "EC2",
        "ResourceIds": [
          "{{ createInstanceFromNewImage.InstanceIds }}"
        ],
        "Tags": [
          {
            "Key": "Type",
            "Value": "{{createImage.ImageId}}-{{productOSAndVersion}}/{{productName}}/{{AMIVersion}}"
          },
          {
            "Key": "Automation-Instance-Type",
            "Value": "Golden"
          }
        ]
      }
    },
    {
      "name": "InspectBaseInstance",
      "action": "aws:invokeLambdaFunction",
      "maxAttempts": 3,
      "timeoutSeconds": 120,
      "onFailure": "Abort",
      "inputs": {
        "FunctionName": "${run_inspector_arn}",
        "Payload": "{\"AMI-ID\": \"{{createImage.ImageId}}\",\"topicArn\":\"${inspector_complete_topic}\",\"instanceId\": \"{{ createInstanceFromNewImage.InstanceIds }}\",\"productOS\": \"{{productOSAndVersion}}\",\"productName\": \"{{productName}}\",\"productVersion\": \"{{AMIVersion}}\"}"
      }
    },
    {
      "name": "sleep",
      "action": "aws:sleep",
      "inputs": {
        "Duration": "PT2M"
      }
    },
    {
      "name": "terminateInspectorInstance",
      "action": "aws:changeInstanceState",
      "timeoutSeconds": 1200,
      "maxAttempts": 1,
      "onFailure": "Continue",
      "inputs": {
        "InstanceIds": [
          "{{ createInstanceFromNewImage.InstanceIds }}"
        ],
        "DesiredState": "terminated"
      }
    },
    {
      "name": "addNewVersionParameter",
      "action": "aws:invokeLambdaFunction",
      "timeoutSeconds": 1200,
      "maxAttempts": 1,
      "onFailure": "Abort",
      "inputs": {
        "FunctionName": "${append_ssm_param_arn}",
        "Payload": "{\"parameterName\":\"/GoldenAMI/{{productOSAndVersion}}/{{productName}}/{{AMIVersion}}\", \"valueToBeCreatedOrAppended\":\"{{createImage.ImageId}}\"}"
      }
    },
    {
      "name": "approve",
      "action": "aws:approve",
      "timeoutSeconds": 172800,
      "onFailure": "Abort",
      "inputs": {
        "NotificationArn": "{{ ApproverNotificationArn }}",
        "Message": "Please check contents of SSM Parameter : /GoldenAMI/{{productOSAndVersion}}/{{productName}}/{{AMIVersion}}/NumCVEs and approve/deny the build.",
        "MinRequiredApprovals": 1,
        "Approvers": [
          "{{ ApproverARN }}"
        ]
      }
    },
    {
      "name": "updateLatestVersionValue",
      "action": "aws:invokeLambdaFunction",
      "timeoutSeconds": 1200,
      "maxAttempts": 1,
      "onFailure": "Abort",
      "inputs": {
        "FunctionName":  "${append_ssm_param_arn}",
        "Payload": "{\"parameterName\":\"/GoldenAMI/latest\", \"valueToBeCreatedOrAppended\":\"{{createImage.ImageId}}\"}"
      }
    }
  ],
  "outputs": [
    "createImage.ImageId"
  ]
}