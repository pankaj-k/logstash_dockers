# logstash-docker-v0.1
The ECS Fargate is configured to increase the number of tasks when the CPU is above 50% in this example.
To generate such load you can use Apache Benchmark which strangely comes preinstalled on Fedora.  

Use Apache Benchmark (ab)

If Logstash is set up to accept HTTP logs:

ab -n 100000 -c 100 http://logstash-server:5044/

Sends 100,000 requests with 100 concurrent connections.