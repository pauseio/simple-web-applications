// The 'package' keyword declares which package (namespace) this class belongs to
// An empty package name means this is in the default package
// Packages organize Java classes and prevent naming conflicts
package ;

// Import statements bring in classes from other packages
// Java uses a fully-qualified naming scheme like 'com.example.ClassName'
// 'java.io.*' imports all classes from the java.io package (input/output)
import java.io.*;
// 'java.util.UUID' imports just the UUID class for generating unique identifiers
import java.util.UUID;
// 'com.sun.net.httpserver.*' imports Java's built-in HTTP server classes
import com.sun.net.httpserver.*;

// The 'class' keyword defines a new class
// In Java, all code must be inside a class
// 'App' is the class name - by convention, class names use PascalCase (capital first letter)
// The class must be declared 'public' so it can be accessed from outside this file
public class App {

    // This is a class-level (static) field - it belongs to the class, not instances
    // 'static' means this variable is shared across all instances of the class
    // 'final' means the value cannot be changed after assignment (constant)
    // 'JsonWriter' is the type - a custom nested class we define below
    private static final JsonWriter jsonWriter = new JsonWriter();

    // This is the 'main' method - the entry point of every Java application
    // 'public' - can be called from anywhere (the JVM calls it)
    // 'static' - belongs to the class, not an instance (JVM doesn't create an object)
    // 'void' - returns nothing
    // 'String[] args' - command-line arguments passed as an array of Strings
    public static void main(String[] args) throws Exception {
        // Get the port from environment variable, default to 8082
        // 'System.getenv()' retrieves environment variables (returns null if not found)
        // The ternary operator '? :' is like an if-else: condition ? valueIfTrue : valueIfFalse
        String port = System.getenv().getOrDefault("PORT", "8082");

        // Log server startup using our custom JSON logger
        // 'System.out' is the standard output stream
        // '.println()' prints a line with automatic newline
        System.out.println(jsonWriter.createLogEntry("Starting server on port " + port));

        // Create the HTTP server
        // 'HttpServer.create()' is a static factory method that creates a server instance
        // 'InetSocketAddress' combines an IP address with a port number
        // 'new InetSocketAddress(Integer.parseInt(port))' creates address for all interfaces on specified port
        // 'Integer.parseInt()' converts the String port to an int primitive type
        // The '0' is the backlog (max queued connections) - 0 means use system default
        HttpServer server = HttpServer.create(new InetSocketAddress(Integer.parseInt(port)), 0);

        // Register a handler for the root path "/"
        // 'createContext()' tells the server which path this handler should process
        // "/" means all requests starting with "/" (which is all requests)
        // We pass a lambda expression (anonymous function) as the handler
        // Java 8+ supports lambda syntax: (params) -> { code }
        server.createContext("/", exchange -> {
            try {
                // 'exchange' contains both the request and response objects
                // 'getRequestMethod()' returns the HTTP method (GET, POST, etc.)
                String method = exchange.getRequestMethod();

                // 'getRequestURI()' gets the full request path (e.g., "/api/users")
                String path = exchange.getRequestURI().getPath();

                // Log the incoming request
                System.out.println(jsonWriter.createLogEntry("Received " + method + " request for path: " + path));

                // Set the HTTP response status code to 200 (OK)
                // 'sendResponseHeaders()' must be called before writing the response body
                // Parameters: status code, response body size (-1 if unknown/chunked)
                exchange.sendResponseHeaders(200, 0);

                // Get the output stream to write the response body
                // 'getResponseBody()' returns an OutputStream we can write to
                // We use try-with-resources (the 'try' statement) to auto-close the stream
                try (OutputStream os = exchange.getResponseBody()) {
                    // Convert our response string to bytes
                    // HTTP responses are transmitted as bytes, not characters
                    // 'getBytes()' converts the String to a byte array using default encoding
                    byte[] response = "Event processed successfully\n".getBytes();

                    // Write the bytes to the output stream
                    os.write(response);
                }

                // Log successful processing
                System.out.println(jsonWriter.createLogEntry("Event processed successfully"));

            } catch (IOException e) {
                // 'IOException' is a checked exception - Java requires us to handle it
                // 'e.getMessage()' returns the detail message string of this throwable
                System.out.println(jsonWriter.createLogEntry("Error handling request: " + e.getMessage()));
            }
        });

        // Create an executor for handling requests
        // 'Executors.newCachedThreadPool()' creates a thread pool that creates new threads as needed
        // HTTP servers need to handle multiple concurrent requests - each request runs in its own thread
        server.setExecutor(Executors.newCachedThreadPool());

        // Start the server - this blocks until the server is stopped
        // 'server.start()' begins accepting connections
        server.start();

        System.out.println(jsonWriter.createLogEntry("Server is running"));
    }

    // This is a nested class - a class defined inside another class
    // Nested classes have access to the enclosing class's private members
    // 'static' nested class doesn't need an instance of the outer class
    // This class handles JSON formatting for our log entries
    static class JsonWriter {
        // Method to create a JSON log entry following OpenTelemetry standard
        // 'String' return type - returns a String containing JSON
        // 'message' parameter - the log message to include
        String createLogEntry(String message) {
            // Generate a random UUID for the trace ID
            // 'UUID.randomUUID()' creates a type 4 (random) UUID
            // '.toString()' converts the UUID object to its String representation
            String traceId = UUID.randomUUID().toString();

            // Generate a different UUID for the span ID
            // In real distributed tracing, a trace has multiple spans
            // Each span represents a single operation within the trace
            String spanId = UUID.randomUUID().toString();

            // Get current time in RFC3339 format (ISO 8601)
            // 'java.time.Instant' represents a moment on the timeline in UTC
            // '.now()' gets the current instant
            // '.toString()' formats it in ISO-8601 format (e.g., "2024-03-23T15:04:05.123Z")
            String timestamp = java.time.Instant.now().toString();

            // Build JSON string manually using String concatenation
            // In production, you'd use a library like Jackson or Gson
            // '\n' at the end is standard for log lines
            return "{" +
                "\"Timestamp\": \"" + timestamp + "\", " +
                "\"SeverityText\": \"INFO\", " +
                "\"SeverityNumber\": 9, " +
                "\"Body\": \"" + message + "\", " +
                "\"TraceId\": \"" + traceId + "\", " +
                "\"SpanId\": \"" + spanId + "\"\n" +
                "}";
        }
    }
}
