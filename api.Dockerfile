ARG GIT_IMAGE=alpine/git
ARG PYTHON_VERSION=3.11

FROM ${GIT_IMAGE} AS builder
ARG API_REPO=https://github.com/icpac-igad/fast-cgan.git
ARG VIZ_REPO=https://github.com/Fenwick-Cooper/show-forecasts.git

RUN git clone --depth 1 ${API_REPO} /tmp/api && git clone --depth 1 -b for-mercury ${VIZ_REPO} /tmp/viz

FROM python:${PYTHON_VERSION}-slim AS runner

ARG WORK_HOME=/opt/app
ARG USER_NAME=cgan
ARG USER_ID=1000
ARG GROUP_ID=1000

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends git rsync ssh ca-certificates pkg-config \
    libgdal-dev libgeos-dev libproj-dev gdal-bin libcgal-dev libxml2-dev libsqlite3-dev  \
    gcc g++ dvipng libfontconfig-dev libjpeg-dev libspng-dev libx11-dev libgbm-dev \
    libeccodes-dev libeccodes-tools && mkdir -p ${WORK_HOME}/.ssh

RUN groupadd --gid ${GROUP_ID} ${USER_NAME} && \
    useradd --home-dir ${WORK_HOME} --uid ${USER_ID} --gid ${GROUP_ID} ${USER_NAME} && \
    chown -Rf ${USER_NAME}:${USER_NAME} ${WORK_HOME}

USER ${USER_NAME}
WORKDIR ${WORK_HOME}

COPY --from=builder --chown=${USER_ID}:root /tmp/viz ${WORK_HOME}/show-forecasts
COPY --from=builder --chown=${USER_ID}:root /tmp/api/README.md /tmp/api/pyproject.toml /tmp/api/poetry.lock ${WORK_HOME}/
COPY --from=builder --chown=${USER_ID}:root /tmp/api/fastcgan ${WORK_HOME}/fastcgan

RUN python -m venv ${WORK_HOME}/.venv
ENV PATH=${WORK_HOME}/.local/bin:${WORK_HOME}/.venv/bin:${PATH} VIRTUAL_ENV=${WORK_HOME}/.venv WORK_HOME=${WORK_HOME}
RUN pip install --no-cache-dir --upgrade poetry && \
    cd ${WORK_HOME}/show-forecasts && poetry install && \
    cd ${WORK_HOME} && poetry install && touch ${WORK_HOME}/.env

CMD ["poetry", "run", "uvicorn", "fastcgan.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
