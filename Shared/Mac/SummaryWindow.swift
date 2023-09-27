//
//  SummaryWindow.swift
//  LocalMonitor
//
//  Created by Ben Gottlieb on 10/24/22.
//

import Cocoa
import SwiftUI
import Suite

class SummaryWindowController: NSWindowController, NSWindowDelegate {
	static var windows: [SummaryWindowController] = []
	
	var date: Date = Date()
	
	convenience init(date: Date) {
		self.init(windowNibName: "SummaryWindow")
		
		self.date = date
		Self.windows.append(self)
		
//		addAsObserver(of: NSWindowDidChangeOcclusionStateNotification, selector: #selector(didChangeOcclusionState), object: window)
	}
	
	func windowDidBecomeKey(_ notification: Notification) {
		Notifications.requestReload.notify()
	}
	
	
	override func windowDidLoad() {
		super.windowDidLoad()
		self.window?.contentViewController = NSHostingController(rootView: SummaryScreen(date: date).padding())
	}
}
