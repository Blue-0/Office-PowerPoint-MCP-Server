FROM python:3.10-alpine
RUN apk add --no-cache gcc musl-dev libffi-dev
WORKDIR /app
COPY . .
RUN pip install --no-cache-dir -r requirements.txt

# Le binaire/script uniquement ici :
ENTRYPOINT ["python", "/app/ppt_mcp_server.py"]
# Arguments par défaut (overridable par compose `command`)
CMD ["--transport", "http", "--port", "8000"]
