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
	var timeline: [Entry] = []
	
	func switched(to applicationBundleID: String?) {
		guard let id = applicationBundleID else { return }
		addEntry(Entry(for: id))
	}
	
	func logCurrent(urls: [BrowserURL]) {
		addEntry(Entry(with: urls))
	}
	
	func addEntry(_ entry: Entry) {
		queue.async {
      if entry.isTabEntry, entry == self.timeline.mostRecentTabsEntry { return }
      if entry.isAppEntry, entry == self.timeline.mostRecentAppEntry { return }
			
			self.timeline.append(entry)
      print(self.currentEntry ?? entry)
		}
	}
	
	var currentEntry: Entry? {
		guard let last = timeline.last else { return nil }
		
    return (timeline.mostRecentAppEntry ?? last) + (timeline.mostRecentTabsEntry ?? last)
	}
	
}

