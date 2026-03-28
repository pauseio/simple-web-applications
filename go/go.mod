// go.mod is the Go module definition file
// It declares the module path and lists all dependencies required by the project

// Module name: this uniquely identifies our Go module
// It follows the convention of repository/path format
module jumpbox-training/go

// Go version specifies the minimum version of Go required to build this module
// Go 1.21 includes many modern language features while maintaining broad compatibility
go 1.21

// Dependencies are listed below with their exact versions
// Each require statement specifies a package path and version
// Go uses semantic versioning (major.minor.patch)

require github.com/google/uuid v1.6.0
