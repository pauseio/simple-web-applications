#!/bin/bash
# The 'shebang' line - tells the system which interpreter to use
# #!/bin/bash means "execute this file using /bin/bash"
# This must be the first line of the script

# ============================================
# FUNCTION DEFINITIONS
# ============================================

# Function to generate a random UUID
# Bash functions are defined using: function_name() { commands; }
# Functions let you reuse code - like methods in other languages
generate_uuid() {
    # /proc/sys/kernel/random/uuid is a Linux kernel interface that provides random UUIDs
    # 'cat' reads the content of a file and outputs it
    # This is the standard way to get UUIDs on Linux systems without external tools
    cat /proc/sys/kernel/random/uuid
}

# Function to get current timestamp in RFC3339 format (ISO 8601)
# This format is: YYYY-MM-DDTHH:MM:SS.mmm+TZ
# Example: 2024-03-23T15:04:05.123+00:00
get_timestamp() {
    # 'date' is a command-line utility for displaying/manipulating dates
    # '+%Y-%m-%dT%H:%M:%S%:z' is the format string:
    #   %Y - 4-digit year
    #   %m - 2-digit month (01-12)
    #   %d - 2-digit day (01-31)
    #   T  - Literal 'T' separator (ISO 8601 standard)
    #   %H - 2-digit hour (00-23)
    #   %M - 2-digit minute (00-59)
    #   %S - 2-digit second (00-59)
    #   %:z - Timezone offset with colon (+00:00)
    date -u '+%Y-%m-%dT%H:%M:%S.%3N%:z'
}

# Function to create a JSON log entry following OpenTelemetry standard
# Takes one parameter: the message to log
# OpenTelemetry is a standard for observability (logs, metrics, traces)
create_log_entry() {
    # '$1' is the first parameter passed to the function
    # In Bash, function parameters are accessed as $1, $2, $3, etc.
    local message="$1"

    # 'local' creates a local variable (only visible inside this function)
    # Without 'local', variables would be global (visible everywhere)
    local trace_id
    local span_id
    local timestamp

    # Command substitution: $(command) runs the command and captures its output
    # This is how we capture the return value of a function into a variable
    trace_id=$(generate_uuid)
    span_id=$(generate_uuid)
    timestamp=$(get_timestamp)

    # Here we're building a JSON string using printf
    # We don't use actual string interpolation in the JSON because we need proper escaping
    # Printf with '%s' placeholders is safer than direct variable expansion
    # The backslashes and quotes are literal - we're building a JSON string
    printf '{"Timestamp": "%s", "SeverityText": "INFO", "SeverityNumber": 9, "Body": "%s", "TraceId": "%s", "SpanId": "%s"}\n' \
        "$timestamp" \
        "$message" \
        "$trace_id" \
        "$span_id"
}

# Function to log a message to stdout
# Wraps create_log_entry and outputs to standard output
log_message() {
    # '$1' is the message parameter
    # Create the log entry and output it using 'echo'
    # 'echo' prints text to standard output
    echo "$(create_log_entry "$1")"
}

# Function to parse the first line of an HTTP request
# HTTP requests start with a line like: "GET / HTTP/1.1"
# We need to extract the HTTP method (GET, POST, etc.) and path
parse_http_request() {
    # 'read' reads a line from standard input into variables
    # '-r' flag prevents backslash from acting as an escape character
    # '-t 5' waits up to 5 seconds for input (times out if no request comes)
    # 'method path version' are the variable names to store the parsed words
    # The first line is automatically split by whitespace into these variables
    read -r -t 5 method path version

    # Output the method and path as "method|path" (pipe-separated)
    # We use '|' as separator because it won't appear in URLs
    echo "${method}|${path}"
}

# Function to send an HTTP response
# Takes one parameter: the HTTP status code (e.g., 200, 404, 500)
send_response() {
    # '$1' is the status code parameter
    local status="$1"

    # 'cat <<EOF' is a "here document" - a way to include multi-line text in a script
    # Everything until the matching 'EOF' line is treated as literal text
    # The text is output to standard output (which the client receives)
    # Each line must end with '\r' (carriage return) per HTTP specification
    cat <<EOF
HTTP/1.1 ${status} OK\r
Content-Type: text/plain\r
Content-Length: 28\r
Connection: close\r
\r
Event processed successfully
EOF
}

# ============================================
# MAIN SCRIPT EXECUTION
# ============================================

# Get the port from environment variable, default to 8083
# '${VAR:-default}' syntax means: use VAR if set, otherwise use default
# This is the standard way to provide default values in Bash
PORT="${PORT:-8083}"

# Log that we're starting the server
log_message "Starting server on port $PORT"

# Start netcat to listen for incoming connections
# 'nc' (netcat) is a networking utility for reading/writing network connections
# '-l' flag: listen mode (act as a server)
# '-k' flag: keep listening after each connection closes (handle multiple requests)
# '-v' flag: verbose mode (log connections)
# '-p "$PORT"' : listen on the specified port
# The 'while true; do ... done' creates an infinite loop to keep server running
while true; do
    {
        # Read the first line of the HTTP request
        # This gets us the method and path
        request_line=$(parse_http_request)

        # Extract the method from the request line
        # '${var%%|pattern}' removes everything from the first '|' onwards
        # This gives us just the method part before the '|'
        method="${request_line%%|*}"

        # Extract the path from the request line
        # '${var##*|}' removes everything up to and including the last '|'
        # This gives us just the path part after the '|'
        path="${request_line##*|}"

        # Log the incoming request
        log_message "Received ${method} request for path: ${path}"

        # Send the HTTP response to the client
        send_response "200"

        # Log successful processing
        log_message "Event processed successfully"

    # The '&lt;&lt;' operator connects the output of the block to netcat's input
    # This allows netcat to receive the response we just built
    } | nc -l -k -v -p "$PORT"
done
