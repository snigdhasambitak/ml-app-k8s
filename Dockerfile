FROM python:3.8.9

LABEL maintainer="snigdhasambit"

WORKDIR /app
COPY requirements.txt /app/

RUN pip install --no-cache-dir -r requirements.txt

ADD ./core ./core
ADD ./models ./models
ADD main.py main.py

EXPOSE 8080

CMD [ "gunicorn", "--bind", "0.0.0.0:8080", "main:app" ]
