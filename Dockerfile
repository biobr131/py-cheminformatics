FROM condaforge/miniforge3:latest

ARG DIR_WORK
WORKDIR ${DIR_WORK}

RUN apt-get update && apt-get install -y build-essential gcc g++ && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ARG ENV_YML
COPY ${ENV_YML} ${DIR_WORK}/
RUN mamba update -y -c conda-forge mamba && \
    mamba env create --file ${ENV_YML} && \
    mamba clean -i -t -y

ARG VENV
ARG REQ_TXT
COPY ${REQ_TXT} ${DIR_WORK}/
RUN mamba run --name ${VENV} pip install --upgrade pip && \
    mamba run --name ${VENV} pip install --no-cache-dir -r ${REQ_TXT}
