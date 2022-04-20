import json
import boto3
import os

def lambda_handler(event, context):
    notification = "Here is the SNS notification for Lambda function example."
    client = boto3.client('sns')
    response = client.publish (
        TargetArn = os.environ['SNS_TOPIC_ARN'],
        Message = json.dumps({'default': notification}),
        MessageStructure = 'json'
    )

    return {
        'statusCode': 200,
        'body': json.dumps(response)
    }
