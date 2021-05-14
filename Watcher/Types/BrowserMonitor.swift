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
		
		checkTimer = Timer.scheduledTimer(timeInterval: checkInterval, target: self, selector: #selector(checkTabs), userInfo: nil, repeats: true)
		checkTabs()
	}
	
	@objc func checkTabs() {
		Publishers.Merge(safariFrontTabs, chromeFrontTabs)
			.collect()
			.sink { tabs in
				Timeline.instance.logCurrent(urls: tabs.flatMap { $0 })
			}
			.store(in: &cancellables)
	}
	
	var safariFrontTabs: AnyPublisher<[BrowserURL], Never> {
		guard NSRunningApplication.isRunning(browser: .safari) else { return Just([]).eraseToAnyPublisher() }
		return ScriptRunner.instance.run(command: .safariAllCurrentTabs)
			.replaceError(with: "")
			.map { string in
        string.components(separatedBy: ",").compactMap { BrowserURL($0, .safari) }
			}
			.eraseToAnyPublisher()
	}

	var chromeFrontTabs: AnyPublisher<[BrowserURL], Never> {
		guard NSRunningApplication.isRunning(browser: .chrome) else { return Just([]).eraseToAnyPublisher() }
		return ScriptRunner.instance.run(command: .chromeAllCurrentTabs)
			.replaceError(with: "")
			.map { string in
				string.components(separatedBy: ",").compactMap { BrowserURL($0, .chrome) }
			}
			.eraseToAnyPublisher()
	}
}
