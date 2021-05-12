//
//  TimelineManager.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/12/21.
//

import Foundation

class TimelineManager {
	static let instance = TimelineManager()
	
	private let queue = DispatchQueue(label: "timeline", qos: .userInitiated)
	var timeline: [TimelineEntry] = []
	
	func switched(to applicationBundleID: String?) {
		guard let id = applicationBundleID else { return }
		addEntry(TimelineEntry(for: id))
	}
	
	func logCurrent(urls: [URL]) {
		addEntry(TimelineEntry(with: urls))
	}
	
	func addEntry(_ entry: TimelineEntry) {
		queue.async {
			if self.timeline.last == entry { return }
			
			self.timeline.append(entry)
			print(entry)
		}
	}
	
	var currentEntry: TimelineEntry? {
		guard timeline.isNotEmpty else { return nil }
		
		var result = TimelineEntry()
		
		for entry in timeline.reversed() {
			if result.bundleIDs == nil {
				result.bundleIDs = entry.bundleIDs
			}
			
			if result.tabURLs == nil {
				result.tabURLs = entry.tabURLs
			}
			
			if result.tabURLs != nil, result.bundleIDs != nil { break }
		}
		
		return result
	}
	
}

extension TimelineManager {
	struct TimelineEntry: Codable, Equatable, CustomStringConvertible {
		var date = Date()
		var bundleIDs: [String]?
		var tabURLs: [URL]?
		
		var description: String {
			if let id = bundleIDs?.first { return id }
			if let urls = tabURLs { return urls.compactMap { $0.host }.joined(separator: ", ") }
			return "no data"
		}

		init(for applicationBundleID: String) {
			bundleIDs = [applicationBundleID]
		}
		
		init(with urls: [URL]) {
			tabURLs = urls.sorted { $0.absoluteString < $1.absoluteString }
		}
		
		init() {
			
		}
		
		static func ==(lhs: TimelineEntry, rhs: TimelineEntry) -> Bool {
			lhs.bundleIDs == rhs.bundleIDs && lhs.tabURLs == rhs.tabURLs
		}
	}
}
