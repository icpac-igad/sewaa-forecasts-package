ARG PYTHON_VERSION=3.10

FROM alpine/git AS builder
ARG API_REPO=https://github.com/icpac-igad/fast-cgan.git
ARG GAN_REPO=https://github.com/jaysnm/ensemble-cgan.git
ARG GAN_BRANCH=Jurre_brishti

RUN git clone --depth 1 ${API_REPO} /tmp/api && git clone --depth 1 -b ${GAN_BRANCH} ${GAN_REPO} /tmp/cgan


FROM python:${PYTHON_VERSION}-slim AS runner

# image build step variables
ARG USER_NAME=cgan
ARG USER_ID=1000
ARG GROUP_ID=1000
ARG WORK_HOME=/opt/cgan

# install system libraries
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends git rsync ssh ca-certificates pkg-config \
    libgdal-dev libgeos-dev libproj-dev gdal-bin libcgal-dev libxml2-dev libsqlite3-dev  \
    gcc g++ dvipng libfontconfig-dev libjpeg-dev libspng-dev libx11-dev libgbm-dev git \
    libeccodes-dev libeccodes-tools && mkdir -p ${WORK_HOME}/.local/bin ${WORK_HOME}/.ssh


RUN groupadd --gid ${GROUP_ID} ${USER_NAME} && \
    useradd --home-dir ${WORK_HOME} --uid ${USER_ID} --gid ${GROUP_ID} ${USER_NAME} && \
    chown -Rf ${USER_NAME}:${USER_NAME} ${WORK_HOME}

USER ${USER_NAME}
WORKDIR ${WORK_HOME}
ENV PATH=${WORK_HOME}/.local/bin:$PATH

COPY --from=builder --chown=${USER_NAME}:root /tmp/cgan ${WORK_HOME}/ensemble-cgan 
RUN cd ${WORK_HOME}/ensemble-cgan && pip install --upgrade pip && pip install --no-cache-dir -e .

COPY --from=builder --chown=${USER_NAME}:root /tmp/api/pyproject.toml /tmp/api/poetry.lock /tmp/api/README.md ${WORK_HOME}/
COPY --from=builder --chown=${USER_NAME}:root /tmp/api/fastcgan ${WORK_HOME}/fastcgan

RUN cd ${WORK_HOME} && pip install --no-cache-dir -e .

CMD ["python", "fastcgan/jobs/manager.py"]
