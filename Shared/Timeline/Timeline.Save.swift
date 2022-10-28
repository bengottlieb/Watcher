//
//  TimelineManager.Save.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/13/21.
//

import Foundation
import Suite

extension Timeline {
	static var sample: [Timeline.Entry] {
		(try? .load(from: Bundle.main.url(forResource: "sample_log", withExtension: "txt"))) ?? []
	}
	var saveURL: URL {
		let dateString = Date().localTimeString(date: .abbr, time: .none).replacingOccurrences(of: "/", with: "-")
		let filename = dateString + ".txt"
		
		return Constants.timelineDirectory.appendingPathComponent(filename)
	}
	
	func load() {
		do {
			timeline = try .load(from: saveURL)
		} catch {
			logg(error: error, "Problem loading timeline")
		}
	}
	
	@objc func save() {
		print("Saving at \(Date())")
		let url = saveURL
		try? FileManager.default.removeItem(at: url)
		
		do {
			let json = try JSONEncoder().encode(timeline)
			try json.write(to: url)
		} catch {
			logg(error: error, "Problem saving timeline")
		}
		
		if url != lastSaveURL {
			lastSaveURL = url
			timeline = []
		}
	}
}
