//
//  Messages.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/12/21.
//

import Foundation
import Nearby

class StatusMessage: NearbyMessage {
  var command = "Status"
	var timelineEntry: TimelineManager.Entry?
	
	init(request: RequestStatusMessage?) {
		timelineEntry = TimelineManager.instance.currentEntry
	}
}

class TodayReportMessage: NearbyMessage {
  var command = "TodayReport"
  var timeline: [TimelineManager.Entry]
  
  init(request: RequestTodayMessage?) {
    timeline = TimelineManager.instance.timeline
  }
}

class RequestStatusMessage: NearbyMessage {
  var command = "RequestStatus"
}

class RequestTodayMessage: NearbyMessage {
  var command = "RequestToday"
}


class TerminateMessage: NearbyMessage {
  var command = "Terminate"
}
