
FROM python:alpine3.10

LABEL maintainer="sloboda282API.com"

ENV PYTHONBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app

WORKDIR /app

EXPOSE 8000

ARG DEV=false

RUN apk update && \
    apk add --no-cache postgresql-libs && \
    apk add --no-cache --virtual .build-deps gcc musl-dev postgresql-dev && \
    python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .tmp-build-dev \
        build-base postgresql-dev musl-dev && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; then \
        /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    apk del .tmp-build-dev && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user && \
    apk --purge del .build-deps postgresql-dev musl-dev gcc && \
    rm -rf /var/cache/apk/*

ENV PATH="/py/bin:$PATH"

USER django-user