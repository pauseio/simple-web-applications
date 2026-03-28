# Go Web Application

## Overview

This is a simple event-driven HTTP server implemented in Go. It handles incoming requests on the `/` route and logs structured output to standard out following the OpenTelemetry logging standard.

## Key Concepts

### What is Go?

Go (also called Golang) is a statically-typed, compiled programming language designed at Google. It's known for:
- **Simplicity**: Clean syntax with fewer keywords than most languages
- **Performance**: Compiled to machine code, runs close to C speed
- **Concurrency**: Built-in support for concurrent programming via goroutines
- **Strong typing**: Type safety catches errors at compile time

### Package Declaration

```go
package main
```

Every Go file starts with a package declaration. The `main` package is special - it tells Go this is an executable program (not a library).

### Import Statement

```go
import (
    "fmt"
    "net/http"
    // ... more imports
)
```

Go uses "factored" import declarations - multiple imports are grouped in parentheses. This is Go's preference for readability.

**Comparison**: Python uses `import module`, JavaScript uses `require()` or `import`, Go uses `import "path"`.

### Functions

```go
func functionName(param type) returnType {
    // function body
}
```

Key differences from other languages:
- **Explicit types**: Parameters must declare their types
- **Return types**: Functions declare what type they return
- **Multiple returns**: Go functions can return multiple values

**Comparison**: Python infers types, JavaScript uses `function` or `() =>`, Go requires explicit type declarations.

### Structured Logging with Maps

```go
logEntry := map[string]interface{}{
    "Timestamp": time.Now(),
    "Body": message,
}
```

Maps are key-value data structures (like Python dictionaries or JavaScript objects). The `interface{}` type means "any value can be stored here" (similar to Python's `Any` or TypeScript's `unknown`).

### HTTP Handler Pattern

```go
func handler(w http.ResponseWriter, r *http.Request) {
    // handle request
}
```

Every Go HTTP handler has this exact signature:
- `w http.ResponseWriter`: Used to write the HTTP response
- `r *http.Request`: Contains the incoming request data
- `*Request` means this is a pointer (a reference to the actual request object)

**Pointers**: Go uses pointers (`*Type`) to pass references to data instead of copying the data itself. This is more memory efficient.

### The Main Function

```go
func main() {
    // program entry point
}
```

Every Go executable must have a `main()` function in the `main` package. This is where execution begins (like Python's `if __name__ == "__main__":` or JavaScript's top-level code).

### Environment Variables

```go
port := os.Getenv("PORT")
if port == "" {
    port = "8080"
}
```

Go requires explicit error/value checking. Unlike some languages, Go doesn't throw exceptions - it returns error values that you must check.

### Starting the Server

```go
http.ListenAndServe(":8080", nil)
```

This starts the HTTP server:
- `:8080` means "listen on all network interfaces, port 8080"
- `nil` means "use the default request handler" (we registered one with `http.HandleFunc`)

## File Information

| File | Description |
|------|-------------|
| `main.go` | Main application code with HTTP server and logging |
| `go.mod` | Module definition and dependency list |
| `go.sum` | Checksums for dependencies (auto-generated) |

## Package Manager

**Go Modules** - Go's built-in dependency management system.

Initialize a new module:
```bash
go mod init module-name
```

Add dependencies:
```bash
go get package-path
```

Download dependencies:
```bash
go mod download
```

## Dependency File

**`go.mod`** - The module file that defines:
- Module name (identifier for your project)
- Go version requirement
- List of dependencies with versions

## Runtime and Packaging

**To run the application:**
```bash
go run main.go
```

**To build an executable:**
```bash
go build -o server main.go
./server
```

**Go's unique approach:**
- `go run` compiles and runs in one step (good for development)
- `go build` produces a standalone binary (no runtime needed!)
- The binary includes all dependencies - just copy and run

## Comparison with Other Languages

| Feature | Go | Python | JavaScript |
|---------|-----|--------|------------|
| **Type System** | Static, compiled | Dynamic, interpreted | Dynamic, JIT-compiled |
| **Execution** | Compiled to binary | Interpreted bytecode | Interpreted/JIT |
| **Concurrency** | Goroutines (built-in) | Threads/asyncio | Event loop/promises |
| **Imports** | `import "path"` | `import module` | `require()/import` |
| **Error Handling** | Return values | Exceptions | try/catch |
| **Deployment** | Single binary | Need Python + dependencies | Need Node + node_modules |
