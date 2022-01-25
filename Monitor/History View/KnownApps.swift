//
//  KnownApps.swift
//  Monitor
//
//  Created by Ben Gottlieb on 1/24/22.
//

import Foundation

struct KnownApps {
	static let loginWindow = "com.apple.loginwindow"
}

extension Timeline.Entry {
	var isLoginWindow: Bool {
		bundleIDs?.contains(KnownApps.loginWindow) ?? false
	}
}
