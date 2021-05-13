//
//  NearbyHost.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/13/21.
//

import Foundation
import Nearby

class NearbyHost: NearbyMonitor {
	var timeline: [TimelineManager.Entry] = []
	var currentTimelineEntry: TimelineManager.Entry? { timeline.last }
	
	func record(timelineEntry: TimelineManager.Entry?) {
		guard let entry = timelineEntry else { return }
		
		timeline.append(entry)
	}
}
