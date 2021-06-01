//
//  TimelineWindow.swift
//  Watcher
//
//  Created by Ben Gottlieb on 6/1/21.
//

import Cocoa
import SwiftUI

class TimelineWindowController: NSWindowController {
  static var windows: [TimelineWindowController] = []
  
  var timeline: [Timeline.Entry] = []
  
  convenience init(timeline: [Timeline.Entry]) {
    self.init(windowNibName: "TimelineWindow")
    
    self.timeline = timeline
    Self.windows.append(self)
  }
  
  
  override func windowDidLoad() {
    self.window?.contentViewController = NSHostingController(rootView: TimelineScreen(timeline: timeline))
  }
}
