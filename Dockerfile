FROM debian:stretch

RUN apt-get update \
 && apt-get -y install cron git nodejs python3 python3-pip \
 && rm -rf /var/lib/apt/lists/*
RUN pip3 install --upgrade cfscrape prometheus_client pytz requests

ADD crontab /etc/cron.d/healthstats
RUN chmod 0644 /etc/cron.d/healthstats \
 && crontab /etc/cron.d/healthstats

COPY . /healthstats
RUN chmod +x /healthstats/entrypoint.sh

ENTRYPOINT ["/healthstats/entrypoint.sh"]
CMD env - `cat $HOME/.env` /usr/bin/python3 /healthstats/collector.py
