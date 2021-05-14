//
//  TimelineManager.Entry.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/12/21.
//

import Foundation

extension Timeline {
  struct Entry: Codable, Equatable, CustomStringConvertible {
    enum Special: String, Codable { case interruption }
    
    var isTabEntry: Bool { tabURLs != nil }
    var isAppEntry: Bool { bundleIDs != nil }

    var date = Date()
    var bundleIDs: [String]?
    var tabURLs: [BrowserURL]?
    var special: Special?
    
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
    }

    init(for applicationBundleID: String) {
      bundleIDs = [applicationBundleID]
    }
    
    init(with urls: [BrowserURL]) {
      tabURLs = urls.sorted()
    }
    
    init(date: Date = Date()) {
      self.date = date
    }
    
    static func ==(lhs: Entry, rhs: Entry) -> Bool {
      lhs.bundleIDs == rhs.bundleIDs && lhs.tabURLs == rhs.tabURLs
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
}
