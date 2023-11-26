#using base image
FROM python:3.9.18-bullseye
WORKDIR /

COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

COPY web_app.py . 

EXPOSE 32777

CMD ["python3","web_app.py"]

