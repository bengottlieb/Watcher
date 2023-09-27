//
//  NSApplication.swift
//  LocalMonitor
//
//  Created by Ben Gottlieb on 10/24/22.
//

import Cocoa
import AppKit

extension NSApplication {
	@discardableResult public class func toggleDockIcon(showIcon: Bool) -> Bool {
		NSApp.setActivationPolicy(showIcon ? .regular : .accessory)
	}
	
	var appDelegate: AppDelegate {
		delegate as! AppDelegate
	}
}
