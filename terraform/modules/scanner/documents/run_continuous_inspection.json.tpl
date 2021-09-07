{
  "description": "This automation document is triggered as part of the continuous vulnerability assessment on all active golden AMIs.",
  "schemaVersion": "0.3",
  "assumeRole": "${automation_service_role}",
  "parameters": {
    "instanceIDs": {
      "type": "String",
      "description": "This parameter contains list of instance-ids on which continuous vulnerability assessment is  performed."
    }
  },
  "mainSteps": [
    {
      "name": "sleep",
      "action": "aws:sleep",
      "inputs": {
        "Duration": "PT6M"
      }
    },
    {
      "name": "InitiateAssessmentLambdaFunction",
      "action": "aws:invokeLambdaFunction",
      "timeoutSeconds": 1200,
      "maxAttempts": 1,
      "onFailure": "Abort",
      "inputs": {
        "FunctionName": "${initiate_assessment_lambda}",
        "Payload": "{\"instanceIDs\":\"{{ instanceIDs }}\"}"
      }
    }
  ]
}