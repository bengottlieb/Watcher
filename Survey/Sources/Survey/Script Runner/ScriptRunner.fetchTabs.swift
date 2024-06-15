//
//  ScriptRunner.fetchTabs.swift
//
//
//  Created by Ben Gottlieb on 6/15/24.
//

import Foundation
import Cocoa

extension ScriptRunner {
	func fetchTabs(using script: AppleScript.TabFetcher) async throws -> [BrowserTabInformation] {
		
		guard NSRunningApplication.isRunning(browser: script.browser) else { return [] }
		do {
			let string = try await ScriptRunner.instance.fetchTabs(for: script)
			return try script.tabs(from: string)
		} catch {
			print("Failed to fetch Safari Tabs: \(error)")
			return []
		}

		
	}
}
