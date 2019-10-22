FROM alpine/git:1.0.7 AS git
WORKDIR /httpbin
ENV HTTPBIN_GIT_TAG v0.4.1
RUN git clone https://github.com/postmanlabs/httpbin.git . && \
    git checkout ${HTTPBIN_GIT_TAG} && \
    rm -rf .git/ .gitignore


FROM ubuntu:18.04
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
RUN apt update -y && apt install python3-pip git -y && pip3 install --no-cache-dir pipenv
WORKDIR /httpbin

COPY --from=git /httpbin/Pipfile /httpbin/Pipfile.lock /httpbin/
RUN /bin/bash -c "pip3 install --no-cache-dir -r <(pipenv lock -r)"

COPY --from=git /httpbin/. /httpbin
RUN pip3 install --no-cache-dir /httpbin

EXPOSE 80

CMD ["gunicorn", "-b", "0.0.0.0:80", "httpbin:app", "-k", "gevent"]
