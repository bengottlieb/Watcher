//
//  Array+Timeline.Entry.swift
//  Watcher
//
//  Created by Ben Gottlieb on 10/15/21.
//

import Foundation
import Survey

extension Array where Element == Timeline.Entry {
	static func load(from url: URL?) throws -> [Element] {
		guard let url = url else { return [] }
		if let data = try? Data(contentsOf: url) {
			let items = try JSONDecoder().decode([Element].self, from: data)
			
			return items.cleanup()
		} else {
			return []
		}
	}
	
	func browserKind(at index: Int) -> BrowserKind? {
		for i in stride(from: index, to: 0, by: -1) {
			if let kind = self[i].browserKind { return kind }
		}
		return nil
	}
	
	func cleanup() -> [Timeline.Entry] {
		var items = self
		for index in items.indices {
			if items[index].uuid == nil { items[index].uuid = UUID().uuidString }
		}
		return items
	}
	
	func diffs() -> [Timeline.Entry] {
		guard isNotEmpty else { return [] }
		let sorted = self.sorted()
		var results: [Timeline.Entry] = []
		var lastApp = sorted.first { $0.isAppEntry }
		var lastTab = sorted.first { $0.isTabEntry }

		if let last = lastApp { results.append(last) }
		if let last = lastTab { results.append(last) }
		var lastDate = Date.distantPast
		if results.isNotEmpty {
			results[0].dateLabel = .date
			lastDate = results[0].date
		}
		
		for element in sorted {
			if element.isAppEntry {
				guard let newIDs = element.bundleIDs, let lastIDs = lastApp?.bundleIDs, newIDs != lastIDs, newIDs.isNotEmpty else { continue }

				lastApp = element
				let dateLabel = element.date.label(relativeTo: lastDate)
				results.append(Timeline.Entry(for: newIDs[0], date: element.date, dateLabel: dateLabel))
				if dateLabel != nil { lastDate = element.date }
				continue
			} else if element.isTabEntry {
				guard let newURLs = element.tabURLs, let lastURLs = lastTab?.tabURLs, newURLs != lastURLs else { continue }
				lastTab = element
				let diff = newURLs.difference(from: lastURLs)
				let new = diff.inserted
				if new.isNotEmpty {
					let dateLabel = element.date.label(relativeTo: lastDate)
					results.append(Timeline.Entry(with: new, date: element.date, dateLabel: dateLabel))
					if dateLabel != nil { lastDate = element.date }
				}
				continue
			}
			
			results.append(element)
		}
		
		return results.sorted()
	}
	
	var appsOnly: [Timeline.Entry] {
		filter { $0.isAppEntry }
	}

	var tabsOnly: [Timeline.Entry] {
		filter { $0.isTabEntry }
	}
}

extension Date {
	func label(relativeTo: Date) -> Timeline.Entry.DateLabel? {
		if abs(self.timeIntervalSinceReferenceDate - relativeTo.timeIntervalSinceReferenceDate) < 60 { return nil }
		
		if self.isSameDay(as: relativeTo) {
			return .time
		}
		return .date
	}
}
