//! This is the main entry point for the "hello-world" Actix-Web application.
//! It sets up a web server that listens on port 8080 and provides a single endpoint (`/`).
//! The application logs structured output to stdout using the OpenTelemetry JSON standard.
//!
//! Key components:
//! - `log_otel`: A logging function that outputs OpenTelemetry-formatted JSON to stdout
//! - `Response`: A simple struct representing the JSON response with message, timestamp, path, and method
//! - `greet`: A request handler that returns a JSON response and logs OTEL-formatted messages
//! - `main`: Starts the Actix-Web server on port 8080

use actix_web::{get, web, App, HttpServer, Responder, HttpRequest};
use serde::Serialize;
use chrono::Utc;
use uuid::Uuid;

/// OpenTelemetry log entry structure matching Go/Python format
/// Contains: Timestamp, SeverityText, SeverityNumber, Body, TraceId, SpanId
#[derive(Serialize)]
#[allow(non_snake_case)]
struct OTelLogEntry {
    Timestamp: String,
    SeverityText: String,
    SeverityNumber: u32,
    Body: String,
    TraceId: String,
    SpanId: String,
}

/// Simple response structure matching Python template
/// Contains: message, timestamp, path, method
#[derive(Serialize)]
struct Response {
    message: String,
    timestamp: String,
    path: String,
    method: String,
}

/// Logs a message in OpenTelemetry JSON format to standard output.
///
/// This function creates a structured log entry following the OpenTelemetry logging standard
/// and outputs it as JSON to stdout. The format matches the Go and Python templates.
///
/// # Arguments
/// * `message` - The log message to include in the Body field
/// * `severity_text` - Human-readable severity level (e.g., "INFO", "WARN", "ERROR")
/// * `severity_number` - Numeric severity level following OpenTelemetry spec (INFO=9, WARN=13, ERROR=17)
///
/// # OpenTelemetry Log Record Format:
/// - Timestamp: ISO 8601 format timestamp in UTC (RFC3339)
/// - SeverityText: Human-readable severity level (TRACE, DEBUG, INFO, WARN, ERROR, FATAL)
/// - SeverityNumber: Numeric severity (0-24, following OpenTelemetry spec)
/// - Body: The main log message content
/// - TraceId: Unique identifier for the entire trace (32 hex characters = 16 bytes)
/// - SpanId: Unique identifier for the span within a trace (16 hex characters = 8 bytes)
fn log_otel(message: &str, severity_text: &str, severity_number: u32) {
    // Generate a new UUID (Universally Unique Identifier) for the trace ID
    // Trace IDs help correlate multiple log entries that are part of the same request/operation
    // The simple() format gives us a hex string without hyphens
    let trace_id = Uuid::new_v4().simple().to_string();

    // Generate a separate UUID for the span ID and take only the first 16 characters
    // Span IDs represent individual operations within a trace
    // A single trace can have multiple spans (e.g., database query, API call, etc.)
    let span_id = Uuid::new_v4().simple().to_string()[..16].to_string();

    // Create the OpenTelemetry log entry with all required fields
    let log_entry = OTelLogEntry {
        // Timestamp: Current time in UTC, formatted as RFC3339 (ISO 8601)
        // Example: "2024-03-28T10:30:45.123456+00:00"
        Timestamp: Utc::now().to_rfc3339_opts(chrono::SecondsFormat::Micros, true),

        // SeverityText: Human-readable severity level
        SeverityText: severity_text.to_string(),

        // SeverityNumber: Numeric severity following OpenTelemetry specification
        // INFO = 9, WARN = 13, ERROR = 17, FATAL = 21
        SeverityNumber: severity_number,

        // Body: The main log message content
        Body: message.to_string(),

        // TraceId: 32-character hex string for trace correlation
        TraceId: trace_id,

        // SpanId: 16-character hex string for span identification
        SpanId: span_id,
    };

    // Serialize the log entry to JSON and print to stdout
    // In containerized environments, stdout is captured by logging systems
    // The unwrap() is safe here because we control the structure and it's always serializable
    println!("{}", serde_json::to_string(&log_entry).unwrap());
}

/// Request handler for the root endpoint ("/").
///
/// This function handles incoming GET requests and returns a JSON response
/// with a greeting message, timestamp, and request metadata.
///
/// # Returns
/// A JSON response containing:
/// - message: A greeting string
/// - timestamp: Current UTC time in ISO 8601 format
/// - path: The request path (should be "/")
/// - method: The HTTP method (should be "GET")
#[get("/")]
async fn greet(req: HttpRequest) -> impl Responder {
    // Get the request path from the HttpRequest
    // The path() method returns the path portion of the URL (e.g., "/" or "/api")
    let path = req.path().to_string();

    // Get the HTTP method from the HttpRequest
    // The method() method returns the HTTP method as an enum (GET, POST, etc.)
    // We convert it to a string for inclusion in our response
    let method = req.method().to_string();

    // Log that we received a request, including the path
    // Severity: INFO (9) - normal informational message
    log_otel(&format!("Received request for path: {}", path), "INFO", 9);

    // Get the current timestamp in UTC for the response
    // This is formatted as RFC3339 (ISO 8601) for consistency with logging
    let timestamp = Utc::now().to_rfc3339_opts(chrono::SecondsFormat::Micros, true);

    // Create and return the JSON response
    // The web::Json wrapper automatically serializes the struct to JSON
    // and sets the Content-Type header to application/json
    web::Json(Response {
        message: "Hello from Rust!".to_string(),
        timestamp,
        path,
        method,
    })
}

/// Main entry point for the application.
///
/// This function sets up and starts the Actix-Web HTTP server.
/// It logs a startup message and begins listening for incoming requests.
///
/// # Returns
/// A `std::io::Result<()>` which indicates success or failure of server startup
///
/// # Behavior
/// - Creates an HttpServer with the greet handler registered
/// - Binds to 0.0.0.0:8080 (all network interfaces, port 8080)
/// - Runs asynchronously until interrupted (e.g., Ctrl+C)
#[actix_web::main]
async fn main() -> std::io::Result<()> {
    // Log that the server is starting
    // Severity: INFO (9) - normal informational message
    log_otel("Starting server on port 8080", "INFO", 9);

    // Create and configure the HTTP server
    // The `move` closure captures ownership of any referenced variables
    // App::new() creates a new Actix-Web application instance
    // .service(greet) registers our handler for the "/" endpoint
    HttpServer::new(|| {
        App::new()
            .service(greet)
    })
    // Bind to all network interfaces (0.0.0.0) on port 8080
    // The ? operator propagates any binding errors (e.g., port already in use)
    .bind(("0.0.0.0", 8080))?
    // Start the server and run until interrupted
    // This is an async operation that awaits incoming requests
    .run()
    .await
}
