#FROM python:alpine3.10
#LABEL maintainer="sloboda282API.com"
#ENV PYTHONBUFFERED 1
#COPY ./requirements.txt /tmp/requirements.txt
#COPY . ./app
#WORKDIR /app
#EXPOSE 8000
#
#RUN python -m venv /py && \
#    /py/bin/pip install --upgrade pip && \
#    /py/bin/pip install -r /tmp/requirements.txt && \
#    rm -rf /tmp && \
#    adduser \
#        --disabled-password \
#        --no-create-home \
#        django-user
#
#ENV PATH="/py/bin:$PATH"
#USER django-user
#FROM python:alpine3.10
#LABEL maintainer="sloboda282API.com"
#ENV PYTHONBUFFERED 1
#COPY ./requirements.txt /tmp/requirements.txt
#COPY ./requirements.dev.txt /tmp/requrements.dev.txt
#COPY ./app ./app
#WORKDIR /app
#EXPOSE 8000
#
#ARG DEV=false
#RUN apk update && \
#    apk add --no-cache postgresql-libs && \
#    apk add --no-cache --virtual .build-deps gcc musl-dev postgresql-dev && \
#    python -m venv /py && \
#    /py/bin/pip install --upgrade pip && \
#    /py/bin/pip install -r /tmp/requirements.txt && \
#    if [ $DEV="true" ]: \
#        then /py/bin/pip install -r requirements.dev.txt ; \
#    fi && \
#    rm -rf /tmp && \
#    adduser \
#        --disabled-password \
#        --no-create-home \
#        django-user && \
#    apk --purge del .build-deps
#
#ENV PATH="/py/bin:$PATH"
#USER django-user
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
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; then \
        /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user && \
    apk --purge del .build-deps

ENV PATH="/py/bin:$PATH"

USER django-user