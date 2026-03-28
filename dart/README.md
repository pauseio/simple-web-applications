# Dart Web Application

## Overview

This is a simple event-driven HTTP server implemented in Dart. It handles incoming requests on the `/` route and logs structured output to standard out following the OpenTelemetry logging standard.

## Key Concepts

### What is Dart?

Dart is a client-optimized programming language developed by Google. It's known for:
- **Flutter**: Primary language for Flutter mobile/desktop/web apps
- ** JIT + AOT**: Can be just-in-time compiled (for development) or ahead-of-time compiled (for production)
- **Strong typing**: Optional static types with type inference
- **Modern syntax**: Clean, readable syntax with async/await built-in

### Import Statements

```dart
import 'dart:io';
import 'dart:convert';
```

Dart imports:
- `dart:library_name` - Built-in libraries (no installation needed)
- `package:package_name/file.dart` - Pub package dependencies
- `file:relative/path.dart` - Relative file imports

**Comparison**: Python uses `import module`, JavaScript uses `import {} from 'module'`, Go uses `import "path"`.

### The Main Function

```dart
void main(List<String> arguments) async {
  // Entry point
}
```

- `void` - Returns nothing
- `main` - Entry point name (required)
- `List<String> arguments` - Command-line arguments
- `async` - Allows using `await` for async operations

**Comparison**: Python uses `def main():` or just top-level code, Go uses `func main()`, JavaScript uses top-level code.

### Type Annotations and Inference

```dart
final port = Platform.environment['PORT'] ?? '8084';
final server = await ServerSocket.bind(...);
void _handleConnection(Socket socket) { }
```

Dart has both:
- **Explicit types**: `String name = 'John';`
- **Type inference**: `var name = 'John';` (compiler infers `String`)
- **Final variables**: `final name = 'John';` (can't be reassigned, like `const` in JavaScript)

**Comparison**: Python infers types dynamically, JavaScript infers types dynamically, Go requires explicit types.

### Null Safety

```dart
final port = Platform.environment['PORT'] ?? '8084';
```

Dart has null safety (sound null safety):
- `??` - Null-coalescing operator (use left if not null, else right)
- `??=` - Assign only if null
- `String?` - Nullable string type
- `String` - Non-nullable string type

**Comparison**: Python has no null safety, JavaScript has optional chaining (`?.`), Go uses pointers for nullable types.

### Async/Await

```dart
final server = await ServerSocket.bind(...);
await for (final Socket socket in server) { }
```

Dart has built-in async/await:
- `async` - Marks a function as asynchronous
- `await` - Waits for a Future to complete
- `await for` - Iterates over a Stream asynchronously

**Comparison**: Python uses `async def` and `await`, JavaScript uses `async function()` and `await`, Go uses goroutines and channels.

### Streams

```dart
await for (final Socket socket in server) { }
socket.listen((List<int> data) { });
```

Streams are Dart's way of handling async sequences:
- `await for` - Consume a stream asynchronously
- `.listen()` - Subscribe to a stream with callbacks
- Similar to JavaScript observables or Python asyncio

**Comparison**: Python uses async iterators, JavaScript uses async generators and RxJS, Go uses channels.

### String Interpolation

```dart
printLog('Received $method request for path: $path');
final response = 'HTTP/1.1 200 OK\r\n';
```

Dart uses `$` for string interpolation:
- `$variable` - Interpolate a variable
- `${expression}` - Interpolate an expression

**Comparison**: Python uses f-strings `f"{variable}"`, JavaScript uses template literals `` `${variable}` ``, Go uses `fmt.Sprintf`.

### Collections

```dart
final lines = requestString.split('\r\n');
final logEntry = {
  'Timestamp': timestamp,
  'Body': message,
};
```

Dart has:
- **Lists**: Like arrays (mutable) - `[1, 2, 3]`
- **Maps**: Like dictionaries/objects - `{'key': 'value'}`
- **Sets**: Like mathematical sets - `{1, 2, 3}` (unique values)

**Comparison**: Python has lists/dicts/sets, JavaScript has arrays/objects/sets, Go has slices/maps.

### Private Members

```dart
void _handleConnection(Socket socket) { }
String _generateUuid() { }
```

Dart uses underscore prefix for library-private members:
- `_name` - Private to this library (file)
- `name` - Public (can be accessed from anywhere)

**Comparison**: Python uses `_name` convention (private by convention), JavaScript uses `#name` (private fields), Go uses lowercase names (exported vs unexported).

### Functions

```dart
void printLog(String message) {
  print(createLogEntry(message));
}

String _bytesToHex(List<int> bytes) {
  return bytes.map((b) => b.toRadixString(16)).join();
}
```

Dart functions:
- `ReturnType functionName(ParamType param) { body }`
- Arrow syntax: `ReturnType func(Param p) => expression;`
- Optional types: `functionName(param) { }`

**Comparison**: Python uses `def func(param):`, Go uses `func func(param Type) ReturnType`, JavaScript uses `function func(param)` or `const func = (param) => {}`.

## File Information

| File | Description |
|------|-------------|
| `server.dart` | Main application code with HTTP server and logging |

## Package Manager

**Pub** - Dart's package manager.

Initialize a new package:
```bash
dart pub init
```

Add dependencies:
```bash
dart pub add package_name
```

Install dependencies:
```bash
dart pub get
```

## Dependency File

**`pubspec.yaml`** - The pubspec file defines:
- Package name and version
- Dependencies with version constraints
- Development dependencies
- SDK constraints

This example uses only Dart's built-in libraries, so no `pubspec.yaml` is needed.

## Runtime and Packaging

**To run directly (JIT mode):**
```bash
dart run server.dart
```

**To compile to an executable (AOT mode):**
```bash
dart compile exe server.dart -o server
./server
```

**Dart's unique approach:**
- `dart run` - JIT compilation with hot reload (great for development)
- `dart compile exe` - Native machine code binary (fast execution)
- `dart compile aot-snapshot` - AOT snapshot (run with `dartaotruntime`)
- Can also compile to JavaScript for web: `dart compile js`

## Comparison with Other Languages

| Feature | Dart | Python | JavaScript | Go |
|---------|------|--------|------------|-----|
| **Type System** | Optional static, sound null safety | Dynamic | Dynamic (JSDoc optional) | Static |
| **Execution** | JIT (dev) or AOT (prod) | Interpreted bytecode | Interpreted/JIT | Compiled to machine code |
| **Entry Point** | `void main() async` | `def main():` or top-level | Top-level code | `func main()` |
| **Imports** | `import 'dart:io'` | `import os` | `import {} from 'module'` | `import "path"` |
| **Async** | `async/await`, `Stream` | `async/await` | `async/await`, Promise | Goroutine, Channel |
| **Primary Use** | Flutter apps, servers | General-purpose | Web, servers | General-purpose |
| **Compilation** | Can compile to native, JS, or run on VM | Bytecode or source | Source or bundled | Native binary |
