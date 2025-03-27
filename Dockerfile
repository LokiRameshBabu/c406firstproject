FROM python:3.9-slim

WORKDIR /app

COPY dist/*.whl .
RUN pip install *.whl

CMD ["myapp"]
