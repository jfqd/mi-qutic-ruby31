#!/usr/bin/bash
# Configure ssh public and private key for root user in mdata variable

if mdata-get logstash_redis 1>/dev/null 2>&1; then
  LOGSTASH_REDIS=$(mdata-get logstash_redis | sed "s/,/\",\"/")

  sed -i \
      -e "s#127.0.0.1#${LOGSTASH_REDIS}#" \
      /opt/local/etc/beats/filebeat.yml
fi

if mdata-get logstash_tags 1>/dev/null 2>&1; then
  LOGSTASH_TAGS=$(mdata-get logstash_tags)

  sed -i \
      -e "s/\"@tags\": \"ruby\"/\"@tags\": \"${LOGSTASH_TAGS}\"/" \
      /opt/local/etc/beats/filebeat.yml
fi

if mdata-get logstash_type 1>/dev/null 2>&1; then
  LOGSTASH_TYPE=$(mdata-get logstash_type)

  sed -i \
      -e "s/\"@type\": \"ruby\"/\"@type\": \"${LOGSTASH_TYPE}\"/" \
      /opt/local/etc/beats/filebeat.yml
fi

svcadm restart svc:/pkgsrc/beats:filebeat