# use the official kics image as basis image
FROM checkmarx/kics:alpine@sha256:990ae994fbbe59760c8e4f7e89b1193a39a0c2968909058ec29335cb6d80efc1

WORKDIR /

ENV GITLAB_ACCESS_TOKEN=GITLAB_ACCESS_TOKEN

# install necessary packages
RUN export OGUSER=$(whoami)
USER root
RUN apk --no-cache add python3 py3-pip py3-setuptools
USER $OGUSER

# install python packages from our requirements.txt
COPY requirements.txt .
RUN pip3 install --break-system-packages --no-cache-dir -r requirements.txt

# copy and execute repo_scanner.py
COPY repo_scanner.py .
COPY templates ./templates/.
ENTRYPOINT ["python3", "repo_scanner.py"]
