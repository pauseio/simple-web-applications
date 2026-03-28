# Python HTTP Server

A simple event-driven HTTP server implemented in Python that handles requests on the `/` route with OpenTelemetry-compliant structured logging.

## Files

| File | Description |
|------|-------------|
| `app.py` | Main HTTP server implementation |
| `pyproject.toml` | Project configuration for uv package manager |

## Package Manager

This project uses **`uv`** - a fast Python package manager and project manager.

### Installing uv

```bash
# On Linux/macOS
curl -LsSf https://astral.sh/uv/install.sh | sh

# On Windows
powershell -c "irm https://astral.sh/uv/install.ps1 | iex"

# Or via pip
pip install uv
```

## Dependencies

This application has **no external dependencies** - it uses only Python's built-in standard library:

- `http.server` - Built-in HTTP server and handler
- `json` - JSON serialization for structured logs
- `uuid` - Generation of unique trace/span identifiers
- `datetime` - Timestamp generation

## Running the Application

### Prerequisites
- Python 3.10 or higher
- uv package manager

### Start the Server

```bash
# Using uv run (recommended - creates virtual environment automatically)
uv run app.py

# Or sync dependencies first, then run
uv sync
uv run app.py
```

The server will start on `http://localhost:8080/`

### Test the Server

```bash
curl http://localhost:8080/
```

You should see:
- JSON response: `{"message": "Hello from Python!", "timestamp": "...", "path": "/", "method": "GET"}`
- OpenTelemetry JSON logs in your terminal

### Example Log Output

```json
{"Timestamp": "2025-01-15T10:30:45.123456Z", "SeverityText": "INFO", "SeverityNumber": 9, "Body": "Python HTTP server starting on port 8080", "TraceId": "a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6", "SpanId": "a1b2c3d4e5f6g7h8"}
```

## App Runtime and Packaging

### Runtime
- **Interpreter**: `python3` (Python 3 interpreter)
- **Execution model**: Script-based execution

### Packaging Options
1. **Script** (current): Run directly with `python3 app.py`
2. **Executable**: Make script executable with `chmod +x app.py` and run `./app.py`
3. **Systemd Service**: Can be packaged as a Linux service for production deployment
4. **Docker**: Can be containerized using a Python base image

### Stopping the Server
Press `Ctrl+C` to gracefully shutdown the server.
