ARG GIT_IMAGE=alpine/git
ARG PYTHON_VERSION=3.11

FROM ${GIT_IMAGE} AS builder
ARG API_REPO=https://github.com/icpac-igad/fast-cgan.git

RUN git clone --depth 1 ${API_REPO} /tmp/api

FROM python:${PYTHON_VERSION}-slim AS runner

ARG WORK_HOME=/opt/app
ARG USER_NAME=cgan
ARG USER_ID=1000
ARG GROUP_ID=1000

RUN apt-get update -y && \
    apt-get install libeccodes-dev git -y --no-install-recommends && \
    mkdir -p ${WORK_HOME}/.local/bin

RUN groupadd --gid ${GROUP_ID} ${USER_NAME} && \
    useradd --home-dir ${WORK_HOME} --uid ${USER_ID} --gid ${GROUP_ID} ${USER_NAME} && \
    chown -Rf ${USER_NAME}:${USER_NAME} ${WORK_HOME}

USER ${USER_NAME}
WORKDIR ${WORK_HOME}

COPY --from=builder --chown=${USER_ID}:root /tmp/api/README.md /tmp/api/pyproject.toml /tmp/api/poetry.lock ${WORK_HOME}/
COPY --from=builder --chown=${USER_NAME}:root /tmp/api/fastcgan ${WORK_HOME}/fastcgan
ENV PATH=${WORK_HOME}/.local/bin:${PATH}
RUN pip install --upgrade pip && pip install --no-cache-dir -e .

CMD ["uvicorn", "fastcgan.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
