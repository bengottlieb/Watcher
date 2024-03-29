//
//  ScriptRunner.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/10/21.
//

import Foundation
import Combine
import Suite

class ScriptRunner {	
	static let instance = ScriptRunner()
	enum ScriptError: Error { case noOSAScriptFound, unableToDecodeString }
	
	var cancellables = Set<AnyCancellable>()
	init() {
	}
	
	func loadOSAScript() async throws -> String {
		if let osascriptPath { return osascriptPath }
		do {
			let path = try await Process.which("osascript")

			Suite.logg("Found OSAScript: \(path)")
			self.osascriptPath = path
			return path
		} catch {
			throw ScriptError.noOSAScriptFound
		}
	}
	
	func setup() {
		
	}
	var osascriptPath: String?
	
	func runForData(script: String) async throws -> Data {
		try await Process(path: loadOSAScript(), arguments: ["-e", "\(script)"]).run()
	}
	
	func run(script: String) async throws -> String {
		let data = try await runForData(script: script)
		if let string = String(data: data, encoding: .utf8) { return string }
		throw ScriptError.unableToDecodeString
	}
	
	func run(command: Command) async throws -> String { try await run(script: command.script) }
}
