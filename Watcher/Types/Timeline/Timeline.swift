//
//  TimelineManager.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/12/21.
//

import Suite

class Timeline {
	static let instance = Timeline()
	
	private let queue = DispatchQueue(label: "timeline", qos: .userInitiated)
  var saveInterval = TimeInterval.minute { didSet { setupSaveTimer() }}
	var timeline: [Entry] = []
  var lastSaveURL: URL!
  let directory = FileManager.documentsDirectory.appendingPathComponent(".timelines")
	let formatter: DateFormatter
	
  init() {
		formatter = DateFormatter(format: "M-d-yy")
    lastSaveURL = saveURL
    try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
    load()
    
    if timeline.isNotEmpty {
      record(special: .interruption)
    }
    setupSaveTimer()
    #if os(macOS)
      BrowserMonitor.instance.checkTabs()
    #endif
    Notifications.willTerminate.watch(self, message: #selector(save))
  }
	
	public var availableDays: [Date] {
		do {
			let contents = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil, options: [])
			
			return contents.compactMap { url in
				let name = url.deletingPathExtension().lastPathComponent
				return formatter.date(from: name)
			}.sorted()
		} catch {
			logg(error: error, "Failed to list day files")
			return []
		}
		
	}

	func timeline(for date: Date) -> [Entry] {
		let filename = directory.appendingPathComponent(formatter.string(from: date) + ".txt")
		do {
			let data = try Data(contentsOf: filename)
			return try JSONDecoder().decode([Entry].self, from: data)
		} catch {
			logg(error: error, "Failed to load in timeline from \(filename)")
			return []
		}
	}
  
  public func record(special: Entry.Special) {
    timeline.append(Entry(special))
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
      if entry.isTabEntry, entry.isSameContent(as: self.timeline.mostRecentTabsEntry) { return }
      if entry.isAppEntry, entry.isSameContent(as: self.timeline.mostRecentAppEntry) { return }
			
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

