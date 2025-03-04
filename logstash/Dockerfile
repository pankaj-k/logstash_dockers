FROM docker.elastic.co/logstash/logstash:8.17.2

# Remove default pipeline configuration file
RUN rm -f /usr/share/logstash/pipeline/logstash.conf

# Copy custom config file for logstash. Input and output listed in it. 
COPY http_to_s3.conf /usr/share/logstash/pipeline/http_to_s3.conf

# Copy custom logstash.yml
COPY logstash.yml /usr/share/logstash/config/logstash.yml

# Copy custom pipelines.yml
COPY pipelines.yml /usr/share/logstash/config/pipelines.yml