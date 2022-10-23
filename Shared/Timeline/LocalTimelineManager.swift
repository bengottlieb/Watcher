//
//  LocalTimelineManager.swift
//  Watcher
//
//  Created by Ben Gottlieb on 10/23/22.
//

import Foundation

class LocalTimelineManager: ObservableObject {
	static let instance = RemoteTimelineManager()

	var today: [Timeline.Entry] = []
	
	init() {
		updateToday()
	}
	
	func updateToday() {
		today = Timeline.instance.timeline(for: Date())
	}
}
