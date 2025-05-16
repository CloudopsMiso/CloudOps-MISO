FROM python:3.12

WORKDIR /app

COPY requirements.txt .

RUN python -m venv venv && \
    . venv/bin/activate && \
    pip install --no-cache-dir -r requirements.txt

COPY . .

COPY newrelic.ini .


ENV NEW_RELIC_CONFIG_FILE=newrelic.ini

EXPOSE 8000

CMD ["venv/bin/newrelic-admin", "run-program", "venv/bin/python", "src/application.py"]

