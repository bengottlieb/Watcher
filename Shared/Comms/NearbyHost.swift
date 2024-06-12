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
		Suite.logg("\(self.isRefreshing ? "Currently" : "Finished") refreshing \(self.device?.name ?? "--")")
		self.objectWillChange.sendOnMain()
	}}
	
	var timeline: [Timeline.Entry] = []
	var currentTimelineEntry: Timeline.Entry? { timeline.last }
	var frontmostAppIdentifier: String? { currentTimelineEntry?.bundleIDs?.first }
	weak var reconnectTimer: Timer?
	var canRefresh: Bool { device != nil }
	
	override func deviceChanged() {
		if device?.state == .provisioned, reconnectTimer != nil {
			self.reconnectTimer?.invalidate()
			self.isRefreshing = false
		}
		super.deviceChanged()
	}
	
	func refresh() {
		guard let device = device, !isRefreshing else { return }
		
		isRefreshing = true
		
		if device.state == .provisioned {
			device.send(message: RequestStatusMessage()) {
				self.isRefreshing = false
			}
		} else {
			device.requestInfo()
			reconnectTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
				self.reconnectTimer = nil
				self.isRefreshing = false
			}
		}
	}
	
	func record(timelineEntry: Timeline.Entry?) {
		guard let entry = timelineEntry else { return }
		
		timeline.append(entry)
		lastUpdatedAt = Date()
		objectWillChange.sendOnMain()
	}
}
