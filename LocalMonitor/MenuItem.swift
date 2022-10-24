//
//  MenuItem.swift
//  LocalMonitor
//
//  Created by Ben Gottlieb on 10/23/22.
//

import Foundation
import Cocoa

class MenuItem: NSObject {
	static let instance = MenuItem()
	let statusItem = NSStatusBar.system.statusItem(withLength: 30)
	
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
	
	func setup() {
		statusItem.button?.image = NSImage(named: "watch")
		statusItem.menu = menu
	}
	
	@objc func showCurrentTimes(_ sender: Any?) {
		NSApp.appDelegate.showSummary()
	}
}
