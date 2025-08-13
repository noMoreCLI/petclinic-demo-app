#!/bin/bash

# Define the JAR file path
JAR_FILE="./jar/spring-petclinic-3.5.0-SNAPSHOT.jar"
# Define the log file path for the application's output
LOG_FILE="application.log"

echo "----------------------------------------------------"
echo "  Starting Spring PetClinic Application DB"
echo "----------------------------------------------------"

docker-compose up -d petclinic-db

echo "----------------------------------------------------"
echo "  Starting Spring PetClinic Application"
echo "----------------------------------------------------"

# Step 1: Stop any existing instance of the application.
# This ensures that we don't end up with multiple instances running.
echo "Attempting to stop any previously running instances..."
# Assuming 'stop.sh' is your script to kill the petclinic process.
# We'll redirect its output to /dev/null to keep this script's output clean,
# but you might want to remove '>/dev/null 2>&1' if you want to see its output.
./stop.sh

# Give a brief moment for the previous process to terminate
sleep 2

echo "Previous instances stopped (if any)."

# Step 2: Start the new application instance in the background.
# 'nohup' prevents the process from being terminated when the terminal session ends.
# 'java -jar' executes the Spring Boot application.
# '> $LOG_FILE 2>&1' redirects both standard output and standard error to the specified log file.
# '&' runs the command in the background, freeing up the terminal.
echo "Starting application: java -jar $JAR_FILE"
nohup java -jar "$JAR_FILE" > "$LOG_FILE" 2>&1 &

# Step 3: Get the Process ID (PID) of the newly started application.
# We use pgrep -f with a pattern that uniquely identifies our application.
# It's important to use a pattern specific enough to avoid matching other Java processes.
# We need to be careful here, as the 'pgrep' might pick up the old process if 'stop.sh'
# takes too long or fails. A more robust way would be to check for the PID after starting.
# For simplicity, we'll try to find it immediately after starting.
# A more robust approach might involve checking the log file for a specific startup message
# or using a more sophisticated process management tool like systemd.
# However, for this basic script, we'll assume it starts quickly.
NEW_PID=$(pgrep -f "java.*$JAR_FILE")

if [ -z "$NEW_PID" ]; then
    echo "ERROR: Failed to start the application or retrieve its PID."
    echo "Check '$LOG_FILE' for details."
else
    echo "Application started successfully in the background."
    echo "PID: $NEW_PID"
    echo "Output redirected to: $LOG_FILE"
    echo "You can check the application status using: tail -f $LOG_FILE"
fi

echo "----------------------------------------------------"
echo "  Startup process complete."
echo "----------------------------------------------------"