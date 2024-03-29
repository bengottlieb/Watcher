//
//  Constants.swift
//  Watcher
//
//  Created by Ben Gottlieb on 10/22/22.
//

import Foundation

struct Constants {
	static var isObserving: Bool { Bundle.main.infoDictionary?["IS_OBSERVING"] as? Bool ?? false }
	
	static var timelineDirectory: URL = FileManager.documentsDirectory.appendingPathComponent(".timelines")
	
	static var ignoredIdentifiers: [String] = [
		"com.apple.UserNotificationCenter",
		"com.apple.loginwindow",
	]
}
