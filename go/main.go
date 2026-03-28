// Package main defines the entry point for our Go web application
// In Go, executable programs must belong to the 'main' package
// This tells the Go compiler that this package should be compiled into a standalone binary
package main

// Import the packages we need for our web server
// Each import path corresponds to either:
// - Standard library packages (like 'fmt', 'log', 'net/http')
// - Third-party packages (like 'github.com/google/uuid')
import (
	// 'encoding/json' provides functions for encoding and decoding JSON data
	// We need this to format our log output as JSON
	"encoding/json"

	// 'fmt' implements formatted I/O functions (like printf)
	// We use this for printing strings and formatting output
	"fmt"

	// 'log' provides a simple logging package
	// We use this to write logs to standard output
	"log"

	// 'net/http' provides HTTP client and server implementations
	// This is the core package for building web servers in Go
	"net/http"

	// 'os' provides a platform-independent interface to operating system functionality
	// We use this to access environment variables and standard output streams
	"os"

	// 'time' provides functionality for measuring and displaying time
	// We need this for creating timestamps in our log output
	"time"

	// 'github.com/google/uuid' is a third-party package for generating UUIDs
	// We use this to generate unique trace IDs and span IDs for OpenTelemetry logging
	"github.com/google/uuid"
)

// generateLogEntry creates a structured log entry following the OpenTelemetry logging standard
// This function returns a map containing all the required fields for OpenTelemetry logs
// OpenTelemetry is an observability standard that provides consistent logging across languages
func generateLogEntry(message string) map[string]interface{} {
	// Generate a new UUID (Universally Unique Identifier) for the trace ID
	// Trace IDs help correlate multiple log entries that are part of the same request/operation
	// Must handle the error case since uuid.New() can potentially fail (though rarely)
	traceId, err := uuid.NewRandom()
	if err != nil {
		// If we can't generate a UUID, use a fallback string
		// This ensures our logging doesn't crash the entire application
		traceId = uuid.MustParse("00000000-0000-0000-0000-000000000000")
	}

	// Generate a separate UUID for the span ID
	// Span IDs represent individual operations within a trace
	// A single trace can have multiple spans (e.g., database query, API call, etc.)
	spanId, err := uuid.NewRandom()
	if err != nil {
		// Same fallback logic as trace ID
		spanId = uuid.MustParse("00000000-0000-0000-0000-000000000000")
	}

	// Create and return a map (key-value pairs) containing all OpenTelemetry log fields
	// Maps in Go are similar to dictionaries in Python or objects in JavaScript
	return map[string]interface{}{
		// "Timestamp" - when the log entry was created
		// RFC3339 is a standard format for representing timestamps (e.g., "2006-01-02T15:04:05Z07:00")
		// Go uses this specific reference date (Jan 2, 2006 at 3:04:05 PM) as the format string
		"Timestamp": time.Now().Format(time.RFC3339Nano),

		// "SeverityText" - human-readable severity level
		// Common values: TRACE, DEBUG, INFO, WARN, ERROR, FATAL
		"SeverityText": "INFO",

		// "SeverityNumber" - numeric severity level (0-24)
		// INFO maps to 9 in the OpenTelemetry specification
		"SeverityNumber": 9,

		// "Body" - the actual log message content
		// This is the main information we want to convey
		"Body": message,

		// "TraceId" - unique identifier for the entire trace
		// Used to correlate all log entries from a single request/operation
		"TraceId": traceId.String(),

		// "SpanId" - unique identifier for this specific operation
		// Used to identify individual steps within a trace
		"SpanId": spanId.String(),
	}
}

// logMessage writes a structured log entry to standard output as JSON
// This function takes a message string, creates a log entry, and outputs it as formatted JSON
// Parameters:
//   - message: the log message to write
func logMessage(message string) {
	// Call generateLogEntry to create the structured log data
	// This creates the map with all OpenTelemetry fields populated
	logEntry := generateLogEntry(message)

	// json.Marshal converts the logEntry map into a JSON byte slice
	// We must check for errors because JSON marshaling can fail (e.g., with unmarshallable data types)
	jsonBytes, err := json.Marshal(logEntry)
	if err != nil {
		// If JSON marshaling fails, print a simple error message and return
		// This prevents the application from crashing due to logging errors
		fmt.Printf("Failed to marshal log entry: %v\n", err)
		return
	}

	// Convert the JSON byte slice to a string and print it to standard output
	// In containerized environments, stdout is captured by logging systems
	// The string() function converts bytes to a string type
	fmt.Println(string(jsonBytes))
}

// requestHandler is a custom handler function that processes incoming HTTP requests
// In Go, HTTP handlers are functions with this specific signature:
// func(w http.ResponseWriter, r *http.Request)
//
// Parameters:
//   - w: ResponseWriter - interface used to construct the HTTP response
//   - r: Request - pointer to the HTTP request struct containing request data
func requestHandler(w http.ResponseWriter, r *http.Request) {
	// Log that we received a request, including the path that was requested
	// r.Path contains the URL path (e.g., "/", "/api", etc.)
	// The + operator concatenates strings in Go
	logMessage("Received request for path: " + r.URL.Path)

	// Set the HTTP response status code to 200 (OK)
	// This tells the client that their request was successful
	w.WriteHeader(http.StatusOK)

	// Write the response body to the client
	// WriteString sends data to the response body
	// The '\n' at the end adds a newline character to the response
	// We must check for errors because writing to the network can fail
	_, err := w.WriteString("Event processed successfully\n")
	if err != nil {
		// Log an error message if writing the response failed
		// This might happen if the client disconnected before we could respond
		logMessage("Failed to write response: " + err.Error())
	}

	// Log that we successfully processed the event
	// This provides confirmation that the handler completed its work
	logMessage("Event processed successfully")
}

// main is the entry point of our Go program
// Every executable Go program must have a main function in the main package
// This function is called automatically when the program starts
func main() {
	// Get the server port from an environment variable
	// os.Getenv retrieves the value of an environment variable
	// The empty string "" is returned if the variable doesn't exist
	port := os.Getenv("PORT")

	// Check if the PORT environment variable is empty
	// In Go, you can't compare strings directly with == (unlike some languages)
	if port == "" {
		// If PORT is not set, use port 8080 as a default
		// This is a common pattern: allow configuration via env vars, with sensible defaults
		port = "8080"
	}

	// Log that the server is starting, including which port it will use
	// fmt.Sprintf creates a formatted string, similar to printf but returns the string
	logMessage(fmt.Sprintf("Starting server on port %s", port))

	// Register our requestHandler function for the root path "/"
	// http.HandleFunc tells Go which function to call when a specific path is requested
	// This is Go's equivalent of route registration in frameworks like Express.js or Flask
	http.HandleFunc("/", requestHandler)

	// Start the HTTP server
	// http.ListenAndServe starts a server that listens on the specified address
	// The ":" + port syntax creates a string like ":8080"
	// The colon before the port means "listen on all network interfaces"
	// If this function returns (due to error), the program will exit
	// The second parameter is nil because we're using HandleFunc, not a custom ServeMux
	err := http.ListenAndServe(":"+port, nil)

	// If ListenAndServe returns an error, it will be non-nil
	// This is the Go idiom for checking errors: always handle the returned error
	if err != nil {
		// Log the error that caused the server to fail
		// err.Error() converts the error type to a string representation
		logMessage("Server failed to start: " + err.Error())

		// Exit the program with a non-zero status code to indicate failure
		// os.Exit terminates the program immediately
		// Status code 1 conventionally indicates an error
		os.Exit(1)
	}
}
