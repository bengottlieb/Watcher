//
//  RemoteTimeline.swift
//  Watcher
//
//  Created by Ben Gottlieb on 10/16/21.
//

import Foundation
import Nearby

class RemoteTimeline: ObservableObject {
	let device: NearbyDevice
	
	var dates: [Date] = []
	var entries: [Date: [Timeline.Entry]] = [:]
	
	init(device: NearbyDevice) {
		self.device = device
	}
	
	func timeline(for date: Date) -> [Timeline.Entry] {
		entries[date.noon] ?? []
	}
	
	func refresh(_ date: Date, noMatterWhat: Bool = false) {
		if !noMatterWhat, entries[date.noon] != nil { return }
		device.send(message: RequestDayMessage(date))
	}
	
	func refreshDates() {
		device.send(message: RequestAvailableDaysMessage())
	}
	
	func setDates(_ dates: [Date]) {
		objectWillChange.sendOnMain()
		self.dates = dates
	}
	
	func setTimeline(_ timeline: [Timeline.Entry]) {
		guard let date = timeline.first?.date.noon else { return }
		
		objectWillChange.sendOnMain()
		entries[date] = timeline.cleanup()
	}
}
