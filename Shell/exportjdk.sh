#!/bin/bash

# Java 21 path
JAVA21_HOME="/opt/jdk-21"

# List of services needing Java 21
JAVA21_SERVICES=("srv2" "srv5" "srv8")

# Function to export JAVA_HOME/PATH if service needs Java 21
use_java21_if_needed() {
    local service=$1
    for s in "${JAVA21_SERVICES[@]}"; do
        if [[ "$s" == "$service" ]]; then
            export JAVA_HOME="$JAVA21_HOME"
            export PATH="$JAVA_HOME/bin:$PATH"
            echo "→ Using Java 21 for $service"
            return
        fi
    done
}

# Main loop over services passed as arguments
for srv in "$@"; do
    use_java21_if_needed "$srv"
    echo "Starting $srv..."
    java -jar "$srv.jar" &
done

wait
