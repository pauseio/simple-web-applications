// Import the 'http' module from Node.js built-in modules
// 'http' is a core module that provides HTTP client and server functionality
// Node.js uses CommonJS by default: require() for imports, module.exports for exports
const http = require('http');

// Get the port from environment variable, default to 8085
// 'process.env' contains environment variables (like os.getenv in Python)
// The '||' operator is the logical OR: use left side if truthy, else right side
// This is a common pattern for default values in JavaScript
const port = process.env.PORT || '8085';

// Function to generate a random UUID v4
// UUID v4 is randomly generated and follows the format: xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx
function generateUUID() {
  // 'crypto.randomUUID()' is the modern way to generate UUIDs in Node.js (v15.6.0+)
  // It generates a cryptographically secure random UUID
  // For older Node versions, you'd need to use 'crypto.randomBytes()' and format it
  return require('crypto').randomUUID();
}

// Function to get current timestamp in ISO 8601 format (RFC3339 compatible)
// Returns a string like "2024-03-23T15:04:05.123Z"
function getTimestamp() {
  // 'new Date()' creates a Date object representing the current moment
  // '.toISOString()' converts the Date to ISO 8601 format string
  // ISO 8601 is the international standard for date and time representation
  return new Date().toISOString();
}

// Function to create a structured log entry following OpenTelemetry standard
// Takes a message string and returns a JSON string with all required fields
// OpenTelemetry is an observability standard for logs, metrics, and traces
function createLogEntry(message) {
  // Generate a random UUID for the trace ID
  // Trace IDs correlate multiple log entries from the same request/operation
  const traceId = generateUUID();

  // Generate a different UUID for the span ID
  // A single trace can have multiple spans (each representing one operation)
  const spanId = generateUUID();

  // Get current timestamp in ISO 8601 format
  const timestamp = getTimestamp();

  // Create the log entry as a JavaScript object (similar to a dictionary in Python)
  // Objects use key: value syntax, with string keys automatically quoted
  const logEntry = {
    // 'Timestamp' - when the log entry was created (ISO 8601 format)
    Timestamp: timestamp,

    // 'SeverityText' - human-readable severity level
    // Common values: TRACE, DEBUG, INFO, WARN, ERROR, FATAL
    SeverityText: 'INFO',

    // 'SeverityNumber' - numeric severity level (0-24)
    // INFO maps to 9 in the OpenTelemetry specification
    SeverityNumber: 9,

    // 'Body' - the actual log message content
    // This is the main information we want to convey
    Body: message,

    // 'TraceId' - unique identifier for the entire trace
    // Used to correlate all log entries from a single request/operation
    TraceId: traceId,

    // 'SpanId' - unique identifier for this specific operation
    // Used to identify individual steps within a trace
    SpanId: spanId,
  };

  // 'JSON.stringify()' converts a JavaScript object to a JSON string
  // This is required because we can only send strings over the network/stdout
  return JSON.stringify(logEntry);
}

// Function to log a message to standard output
// Wraps createLogEntry and outputs the JSON string
function logMessage(message) {
  // 'console.log()' prints to standard output (stdout)
  // In containerized environments, stdout is captured by logging systems
  console.log(createLogEntry(message));
}

// Create the HTTP server
// 'http.createServer()' creates a new web server instance
// It takes a callback function that will be called for each incoming request
// The callback receives two parameters: request (req) and response (res)
const server = http.createServer((req, res) => {
  // 'req.method' contains the HTTP method (GET, POST, DELETE, etc.)
  const method = req.method;

  // 'req.url' contains the request path (e.g., "/", "/api/users", etc.)
  // Note: This is just the path, not the full URL with domain
  const path = req.url;

  // Log the incoming request with method and path
  // Template literals (backticks) allow embedded expressions using ${expression}
  // This is cleaner than string concatenation: 'Received ' + method + ' request for...'
  logMessage(`Received ${method} request for path: ${path}`);

  // Set the HTTP response status code to 200 (OK)
  // '.writeHead()' writes the HTTP status line and headers
  // First parameter: status code (200 means success)
  // Second parameter: headers object (key-value pairs of response headers)
  res.writeHead(200, {
    // 'Content-Type' tells the client what type of content we're sending
    // 'text/plain' means plain text (not HTML, JSON, etc.)
    'Content-Type': 'text/plain',
  });

  // Send the response body to the client
  // '.end()' sends data and signals the response is complete
  // The '\n' at the end adds a newline character to the response
  res.end('Event processed successfully\n');

  // Log that we successfully processed the event
  // This provides confirmation that the handler completed its work
  logMessage('Event processed successfully');
});

// Start listening for incoming connections
// '.listen()' tells the server to start accepting connections
// First parameter: port number to listen on
// Second parameter (optional): IP address to bind to (omitted = all interfaces)
// Third parameter (optional): callback function when server starts listening
server.listen(port, () => {
  // This callback runs when the server successfully starts
  // Log that the server is running
  logMessage(`Server is running on port ${port}`);
});
