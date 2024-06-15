//
//  Surveyor.swift
//  Survey
//
//  Created by Ben Gottlieb on 6/13/24.
//

import Foundation

public actor Surveyor {
	public static let instance = Surveyor()
	
	public func setup() {
		ScriptRunner.instance.setup()
		ApplicationMonitor.instance.setup()
		BrowserMonitor.instance.setup()
	}

	nonisolated public func updateBrowserTabs() {
		
	}
}
