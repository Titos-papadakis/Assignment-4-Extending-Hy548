FROM python:3.9-slim
RUN pip install kopf kubernetes jinja2
COPY controller.py /controller.py
CMD kopf run /controller.py --verbose