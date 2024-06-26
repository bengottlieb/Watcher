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
		let firstUse: Date
		
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
	var allURLs: [URL] {
		let all = flatMap { $0.tabURLs?.map { $0.url } ?? [] }
		return all.removingDuplicates()
	}
	
	var allRootURLs: [URL] {
		let all = flatMap { $0.tabURLs?.compactMap { $0.url.hostOnlyURL } ?? [] }
		return all.removingDuplicates()
	}
	
	var summary: [Timeline.Summary] {
		guard count > 1 else { return [] }
		var results: [Timeline.Summary] = []
		let count = count
		let sorted = Array(self.sorted().reversed())
		
		for index in 1..<count {
			let entry = sorted[index]
			guard !entry.isIgnored, let identifier = entry.summaryIdentifier else { continue }
			let duration = index < (count - 1) ? entry.duration(until: sorted[index + 1]) : nil
			if let summaryIndex = results.firstIndex(where: { $0.identifier == identifier }) {
				results[summaryIndex].totalTime += duration ?? 0
			} else {
				results.append(Timeline.Summary(identifier: identifier, totalTime: duration ?? 0, title: nil, isWebsite: entry.isTabEntry, firstUse: entry.date))
			}
		}
		
		return results
	}
}

extension URL {
	var hostOnlyURL: URL {
		let components = URLComponents(url: self, resolvingAgainstBaseURL: true)
		
		if let host = components?.host, let scheme = components?.scheme {
			return URL(string: scheme + "://" + host) ?? self
		}
		
		return self
	}
}
