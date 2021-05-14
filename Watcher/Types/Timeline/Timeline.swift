//
//  TimelineManager.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/12/21.
//

import Foundation

class Timeline {
	static let instance = Timeline()
	
	private let queue = DispatchQueue(label: "timeline", qos: .userInitiated)
  var saveInterval = TimeInterval.minute { didSet { setupSaveTimer() }}
	var timeline: [Entry] = []
  var lastSaveURL: URL!
  let directory = FileManager.documentsDirectory.appendingPathComponent("timelines")
	
  init() {
    lastSaveURL = saveURL
    try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
    load()
    
    if timeline.isNotEmpty {
      timeline.append(Entry(.interruption))
    }
    setupSaveTimer()
    #if os(macOS)
      BrowserMonitor.instance.checkTabs()
    #endif
    Notifications.willTerminate.watch(self, message: #selector(save))
  }
  
  private var saveTimer: Timer?
  func setupSaveTimer() {
    saveTimer?.invalidate()
    saveTimer = Timer.scheduledTimer(timeInterval: saveInterval, target: self, selector: #selector(save), userInfo: nil, repeats: true)
  }
  
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
			NearbyMonitorManager.instance.sendStatusToAllMonitors()
		}
	}
	
	var currentEntry: Entry? {
		guard let last = timeline.last else { return nil }
		
    return (timeline.mostRecentAppEntry ?? last) + (timeline.mostRecentTabsEntry ?? last)
	}
	
}

