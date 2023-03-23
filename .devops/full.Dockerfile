ARG UBUNTU_VERSION=22.04

FROM ubuntu:$UBUNTU_VERSION as base

RUN apt update && \
    apt install -y build-essential ninja-build python3 python3-pip aria2 && \
    pip3 install --upgrade pip setuptools wheel cmake

FROM base as build

RUN apt update && \
    apt install -y build-essential ninja-build python3 python3-pip && \
    pip3 install cmake

WORKDIR /app

COPY . .

RUN mkdir -p build && \
    cd build && \
    cmake -G Ninja .. && \
    cmake --build .

FROM base as runtime

WORKDIR /app

COPY . .
COPY --from=build /app/build/bin/* .

RUN pip3 install -r requirements.txt

ENTRYPOINT ["/app/.devops/tools.sh"]
