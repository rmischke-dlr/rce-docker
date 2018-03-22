FROM openjdk:8-jre-slim
RUN useradd -ms /bin/bash rce-run
RUN apt-get update && apt-get install -y wget sudo && rm -rf /var/lib/apt/lists/*
ARG RCE_BASE_URL=https://updates-external.sc.dlr.de/rce/9.x/products/standard/snapshots/trunk
RUN wget -nv -O VERSION.tmp ${RCE_BASE_URL}/zip/VERSION \
  && VERSION=$(cat VERSION.tmp) \
  && RCE_ZIP_URL=${RCE_BASE_URL}/zip/rce-${VERSION}-standard-linux.x86_64.zip \
  && echo Downloading $RCE_ZIP_URL ... \
  && wget -nv -O /tmp/rce.zip ${RCE_ZIP_URL} \
  && unzip /tmp/rce.zip -d / \
  && rm /tmp/rce.zip \
  && chmod +x /rce/rce
COPY entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh
# patch log configuration
COPY logging.conf /rce/configuration/services/org.ops4j.pax.logging.properties
USER rce-run
ENTRYPOINT ["/entrypoint.sh"]
