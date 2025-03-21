import json
import boto3
import os

sns_client = boto3.client("sns")

# Fetch the SNS Topic ARN from an environment variable
SNS_TOPIC_ARN = os.getenv("SNS_TOPIC_ARN")

def lambda_handler(event, context):
    print("Received event:", json.dumps(event, indent=2))

    for record in event["detail"]:
        cluster_name = event["detail"]["clusterArn"].split("/")[-1]
        task_id = event["detail"]["taskArn"].split("/")[-1]
        status = event["detail"]["lastStatus"]

        # Create a formatted email message
        subject = f"ECS Task {status}: {task_id}"
        message = f"""
        🚀 **ECS Task Notification** 🚀

        - **Cluster:** {cluster_name}
        - **Task ID:** {task_id}
        - **Status:** {status}

        Check ECS Console for details.
        """

        # Send email via SNS
        sns_client.publish(
            TopicArn=SNS_TOPIC_ARN,
            Subject=subject,
            Message=message,
        )

    return {"statusCode": 200, "body": "Notification sent!"}
