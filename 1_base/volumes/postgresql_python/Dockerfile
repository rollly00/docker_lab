FROM python:3.7-alpine

WORKDIR /flask/app

RUN apk add --no-cache postgresql-libs --virtual .build-deps gcc musl-dev postgresql-dev

COPY . /flask/app/

RUN pip install -r requirements.txt

EXPOSE 5000

CMD ["flask", "run"]
