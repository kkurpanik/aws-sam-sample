from functions.send_notification import app
from moto import mock_sns
import os
import boto3

@mock_sns
def test_send_notification():
    name = "Johny Bravo"
    input_payload = {"name": name}
    conn = boto3.client("sns", region_name="eu-west-2")
    mock_topic = conn.create_topic(Name="mocktopic")
    topic_arn = mock_topic.get("TopicArn")

    os.environ["SNS_TOPIC_ARN"] = topic_arn
    data = app.lambda_handler(input_payload, "")

    assert data['statusCode'] == 200
    assert name in data['message']

def test_something_else():
    assert 1 == 1