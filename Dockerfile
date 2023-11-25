# 기반 이미지 설정
FROM alpine:3.14.2
# FROM ubuntu:22.04

# narwhal-node 바이너리를 컨테이너로 복사
COPY /home/jyr/go/bin/geth /usr/local/bin/
COPY entrypoint.sh /usr/local/bin/

# 실행 권한 설정
RUN chmod +x /usr/local/bin/geth
RUN chmod +x /usr/local/bin/entrypoint.sh

# CMD /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/bin/bash", "/usr/local/bin/entrypoint.sh"]
