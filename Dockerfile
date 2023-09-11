FROM myoung34/github-runner:latest

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR /install-chrome
COPY install-chrome.sh /install-chrome

RUN echo en_US.UTF-8 UTF-8 >> /etc/locale.gen \
  && chmod +x /install-chrome/install-chrome.sh \
  && /install-chrome/install-chrome.sh

WORKDIR /actions-runner

ENTRYPOINT ["/entrypoint.sh"]
CMD ["./bin/Runner.Listener", "run", "--startuptype", "service"]
