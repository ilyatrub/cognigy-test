FROM python:alpine

# Create working directory for application
WORKDIR /app
# Copy dependency file
COPY requirements.txt .
# Install dependecies
RUN pip install -r requirements.txt
# Copy source code
COPY main.py .
# Set env variable for flask
ENV FLASK_APP=main.py
# Expose default port
EXPOSE 3000
# Run application
ENTRYPOINT [ "flask" ]
CMD [ "run", "--host", "0.0.0.0", "--port", "3000" ]