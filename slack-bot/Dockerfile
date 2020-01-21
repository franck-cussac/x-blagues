FROM rust:1.40-buster as builder

# First make a dumb release to get all dependencies cached
WORKDIR /app
COPY Cargo.toml Cargo.toml
RUN mkdir src/
RUN echo "fn main() {println!(\"if you see this, the build broke\")}" > src/main.rs
RUN cargo build --release
RUN rm -f target/release/deps/x_blagues*

# then build the real app
COPY src/ ./src
COPY build.rs build.rs
RUN cargo build --release

FROM debian:buster-slim
RUN apt-get update -y && apt-get install -y openssl libssl-dev ca-certificates
# copy the binary into the final image
COPY --from=builder /app/target/release/x_blagues /x_blagues
ENV SLACK_API_TOKEN xxx-xxx-xxx-xxx
CMD ["/x_blagues"]
