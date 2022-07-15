FROM python:3.9-alpine3.13
LABEL maintainer="ftcds.net"

ENV PYTHONUNBUFFERED 1


COPY ./requeriments.txt /tmp/requeriments.txt
COPY ./requeriments.dev.txt /tmp/requeriments.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .tmp_build_devs  \
        build-base postgresql-dev  musl-dev && \
    /py/bin/pip install -r /tmp/requeriments.txt && \
    if [ ${DEV} = "true" ]; \
        then /py/bin/pip install -r /tmp/requeriments.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    apk del .tmp_build_devs && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH="/py/bin:$PATH"

USER django-user