import XCTest
import class Foundation.Bundle

import MyFiniteAutomatas
import FiniteAutomata

@available(macOS 10.13, *)
final class proj1Tests: XCTestCase {
    func testAstarC2Bstar() throws {
        runProcess(automata: AstarC2Bstar.self, testValidClosure: { (res, arg1) in
            let (input, states) = arg1
            XCTAssertNil(res.asFailure)
            XCTAssertTrue(res.isSuccess)
            let out = res.asSuccess?.description ?? "nil"
            let expected = states.joined(separator: "\n") + "\n"
            let outDesc = out.replacingOccurrences(of: "\n", with: "\\n")
            let expDesc = expected.replacingOccurrences(of: "\n", with: "\\n")
            XCTAssertEqual(out, expected)
            XCTAssertEqual(outDesc, expDesc, "Output '\(outDesc)' for input string '\(input)' is not equal to expected '\(expDesc)'")
        }, testInvalidClosure: { (res, input) in
            XCTAssertNil(res.asSuccess)
            XCTAssertTrue(res.isFailure)
            XCTAssertEqual(res.asFailure?.type, .notAccepted)
        })
    }

    func testCIdentifierAutomata() throws {
        runProcess(automata: CIdentifierAutomata.self, testValidClosure: { (res, arg1) in
            let (input, states) = arg1
            XCTAssertNil(res.asFailure)
            XCTAssertTrue(res.isSuccess)
            let out = res.asSuccess?.description ?? "nil"
            let expected = states.joined(separator: "\n") + "\n"
            let outDesc = out.replacingOccurrences(of: "\n", with: "\\n")
            let expDesc = expected.replacingOccurrences(of: "\n", with: "\\n")
            XCTAssertEqual(out, expected)
            XCTAssertEqual(outDesc, expDesc, "Output '\(outDesc)' for input string '\(input)' is not equal to expected '\(expDesc)'")
        }, testInvalidClosure: { (res, input) in
            XCTAssertNil(res.asSuccess)
            XCTAssertTrue(res.isFailure)
            XCTAssertEqual(res.asFailure?.type, .notAccepted)
        })
    }

    static var allTests = [
        ("testAstarC2Bstar", testAstarC2Bstar),
        ("testCIdentifierAutomata", testCIdentifierAutomata),
    ]
}

// MARK: - Run process
@available(OSX 10.13, *)
extension proj1Tests {
    /// Structure used to describe process errors
    struct ProcessError: Error {
        let type: ProcessErrorType
        let stderr: String?

        init(_ type: ProcessErrorType, stderr: String? = nil) {
            self.type = type
            self.stderr = stderr
        }

        enum ProcessErrorType: Error {
            case runError
            case invalidOutputEncoding
            case unknownError
            case notAccepted
        }
    }

    /// Closure with tests for failing process
    /// - Parameters:
    ///   - processResult: Result from process
    typealias FailingProcessTests = (_ processResult: Result<String, ProcessError>) -> Void

    /// Run process with given automata, intput and closure with process result
    /// - Parameters:
    ///   - automata: Automata description
    ///   - input: Input string
    ///   - testClosure: closure with tests
    func runFailingProcess<T>(automata: T.Type, input: String = "", testClosure: FailingProcessTests) where T: MyStringConvertibleAutomata {
        let process = Process()
        let fooBinary = productsDirectory.appendingPathComponent("proj1")
        process.executableURL = fooBinary
        process.currentDirectoryURL = productsDirectory

        let url = createFile(content: T.description.description, dir: productsDirectory)
        defer { removeFile(url: url) }

        let args = [input, url.lastPathComponent]
        let runResult = runProcess(arguments: args)
        testClosure(runResult)
    }

    /// Closure for tests with valid input
    /// - Parameters:
    ///   - processResult: Result from process
    ///   - valid: Valid input and expected states
    typealias ValidInputTests = (_ processResult: Result<String, ProcessError>, _ valid: (String, [String])) -> Void

    /// Closure for tests with invalid input
    /// - Parameters:
    ///   - processResult: Result from process
    ///   - invalidInput: Invalid input string
    typealias InvalidInputTests = (_ processResult: Result<String, ProcessError>, _ invalidInput: String) -> Void

    /// Run process with given automata
    /// - Parameters:
    ///   - automata: Automata description
    ///   - testValidClosure: Test closure to test valid inputs
    ///   - testInvalidClosure: Test closure to test invalid inputs
    func runProcess<T>(automata: T.Type, testValidClosure: ValidInputTests, testInvalidClosure: InvalidInputTests) where T: MyStringConvertibleAutomata & MyAutomataInputs {
        print(automata)
        print(productsDirectory.absoluteString)
        let process = Process()
        let fooBinary = productsDirectory.appendingPathComponent("proj1")
        process.executableURL = fooBinary
        process.currentDirectoryURL = productsDirectory

        let url = createFile(content: T.description.description, dir: productsDirectory)
        defer { removeFile(url: url) }

        T.valid.forEach { input, states in
            let args = [input, url.lastPathComponent]
            let runResult = runProcess(arguments: args)
            testValidClosure(runResult, (input, states))
        }

        T.invalid.forEach { input in
            let args = [input, url.lastPathComponent]
            let runResult = runProcess(arguments: args)
            testInvalidClosure(runResult, input)
        }
    }

    /// Run process with given arguments
    /// - Parameter arguments: Process arguments
    func runProcess(arguments: [String]) -> Result<String, ProcessError> {
        let process = Process()
        let fooBinary = productsDirectory.appendingPathComponent("proj1")
        process.executableURL = fooBinary
        process.currentDirectoryURL = productsDirectory

        let pipe = Pipe()
        process.standardOutput = pipe
        let stderrPipe = Pipe()
        process.standardError = stderrPipe
        process.arguments = arguments
        do {
            try process.run()
        } catch {
            return .failure(.init(.runError))
        }
        process.waitUntilExit()
        let code = process.terminationStatus
        switch code {
        case 0:
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            guard let output = String(data: data, encoding: .utf8) else {
                return .failure(.init(.invalidOutputEncoding))
            }
            return .success(output)
        case 6:
            return .failure(.init(.notAccepted))
        default:
            let data = stderrPipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: data, encoding: .utf8)
            return .failure(.init(.unknownError, stderr: output))
        }
    }
}

// MARK: - File handling

@available(OSX 10.13, *)
extension proj1Tests {
    func createFile(content: String, dir: URL) -> URL {
        let fileName = UUID().uuidString
        let fileURL = dir.appendingPathComponent(fileName)
        try! content.write(to: fileURL, atomically: true, encoding: .utf8)
        return fileURL
    }

    func removeFile(url: URL) {
        try? FileManager.default.removeItem(at: url)
    }

    /// Returns path to the built products directory.
    var productsDirectory: URL {
      #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
      #else
        return Bundle.main.bundleURL
      #endif
    }
}


// MARK: - Result extensions
extension Result {
    var asFailure: Failure? {
        switch self {
        case .failure(let err):
            return err
        case .success:
            return nil
        }
    }
    var asSuccess: Success? {
        switch self {
        case .failure:
            return nil
        case .success(let s):
            return s
        }
    }

    var isSuccess: Bool {
        return asFailure == nil
    }
    var isFailure: Bool {
        return !isSuccess
    }
}
