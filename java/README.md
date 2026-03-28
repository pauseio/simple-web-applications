# Java Web Application

## Overview

This is a simple event-driven HTTP server implemented in Java. It handles incoming requests on the `/` route and logs structured output to standard out following the OpenTelemetry logging standard.

## Key Concepts

### What is Java?

Java is a class-based, object-oriented programming language designed to have as few implementation dependencies as possible. It's known for:
- **"Write Once, Run Anywhere"**: Java code compiles to bytecode that runs on any Java Virtual Machine (JVM)
- **Strong typing**: Type safety with explicit type declarations
- **Object-oriented**: Everything is a class or part of a class
- **Automatic memory management**: Garbage collection handles memory cleanup

### Package Declaration

```java
package com.example.myapp;
```

Every Java file starts with a package declaration (empty package is default). Packages organize related classes and prevent naming conflicts.

**Comparison**: Python uses folders for packages, Go uses module paths, Java uses reverse domain notation.

### Import Statements

```java
import java.util.UUID;
import java.io.*;
```

Java imports classes from other packages. The `*` wildcard imports all classes in a package.

**Comparison**: Python uses `from module import item`, JavaScript uses `import {} from 'module'`, Java uses `import package.Class`.

### Class Declaration

```java
public class App {
    // fields and methods
}
```

All Java code must be inside a class. The class name must match the filename (minus `.java`).

- `public`: Accessible from anywhere
- Class names use PascalCase by convention

**Comparison**: Python uses any file as a module, JavaScript uses classes or functions, Go uses any file in a package.

### The Main Method

```java
public static void main(String[] args) {
    // Entry point
}
```

The JVM calls `main()` to start the program:
- `public`: JVM must be able to call it
- `static`: No object instance needed
- `void`: Returns nothing to JVM
- `String[] args`: Command-line arguments

**Comparison**: Python uses `if __name__ == "__main__":`, Go uses `func main()`, JavaScript uses top-level code.

### Static vs Instance Members

```java
private static final JsonWriter jsonWriter = new JsonWriter();
```

- `static`: Belongs to the class, shared across all instances
- `final`: Cannot be reassigned (constant)
- `private`: Only accessible within this class

**Comparison**: Python uses `@staticmethod` decorator, Go uses package-level variables, JavaScript uses `static` keyword.

### Type Declarations

```java
String port = System.getenv("PORT");
int portNum = Integer.parseInt(port);
```

Java requires explicit type declarations:
- `String`: Text data (like Python `str` or JavaScript `string`)
- `int`: Integer numbers (32-bit)
- `boolean`: true/false
- All variables must have a declared type

**Comparison**: Python infers types dynamically, JavaScript uses `let/const` with dynamic types, Go requires explicit types like Java.

### Ternary Operator

```java
String port = envPort != null ? envPort : "8080";
```

Java's ternary operator is a compact if-else: `condition ? valueIfTrue : valueIfFalse`

**Comparison**: Python uses `valueIfTrue if condition else valueIfFalse`, JavaScript uses the same syntax as Java.

### Exception Handling

```java
public static void main(String[] args) throws Exception {
    // ...
}
```

Java has two types of exceptions:
- **Checked exceptions**: Must be declared in `throws` or caught with `try-catch`
- **Unchecked exceptions**: Don't need to be declared

The `throws Exception` declaration means this method might fail and callers must handle it.

**Comparison**: Python uses try/except, JavaScript uses try/catch, Java uses both.

### Lambda Expressions

```java
server.createContext("/", exchange -> {
    // handle request
});
```

Java 8+ supports lambda expressions for concise anonymous functions:
- `exchange -> expression`: Single parameter, single expression
- `(params) -> { statements }`: Multiple parameters/statements

**Comparison**: Python uses `lambda x: x`, JavaScript uses `(x) => {}`, Go uses anonymous functions.

### Try-with-Resources

```java
try (OutputStream os = exchange.getResponseBody()) {
    os.write(response);
}
```

The try-with-resources statement automatically closes resources after use. Any object implementing `AutoCloseable` works here.

**Comparison**: Python uses `with open()`, JavaScript uses no automatic resource management, Go uses `defer`.

### Nested Classes

```java
static class JsonWriter {
    // ...
}
```

Classes can be nested inside other classes:
- `static` nested class: Doesn't need outer class instance
- Non-static inner class: Requires outer class instance

**Comparison**: Python supports nested classes, JavaScript supports nested classes (ES6+), Go doesn't have nested classes.

## File Information

| File | Description |
|------|-------------|
| `App.java` | Main application code with HTTP server and logging |

## Package Manager

**Maven** or **Gradle** - Java has two main build tools.

This example uses only the Java standard library (no external dependencies).

## Dependency File

For projects with dependencies, use either:
- **Maven**: `pom.xml` - Project Object Model file
- **Gradle**: `build.gradle` - Gradle build script

## Runtime and Packaging

**To run directly:**
```bash
javac App.java
java App
```

**Explanation:**
- `javac`: Java compiler - compiles `.java` to `.class` bytecode
- `java`: Java application launcher - runs the compiled bytecode

**To create a JAR (Java Archive):**
```bash
javac App.java
jar cfe app.jar App App.class
java -jar app.jar
```

**Java's unique approach:**
- Source code (`App.java`) → Bytecode (`App.class`) → Runs on JVM
- The JVM provides platform independence
- bytecode runs on any device with a JVM

## Comparison with Other Languages

| Feature | Java | Python | Go |
|---------|------|--------|-----|
| **Type System** | Static, object-oriented | Dynamic | Static, structural |
| **Execution** | Compiled to bytecode on JVM | Interpreted bytecode | Compiled to machine code |
| **File Structure** | One public class per file | Any structure | One package per directory |
| **Entry Point** | `public static void main()` | `if __name__ == "__main__":` | `func main()` |
| **Imports** | `import package.Class` | `import module` | `import "path"` |
| **Memory Management** | Garbage collection | Reference counting + GC | Garbage collection |
| **Classes** | Everything must be in a class | Classes optional | No classes (structs) |
