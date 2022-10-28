//
//  MenuItem.swift
//  LocalMonitor
//
//  Created by Ben Gottlieb on 10/23/22.
//

import Foundation
import Cocoa
import Combine
import Suite

class MenuItem: NSObject {
	static let instance = MenuItem()
	let statusItem = NSStatusBar.system.statusItem(withLength: 90)
	var updateTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
		MenuItem.instance.updateMenuAsync()
	}
	var menu: NSMenu {
		let menu = NSMenu(title: "")
		
		let items = [
			NSMenuItem(title: "Current Times…", action: #selector(showCurrentTimes), keyEquivalent: "")
		]
		
		items.forEach { item in
			item.target = self
			menu.addItem(item)
		}
		
		return menu
	}
	
	var settingsCancellable: AnyCancellable?
	
	override init() {
		super.init()
		settingsCancellable = Settings.instance.objectWillChange.sink { _ in
			self.updateMenuAsync()
		}

		settingsCancellable = Timeline.instance.objectWillChange.sink { _ in
			self.updateMenuAsync()
		}
	}
	
	func updateMenuAsync() {
		Task {
			await MainActor.run { self.updateMenuItem() }
		}
	}
	
	@MainActor func updateMenuItem() {
		let timeline = Timeline.instance.timeline(for: Date())
		if let id = Settings.instance.menuBarIdentifier {
			if let time = timeline.summary.time(for: id) {
				statusItem.button?.title = time.durationString(style: .minutes, showLeadingZero: true, roundUp: true)
			}
		} else {
			if let current = timeline.last?.displayTitle {
				statusItem.button?.title = current
				print("Switched to \(current)")
			}
		}
	}
	
	func setup() {
		statusItem.button?.image = NSImage(named: "watch")
		statusItem.menu = menu
		updateMenuAsync()
	}
	
	@objc func showCurrentTimes(_ sender: Any?) {
		NSApp.appDelegate.showSummary()
	}
}
