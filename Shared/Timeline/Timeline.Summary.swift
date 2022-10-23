//
//  Timeline.Summary.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/12/21.
//

import Foundation

extension Timeline {
	struct Summary: Codable, Identifiable {
		var id: String { identifier }
		
		let identifier: String
		var totalTime: TimeInterval = 0
		var title: String?
		let isWebsite: Bool
		
		var displayTitle: String { title ?? identifier }
	}
}

extension Timeline.Entry {
	var summaryIdentifier: String? {
		if isTabEntry, let url = tabURLs?.first {
			return url.host
		}
		
		if isAppEntry { return bundleIDs?.first }
		
		return nil
	}
}


extension Array where Element == Timeline.Entry {
	var summary: [Timeline.Summary] {
		var results: [Timeline.Summary] = []
		let count = count
		
		for index in 0..<count {
			let entry = self[index]
			guard !entry.isIgnored, let identifier = entry.summaryIdentifier else { continue }
			let duration = index < (count - 1) ? entry.duration(until: self[index + 1]) : nil
			if let summaryIndex = results.firstIndex(where: { $0.identifier == identifier }) {
				results[summaryIndex].totalTime += duration ?? 0
			} else {
				results.append(Timeline.Summary(identifier: identifier, totalTime: duration ?? 0, title: nil, isWebsite: entry.isTabEntry))
			}
		}
		
		return results
	}
}
