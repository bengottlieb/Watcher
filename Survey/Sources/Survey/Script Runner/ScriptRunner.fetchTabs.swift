//
//  ScriptRunner.fetchTabs.swift
//
//
//  Created by Ben Gottlieb on 6/15/24.
//

import Foundation
import Cocoa

extension ScriptRunner {
	
	func fetchTabs(for script: AppleScript.TabFetcher) async throws -> BrowserTabCollection {
		let raw = try await run(command: script)
		return try script.tabs(from: raw)
	}
}
