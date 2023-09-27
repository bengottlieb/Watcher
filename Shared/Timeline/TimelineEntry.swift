//
//  TimelineManager.Entry.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/12/21.
//

import Foundation
import Suite

extension Timeline {
	struct Entry: Codable, CustomStringConvertible, Comparable, Identifiable {
		enum DateLabel: String, RawCodable { case time, date }
		enum Special: String, RawCodable { case interruption, sleep, wake, powerOff }
		
		var isTabEntry: Bool { tabURLs != nil }
		var isAppEntry: Bool { bundleIDs != nil }
		var browserKind: BrowserKind? {
			for kind in BrowserKind.allCases {
				if bundleIDs?.contains(kind.bundleIdentifier) == true { return kind }
			}
			return nil
		}

		var id: String { uuid }
		var uuid: String! = UUID().uuidString
		var date = Date()
		var bundleIDs: [String]?
		var tabURLs: [BrowserURL]?
		var special: Special?
		var dateLabel: DateLabel?
		var title: String?
		var displayTitle: String {
			if let title { return title }
			if let bundle = bundleIDs?.first {
				let components = bundle.components(separatedBy: ".")
				if components.count > 2 { return components.dropFirst(2).joined() }
				return bundle
			}
			if let host = tabURLs?.first?.host { return host }
			return "--"
		}
		
		var description: String {
			if let special = special { return special.rawValue }
			var result = ""
			if let ids = bundleIDs, ids.isNotEmpty {
				result += ids.joined(separator: ", ")
			}
			
			if let urls = tabURLs, urls.isNotEmpty {
				if !result.isEmpty { result += "; " }
				result += urls.map { $0.description }.joined(separator: ", ")
			}
			return result
		}
		
		init(_ special: Special) {
			self.special = special
			uuid = UUID().uuidString
		}
		
		init(for applicationBundleID: String, date: Date = Date(), dateLabel: DateLabel? = nil) {
			bundleIDs = [applicationBundleID]
			self.date = date
			self.dateLabel = dateLabel
			uuid = UUID().uuidString
		}
		
		init(with urls: [BrowserURL], date: Date = Date(), dateLabel: DateLabel? = nil) {
			tabURLs = urls.sorted()
			self.date = date
			self.dateLabel = dateLabel
			uuid = UUID().uuidString
		}
		
		var firstTabEntry: Timeline.Entry? {
			guard let url = tabURLs?.first else { return nil }
			
			return Timeline.Entry(with: [url], date: self.date)
		}
		
		init(date: Date = Date()) {
			self.date = date
			uuid = UUID().uuidString
		}
		
		//    static func ==(lhs: Entry, rhs: Entry) -> Bool {
		//      lhs.bundleIDs == rhs.bundleIDs && lhs.tabURLs == rhs.tabURLs
		//    }
		
		func isSameContent(as other: Entry?) -> Bool {
			bundleIDs == other?.bundleIDs && tabURLs == other?.tabURLs
		}
		
		static func <(lhs: Entry, rhs: Entry) -> Bool {
			lhs.date > rhs.date
		}
		
		static func +(lhs: Entry, rhs: Entry?) -> Entry {
			let tabs = (lhs.tabURLs ?? []) + (rhs?.tabURLs ?? [])
			let apps = (lhs.bundleIDs ?? []) + (rhs?.bundleIDs ?? [])
			var result = Entry(date: min(lhs.date, rhs?.date ?? Date()))
			
			result.tabURLs = tabs.isEmpty ? nil : tabs.removingDuplicates()
			result.bundleIDs = apps.isEmpty ? nil : apps.removingDuplicates()
			return result
		}
		
		func duration(until next: Timeline.Entry?) -> TimeInterval? {
			guard let next = next else { return nil }
			return next.date.timeIntervalSince(date)
		}
		
		var isIgnored: Bool {
			if special == .wake { return true }
			if special == .sleep { return false }

			guard let bundleIDs else { return false }
			for identifier in bundleIDs {
				if Constants.ignoredIdentifiers.contains(identifier) { return true }
			}
			
			return false
		}
	}
}

extension Array where Element == Timeline.Entry {
	var mostRecentTabsEntry: Element? {
		reversed().first { $0.isTabEntry }
	}
	
	var mostRecentAppEntry: Element? {
		reversed().first { $0.isAppEntry }
	}
	
	var startTime: Date? {
		first?.date
	}
	
	var endTime: Date? {
		last?.date
	}
	
	var duration: TimeInterval {
		guard let start = startTime, let end = endTime else { return 0 }
		
		return end.timeIntervalSince(start)
	}
}
