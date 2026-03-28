// Import the 'dart:io' library which provides file, socket, HTTP, and other I/O functionality
// In Dart, 'dart:' prefix indicates a built-in library (no need to install)
// The 'io' library includes ServerHttp, HttpClient, File, and other core I/O classes
import 'dart:io';

// Import the 'dart:convert' library for encoding and decoding data
// This provides JSON encoding/decoding, UTF-8, base64, and other conversions
import 'dart:convert';

// The 'main' function is the entry point of the Dart program
// Dart executes top-level code, and main() is where execution begins
// The 'async' keyword means this function can use 'await' for asynchronous operations
void main(List<String> arguments) async {
  // Get the port from environment variable, default to 8084
  // 'Platform.environment' returns a map of environment variables
  // The '??' operator is the null-coalescing operator: use left side if not null, else right side
  // This is similar to Python's 'env.get("PORT") or "8084"' or JavaScript's 'env.PORT || "8084"'
  final port = Platform.environment['PORT'] ?? '8084';

  // Log that we're starting the server
  // 'print' outputs to standard output (like Python's print, JavaScript's console.log)
  printLog('Starting server on port $port');

  // Bind to the specified port on all interfaces (IPv4)
  // 'ServerSocket.bind' creates a listening socket for incoming connections
  // 'InternetAddress.anyIPv4' means listen on all network interfaces (0.0.0.0)
  // 'int.parse' converts the string port to an integer
  // 'await' waits for the bind operation to complete (asynchronous)
  final server = await ServerSocket.bind(InternetAddress.anyIPv4, int.parse(port));

  // Log that the server is running
  printLog('Server is running');

  // Listen for incoming connections
  // 'server.listen' is an async stream that yields a Socket for each connection
  // The 'await for' loop iterates over each incoming connection asynchronously
  // This is Dart's way of handling multiple connections concurrently
  await for (final Socket socket in server) {
    // Handle each connection in a separate operation
    // The 'socket' variable represents the client connection
    _handleConnection(socket);
  }
}

// Function to handle a single client connection
// 'Socket' represents a network connection to a client
// Dart uses underscore prefix (_) to indicate library-private members (like protected/private)
void _handleConnection(Socket socket) {
  // Log that we received a connection
  // 'socket.remoteAddress' gets the client's IP address
  // 'socket.remotePort' gets the client's port number
  printLog('Received connection from ${socket.remoteAddress}:${socket.remotePort}');

  // Listen for data from the client
  // 'socket.listen' sets up a callback that will be called whenever data arrives
  // The callback receives a 'List<int>' which is the raw bytes of the data
  socket.listen((List<int> data) {
    // Convert the bytes to a string for easier parsing
    // 'utf8.decode' converts UTF-8 encoded bytes to a Dart String
    // HTTP requests are text-based, so we can decode them as UTF-8
    final requestString = utf8.decode(data);

    // Parse the HTTP request to extract method and path
    // Split the request by whitespace to get individual parts
    // HTTP request format: "METHOD /path HTTP/1.1"
    final lines = requestString.split('\r\n');
    final requestLine = lines[0].split(' ');

    // Extract the HTTP method (GET, POST, etc.)
    // 'requestLine[0]' is the first word of the request line
    final method = requestLine[0];

    // Extract the path (e.g., "/" or "/api/users")
    // 'requestLine[1]' is the second word of the request line
    final path = requestLine[1];

    // Log the incoming request
    printLog('Received $method request for path: $path');

    // Build the HTTP response
    // '\r\n' is the line ending for HTTP (carriage return + newline)
    // This is required by the HTTP specification
    final response = 'HTTP/1.1 200 OK\r\n'
        'Content-Type: text/plain\r\n'
        'Content-Length: 28\r\n'
        'Connection: close\r\n'
        '\r\n'
        'Event processed successfully';

    // Write the response to the socket
    // 'socket.write' sends data to the client
    // We convert the string to bytes using 'utf8.encode'
    // This is required because network sockets transmit bytes, not strings
    socket.add(utf8.encode(response));

    // Close the socket to end the connection
    // 'socket.close' terminates the connection
    // Always close connections to free up resources
    socket.close();

    // Log successful processing
    printLog('Event processed successfully');
  });
}

// Function to create a structured log entry following OpenTelemetry standard
// Returns a JSON string with timestamp, severity, body, trace ID, and span ID
String createLogEntry(String message) {
  // Generate a random UUID for the trace ID
  // 'Uuid' is from dart:io library (via Platform)
  // We create a v4 (random) UUID for distributed tracing
  final traceId = _generateUuid();

  // Generate a different UUID for the span ID
  // A trace can have multiple spans - each represents one operation
  final spanId = _generateUuid();

  // Get current timestamp in RFC3339 format (ISO 8601)
  // 'DateTime.now()' gets the current date and time
  // '.toIso8601String()' formats it as "2024-03-23T15:04:05.123Z"
  final timestamp = DateTime.now().toIso8601String();

  // Build a JSON object using a Map
  // Maps in Dart are like dictionaries in Python or objects in JavaScript
  // We create a map with string keys and dynamic values (any type)
  final logEntry = {
    'Timestamp': timestamp,
    'SeverityText': 'INFO',
    'SeverityNumber': 9,
    'Body': message,
    'TraceId': traceId,
    'SpanId': spanId,
  };

  // Convert the map to a JSON string
  // 'jsonEncode' converts Dart objects to JSON strings
  // It handles proper escaping of special characters
  return jsonEncode(logEntry);
}

// Function to log a message to standard output
// Wraps createLogEntry and prints the result
void printLog(String message) {
  // Create the log entry and output it
  // 'print' adds a newline automatically
  print(createLogEntry(message));
}

// Function to generate a random UUID (v4)
// Returns a string like "550e8400-e29b-41d4-a716-446655440000"
String _generateUuid() {
  // Generate 16 random bytes (128 bits)
  // UUID v4 is randomly generated
  final randomBytes = List<int>.generate(16, (index) {
    // 'Random.secure()' provides cryptographically secure random numbers
    // 'nextInt(256)' generates a random integer from 0 to 255 (one byte)
    return Random.secure().nextInt(256);
  });

  // Convert the bytes to a UUID string format
  // UUID format: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
  // We use string interpolation to build the formatted string
  final buffer = StringBuffer();

  // Add bytes 0-3 (first segment)
  buffer.write(_bytesToHex(randomBytes.sublist(0, 4)));
  buffer.write('-');

  // Add bytes 4-5 (second segment)
  buffer.write(_bytesToHex(randomBytes.sublist(4, 6)));
  buffer.write('-');

  // Add bytes 6-7 (third segment) with version bits set
  // For UUID v4, the version nibble is set to 4 (binary: 0100)
  buffer.write(_bytesToHex([randomBytes[6] & 0x0F | 0x40, randomBytes[7]]));
  buffer.write('-');

  // Add bytes 8-9 (fourth segment) with variant bits set
  // The variant nibble is set to 10xx (binary) for RFC 4122 UUIDs
  buffer.write(_bytesToHex([randomBytes[8] & 0x3F | 0x80, randomBytes[9]]));
  buffer.write('-');

  // Add bytes 10-15 (final segment)
  buffer.write(_bytesToHex(randomBytes.sublist(10, 16)));

  // Return the complete UUID string
  return buffer.toString();
}

// Helper function to convert bytes to hexadecimal string
// Takes a list of bytes and returns a hex string (e.g., [255, 0] -> "ff00")
String _bytesToHex(List<int> bytes) {
  // 'map' transforms each byte to its hex representation
  // 'join' combines all the hex strings together
  return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
}

// Import the dart:math library for the Random class
// This is imported at the bottom because we only need Random in _generateUuid
// In real code, this would be at the top with other imports
import 'dart:math';
