import boto3
import botocore.exceptions

s3_client = boto3.client('s3')


def s3_bucket_data_check(bucket_name, prefix):
    response = s3_client.list_objects_v2(Bucket=bucket_name,
                                         Prefix=prefix)
    return response['KeyCount'] > 0


def write_to_s3(data, bucket_name, ticker, quarter_end):
    prefix = f"ticker={ticker}/quarter_end={quarter_end}"
    try:
        response = s3_client.put_object(
                    Bucket=bucket_name,
                    Key=f"{prefix}/data.json",
                    Body=data,
                    ContentType="application/json",
                    )
    except botocore.exceptions.ClientError as e:
        print(f"Error caught: {e}")
        raise
    else:
        print(f'''File successfully uploaded. HTTP Status Code:
                {response['ResponseMetadata']['HTTPStatusCode']}''')
        return True
