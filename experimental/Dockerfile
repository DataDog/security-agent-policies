FROM hashicorp/terraform:1.14.0-alpha20250827
COPY policies /policies

WORKDIR /policies/hash-exec
RUN terraform init
