//
//  ApplicationMonitor.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/12/21.
//

import Foundation
import Cocoa

class ApplicationMonitor: NSObject {
	static let instance = ApplicationMonitor()
	
	// NSWorkspace.shared.frontmostApplication?.localizedName
	func setup() {
		NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(didActivateApplication), name: NSWorkspace.didActivateApplicationNotification, object: nil)
		NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(didLaunchApplication), name: NSWorkspace.didLaunchApplicationNotification, object: nil)
		NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(didWake), name: NSWorkspace.didWakeNotification, object: nil)
		NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(willSleep), name: NSWorkspace.willSleepNotification, object: nil)
		NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(willPowerOff), name: NSWorkspace.willPowerOffNotification, object: nil)
	}
	
	func process(application: NSRunningApplication?) {
		//Timeline.instance.switched(to: application?.bundleIdentifier)
	}
	
	@objc func didActivateApplication(_ note: Notification) {
		process(application: note.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication)
	}
	
	@objc func didLaunchApplication(_ note: Notification) {
		process(application: note.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication)
	}
	
	@objc func didWake(_ note: Notification) {
    //Timeline.instance.record(special: .wake)
	}
	
	@objc func willSleep(_ note: Notification) {
    //Timeline.instance.record(special: .sleep)
	}
	
	@objc func willPowerOff(_ note: Notification) {
    //Timeline.instance.record(special: .powerOff)
	}

	
}
