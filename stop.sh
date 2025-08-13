#!/bin/bash

# --- Configuration with Default Values ---

# Default pattern to search for in the process command line.
# This can be overridden by the environment variable KILL_PROCESS_PATTERN.
# Example: export KILL_PROCESS_PATTERN="my_other_app.jar"
DEFAULT_PROCESS_PATTERN="java.*jar/spring-petclinic-3.5.0-SNAPSHOT.jar"
PROCESS_PATTERN="${KILL_PROCESS_PATTERN:-$DEFAULT_PROCESS_PATTERN}"

# Default kill signal to send to the process.
# Use -9 for SIGKILL (forceful), -15 for SIGTERM (graceful).
# This can be overridden by the environment variable KILL_SIGNAL.
# Example: export KILL_SIGNAL="-15"
DEFAULT_KILL_SIGNAL="-9" # SIGKILL (forceful)
KILL_SIGNAL="${KILL_SIGNAL:-$DEFAULT_KILL_SIGNAL}"

# --- Script Logic ---

echo "--- Process Killer Script ---"
echo "Targeting process pattern: '$PROCESS_PATTERN'"
echo "Using kill signal: '$KILL_SIGNAL'"
echo "-----------------------------"

# Find the Process ID(s) (PID) of the matching process(es).
# 'pgrep -f' searches the full command line of all running processes.
PIDS=$(pgrep -f "$PROCESS_PATTERN")

# Check if any PIDS were found
if [ -z "$PIDS" ]; then
    echo "No process found matching the specified pattern."
else
    echo "Found process(es) with PID(s): $PIDS"
    echo "Attempting to kill process(es) with signal $KILL_SIGNAL..."

    # Kill the found process(es).
    # Using 'eval' allows the KILL_SIGNAL variable to be interpreted correctly,
    # as 'kill' expects the signal as a separate argument (e.g., 'kill -9 PID').
    # It's generally safe here because KILL_SIGNAL is controlled internally or by a trusted ENV var.
    eval kill "$KILL_SIGNAL" "$PIDS"

    # Check the exit status of the kill command
    if [ $? -eq 0 ]; then
        echo "Process(es) killed successfully."
    else
        echo "Failed to kill process(es). Check permissions or if the process is still running."
    fi
fi

echo "--- Script Finished ---"