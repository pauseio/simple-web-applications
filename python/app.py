#!/usr/bin/env python3
"""
Simple Event-Driven HTTP Server in Python
==========================================
This application implements a basic HTTP server that handles incoming
requests on the '/' route. It demonstrates event-driven programming using
Python's built-in http.server module.

The server logs structured output to standard out using the OpenTelemetry
logging JSON standard representation.
"""

import json
import uuid
from datetime import datetime, timezone
from http.server import HTTPServer, BaseHTTPRequestHandler


# ==============================================================================
# OPENTELEMETRY LOGGING FUNCTION
# ==============================================================================
def log_otel(message, severity_text="INFO", severity_number=9):
    """
    Log a message in OpenTelemetry JSON format to standard output.

    OpenTelemetry Log Record Format:
    - Timestamp: ISO 8601 format timestamp in UTC
    - SeverityText: Human-readable severity level (TRACE, DEBUG, INFO, WARN, ERROR, FATAL)
    - SeverityNumber: Numeric severity (0-24, following OpenTelemetry spec)
    - Body: The main log message content
    - TraceId: Unique identifier for the entire trace (16 bytes hex)
    - SpanId: Unique identifier for the span within a trace (8 bytes hex)

    Args:
        message (str): The log message to output
        severity_text (str): Severity level as text (default: "INFO")
        severity_number (int): Numeric severity (default: 9 for INFO)
    """
    log_entry = {
        "Timestamp": datetime.now(timezone.utc).isoformat().replace("+00:00", "Z"),
        "SeverityText": severity_text,
        "SeverityNumber": severity_number,
        "Body": message,
        "TraceId": uuid.uuid4().hex[:32],  # 16 bytes = 32 hex chars
        "SpanId": uuid.uuid4().hex[:16]    # 8 bytes = 16 hex chars
    }
    # Output the JSON log to stdout (no extra formatting)
    print(json.dumps(log_entry))


# ==============================================================================
# HTTP REQUEST HANDLER
# ==============================================================================
class EventHandler(BaseHTTPRequestHandler):
    """
    Custom HTTP request handler that processes incoming events (requests).

    This class inherits from BaseHTTPRequestHandler and overrides the
    do_GET method to handle GET requests to the '/' route.
    """

    def log_message(self, format, *args):
        """
        Override the default logging to use our OpenTelemetry logger.
        This ensures all HTTP server activity is logged in OTEL format.
        """
        log_otel(format % args, "INFO", 9)

    def do_GET(self):
        """
        Handle GET requests.

        When a request comes in:
        1. Log the incoming event
        2. Send a 200 OK response
        3. Include a structured JSON body
        """
        # Log that we received an event
        log_otel(f"Received request: {self.path} from {self.client_address[0]}", "INFO", 9)

        # Only handle the root path '/'
        if self.path == '/':
            # Send HTTP 200 OK status
            self.send_response(200)

            # Send HTTP headers
            # Content-Type: application/json tells the client we're sending JSON data
            self.send_header('Content-Type', 'application/json; charset=utf-8')
            self.end_headers()

            # Build the structured JSON response
            # Include current timestamp, message, and request metadata
            response_data = {
                "message": "Hello from Python!",
                "timestamp": datetime.now(timezone.utc).isoformat().replace("+00:00", "Z"),
                "path": self.path,
                "method": "GET"
            }

            # Convert the response dictionary to JSON bytes
            response_body = json.dumps(response_data).encode('utf-8')
            self.wfile.write(response_body)

            # Log successful response
            log_otel(f"Sent 200 OK response for path: {self.path}", "INFO", 9)
        else:
            # Return 404 for non-root paths with JSON error response
            self.send_response(404)
            self.send_header('Content-Type', 'application/json; charset=utf-8')
            self.end_headers()

            error_response = {
                "error": "Not Found",
                "path": self.path,
                "message": f"The requested path '{self.path}' was not found"
            }
            self.wfile.write(json.dumps(error_response).encode('utf-8'))
            log_otel(f"Sent 404 Not Found for path: {self.path}", "WARN", 13)


# ==============================================================================
# SERVER CONFIGURATION AND STARTUP
# ==============================================================================
def run_server(port=8080):
    """
    Start the HTTP server and listen for incoming requests.

    Args:
        port (int): The port number to listen on (default: 8080)
    """
    # Create the server with our custom handler
    # ('' means bind to all available interfaces)
    server_address = ('', port)
    httpd = HTTPServer(server_address, EventHandler)

    log_otel(f"Python HTTP server starting on port {port}", "INFO", 9)
    log_otel(f"Access the server at http://localhost:{port}/", "INFO", 9)

    try:
        # Serve requests indefinitely (until interrupted with Ctrl+C)
        httpd.serve_forever()
    except KeyboardInterrupt:
        # Handle graceful shutdown on Ctrl+C
        log_otel("Server shutting down...", "INFO", 9)
        httpd.server_close()


# ==============================================================================
# MAIN ENTRY POINT
# ==============================================================================
if __name__ == '__main__':
    """
    Entry point when the script is run directly.
    This block only executes when the file is run as a script,
    not when imported as a module.
    """
    run_server()
