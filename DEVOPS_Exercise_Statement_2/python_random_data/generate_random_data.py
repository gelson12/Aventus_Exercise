# generate_random_data.py
import json
import random
import string

def lambda_handler(event, context):
    # Generate random data
    random_data = ''.join(random.choices(string.ascii_letters + string.digits, k=10))
    
    # Logic to save data to an S3 bucket can be added here if doing so directly from Lambda
    #  just returning the random data

    return {
        'statusCode': 200,
        'body': json.dumps({'random_data': random_data})
    }
