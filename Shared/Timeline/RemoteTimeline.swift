//
//  RemoteTimeline.swift
//  Watcher
//
//  Created by Ben Gottlieb on 10/16/21.
//

import Foundation
import Nearby
import Suite

class RemoteTimeline: ObservableObject {
	var device: NearbyDevice?
	
	var dates: [Date] = []
	var entries: [Date: [Timeline.Entry]] = [:]
	let cacheURL: URL
	
	enum State: String { case idle, requestingToday, requestingAvailable, requestingDate
		var title: String {
			rawValue
		}
	}
	
	@Published var state = State.idle
	
	init(deviceID: String) {
		cacheURL = RemoteTimelineManager.instance.url(for: deviceID)
		loadCache()
	}
	
	init(device: NearbyDevice) {
		self.device = device
		cacheURL = RemoteTimelineManager.instance.url(for: device)
		
		loadCache()
	}
	
	func loadCache() {
		objectWillChange.send()
		let fileURLs = (try? FileManager.default.contentsOfDirectory(at: cacheURL, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])) ?? []
		
		for url in fileURLs {
			guard let data = try? Data(contentsOf: url) else { continue }
			do {
				let timeline = try [Timeline.Entry].loadJSON(data: data)
				guard let date = timeline.first?.date.noon else { continue }
			
				entries[date] = timeline.cleanup()
				if !dates.contains(day: date) {
					dates.append(date)
					dates.sort()
				}
			} catch {
				logg("Failed to construct timeline: \(error)")
			}
		}
	}
	
	func timeline(for date: Date) -> [Timeline.Entry] {
		entries[date.noon] ?? []
	}
	
	@MainActor func refresh(_ date: Date, noMatterWhat: Bool = false) {
		state = .requestingDate
		if !noMatterWhat, entries[date.noon] != nil { return }
		device?.send(message: RequestDayMessage(date))
	}
	
	@MainActor func refreshDates() {
		state = .requestingAvailable
		device?.send(message: RequestAvailableDaysMessage())
	}
	
	func setDates(_ dates: [Date]) {
		objectWillChange.sendOnMain()
		self.dates = dates.sorted().reversed()
	}
	
	func setTimeline(_ timeline: [Timeline.Entry]) {
		guard let date = timeline.first?.date.noon else { return }
		
		objectWillChange.sendOnMain()
		entries[date] = timeline.cleanup()
	}
}
