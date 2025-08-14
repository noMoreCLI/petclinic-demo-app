#!/bin/bash

MY_IP=""
OS=$(uname -s)

case "$OS" in
    "Darwin")
        echo "Detected OS: macOS"
        # Get the default network interface name (e.g., en0, en1)
        DEFAULT_INTERFACE=$(route -n get default | grep interface | awk '{print $2}')
        if [ -z "$DEFAULT_INTERFACE" ]; then
            error_exit "Could not determine default network interface on macOS."
        fi

        # Get the IP address using ifconfig and robust awk parsing
        # This awk command looks for lines with "inet " but NOT "inet6", then prints the 2nd field.
        MY_IP=$(ifconfig "$DEFAULT_INTERFACE" | awk '/inet / && !/inet6/ {print $2}' | head -n 1)

        if [ -z "$MY_IP" ]; then
            error_exit "Could not determine IP address for interface '$DEFAULT_INTERFACE' on macOS."
        fi
        ;;
    "Linux")
        echo "Detected OS: Linux"
        # Get the IP address using ip command and awk/cut
        # This gets the first non-loopback IPv4 address
        MY_IP=$(ip -4 a | awk '/inet /{print $2}' | cut -d/ -f1 | grep -v '127.0.0.1' | head -n 1)

        if [ -z "$MY_IP" ]; then
            error_exit "Could not determine IP address on Linux. Is 'ip' command available and configured?"
        fi
        ;;
    *)
        error_exit "Unsupported operating system: $OS. This script supports macOS and Linux."
        ;;
esac

echo "Detected IP address: $MY_IP"
# Define the port
PORT="8080"
# Construct the BASE_URL
BASE_URL="http://$MY_IP:$PORT"

counter=0
while true; do
  echo "Loop iteration: $counter"
  counter=$((counter + 1))
  echo "Current Base URL: $BASE_URL"
  docker run --rm --name loadgen -e MY_IP="$MY_IP" -e BASE_URL="$BASE_URL" loadgen:conf25
  sleep 5 # Wait for 2 seconds
done
