FROM python:3.7-alpine

WORKDIR /flask/app

RUN apk add --no-cache postgresql-libs --virtual .build-deps gcc musl-dev postgresql-dev

COPY app/ /flask/app/

RUN pip install -r requirements.txt

ENV FLASK_APP=app.py

ENV FLASK_RUN_HOST=0.0.0.0

EXPOSE 5000

CMD ["flask", "run"]
