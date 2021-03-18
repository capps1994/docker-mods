FROM alpine as buildstage

ARG TF_VERSION=latest

RUN apk add --no-cache curl jq && \
    if [ "${TF_VERSION}" = "latest" ]; then \
    TF_VERSION=$(curl -sX GET "https://api.github.com/repos/hashicorp/terraform/releases/latest" | jq -r .tag_name | awk '{print substr($1,2); }') \
    TG_VERSION=$(curl -sX GET "https://api.github.com/repos/gruntwork-io/terragrunt/releases/latest" | jq -r .tag_name ); \
    fi && \
    mkdir /root-layer && \
    wget -O /root-layer/terragrunt "https://github.com/gruntwork-io/terragrunt/releases/download/${TG_VERSION}/terragrunt_linux_amd64" && \
    wget -O  /root-layer/terraform.zip "https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip"&& \
    unzip /root-layer/terraform.zip -d /root-layer/terraform-folder/ && \
    mv /root-layer/terraform-folder/terraform /root-layer/terraform && \
    rm -r /root-layer/terraform-folder && \
    chmod +x /root-layer/terra*

FROM scratch

LABEL maintainer="capps1994"

# copy local files
COPY --from=buildstage /root-layer/ /
