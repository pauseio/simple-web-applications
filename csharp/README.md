# C# Web Application

## Overview

This is a simple event-driven HTTP server implemented in C#. It handles incoming requests on the `/` route and logs structured output to standard out following the OpenTelemetry logging standard.

## Key Concepts

### What is C#?

C# (pronounced "C Sharp") is a modern, object-oriented programming language developed by Microsoft. It's known for:
- **.NET ecosystem**: Runs on .NET Runtime (cross-platform since .NET Core)
- **Strong typing**: Static typing with type inference
- **Modern features**: Async/await, LINQ, pattern matching, records
- **Multiple runtimes**: Full framework (Windows-only) or .NET Core/5+ (cross-platform)

### Using Directives

```csharp
using System;
using System.Text.Json;
```

`using` directives import namespaces:
- `System` is the fundamental namespace with core types
- `System.Text.Json` provides JSON serialization
- Similar to Python's `import`, Java's `import`, Go's `import`

**Comparison**: Python uses `import module`, JavaScript uses `import {} from 'module'`, Go uses `import "path"`.

### Namespaces

```csharp
namespace JumpboxTraining;
```

Namespaces organize code and prevent conflicts:
- Similar to Java packages or Python modules
- Convention: PascalCase (e.g., `MyCompany.MyProject`)
- Can be nested with dots

**Comparison**: Python uses folders/packages, Go uses module paths, Java uses reverse domain notation.

### Classes

```csharp
class Program
{
    static async Task Main(string[] args) { }
}
```

C# is object-oriented:
- Everything must be in a class (for traditional C#)
- `class` keyword defines a class
- PascalCase naming by convention
- `static` members belong to class, not instances

**Comparison**: Python uses classes optionally, Go uses structs, Java requires classes like C#.

### The Main Method

```csharp
static async Task Main(string[] args) { }
```

Entry point variations:
- `static void Main(string[] args)` - Traditional synchronous
- `static async Task Main(string[] args)` - Async (recommended for I/O)
- Top-level statements (C# 9+) - No class/Main needed

**Comparison**: Python uses `if __name__ == "__main__":`, Go uses `func main()`, Java uses `public static void main()`.

### Variables

```csharp
string port = Environment.GetEnvironmentVariable("PORT") ?? "8087";
var server = new SimpleHttpServer(port);
```

C# has both explicit and inferred types:
- `string name` - Explicit type declaration
- `var name` - Type inference (compiler determines type)
- `string? name` - Nullable string type

**Comparison**: Python infers types, JavaScript infers types, Go requires explicit types or `:=` inference.

### Null-Coalescing Operator

```csharp
string port = envValue ?? "8087";
string? name = GetValue() ?? "Default";
```

The `??` operator provides a default value:
- Returns left side if not null, else right side
- `??=` assigns only if null

**Comparison**: Python uses `or`, JavaScript uses `||` or `??`, Dart uses `??`.

### String Interpolation

```csharp
Console.WriteLine(JsonLogEntry.Create($"Received {method} request for path: {path}"));
```

C# uses `$` for string interpolation:
- `$"Text {variable}"` - Simple interpolation
- `$"Text {expression:N2}"` - Format specifiers
- `$@"Text {var}"` - Verbatim interpolated strings (preserves newlines)

**Comparison**: Python uses f-strings `f"{var}"`, JavaScript uses template literals `` `${var}` ``, Dart uses `"$var"`.

### Async/Await

```csharp
public async Task StartAsync()
{
    var context = await listener.GetContextAsync();
}
```

C# has built-in async/await:
- `async` - Marks method as asynchronous
- `await` - Waits for Task to complete without blocking
- `Task` - Represents an ongoing operation (like Promise)

**Comparison**: Python uses `async def` and `await`, JavaScript uses `async function()` and `await`, Go uses goroutines and channels.

### Anonymous Types

```csharp
var logEntry = new
{
    Timestamp = timestamp,
    Body = message,
};
```

Anonymous types:
- Created with `new { Prop = value }`
- No class definition needed
- Read-only properties
- Great for temporary data structures

**Comparison**: Python uses dictionaries, JavaScript uses object literals `{}`, Go uses struct literals.

### Using Statement

```csharp
using var output = response.OutputStream;
```

The `using` statement ensures resources are disposed:
- `using var` - Declare and dispose at end of scope
- `using (var x = ...)` - Traditional block scope
- Calls `Dispose()` automatically

**Comparison**: Python uses `with open()`, Go uses `defer`, Java uses try-with-resources.

### JSON Serialization

```csharp
string json = JsonSerializer.Serialize(logEntry);
```

Built-in JSON support:
- `System.Text.Json` - Modern, high-performance JSON library
- `JsonSerializer.Serialize()` - Object to JSON string
- `JsonSerializer.Deserialize()` - JSON string to object

**Comparison**: Python uses `json.dumps()`, JavaScript uses `JSON.stringify()`, Go uses `json.Marshal()`.

## File Information

| File | Description |
|------|-------------|
| `Program.cs` | Main application code with HTTP server and logging |
| `JumpboxTraining.csproj` | Project file for .NET SDK |

## Package Manager

**NuGet** - .NET's package manager.

Restore dependencies:
```bash
dotnet restore
```

Add a package:
```bash
dotnet add package PackageName
```

## Dependency File

**`*.csproj`** - The MSBuild project file.

Example structure:
```xml
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <OutputType>Exe</OutputType>
    <TargetFramework>net8.0</TargetFramework>
  </PropertyGroup>
</Project>
```

## Runtime and Packaging

**To run the application:**
```bash
dotnet run
```

**To build an executable:**
```bash
dotnet build
dotnet run --project JumpboxTraining.csproj
```

**To publish as self-contained (includes runtime):**
```bash
dotnet publish -c Release -r linux-x64 --self-contained
```

**C#'s unique approach:**
- Source code compiles to IL (Intermediate Language)
- IL runs on .NET Runtime (JIT-compiled to machine code)
- Can be AOT-compiled with Native AOT (newer .NET versions)
- Single-file deployment available

## Comparison with Other Languages

| Feature | C# | Java | Python | Go |
|---------|-----|------|--------|-----|
| **Type System** | Static, with inference | Static | Dynamic | Static |
| **Execution** | IL → JIT (or AOT) | Bytecode → JVM | Interpreted bytecode | Compiled to machine code |
| **Entry Point** | `static async Task Main()` | `public static void main()` | `if __name__ == "__main__":` | `func main()` |
| **Imports** | `using Namespace;` | `import package.*;` | `import module` | `import "path"` |
| **String Interpolation** | `$"{var}"` | `"var"` or String.format | `f"{var}"` | `fmt.Sprintf` |
| **Async Model** | `async/await`, `Task` | `CompletableFuture` | `async/await`, asyncio | Goroutine, Channel |
| **Classes** | Required (traditional) | Required | Optional | No classes (structs) |
| **Null Safety** | Reference types nullable, `?` operator | Reference types nullable | All types nullable | Pointers for nullable |
| **JSON** | System.Text.Json | Jackson/Gson | json module | encoding/json |

## C# Version Notes

This example targets .NET 8.0:
- Uses top-level statements (optional, not used here for clarity)
- Uses file-scoped namespaces (`namespace JumpboxTraining;`)
- Uses nullable reference types (`string?`)
- Modern async/await patterns

For older .NET Framework (pre-.NET Core):
- Requires `System.Net.Http` for HTTP client (different from HttpListener)
- No built-in JSON (need Newtonsoft.Json or System.Text.Json NuGet)
- Slightly different syntax in some areas
