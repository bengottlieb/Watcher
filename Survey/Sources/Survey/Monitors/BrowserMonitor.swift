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
	
	var checkInterval: TimeInterval = 5 { didSet { setup() }}
	private weak var checkTimer: Timer?
	private var cancellables = Set<AnyCancellable>()
	
	func setup() {
		checkTimer?.invalidate()
		checkTimer = Timer.scheduledTimer(withTimeInterval: checkInterval, repeats: true, block: { [weak self] _ in
			guard let self else { return }
			Task { await self.checkTabs() }
		})
		Task { await checkTabs() }
	}
	
	@objc func checkTabs() async {
		do {
			async let safari = try ScriptRunner.instance.fetchTabs(for: .safariAllTabs)
			async let chrome = try ScriptRunner.instance.fetchTabs(for: .chromeAllTabs)
			async let opera = try ScriptRunner.instance.fetchTabs(for: .operaAllVisibleTabs)
			
			await logScriptResults([.safariAllFrontWindowTabs])
			
			let tabs = try await safari// + chrome + opera
			//		print(tabs)
			//Timeline.instance.logCurrent(urls: tabs.compactMap { $0 })
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
