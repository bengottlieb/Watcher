//
//  BrowserMonitor.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/12/21.
//

import Foundation
import Cocoa
import Combine

class BrowserMonitor: NSObject {
	static let instance = BrowserMonitor()
	var initialState: BrowserState?
	var lastState: BrowserState?
	
	@MainActor var checkInterval: TimeInterval = 1 { didSet { setup() }}
	private weak var checkTimer: Timer?
	private var cancellables = Set<AnyCancellable>()
	
	@MainActor func setup() {
		checkTimer?.invalidate()
		checkTimer = Timer.scheduledTimer(withTimeInterval: checkInterval, repeats: true, block: { [weak self] _ in
			guard let self else { return }
			Task { await self.checkTabs() }
		})
		Task { await checkTabs() }
	}
	
	var currentState: BrowserState {
		get async throws {
			let start = Date()
			async let safariAll = try ScriptRunner.instance.fetchTabs(for: .safariAllTabs)
			async let chromeAll = try ScriptRunner.instance.fetchTabs(for: .chromeAllTabs)
			async let operaAll = try ScriptRunner.instance.fetchTabs(for: .operaAllVisibleTabs)

			async let safariVisible = try ScriptRunner.instance.fetchTabs(for: .safariAllVisibleTabs)
			async let chromeVisible = try ScriptRunner.instance.fetchTabs(for: .chromeAllVisibleTabs)
			async let operaVisible = try ScriptRunner.instance.fetchTabs(for: .operaAllVisibleTabs)

			let (all, visible) = (try await (safariAll + chromeAll + operaAll), try await safariVisible + chromeVisible + operaVisible)
		//	let visible = try await safariVisible// + chrome + opera
			print("Took \(abs(start.timeIntervalSinceNow)) sec")
			return BrowserState(all: all, visible: visible)
		}
	}
	
	@objc func checkTabs() async {
		do {
			let newState = try await currentState
			guard let lastState else {
				initialState = newState
				lastState = newState
				return
			}
			
			let diff = newState.diffs(since: lastState)
			if !diff.isEmpty {
				self.lastState = newState
				print(diff)
			}
		} catch {
			print("Tab fetching failed: \(error)")
		}
	}
	
//	var safariFrontTabs: [BrowserTabInformation] {
//		get async {
//			guard NSRunningApplication.isRunning(browser: .safari) else { return [] }
//			do {
//				let string = try await ScriptRunner.instance.fetchTabs(for: .safariAllVisibleTabs)
//				return try [BrowserTabInformation](currentSafariTabs: string)
//			} catch {
//				print("Failed to fetch Safari Tabs: \(error)")
//				return []
//			}
//		}
//	}
//
//	var chromeFrontTabs: [BrowserURL] {
//		get async {
//			guard NSRunningApplication.isRunning(browser: .chrome) else { return [] }
//			do {
//				let string = try await ScriptRunner.instance.fetchTabs(for: .chromeAllVisibleTabs)
//				return string.components(separatedBy: ",").compactMap { BrowserURL($0, .chrome) }
//			} catch {
//				return []
//			}
//		}
//	}
//
//	var operaFrontTabs: [BrowserURL] {
//		get async {
//			guard NSRunningApplication.isRunning(browser: .opera) else { return [] }
//			do {
//				let string = try await ScriptRunner.instance.fetchTabs(for: .operaAllVisibleTabs)
//				return string.components(separatedBy: ",").compactMap { BrowserURL($0, .safari) }
//			} catch {
//				return []
//			}
//		}
//	}
}

extension BrowserMonitor {
	func logScriptResults(_ scripts: [AppleScript.TabFetcher]) async {
//		let scripts: [AppleScript.TabFetcher] = [.chromeAllTabs, .chromeFrontmostTab, .chromeAllVisibleTabs, .chromeAllFrontWindowTabs]
		for script in scripts {
			do {
				print("SCRIPT: \(script.rawValue) \(script.script)")
				print(try await ScriptRunner.instance.fetchTabs(for: script))
				print("SCRIPT END -----------------------------")
				
			} catch {
				print("Failed to log \(script.title) \(error)")
			}
		}
	}
}
