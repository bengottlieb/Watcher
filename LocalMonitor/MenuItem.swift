//
//  MenuItem.swift
//  LocalMonitor
//
//  Created by Ben Gottlieb on 10/23/22.
//

import Foundation
import Cocoa

class MenuItem {
	static let instance = MenuItem()
	let statusItem = NSStatusBar.system.statusItem(withLength: 30)
	
	func setup() {
		statusItem.button?.title = "Item"
	}
}
