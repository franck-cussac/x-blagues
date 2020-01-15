FROM debian:jessie as builder

RUN apt-get update && \
  apt-get install -y \
  musl-dev \
  musl-tools \
  xutils-dev \
  make \
  curl \
  pkgconf \
  git \
  g++ \
  ca-certificates \
  file

ENV PREFIX=/musl

ENV PATH=$PREFIX/bin:/root/.cargo/bin:$PATH \
    PKG_CONFIG_ALLOW_CROSS=true \
    PKG_CONFIG_ALL_STATIC=true \
    PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig \
    PQ_LIB_STATIC=true \
    OPENSSL_STATIC=true \
    OPENSSL_DIR=$PREFIX \
    LD_LIBRARY_PATH=$PREFIX/lib \
    SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt \
    SSL_CERT_DIR=/etc/ssl/certs \
    CC=musl-gcc

# OpenSSL have their own build system
RUN curl -sL http://www.openssl.org/source/openssl-1.0.2j.tar.gz | tar xz --strip-components=1 && \
    ./Configure no-shared --prefix=$PREFIX --openssldir=$PREFIX/ssl no-zlib linux-x86_64 && \
    make depend && make -j$(nproc) && make install

# Install Rustup, and a Rust toolchain
# Why nightly? Because Diesel uses compiler plugins only available on nightly.
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain stable && \
    rustup target add x86_64-unknown-linux-musl

COPY src/ /app/src
COPY Cargo.toml /app/Cargo.toml
COPY Cargo.lock /app/Cargo.lock
COPY build.rs /app/build.rs

WORKDIR /app
RUN cargo build --target x86_64-unknown-linux-musl --release

FROM ubuntu:18.04
COPY --from=builder /app/target/x86_64-unknown-linux-musl/release/x_blagues /x_blagues
ENV SLACK_API_TOKEN xxx-xxx-xxx-xxx

CMD ["/x_blagues"]
