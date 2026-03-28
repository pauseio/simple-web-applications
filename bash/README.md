# Bash Web Application

## Overview

This is a simple event-driven HTTP server implemented in Bash. It handles incoming requests on the `/` route and logs structured output to standard out following the OpenTelemetry logging standard.

## Key Concepts

### What is Bash?

Bash (Bourne Again SHell) is a Unix shell and command language. It's primarily designed for:
- **System administration**: Automating system tasks
- **Command execution**: Running other programs and coordinating them
- **Text processing**: Manipulating text files and output
- **Not general-purpose programming**: While possible, it's not ideal for complex applications

### The Shebang Line

```bash
#!/bin/bash
```

The first line of a Bash script must be the shebang:
- `#!` tells the system "this is a script, use the following interpreter"
- `/bin/bash` is the full path to the Bash interpreter
- This allows scripts to be executed directly (like: `./app.sh`)

**Comparison**: Python uses `#!/usr/bin/env python3`, Go scripts don't exist, JavaScript uses `#!/usr/bin/env node`.

### Variables

```bash
PORT="${PORT:-8083}"
message="$1"
```

Bash variables are:
- **String-based**: Everything is a string (no types)
- **No spaces**: `VAR=value` (no spaces around `=`)
- **Reference with `$`: `echo $VAR` or `echo "${VAR}"`
- **Default values**: `${VAR:-default}` means "use VAR if set, else default"

**Comparison**: Python has types (`int`, `str`), JavaScript uses `let/var/const`, Go requires explicit types.

### Command Substitution

```bash
trace_id=$(generate_uuid)
timestamp=$(get_timestamp)
```

The `$(command)` syntax runs a command and captures its output:
- `$(generate_uuid)` runs the function and stores its output in `trace_id`
- This is how you get return values from commands in Bash

**Comparison**: Python uses `result = function()`, JavaScript uses `const result = function()`, Go uses `result := function()`.

### Functions

```bash
function_name() {
    local var="$1"
    # do something
    echo "return value"
}
```

Bash functions:
- Don't declare parameters in the definition
- Access parameters via `$1`, `$2`, `$3`, etc.
- "Return" values by echoing them (captured via command substitution)
- `local` creates variables local to the function

**Comparison**: Python uses `def func(param):`, Go uses `func func(param) returnType:`, JavaScript uses `function func(param) {}`.

### Here Documents

```bash
cat <<EOF
HTTP/1.1 200 OK
Content-Type: text/plain

Event processed successfully
EOF
```

Here documents allow multi-line strings:
- `<<EOF` starts a here document
- Everything until `EOF` is literal text
- Great for templates, HTTP responses, config files

**Comparison**: Python uses triple quotes `"""text"""`, JavaScript uses template literals, Go uses backticks.

### Parameter Expansion

```bash
method="${request_line%%|*}"
path="${request_line##*|}"
```

Bash has powerful string manipulation:
- `${var%%pattern}` - remove longest match of pattern from end
- `${var##pattern}` - remove longest match of pattern from start
- `${var#pattern}` - remove shortest match from start
- `${var%pattern}` - remove shortest match from end

**Comparison**: Python uses string methods like `split()` or regex, JavaScript uses `split()` or `replace()`.

### Pipes and Redirection

```bash
echo "response" | nc -l -p 8080
```

Pipes (`|`) connect commands:
- Output of left command becomes input of right command
- This is the "Unix philosophy": small tools that work together

**Comparison**: Python uses subprocess pipes, JavaScript uses streams, Go uses io.Pipe.

### Loops

```bash
while true; do
    # repeat forever
done
```

Bash supports:
- `while true; do ... done` - infinite loop
- `for i in 1 2 3; do ... done` - iterate over list
- `for ((i=0; i<10; i++)); do ... done` - C-style for loop

**Comparison**: Python uses `while True:` and `for i in range():`, Go uses `for { }` and `for i := 0; i < 10; i++`.

### Conditionals

```bash
if [ "$var" = "value" ]; then
    # do something
fi
```

Bash conditionals use `[ ]` (or `[[ ]]`):
- Spaces around `[ ]` are required!
- String comparison: `=`, `!=`
- Numeric comparison: `-eq`, `-ne`, `-lt`, `-gt`
- File tests: `-f` (file exists), `-d` (directory)

**Comparison**: Python uses `if var == "value":`, JavaScript uses `if (var === "value")`, Go uses `if var == "value"`.

### Netcat (nc)

```bash
nc -l -k -v -p "$PORT"
```

Netcat is the "Swiss Army knife" of networking:
- `-l`: Listen mode (act as server)
- `-k`: Keep listening after connection closes
- `-v`: Verbose (log connections)
- `-p`: Port to listen on

**Warning**: This is a minimal server. For production, use dedicated web servers (nginx, Apache) or application servers.

## File Information

| File | Description |
|------|-------------|
| `app.sh` | Main application code with HTTP server and logging |

## Package Manager

**None** - Bash scripts typically use only system utilities.

For external dependencies, use:
- System package manager: `apt`, `yum`, `brew`
- Or check for commands: `command -v nc` checks if netcat is installed

## Dependency File

**None** - Bash scripts don't have dependency files.

Dependencies are documented in comments or README files.

## Runtime and Packaging

**To run the script:**
```bash
# Make it executable
chmod +x app.sh

# Run it
./app.sh
```

**Or directly with bash:**
```bash
bash app.sh
```

**No compilation needed** - Bash scripts are interpreted line by line.

**Portability concerns:**
- Linux and macOS have Bash installed by default
- Different versions may have different features
- Some Linux distros use `dash` or `sh` instead of `bash`

## Comparison with Other Languages

| Feature | Bash | Python | Go |
|---------|------|--------|-----|
| **Type System** | None (strings only) | Dynamic | Static |
| **Execution** | Interpreted | Interpreted bytecode | Compiled to machine code |
| **Primary Use** | System automation | General-purpose | General-purpose |
| **Error Handling** | Exit codes | Exceptions | Error values |
| **Variables** | `$VAR` | `var = value` | `var := value` |
| **Functions** | `func() { }` | `def func():` | `func func() { }` |
| **HTTP Server** | Requires netcat | Requires http.server | Built into stdlib |
| **Best For** | Quick scripts, automation | Everything | Performance-critical apps |

## When NOT to Use Bash

While this example shows Bash can run a web server, you typically shouldn't:
- **Performance**: Bash is slow for heavy workloads
- **Security**: Shell injection vulnerabilities are common
- **Complexity**: Hard to maintain complex logic in Bash
- **Portability**: Different systems have different Bash versions

Use Python, Go, Node.js, or another language for real web applications.
