//
//  NearbyHost.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/13/21.
//

import Foundation
import Nearby
import Suite

class NearbyHost: NearbyMonitor {
	var isRefreshing = false { didSet {
		if isRefreshing == oldValue { return }
		Suite.logg("\(isRefreshing ? "Currently" : "Finished") refreshing \(device?.name ?? "--")")
		self.objectWillChange.sendOnMain()
	}}
	
	var timeline: [Timeline.Entry] = []
	var currentTimelineEntry: Timeline.Entry? { timeline.last }
	var frontmostAppIdentifier: String? { currentTimelineEntry?.bundleIDs?.first }
	
	func refresh() {
		guard let device = device, !isRefreshing else { return }
		
		isRefreshing = true
		
		device.send(message: RequestStatusMessage()) {
			self.isRefreshing = false
		}
	}
	
	func record(timelineEntry: Timeline.Entry?) {
		guard let entry = timelineEntry else { return }
		
		timeline.append(entry)
		lastUpdatedAt = Date()
		objectWillChange.sendOnMain()
	}
}
