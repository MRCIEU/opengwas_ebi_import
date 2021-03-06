FROM bioconductor/bioconductor_docker:devel

RUN apt-get update 
RUN apt-get -y install cron
RUN apt-get -y install ncftp

RUN R -e "remotes::install_github('mrcieu/GwasDataImport', upgrade='always')"

COPY ebi-cron /etc/cron.d/ebi-cron
RUN chmod 0644 /etc/cron.d/ebi-cron
RUN crontab /etc/cron.d/ebi-cron
RUN touch /var/log/cron.log
CMD cron && tail -f /var/log/cron.log
