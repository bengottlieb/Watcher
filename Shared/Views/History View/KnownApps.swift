//
//  KnownApps.swift
//  Monitor
//
//  Created by Ben Gottlieb on 1/24/22.
//

import Foundation

struct KnownApps {
	static let loginWindow = "com.apple.loginwindow"
	static let messages = "com.apple.MobileSMS"
	static let safari = "com.apple.safari"
	static let notificationCenter = "com.apple.UserNotificationCenter"
}

extension Timeline.Entry {
	var isLoginWindow: Bool {
		bundleIDs?.contains(KnownApps.loginWindow) ?? false
	}
}
