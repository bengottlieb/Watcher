//
//  SummaryWindow.swift
//  LocalMonitor
//
//  Created by Ben Gottlieb on 10/24/22.
//

import Cocoa
import SwiftUI

class SummaryWindowController: NSWindowController {
	static var windows: [SummaryWindowController] = []
	
	var date: Date = Date()
	
	convenience init(date: Date) {
		self.init(windowNibName: "SummaryWindow")
		
		self.date = date
		Self.windows.append(self)
	}
	
	
	override func windowDidLoad() {
		super.windowDidLoad()
		self.window?.contentViewController = NSHostingController(rootView: SummaryScreen(date: date))
	}
}
