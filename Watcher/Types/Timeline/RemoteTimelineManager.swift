//
//  RemoteTimelineManager.swift
//  Monitor
//
//  Created by Ben Gottlieb on 10/16/21.
//

import Foundation
import Nearby

class RemoteTimelineManager {
	static let instance = RemoteTimelineManager()
	
	var timelines: [String: RemoteTimeline] = [:]
	
	func timeline(for device: NearbyDevice) -> RemoteTimeline {
		let id = device.name
		if let timeline = timelines[id] {
			return timeline
		} else {
			let timeline = RemoteTimeline(deviceName: id)
			timelines[id] = timeline
			return timeline
		}
	}
	
	func setAvailableDays(_ days: [Date], for device: NearbyDevice) {
		
		timeline(for: device).setDates(days)
	}
	
	func setTimeline(_ entries: [Timeline.Entry], for device: NearbyDevice) {
		timeline(for: device).setTimeline(entries)
	}
}
