FROM registry.test.test.corp/hyperloop/selenium-node-base:latest

ARG http_proxy=http://pilotproxy.abbey.gs.corp:80
ARG https_proxy=http://pilotproxy.abbey.gs.corp:80

USER root

# Google Chrome

ARG CHROME_VERSION="google-chrome-stable"
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
  && apt-get update -qqy \
  && apt-get -qqy install \
    ${CHROME_VERSION:-google-chrome-stable} \
  && rm /etc/apt/sources.list.d/google-chrome.list \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

USER 1000

COPY resources/chromedriver_linux64.zip /tmp/

# Chrome webdriver
ARG CHROME_DRIVER_VERSION=2.30

RUN rm -rf /opt/selenium/chromedriver \
  && unzip /tmp/chromedriver_linux64.zip -d /opt/selenium \
  && mv /opt/selenium/chromedriver /opt/selenium/chromedriver-$CHROME_DRIVER_VERSION \
  && chmod 755 /opt/selenium/chromedriver-$CHROME_DRIVER_VERSION \
  && sudo ln -fs /opt/selenium/chromedriver-$CHROME_DRIVER_VERSION /usr/bin/chromedriver

COPY generate_config /opt/bin/generate_config

# Chrome Launch Script Modification
COPY chrome_launcher.sh /opt/google/chrome/google-chrome

RUN sudo chmod -R 755 /opt/bin/generate_config
# Generating config inside the image rather than with entry_point.sh
RUN /opt/bin/generate_config > /opt/selenium/config.json
