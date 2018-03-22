FROM rce/base:latest
USER root
COPY configuration.json /home/rce-run/.rce/default/configuration.json
RUN chown rce-run: /home/rce-run/.rce -R
USER rce-run
