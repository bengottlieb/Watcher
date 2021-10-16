//
//  RemoteTimeline.swift
//  Watcher
//
//  Created by Ben Gottlieb on 10/16/21.
//

import Foundation

class RemoteTimeline: ObservableObject {
	let deviceName: String
	
	var dates: [Date] = []
	var entries: [Date: [Timeline.Entry]] = [:]
	
	init(deviceName: String) {
		self.deviceName = deviceName
	}
	
	func setDates(_ dates: [Date]) {
		objectWillChange.send()
		self.dates = dates
	}
	
	func setTimeline(_ timeline: [Timeline.Entry]) {
		guard let date = timeline.first?.date.noon else { return }
		
		objectWillChange.send()
		entries[date] = timeline
	}
}
