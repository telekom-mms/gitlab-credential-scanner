# use the official kics image as basis image
FROM checkmarx/kics:v2.1.20-debian@sha256:b29ec62a21fb97f0b65aee2307fcb29dd334c1e39e2c1f1cfe56102fce1c6be4

WORKDIR /

ENV GITLAB_ACCESS_TOKEN=GITLAB_ACCESS_TOKEN

# copy the requirements.txt, repo_scanner.py, and templates directory to the container
COPY requirements.txt .
COPY repo_scanner.py .
COPY templates ./templates/.

# install python3, python3-venv, and the required python packages in a virtual environment
RUN set -eux; \
  apt-get update && \
  apt-get install -y --no-install-recommends \
  python3=3.13.5-1 \
  python3-venv=3.13.5-1 && \
  apt-get clean all && \
  rm -rf /var/lib/apt/lists/* && \
  python3 -m venv .venv && \
  . .venv/bin/activate && \
  pip install --no-cache-dir -r requirements.txt

# set the entrypoint to run the repo_scanner.py script when the container starts
ENTRYPOINT ["/.venv/bin/python3", "repo_scanner.py"]
