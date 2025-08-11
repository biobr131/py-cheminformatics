FROM condaforge/miniforge3:latest

ARG DIR_WORK
WORKDIR ${DIR_WORK}

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        gcc \
        g++ \
        ca-certificates \
        curl \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ARG ENV_YML
COPY ${ENV_YML} ${DIR_WORK}/
ARG VENV
RUN mamba update -y -c conda-forge mamba && \
    mamba env create --file ${ENV_YML} && \
    mamba clean -i -t -y && \
    mamba run --name ${VENV} pip install --upgrade pip

ARG REQ_TXT
COPY ${REQ_TXT} ${DIR_WORK}/
RUN mamba run --name ${VENV} pip install --no-cache-dir -r ${REQ_TXT}

USER ubuntu

CMD ["mamba", "run", "--name", "${VENV}", "/bin/bash"]
