# Simple Web Applications

A collection of simple, event-driven HTTP web applications implemented in various programming languages. Each application demonstrates the core concepts of building a basic web server with structured logging following OpenTelemetry standards.

## Overview

This repository contains identical web server implementations across multiple programming languages, making it ideal for:
- **Language Comparison**: See how the same concepts are implemented differently across languages
- **Learning**: Each directory contains detailed explanations of language-specific concepts
- **Reference**: Quick examples of HTTP servers and structured logging in different languages

## Architecture

All applications share the same architecture:

1. **Event-Driven HTTP Server**: Handles incoming requests on the `/` route
2. **Structured Logging**: Outputs logs to stdout in OpenTelemetry JSON format with:
   - Timestamp
   - SeverityText and SeverityNumber
   - Body
   - TraceId and SpanId
3. **Simple Response**: Returns a basic HTTP response

## Available Languages

| Language | Directory | Run Command | Port |
|----------|-----------|-------------|------|
| **Bash** | `bash/` | `bash app.sh` | 8083 |
| **Python** | `python/` | `uv run app.py` | 8080 |
| **JavaScript** | `javascript/` | `node app.js` | - |
| **Go** | `go/` | `go run main.go` | - |
| **Java** | `java/` | See directory | - |
| **C#** | `csharp/` | See directory | - |
| **PHP** | `php/` | `php -S localhost:8086 index.php` | 8086 |
| **Dart** | `dart/` | `dart run server.dart` | - |

## Quick Start

Each directory is self-contained with its own README explaining:

1. **Source file name** - The main application file
2. **Package manager** - How to install dependencies
3. **Dependency file** - Where dependencies are declared
4. **Runtime and packaging** - How to run and deploy the application

### Example: Running the Python Server

```bash
cd python
uv run app.py
curl http://localhost:8080/
```

### Example: Running the Bash Server

```bash
cd bash
bash app.sh
curl http://localhost:8083/
```

## Educational Features

Each language directory includes:

- **Detailed README** with language-specific explanations
- **Key Concepts** section covering important language features
- **Comparisons** with other languages in the repository
- **Code comments** explaining what each line does
- **Cross-references** to similar concepts in other languages

## Common Concepts Across Languages

| Concept | Description |
|---------|-------------|
| HTTP Server | Each language implements a basic HTTP listener |
| Request Handling | Parsing HTTP methods and paths |
| JSON Logging | Structured output in OpenTelemetry format |
| UUID Generation | Trace IDs for request tracking |
| Timestamps | ISO 8601 formatted timestamps |

## Contributing

When adding new language implementations:

1. Create a new directory named after the language
2. Implement the same HTTP server functionality
3. Add a comprehensive README.md with:
   - Source file name
   - Package manager
   - Dependency file
   - Runtime and packaging instructions
   - Key concepts and language comparisons
4. Include detailed code comments
5. Ensure OpenTelemetry-compliant logging

## License

See root repository for license information.
