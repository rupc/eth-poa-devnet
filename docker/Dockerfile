# 기반 이미지 설정
# FROM alpine:3.14.2
FROM ubuntu:22.04
# FROM python:3.11.6-bookworm

# RUN apt-get update && \
#     apt-get install -y jq && \
#     rm -rf /var/lib/apt/lists/*

# narwhal-node 바이너리를 컨테이너로 복사
COPY geth /usr/local/bin/
COPY entrypoint.sh /usr/local/bin/

# 실행 권한 설정
RUN chmod +x /usr/local/bin/geth
RUN chmod +x /usr/local/bin/entrypoint.sh

# CMD /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/bin/bash", "/usr/local/bin/entrypoint.sh"]
