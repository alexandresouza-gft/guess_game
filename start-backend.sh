#!/bin/bash

# Define environment variables
export FLASK_APP="run.py"
export FLASK_DB_TYPE="postgres"
export FLASK_DB_USER="gameadmin"
export FLASK_DB_NAME="gamedb"
export FLASK_DB_PASSWORD="secretpassword"
export FLASK_DB_HOST="localhost" # Nome do serviço definido no docker-compose.yml
export FLASK_DB_PORT="5432"

# Run the Flask application
flask run --host=0.0.0.0 --port=5000
