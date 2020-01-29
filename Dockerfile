FROM openjdk:8-jre-slim
RUN  useradd -ms /bin/bash rce-run
RUN  apt-get update && apt-get install -y wget sudo && rm -rf /var/lib/apt/lists/*
ARG  RCE_BASE_URL=https://software.dlr.de/updates/rce/10.x/products/standard/releases/latest
RUN  wget -nv -O /VERSION ${RCE_BASE_URL}/zip/VERSION \
 &&  VERSION=$(cat /VERSION) \
 &&  RCE_ZIP_URL=${RCE_BASE_URL}/zip/rce-${VERSION}-standard-linux.x86_64.zip \
 &&  echo Downloading $RCE_ZIP_URL ... \
 &&  wget -nv -O /tmp/rce.zip ${RCE_ZIP_URL} \
 &&  unzip /tmp/rce.zip -d / \
 &&  rm /tmp/rce.zip \
 &&  chmod +x /rce/rce
COPY entrypoint.sh /entrypoint.sh
#  patch log configuration
COPY logging.conf /rce/configuration/services/org.ops4j.pax.logging.properties
#  copy configuration templates
COPY configuration*.json /presets/
#  adjust permissions
RUN  chmod a+rx /entrypoint.sh \
 &&  mkdir /profile \
 &&  chown rce-run: -R /presets /profile
#  expose default ports for standard connections and SSH; may or may not be actually used
EXPOSE 20001 30001
USER rce-run
ENTRYPOINT ["/entrypoint.sh"]
