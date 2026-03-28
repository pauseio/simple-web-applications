# JavaScript Web Application

## Overview

This is a simple event-driven HTTP server implemented in JavaScript (Node.js). It handles incoming requests on the `/` route and logs structured output to standard out following the OpenTelemetry logging standard.

## Key Concepts

### What is JavaScript?

JavaScript is a dynamic, interpreted programming language primarily known for:
- **Web development**: The language of the web (runs in all browsers)
- **Node.js**: Server-side JavaScript runtime (what we're using here)
- **Event-driven**: Designed around asynchronous events and callbacks
- **Dynamic typing**: Variables can hold any type of data

### Require Statements (CommonJS)

```javascript
const http = require('http');
```

Node.js uses CommonJS modules by default:
- `require()` imports a module
- `module.exports` exports from a module
- Built-in modules don't need `./` path: `require('http')`
- Local files need relative path: `require('./myFile')`

**Comparison**: Python uses `import module`, Go uses `import "path"`, ES6 uses `import {} from 'module'`.

### Variables

```javascript
const port = process.env.PORT || '8085';
let count = 0;
```

JavaScript has three variable keywords:
- `const` - Constant (cannot be reassigned, like final in Java)
- `let` - Block-scoped variable (can be reassigned)
- `var` - Function-scoped variable (legacy, avoid in modern code)

**Comparison**: Python uses `name = value`, Go uses `var name Type` or `name := value`, Dart uses `final` and `var`.

### Functions

```javascript
function createLogEntry(message) {
  // ...
}

const logMessage = (message) => {
  // ...
};
```

JavaScript has multiple ways to define functions:
- `function name() {}` - Traditional function declaration
- `const name = () => {}` - Arrow function (ES6+, preferred for callbacks)
- `const name = function() {}` - Function expression

**Comparison**: Python uses `def func():`, Go uses `func func() {}`, Dart uses `ReturnType func()`.

### Template Literals

```javascript
logMessage(`Received ${method} request for path: ${path}`);
```

Template literals use backticks (\`):
- `${expression}` embeds expressions
- Support multi-line strings
- Support nested expressions

**Comparison**: Python uses f-strings `f"{var}"`, Dart uses `"$var"`, Go uses `fmt.Sprintf`.

### Objects

```javascript
const logEntry = {
  Timestamp: timestamp,
  Body: message,
};
```

JavaScript objects are like dictionaries:
- `{ key: value }` syntax
- Keys are automatically converted to strings (or use Symbols)
- Access via dot: `obj.key` or bracket: `obj['key']`

**Comparison**: Python uses dictionaries `{ 'key': value }`, Go uses maps `map[key]value`, Dart uses maps `{'key': value}`.

### JSON

```javascript
const jsonString = JSON.stringify(logEntry);
const parsed = JSON.parse(jsonString);
```

JSON is JavaScript Object Notation:
- `JSON.stringify()` - Converts object to JSON string
- `JSON.parse()` - Parses JSON string to object
- JSON is a subset of JavaScript syntax

**Comparison**: Python uses `json.dumps()` and `json.loads()`, Go uses `json.Marshal()` and `json.Unmarshal()`.

### Callbacks and Async

```javascript
const server = http.createServer((req, res) => {
  // handle request
});

server.listen(port, () => {
  // server started
});
```

JavaScript is inherently asynchronous:
- Callbacks are functions passed as arguments
- Arrow functions `() => {}` are concise callbacks
- Used for events, I/O, timers, etc.

**Comparison**: Python uses callbacks or async/await, Go uses goroutines, Dart uses `Future` and `Stream`.

### Process Environment

```javascript
const port = process.env.PORT || '8085';
```

Node.js provides the `process` object:
- `process.env` - Environment variables
- `process.argv` - Command-line arguments
- `process.exit()` - Exit the program

**Comparison**: Python uses `os.environ`, Go uses `os.Getenv`, Dart uses `Platform.environment`.

### HTTP Server

```javascript
const server = http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.end('Event processed successfully\n');
});
```

Node.js built-in HTTP module:
- `http.createServer()` - Creates a server
- `req` - Request object (method, url, headers, body)
- `res` - Response object (writeHead, end, write)

**Comparison**: Python uses `http.server`, Go uses `net/http`, Dart uses `dart:io`.

## File Information

| File | Description |
|------|-------------|
| `app.js` | Main application code with HTTP server and logging |

## Package Manager

**npm** (Node Package Manager) - The default package manager for Node.js.

Initialize a new package:
```bash
npm init
```

Add dependencies:
```bash
npm install package-name
```

Install dependencies:
```bash
npm install
```

## Dependency File

**`package.json`** - Defines package metadata and dependencies.

Example structure:
```json
{
  "name": "my-app",
  "version": "1.0.0",
  "dependencies": {
    "express": "^4.18.0"
  }
}
```

This example uses only Node.js built-in modules, so no `package.json` is needed.

## Runtime and Packaging

**To run the application:**
```bash
node app.js
```

**Or using npm (if package.json exists with "start" script):**
```bash
npm start
```

**JavaScript's unique approach:**
- Source code runs directly via Node.js (no compilation)
- Can be bundled with tools like Webpack, esbuild for deployment
- Can be transpiled from TypeScript for type safety

## Comparison with Other Languages

| Feature | JavaScript | Python | Go | Dart |
|---------|-----------|--------|-----|------|
| **Type System** | Dynamic (optional TypeScript) | Dynamic | Static | Optional static |
| **Execution** | Interpreted by V8 engine | Interpreted bytecode | Compiled to machine code | JIT or AOT |
| **Entry Point** | Top-level code or main file | Top-level code or `if __name__` | `func main()` | `void main()` |
| **Imports** | `require('module')` | `import module` | `import "path"` | `import 'dart:io'` |
| **Async Model** | Callbacks, Promises, async/await | async/await, asyncio | Goroutines, channels | async/await, streams |
| **Variable Declaration** | `const`, `let`, `var` | `name = value` | `var name Type`, `name :=` | `final`, `var` |
| **Functions** | `() => {}` or `function() {}` | `def func():` | `func func() {}` | `func() {}` or `=>` |
| **HTTP Server** | `http.createServer()` | `http.server` | `net/http` | `dart:io` |

## ES6 Modules (Modern Alternative)

While this example uses CommonJS (`require`), modern Node.js also supports ES6 modules:

```javascript
// Use ES6 imports instead of require
import http from 'http';

// Use export instead of module.exports
export { handler };
```

To use ES6 modules, either:
1. Name files with `.mjs` extension
2. Add `"type": "module"` to `package.json`
