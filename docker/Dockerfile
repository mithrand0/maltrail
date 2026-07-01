###############
# build image #
###############
FROM python:3.14-trixie AS build

# Other environment variables
ENV VENV="/opt/maltrail"
ENV PATH="${VENV}/bin:${PATH}"

# Pypcap-ng
RUN --mount=type=cache,target=/var/lib/apt apt -qq update && apt -y install libpcap-dev

# Virtualenv
RUN python -m venv $VENV

# Switch to working directory
WORKDIR ${VENV}

# Pip
COPY requirements.txt ./
RUN pip install -r requirements.txt

####################
# production image #
####################
FROM python:3.14-slim-trixie

# Env
ENV VENV="/opt/maltrail"
ENV PATH="${VENV}/bin:${PATH}"

ENV PYTHONUNBUFFERED=1 \
    PYTHONWARNINGS=ignore \
    DEBIAN_FRONTEND=noninteractive

# Workdir
WORKDIR ${VENV}

# Copy maltrail dependencies from build container
COPY --from=build ${VENV} ${VENV}

# Copy required maltrail directories and files
COPY core core
COPY html html
COPY misc misc
COPY plugins plugins
COPY thirdparty thirdparty
COPY trails trails
COPY maltrail.conf maltrail.conf

COPY sensor.py sensor.py
COPY server.py server.py

# Initial update of trails
RUN python core/update.py

# Store those trails outside of the container for initial startup
RUN mv /root/.maltrail /root/.maltrail-dist

# Install required packages
RUN --mount=type=cache,target=/var/lib/apt apt -qq update && apt -y install libpcap0.8t64 schedtool tini

# Keep things compatible with the compose instructions'
COPY docker/start.sh /start.sh

# Places where maltrail writes files
VOLUME /root/.maltrail
VOLUME /var/log/maltrail

# Run a very simple test if everything works
RUN python server.py --version
RUN python sensor.py --version

# Expose server ports
EXPOSE 8337/udp
EXPOSE 8338/tcp

# entrypoint
ENTRYPOINT ["/usr/bin/tini", "--", "/start.sh"]
