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
	var timelinesRootDirectory = URL.cache(named: "timelines")
	let saveQueue = DispatchQueue(label: "RemoteTimelineManager")
	
	func url(for device: NearbyDevice, date: Date? = nil) -> URL {
		var url = timelinesRootDirectory.appendingPathComponent(device.filename)
			
		if let date = date {
			let dateLabel = date.ymdString
			url = url.appendingPathComponent(dateLabel).appendingPathExtension("json")
		}
		
		try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
		return url
	}
	
	var timelines: [String: RemoteTimeline] = [:]
	
	func timeline(for device: NearbyDevice) -> RemoteTimeline {
		let id = device.name
		if let timeline = timelines[id] {
			return timeline
		} else {
			let timeline = RemoteTimeline(device: device)
			timelines[id] = timeline
			return timeline
		}
	}
	
	func setAvailableDays(_ days: [Date], for device: NearbyDevice) {
		timeline(for: device).setDates(days)
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
					print("Failed to save timeline entries: \(error)")
				}
			}
		}
		timeline(for: device).setTimeline(entries)
	}
}

extension Date {
	static let formatter = DateFormatter(format: "yyyy-MM-DD")
	
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
