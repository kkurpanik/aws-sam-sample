import json
import boto3
import os

def lambda_handler(event, context):
    name = event['name']
    notification = f"Hi, {name}! This is the SNS notification for Lambda function example."
    client = boto3.client('sns', region_name="eu-west-2")
    response = client.publish (
        TargetArn = os.environ['SNS_TOPIC_ARN'],
        Message = json.dumps({'default': notification}),
        MessageStructure = 'json'
    )

    return {
        'statusCode': 200,
        'message': notification,
        'body': json.dumps(response)
    }
