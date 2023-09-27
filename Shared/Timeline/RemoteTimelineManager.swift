//
//  RemoteTimelineManager.swift
//  Monitor
//
//  Created by Ben Gottlieb on 10/16/21.
//

import Foundation
import Nearby
import Suite

class RemoteTimelineManager {
	static let instance = RemoteTimelineManager()
	var timelinesRootDirectory = URL.cache(named: "timelines")
	let saveQueue = DispatchQueue(label: "RemoteTimelineManager")

	func url(for deviceID: String) -> URL {
		timelinesRootDirectory.appendingPathComponent(deviceID.idBasedFilename)
	}
	
	func url(for device: NearbyDevice, date: Date? = nil) -> URL {
		var url = url(for: device.uniqueID)
			
		if let date = date {
			let dateLabel = date.ymdString
			url = url.appendingPathComponent(dateLabel).appendingPathExtension("json")
		}
		
		try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
		return url
	}
	
	var timelines: [String: RemoteTimeline] = [:]
	
	func timeline(for id: String) -> RemoteTimeline {
		if let timeline = timelines[id] {
			return timeline
		} else {
			let timeline = RemoteTimeline(deviceID: id)
			timelines[id] = timeline
			return timeline
		}
	}
	
	func timeline(for device: NearbyDevice) -> RemoteTimeline {
		let id = device.uniqueID
		if let timeline = timelines[id] {
			return timeline
		} else {
			let timeline = RemoteTimeline(device: device)
			timelines[id] = timeline
			return timeline
		}
	}
	
	func setAvailableDays(_ days: [Date], for device: NearbyDevice) {
		let timeline = timeline(for: device)
		timeline.setDates(days)
	}
	
	func setTimeline(_ entries: [Timeline.Entry], for device: NearbyDevice) {
		if let date = entries.first?.date {
			saveQueue.async {
				do {
					let data = try JSONEncoder().encode(entries)
					let url = self.url(for: device, date: date)
					try FileManager.default.removeItem(at: url)
					try data.write(to: url)
				} catch {
					logg("Failed to save timeline entries: \(error)")
				}
			}
		}
		timeline(for: device).setTimeline(entries)
	}
}

extension Date {
	static let formatter = DateFormatter(format: "yyyy-MM-dd")
	
	var ymdString: String {
		Self.formatter.string(from: self)
	}
	
	init?(ymdString: String) {
		if let date = Self.formatter.date(from: ymdString) {
			self = date
		} else {
			return nil
		}
	}
}
