"""
This Module is to create API for
Web Application.
"""
import os
import logging
import json
import boto3

LOGGER = logging.getLogger(__name__)
LOGGER.setLevel(logging.INFO)
DYNAMO_TABLE = os.environ['ENV_VAR1'].split("TABLENAME=")[1].split(";")[0]
DYNAMO = boto3.resource('dynamodb').Table(DYNAMO_TABLE)

def handle_source_sqs(message: dict) -> dict:
    """
    Source code to handle SQS messages
    """
    message_id = message.get("messageId")
    message_content = message.get("body")
    payload = dict()
    item = dict()
    item["UserID"] = message_id
    item["IP"] = message_content.split('=')[1].split('loc')[0]
    item["Location"] = message_content.split('=')[2]
    item["UsageInfo"] = message_content.split('=')[3]
    payload["Item"] = item
    LOGGER.info("Database raw payload: %s", payload)
    return payload


def lambda_handler(event, context):
    """
    This Function is the Lambda Handler
    for Web Application API
    """
    try:
        LOGGER.info("Received the event: %s", event)
        message = event.get("Records")[0] if event else raise Exception
        if 'sqs' in message.get("eventSource"):
            operation = 'create'
            payload = handle_source_sqs(message)
        else:
            operation = event.get('operation')
            payload = event.get('payload')
        operations = {
            'create': lambda x: DYNAMO.put_item(**x),
            'update': lambda x: DYNAMO.update_item(**x),
            'read': lambda x: DYNAMO.get_item(**x),
            'delete': lambda x: DYNAMO.delete_item(**x)
        }
        if operation in operations:
            return operations[operation](payload)
        LOGGER.error('Unrecognized operation %s', operation)
    except Exception as error:
        LOGGER.exception('Failed to handle event: %s', error)

