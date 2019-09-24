// Provides path to executable with the following interface:
// `<executable> <local-file> <remote-name>`
// where
// <executable> is what is returned by the provider
// <local-file> is an absolute path to a local file
// <remote-name> is a path-like string that will be present in the URL.
//
// The idea is to make an abstraction of internal services in CI infrastructure.
// This code was translated from bash. Ideally we do not want to operate executables,
// everything should be written in Swift.
//
public protocol FileUploaderExecutableProvider {
    func fileUploaderExecutable() throws -> String
}
