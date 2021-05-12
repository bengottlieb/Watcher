//
//  ScriptRunner.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/10/21.
//

import Foundation
import Combine

class ScriptRunner {	
	static let instance = ScriptRunner()
	enum ScriptError: Error { case noOSAScriptFound, unableToDecodeString }
	
	var cancellables = Set<AnyCancellable>()
	init() {
		Process.which("osascript")
			.sink { completion in
				switch completion {
				case .failure(let err):
					print(err)
				default: break
				}
			} receiveValue: { path in
				print("Found osascript: \(path)")
				self.osascriptPath.send(path)
			}
			.store(in: &cancellables)
	}
	
	func setup() {
		
	}
	var osascriptPath = CurrentValueSubject<String, Never>("")
	
	func runForData(script: String) -> AnyPublisher<Data, Error> {
		guard osascriptPath.value != "" else { return Fail(outputType: Data.self, failure: ScriptError.noOSAScriptFound).eraseToAnyPublisher() }
		
		return Process(path: osascriptPath.value, arguments: ["-e", "\(script)"])
			.publisher()
			.eraseToAnyPublisher()
	}
	
	func run(script: String) -> AnyPublisher<String, Error> {
		runForData(script: script)
			.tryMap { data in
				if let string = String(data: data, encoding: .utf8) { return string }
				throw ScriptError.unableToDecodeString
			}
			.eraseToAnyPublisher()
	}
	
	func run(command: Command) -> AnyPublisher<String, Error> { run(script: command.script) }
}
