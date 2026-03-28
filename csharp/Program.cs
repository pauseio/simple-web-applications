// Using directives import namespaces
// 'System' is the fundamental namespace for .NET, containing core types like String, Int32, etc.
// Similar to 'import' in Python or Java, but C# uses 'using' keyword
using System;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;

// The 'namespace' keyword organizes code into containers
// Namespaces prevent naming conflicts and organize code hierarchically
// Similar to packages in Java or modules in Python
namespace JumpboxTraining;

// The 'Program' class contains our application code
// In modern C#, you don't need to declare a class for the main method (top-level statements)
// We use a class here for clarity and to match traditional C# style
class Program
{
    // The 'Main' method is the entry point of a C# application
    // 'async Task' indicates this method can perform asynchronous operations
    // 'string[] args' represents command-line arguments passed to the program
    // 'async' allows using 'await' for asynchronous operations without blocking
    static async Task Main(string[] args)
    {
        // Get the port from environment variable, default to 8087
        // 'Environment.GetEnvironmentVariable()' retrieves environment variables
        // The '??' operator is the null-coalescing operator: use left if not null, else right
        // This is similar to Python's 'os.getenv("PORT") or "8087"' or JavaScript's 'env.PORT || "8087"'
        string port = Environment.GetEnvironmentVariable("PORT") ?? "8087";

        // Log that we're starting the server
        // 'Console.WriteLine()' writes text to standard output followed by a newline
        // This is like Python's 'print()' or JavaScript's 'console.log()'
        Console.WriteLine(JsonLogEntry.Create("Starting server on port " + port));

        // Create a new HTTP server instance
        // 'SimpleHttpServer' is a custom class we define below
        // 'new' instantiates a new object (like JavaScript's 'new' or Python's 'ClassName()')
        var server = new SimpleHttpServer(port);

        // Start the server asynchronously
        // 'await' waits for the StartAsync operation to complete without blocking the thread
        // This is key to C#'s async model: non-blocking I/O operations
        await server.StartAsync();
    }
}

// The 'SimpleHttpServer' class implements a basic HTTP server
// It listens for incoming connections and handles HTTP requests
class SimpleHttpServer
{
    // Private fields store the server's configuration and state
    // 'readonly' means the field can only be assigned in the constructor or declaration
    // 'string' is the type for text (like System.String)
    private readonly string _port;

    // Constructor: A special method called when creating a new instance
    // Initializes the object's state
    // Parameters are declared as 'Type paramName'
    public SimpleHttpServer(string port)
    {
        // 'this._port = port' assigns the parameter to the field
        // 'this' refers to the current instance (like Java's 'this')
        _port = port;
    }

    // Method to start the server asynchronously
    // 'async Task' indicates this method returns a Task representing the ongoing operation
    // 'Task' is like a Promise in JavaScript or a Future in Python/Dart
    public async Task StartAsync()
    {
        // Create a URI for the server to listen on
        // 'http://*:{_port}' means listen on all interfaces (* wildcard) on the specified port
        // '*' is equivalent to '0.0.0.0' - all network interfaces
        string serverUrl = $"http://*:{_port}/";

        // Build the HTTP listener prefix
        // HttpListener requires specific URL prefix formats
        // Using '+' instead of '*' means all interfaces for HttpListener
        string listenerPrefix = $"http://+:{_port}/";

        // Create a new HttpListener instance
        // HttpListener is a built-in .NET class for HTTP server functionality
        // It's simple but limited compared to full frameworks like ASP.NET Core
        var listener = new System.Net.HttpListener();

        // Add the URL prefix to listen on
        // HttpListener can listen on multiple prefixes simultaneously
        listener.Prefixes.Add(listenerPrefix);

        // Start listening for incoming connections
        // This tells the OS to start accepting connections on the specified port
        listener.Start();

        // Log that the server is running
        Console.WriteLine(JsonLogEntry.Create("Server is running"));

        // Infinite loop to handle incoming connections
        // 'true' means this loop will continue forever (or until an exception occurs)
        while (true)
        {
            // Wait for an incoming connection asynchronously
            // 'GetContextAsync()' returns a Task<HttpListenerContext>
            // 'await' waits for a client to connect without blocking the thread
            // This allows handling multiple connections efficiently (non-blocking I/O)
            var context = await listener.GetContextAsync();

            // Handle the request in a background task
            // '_ = ' discards the Task (we don't need to wait for it to complete)
            // This allows us to accept new connections immediately while processing current one
            _ = Task.Run(() => HandleRequest(context));
        }
    }

    // Method to handle a single HTTP request
    // 'HttpListenerContext' contains both the request and response objects
    private static void HandleRequest(System.Net.HttpListenerContext context)
    {
        // Extract the request from the context
        // 'Request' property gives us access to the HTTP request data
        var request = context.Request;

        // Extract the HTTP method (GET, POST, etc.)
        // 'HttpMethod' property returns the HTTP method as a string
        string method = request.HttpMethod;

        // Extract the request path (e.g., "/", "/api/users")
        // 'Url' is a System.Uri object representing the request URL
        // 'AbsolutePath' gets just the path without query string or domain
        string path = request.Url?.AbsolutePath ?? "/";

        // Log the incoming request
        // String interpolation: '$' prefix allows embedding expressions in braces
        // Similar to Python's f-strings or JavaScript's template literals
        Console.WriteLine(JsonLogEntry.Create($"Received {method} request for path: {path}"));

        // Extract the response from the context
        // 'Response' property gives us access to send data back to the client
        var response = context.Response;

        // Set the HTTP response status code to 200 (OK)
        // 'StatusCode' sets the numeric HTTP status code
        // 200 means the request succeeded
        response.StatusCode = 200;

        // Set the Content-Type header to plain text
        // 'ContentType' sets the HTTP Content-Type header
        // This tells the client what type of content we're sending
        response.ContentType = "text/plain";

        // Get the output stream for writing the response body
        // 'OutputStream' is a Stream we can write to
        // Everything we write to this stream gets sent to the client
        using var output = response.OutputStream;

        // Convert our response string to bytes
        // HTTP responses are transmitted as bytes, not characters
        // 'Encoding.UTF8.GetBytes()' converts a string to UTF-8 encoded bytes
        byte[] responseBytes = Encoding.UTF8.GetBytes("Event processed successfully\n");

        // Write the bytes to the output stream
        // 'WriteAsync()' sends data asynchronously (non-blocking)
        // We use '.GetAwaiter().GetResult()' to wait synchronously (simple for this example)
        output.Write(responseBytes, 0, responseBytes.Length);

        // Close the response to complete the HTTP transaction
        // This sends any buffered data and closes the connection
        response.Close();

        // Log successful processing
        Console.WriteLine(JsonLogEntry.Create("Event processed successfully"));
    }
}

// Static class for creating JSON log entries
// 'static' means all members belong to the class itself (no instances needed)
// 'JsonLogEntry' provides methods for creating OpenTelemetry-compliant log entries
static class JsonLogEntry
{
    // Method to create a log entry as a JSON string
    // 'string message' is the log message to include in the log entry
    public static string Create(string message)
    {
        // Generate a random UUID for the trace ID
        // 'Guid.NewGuid()' creates a new globally unique identifier
        // 'Guid' is .NET's UUID implementation (128-bit unique value)
        string traceId = Guid.NewGuid().ToString();

        // Generate a different UUID for the span ID
        // In distributed tracing, a trace contains multiple spans (operations)
        // Each span represents a single step in the trace
        string spanId = Guid.NewGuid().ToString();

        // Get current timestamp in UTC as ISO 8601 string
        // 'DateTime.UtcNow' gets the current date and time in UTC
        // 'ToString("o")' formats using the round-trip date/time pattern (ISO 8601)
        string timestamp = DateTime.UtcNow.ToString("o");

        // Create an anonymous object for the log entry
        // 'new { }' creates an object with properties without defining a class
        // The 'new { Prop = value }' syntax creates an anonymous type with read-only properties
        var logEntry = new
        {
            // 'Timestamp' - when the log entry was created (ISO 8601 format)
            Timestamp = timestamp,

            // 'SeverityText' - human-readable severity level
            // Common values: TRACE, DEBUG, INFO, WARN, ERROR, FATAL
            SeverityText = "INFO",

            // 'SeverityNumber' - numeric severity level (0-24)
            // INFO maps to 9 in the OpenTelemetry specification
            SeverityNumber = 9,

            // 'Body' - the actual log message content
            // This is the main information we want to convey
            Body = message,

            // 'TraceId' - unique identifier for the entire trace
            // Used to correlate all log entries from a single request/operation
            TraceId = traceId,

            // 'SpanId' - unique identifier for this specific operation
            // Used to identify individual steps within a trace
            SpanId = spanId,
        };

        // Convert the anonymous object to a JSON string
        // 'JsonSerializer.Serialize()' converts .NET objects to JSON
        // This is from the System.Text.Json namespace (built into .NET Core / .NET 5+)
        return JsonSerializer.Serialize(logEntry);
    }
}
