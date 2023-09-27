//
//  Notifications.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/13/21.
//

import Foundation

struct Notifications {
	static let willTerminate = Notification.Name("Notifications.willTerminate")
	static let requestReload = Notification.Name("Timeline.requestReload")
}
