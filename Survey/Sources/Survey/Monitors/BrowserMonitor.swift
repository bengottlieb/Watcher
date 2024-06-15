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
		async let safari = safariFrontTabs
		async let chrome = chromeFrontTabs
		async let opera = operaFrontTabs
		
		let tabs = await safari// + chrome + opera
		//print(tabs)
		//Timeline.instance.logCurrent(urls: tabs.compactMap { $0 })
	}
	
	var safariFrontTabs: [BrowserTabInformation] {
		get async {
			guard NSRunningApplication.isRunning(browser: .safari) else { return [] }
			do {
				let string = try await ScriptRunner.instance.run(command: .safariAllCurrentTabs)
				return try [BrowserTabInformation](currentSafariTabs: string)
			} catch {
				print("Failed to fetch Safari Tabs: \(error)")
				return []
			}
		}
	}

	var chromeFrontTabs: [BrowserURL] {
		get async {
			let scripts: [ScriptRunner.Command] = [.chromeAllTabs, .chromeCurrentTab, .chromeAllCurrentTabs, .chromeAllFrontWindowTabs]
			for script in scripts {
				print("SCRIPT: \(script.rawValue) \(script.script)")
				print(try! await ScriptRunner.instance.run(command: .safariAllCurrentTabs))
				print("SCRIPT END -----------------------------")
			}
			

			guard NSRunningApplication.isRunning(browser: .chrome) else { return [] }
			do {
				let string = try await ScriptRunner.instance.run(command: .chromeAllCurrentTabs)
				return string.components(separatedBy: ",").compactMap { BrowserURL($0, .chrome) }
			} catch {
				return []
			}
		}
	}

	var operaFrontTabs: [BrowserURL] {
		get async {
			guard NSRunningApplication.isRunning(browser: .opera) else { return [] }
			do {
				let string = try await ScriptRunner.instance.run(command: .operaAllCurrentTabs)
				return string.components(separatedBy: ",").compactMap { BrowserURL($0, .safari) }
			} catch {
				return []
			}
		}
	}
}
