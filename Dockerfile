FROM alpine:3.11
RUN apk add --no-cache py3-pip bash findutils jq && \
 pip3 install jinja2-cli jinja2-ansible-filters yq

ADD . /execfuse-jinja2 

WORKDIR /execfuse-jinja2

ENTRYPOINT [ "/execfuse-jinja2/wrapper.sh" ]
