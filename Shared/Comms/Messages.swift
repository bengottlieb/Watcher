//
//  Messages.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/12/21.
//

import Foundation
import Nearby
import CrossPlatformKit

class StatusMessage: NearbyMessage {
  var command = "Status"
	var timelineEntry: Timeline.Entry?
	
	init(request: RequestStatusMessage?) {
		timelineEntry = Timeline.instance.currentEntry
	}
}

class TodayReportMessage: NearbyMessage {
  var command = "TodayReport"
  var timeline: [Timeline.Entry]
  
  init(request: RequestTodayMessage?) {
    timeline = Timeline.instance.timeline
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

class RequestAvailableDaysMessage: NearbyMessage {
	var command = "RequestAvailableDays"
}

class RequestDayMessage: NearbyMessage {
	var command = "RequestDay"
	var date: Date
	init(_ date: Date) {
		self.date = date
	}
}

class SendAvailableDaysMessage: NearbyMessage {
	var command = "SendAvailableDays"
	var dates: [Date]
	init(_ dates: [Date]) {
		self.dates = dates
	}
}

class SendDayMessage: NearbyMessage {
	var command = "SendDay"
	var timeline: [Timeline.Entry]
	init(_ timeline: [Timeline.Entry]) {
		self.timeline = timeline
	}
}

class RequestImageMessage: NearbyMessage {
  var command = "RequestImage"
  
  var identifier: String
  
  init(_ id: String) {
    identifier = id
  }
}

class SendImageMessage: NearbyMessage {
  var command = "SendImage"
  var identifier: String
  var imageData: Data?
  
  init(image: UXImage, identifier: String) {
	 imageData = image.pngData()
	 self.identifier = identifier
  }
  
  var image: UXImage? { imageData == nil ? nil : UXImage(data: imageData!) }
}


class NoImageMessage: NearbyMessage {
  var command = "NoImage"
  var identifier: String
  
  init(identifier: String) {
	 self.identifier = identifier
  }
}
