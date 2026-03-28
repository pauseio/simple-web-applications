# Hello-World API

This is a sample web application demonstrating a simple Actix-Web API in Rust. It logs structured output to stdout using the OpenTelemetry JSON logging standard and returns simple JSON responses.

## Project Details

- **Source Code**: `main.rs` (located in the `src/` directory).
- **Package Manager**: Cargo (the official Rust package manager).
- **Dependency File**: `Cargo.toml` (tracks dependencies like `actix-web`, `serde`, `chrono`, `uuid`, and `serde_json`).
- **App Runtime**: Rust compiles directly to a native, standalone OS executable binary. It runs directly on the operating system without needing a virtual machine or interpreter (no separate runtime required).

## Features

- **Single Endpoint**: `GET /` returns a JSON greeting
- **OpenTelemetry Logging**: Structured JSON logs output to stdout with Timestamp, SeverityText, SeverityNumber, Body, TraceId, and SpanId fields
- **Simple Response Format**: Returns JSON with message, timestamp, path, and method

## How to run

Start the application using Cargo:

```bash
cargo run
```

The server will be available at `http://0.0.0.0:8080`.

## Example Response

```json
{
  "message": "Hello from Rust!",
  "timestamp": "2024-03-28T10:30:45.123456+00:00",
  "path": "/",
  "method": "GET"
}
```

## Example Log Output

```json
{"Timestamp":"2024-03-28T10:30:45.123456+00:00","SeverityText":"INFO","SeverityNumber":9,"Body":"Starting server on port 8080","TraceId":"a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6","SpanId":"e5f6a7b8c9d0e1f2"}
```
