//
//  RunningApplication.swift
//
//
//  Created by Ben Gottlieb on 6/15/24.
//

import Foundation
import Cocoa

public struct RunningApplication: Codable, Hashable {
	let identifier: String
	let name: String
}

extension RunningApplication {
	init?(_ app: NSRunningApplication?) {
		guard let ident = app?.bundleIdentifier, let name = app?.localizedName else { return nil }
		identifier = ident
		self.name = name
	}
	
	static var frontmost: RunningApplication? {
		RunningApplication(NSWorkspace.shared.frontmostApplication)
	}
}
