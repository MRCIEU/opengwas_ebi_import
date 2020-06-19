# FROM rocker/r-base
FROM bioconductor/bioconductor_docker:devel

RUN apt-get update && apt-get -y install cron

RUN R -e "remotes::install_github('mrcieu/GwasDataImport', upgrade='always')"

RUN mkdir -p /app
COPY . /app/

COPY ebi-cron /etc/cron.d/ebi-cron

RUN chmod 0644 /etc/cron.d/ebi-cron
RUN crontab /etc/cron.d/ebi-cron
RUN touch /var/log/cron.log

CMD cron && tail -f /var/log/cron.log
