//
//  TimelineManager.Entry.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/12/21.
//

import Foundation

extension Timeline {
  struct Entry: Codable, CustomStringConvertible, Comparable, Identifiable {
		enum DateLabel: String, Codable { case time, date }
    enum Special: String, Codable { case interruption, sleep, wake, powerOff }
    
    var isTabEntry: Bool { tabURLs != nil }
    var isAppEntry: Bool { bundleIDs != nil }

		var id: String { uuid }
		var uuid: String! = UUID().uuidString
    var date = Date()
    var bundleIDs: [String]?
    var tabURLs: [BrowserURL]?
    var special: Special?
		var dateLabel: DateLabel?
    
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
      lhs.date < rhs.date
    }
    
    static func +(lhs: Entry, rhs: Entry?) -> Entry {
      let tabs = (lhs.tabURLs ?? []) + (rhs?.tabURLs ?? [])
      let apps = (lhs.bundleIDs ?? []) + (rhs?.bundleIDs ?? [])
      var result = Entry(date: min(lhs.date, rhs?.date ?? Date()))
      
      result.tabURLs = tabs.isEmpty ? nil : tabs.removingDuplicates()
      result.bundleIDs = apps.isEmpty ? nil : apps.removingDuplicates()
      return result
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
