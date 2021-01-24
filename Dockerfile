ARG ROS_DISTRO

FROM ros:${ROS_DISTRO}-ros-base

ARG DOCKER_USER=orise

RUN useradd -s /bin/bash ${DOCKER_USER}

RUN echo "${DOCKER_USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/${DOCKER_USER} && \
    chmod 0440 /etc/sudoers.d/${DOCKER_USER}

# install gosu
RUN set -eux; \
    apt-get update; \
    apt-get install -y gosu; \
    rm -rf /var/lib/apt/lists/*; \
    gosu nobody true

# install common dev tools
RUN export DEBIAN_FRONTEND=noninteractive; \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    bash-completion \
    pkg-config \
    git \
    python3-pip \
    vim \
    && rm -rf /var/lib/apt/lists/*

# install ament_flake8 non-declared pip deps
RUN pip3 install \
    flake8-blind-except \
    flake8-builtins \
    flake8-class-newline \
    flake8-comprehensions \
    flake8-deprecated \
    flake8-docstrings \
    flake8-import-order \
    flake8-quotes

# install ros tools
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    python3-colcon-mixin \
    python3-vcstool \
    python3-colcon-common-extensions \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /home/${DOCKER_USER}/devel_ws && chown ${DOCKER_USER}:${DOCKER_USER} /home/${DOCKER_USER}/devel_ws;

WORKDIR /home/${DOCKER_USER}/devel_ws

COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["bash"]
