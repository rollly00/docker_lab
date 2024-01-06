FROM python:3.7-slim

WORKDIR /app

ENV FLASK_APP=src/app.py

RUN apt-get update && apt-get install python3-dev -y

RUN groupadd -g 1000 app && useradd -m -u 1002 -g app app

COPY src src/

COPY docker-entrypoint.sh /app

COPY requirements.txt /app

COPY setup.py /app

RUN pip install -r requirements.txt

EXPOSE 8000

ENTRYPOINT ["./docker-entrypoint.sh"]