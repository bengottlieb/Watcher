//
//  NearbyHost.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/13/21.
//

import Foundation
import Nearby

class NearbyHost: NearbyMonitor {
	var timeline: [Timeline.Entry] = []
	var currentTimelineEntry: Timeline.Entry? { timeline.last }
	
	func record(timelineEntry: Timeline.Entry?) {
		guard let entry = timelineEntry else { return }
		
		timeline.append(entry)
    lastUpdatedAt = Date()
    objectWillChange.sendOnMain()
	}
}
