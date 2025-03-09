# logstash-docker-v0.1
Simple Docker based Logstash

Version of logstash pulled is fixed so that there is uniformity.
http input is used so that it is easy to test out the image created.

We use github as code repo. Github actions for compiling the code and pushing it to Docker Hub and AWS ECR.

Before Github action is run, make sure that docker hub has logstash-8.17.2 and AWS ECR has logstash-8.17.2 repo is already created.

Docker Hub repo creation is manual.

For AWS repo creation, go to logstash_dockers/terraform, comment out contents of ecs.tf and run:
terraform init
terraform apply -auto-approve=true
terraform destroy -auto-approve=true

Then make changes to docker-push.yml , like an extra space and then push the code to github so that github actions send image to both docker hub and the aws ecr repo just created above step.

Then uncomment the ecs.tf and run terraform again. That then creates a ecs fargate service using the image 
sent to the ecr.

The repo in github will need secrets to be added to it so that it is able to connect to docker hub and AWS. 
Repo-> Settings-> Security-> Secrets and variables-> Actions

AWS_ACCESS_KEY_ID	
AWS_ACCOUNT_ID
AWS_REGION
AWS_SECRET_ACCESS_KEY
DOCKERHUB_USERNAME
DOCKER_PASSWORD

DOCKER_PASSWORD is your personal access token you create in docker hub.
DOCKERHUB_USERNAME is your userid not your email.