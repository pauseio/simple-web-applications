<?php
// The opening PHP tag '<?php' tells the server "execute this as PHP code"
// Everything outside these tags is treated as plain HTML/text
// The closing '?>' is optional at the end of a file (and often omitted for safety)

// ============================================
// FUNCTION DEFINITIONS
// ============================================

// Function to generate a random UUID v4
// In PHP, functions are defined using the 'function' keyword
// PHP uses snake_case for function names by convention (PascalCase for classes)
function generate_uuid(): string {
    // 'random_bytes()' generates cryptographically secure random bytes
    // For UUID v4, we need 16 random bytes (128 bits)
    $data = random_bytes(16);

    // Set version bits to 0100 (UUID v4)
    // We modify byte 6: set the high nibble to 0100
    // '& 0x0F' clears the high 4 bits (keeps only low 4 bits)
    // '| 0x40' sets the high 4 bits to 0100 (binary for 4)
    $data[6] = chr(ord($data[6]) & 0x0F | 0x40);

    // Set variant bits to 10xx (RFC 4122 variant)
    // We modify byte 8: set the high two bits to 10
    // '& 0x3F' clears the high 2 bits (keeps only low 6 bits)
    // '| 0x80' sets the high 2 bits to 10 (binary for 10000000)
    $data[8] = chr(ord($data[8]) & 0x3F | 0x80);

    // Format the bytes as a UUID string: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
    // 'vsprintf' formats a string using an array of values
    // '%s%s%s%s' is the format string (four string placeholders)
    // 'unpack()' extracts binary data from a string according to a format
    // 'H*' means "hex string, read all remaining data"
    return vsprintf('%s%s-%s-%s-%s-%s%s%s', str_split(bin2hex($data), 4));
}

// Function to get current timestamp in ISO 8601 format (RFC3339 compatible)
// Returns a string like "2024-03-23T15:04:05.123+00:00"
function get_timestamp(): string {
    // 'date()' formats a local date/time
    // 'c' format character gives ISO 8601 date (e.g., "2004-02-12T15:19:21+00:00")
    return date('c');
}

// Function to create a structured log entry following OpenTelemetry standard
// Takes a message string and returns a JSON string with all required fields
// ': string' declares that the parameter must be a string (PHP 7+ type hints)
function create_log_entry(string $message): string {
    // Generate a random UUID for the trace ID
    // Trace IDs correlate multiple log entries from the same request/operation
    $trace_id = generate_uuid();

    // Generate a different UUID for the span ID
    // A single trace can have multiple spans (each representing one operation)
    $span_id = generate_uuid();

    // Get current timestamp in ISO 8601 format
    $timestamp = get_timestamp();

    // Create the log entry as an associative array
    // PHP calls key-value arrays "associative arrays" (like dictionaries in Python)
    $log_entry = [
        // 'Timestamp' - when the log entry was created (ISO 8601 format)
        'Timestamp' => $timestamp,

        // 'SeverityText' - human-readable severity level
        // Common values: TRACE, DEBUG, INFO, WARN, ERROR, FATAL
        'SeverityText' => 'INFO',

        // 'SeverityNumber' - numeric severity level (0-24)
        // INFO maps to 9 in the OpenTelemetry specification
        'SeverityNumber' => 9,

        // 'Body' - the actual log message content
        // This is the main information we want to convey
        'Body' => $message,

        // 'TraceId' - unique identifier for the entire trace
        // Used to correlate all log entries from a single request/operation
        'TraceId' => $trace_id,

        // 'SpanId' - unique identifier for this specific operation
        // Used to identify individual steps within a trace
        'SpanId' => $span_id,
    ];

    // 'json_encode()' converts a PHP array to a JSON string
    // This is required because we can only send strings over the network/stdout
    // 'JSON_UNESCAPED_SLASHES' prevents escaping forward slashes (makes URLs more readable)
    // 'JSON_UNESCAPED_UNICODE' prevents escaping Unicode characters
    return json_encode($log_entry, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
}

// Function to log a message to standard output
// Wraps create_log_entry and outputs the JSON string
function log_message(string $message): void {
    // 'echo' outputs text to standard output (stdout)
    // Unlike 'print', 'echo' doesn't return a value and is slightly faster
    // We add PHP_EOL (End Of Line) constant for cross-platform newline (\n on Unix, \r\n on Windows)
    echo create_log_entry($message) . PHP_EOL;
}

// ============================================
// MAIN SCRIPT EXECUTION
// ============================================

// Get the server port from environment variable, default to 8086
// '$_ENV' is a superglobal containing environment variables
// '??' is the null coalescing operator (PHP 7+): use left if exists and not null, else right
// This is similar to Python's 'env.get("PORT") or "8086"'
$port = $_ENV['PORT'] ?? '8086';

// Get the request method (GET, POST, etc.)
// '$_SERVER' is a superglobal containing server and execution environment information
// 'REQUEST_METHOD' key contains the HTTP method used for the request
$method = $_SERVER['REQUEST_METHOD'] ?? 'GET';

// Get the request path (e.g., "/", "/api/users")
// 'REQUEST_URI' contains the URI which was given to access the page
// 'parse_url()' extracts the path component from a URL
$path = parse_url($_SERVER['REQUEST_URI'] ?? '/', PHP_URL_PATH);

// Log the incoming request
// '.=' is the concatenation assignment operator: $str .= "more" means $str = $str . "more"
log_message("Received {$method} request for path: {$path}");

// Set the HTTP response header to indicate plain text content
// 'header()' sends a raw HTTP header
// Must be called before any actual output is sent (including HTML, whitespace, etc.)
// 'Content-Type: text/plain' tells the client we're sending plain text (not HTML or JSON)
header('Content-Type: text/plain');

// Set the HTTP response status code
// 'http_response_code()' sets or gets the HTTP response status code
// 200 means "OK" - the request succeeded
http_response_code(200);

// Send the response body
// 'echo' outputs the response that will be sent to the client
echo "Event processed successfully" . PHP_EOL;

// Log that we successfully processed the event
// This provides confirmation that the handler completed its work
log_message("Event processed successfully");
