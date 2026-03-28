# PHP Web Application

## Overview

This is a simple event-driven HTTP server implemented in PHP. It handles incoming requests on the `/` route and logs structured output to standard out following the OpenTelemetry logging standard.

## Key Concepts

### What is PHP?

PHP (PHP: Hypertext Preprocessor) is a server-side scripting language designed for web development. It's known for:
- **Web-first**: Designed specifically for generating dynamic web pages
- **Easy deployment**: Runs on most web servers (Apache, nginx)
- **Embedded in HTML**: Can be mixed directly with HTML
- **Large ecosystem**: WordPress, Laravel, Symfony, and many others

### PHP Opening Tag

```php
<?php
// PHP code here
?>
```

All PHP code must be within `<?php ?>` tags:
- `<?php` opens a PHP code block
- `?>` closes a PHP code block (optional at end of file)
- Everything outside tags is plain HTML/text

**Comparison**: Python uses no special tags (entire file is code), JavaScript files are all code, Go uses no special tags.

### Variables

```php
$port = $_ENV['PORT'] ?? '8086';
$message = "Hello";
```

PHP variables:
- Must start with `$` (dollar sign)
- No declaration needed (just assign)
- Dynamic typing (any variable can hold any type)
- `$thisIsCamelCase` is the naming convention

**Comparison**: Python uses `name = value`, JavaScript uses `let/var/const name = value`, Go uses `name := value`.

### Type Hints

```php
function create_log_entry(string $message): string {
    // ...
}
```

PHP 7+ supports type hints:
- `string $param` - Parameter must be a string
- `: string` - Function returns a string
- `: void` - Function returns nothing
- Optional but recommended for type safety

**Comparison**: Python uses type hints `def func(param: str) -> str:`, Go requires types, Dart uses `ReturnType func(ParamType param)`.

### Superglobals

```php
$method = $_SERVER['REQUEST_METHOD'];
$env = $_ENV['PORT'];
```

PHP has "superglobals" - built-in variables available everywhere:
- `$_SERVER` - Server and execution environment info
- `$_ENV` - Environment variables
- `$_GET` - HTTP GET parameters
- `$_POST` - HTTP POST data
- `$_REQUEST` - Combined GET, POST, and COOKIE data

**Comparison**: Python uses `os.environ`, Go uses `os.Getenv`, JavaScript uses `process.env`.

### Arrays

```php
$log_entry = [
    'Timestamp' => $timestamp,
    'Body' => $message,
];
```

PHP arrays are versatile:
- Indexed arrays: `$arr = [1, 2, 3]`
- Associative arrays: `$arr = ['key' => 'value']`
- Both use the same type (unlike most languages)

**Comparison**: Python has separate `list` and `dict`, JavaScript has `array` and `object`, Go has slices and maps.

### String Interpolation

```php
log_message("Received {$method} request for path: {$path}");
```

PHP supports multiple string interpolation styles:
- `"{$var}"` - Complex syntax with braces
- `"$var"` - Simple syntax without braces
- `'text ' . $var . ' more'` - Concatenation with `.`

**Comparison**: Python uses f-strings `f"{var}"`, JavaScript uses template literals `` `${var}` ``, Go uses `fmt.Sprintf`.

### Functions

```php
function log_message(string $message): void {
    echo create_log_entry($message) . PHP_EOL;
}
```

PHP functions:
- `function name(Params): ReturnType { body }`
- `: void` means returns nothing
- Parameters can have type hints
- `snake_case` naming convention (PascalCase for classes)

**Comparison**: Python uses `def func():`, Go uses `func func() ReturnType`, JavaScript uses `function func() {}` or `const func = () => {}`.

### HTTP Headers

```php
header('Content-Type: text/plain');
http_response_code(200);
```

PHP provides built-in HTTP functions:
- `header()` - Send raw HTTP header (must be called before output)
- `http_response_code()` - Set/get HTTP response code

**Warning**: `header()` must be called before any output (including whitespace before `<?php`).

### JSON

```php
$json = json_encode($log_entry, JSON_UNESCAPED_SLASHES);
$decoded = json_decode($json, true);
```

PHP has built-in JSON support:
- `json_encode()` - Convert to JSON string
- `json_decode()` - Parse JSON string (second param `true` for array)
- Flags like `JSON_UNESCAPED_SLASHES` control formatting

**Comparison**: Python uses `json.dumps()` and `json.loads()`, JavaScript uses `JSON.stringify()` and `JSON.parse()`.

### Constants

```php
echo "Message" . PHP_EOL;
```

PHP has predefined constants:
- `PHP_EOL` - End of line character (`\n` on Unix, `\r\n` on Windows)
- `__FILE__` - Current file path
- `__LINE__` - Current line number
- `__DIR__` - Directory of the current file

## File Information

| File | Description |
|------|-------------|
| `index.php` | Main application code with request handling and logging |

## Package Manager

**Composer** - PHP's dependency manager.

Initialize a new project:
```bash
composer init
```

Add dependencies:
```bash
composer require vendor/package
```

Install dependencies:
```bash
composer install
```

## Dependency File

**`composer.json`** - Defines project metadata and dependencies.

Example structure:
```json
{
    "name": "vendor/project",
    "require": {
        "monolog/monolog": "^3.0"
    }
}
```

This example uses only PHP built-in functions, so no `composer.json` is needed.

## Runtime and Packaging

**Using PHP's built-in server:**
```bash
php -S localhost:8086 index.php
```

**Using Apache + mod_php:**
- Place files in web root (e.g., `/var/www/html`)
- Access via web server (e.g., `http://localhost/`)

**Using PHP-FPM + nginx:**
- Configure nginx to pass PHP files to PHP-FPM
- More complex but better for production

**PHP's unique approach:**
- Scripts are interpreted on each request (no compilation step)
- Can be embedded directly in HTML
- Designed primarily for web requests (not standalone servers)

## Comparison with Other Languages

| Feature | PHP | Python | JavaScript | Go |
|---------|-----|--------|------------|-----|
| **Type System** | Dynamic (optional hints) | Dynamic | Dynamic | Static |
| **Execution** | Interpreted (opcache available) | Interpreted bytecode | Interpreted by V8 | Compiled to machine code |
| **Variable Syntax** | `$name` | `name = value` | `let/var/const name` | `var name Type` or `name :=` |
| **Entry Point** | Top of file or first `<?php` | Top of file or `if __name__` | Top of file | `func main()` |
| **String Interpolation** | `"{$var}"` or `"$var"` | `f"{var}"` | `` `${var}` `` | `fmt.Sprintf` |
| **Arrays** | Unified (indexed/associative) | Separate list/dict | Array/Object | Slice/Map |
| **HTTP Response** | `header()` then `echo` | Various frameworks | `res.send()` or `res.end()` | `http.ResponseWriter` |
| **Primary Use** | Web servers, CMS | General-purpose | Web, servers | General-purpose |

## PHP vs. Other Web Languages

**PHP's strengths:**
- Deployed everywhere (shared hosting, etc.)
- Easy to learn for beginners
- Designed specifically for the web
- Huge ecosystem (WordPress, Laravel, etc.)

**PHP's weaknesses:**
- Not designed for long-running processes
- Inconsistent naming in standard library
- Historically had security issues (improved in modern PHP)
- Less performant than compiled languages

**When to use PHP:**
- Building websites/web applications
- Content management systems
- Quick prototypes
- Deploying to shared hosting

**When NOT to use PHP:**
- CLI tools (use Python, Go, Bash)
- High-performance APIs (use Go, Rust, C#)
- Real-time applications (use Node.js, Go)
- Mobile apps (use Dart/Flutter, React Native)
