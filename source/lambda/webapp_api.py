"""
This Module is to create API for
Web Application.
"""
import os
import logging
import json
import boto3

LOGGER = logging.getLogger(__name__)
DYNAMO_TABLE = ''
DYNAMO = boto3.resource('dynamodb').Table(DYNAMO_TABLE)

def lambda_handler(even, context):
    """
    This Function is the Lambda Handler
    for Web Application API
    """
    try:
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
        LOGGER.error('Unrecognized operation %', operation)
    except Exception as error:
        LOGGER.exception('Failed to handle event: %s', error)

