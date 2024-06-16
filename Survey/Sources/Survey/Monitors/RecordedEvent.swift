//
//  RecordedEvent.swift
//
//
//  Created by Ben Gottlieb on 6/15/24.
//

import Foundation

public enum RecordedEvent: Codable, CustomStringConvertible {
	case browserEvent(BrowserEvent, Date)
	case applicationEvent(ApplicationEvent, Date)
	
	public var description: String {
		switch self {
		case .browserEvent(let event, _): event.description
		case .applicationEvent(let event, _): event.description
		}
	}
	
	var age: TimeInterval {
		switch self {
		case .browserEvent(_, let date): abs(date.timeIntervalSinceNow)
		case .applicationEvent(_, let date): abs(date.timeIntervalSinceNow)
		}
	}
}

extension [RecordedEvent] {
	func mostRecentOpenTabEvent(for tab: BrowserTabInformation) -> RecordedEvent? {
		for event in reversed() {
			if case let .browserEvent(browserEvent, _) = event {
				if case let .openedTab(opened) = browserEvent, opened.url == tab.url { return event }
				if case let .initialState(state) = browserEvent, state.all.contains(tab.url) { return event }
			}
			
			
		}
		return nil
	}
	
	func mostRecentSwitchToTabEvent(for tab: BrowserTabInformation) -> RecordedEvent? {
		for event in reversed() {
			if case let .browserEvent(browserEvent, _) = event {
				if case let .switchedToTab(opened) = browserEvent, opened.url == tab.url { return event }
				if case let .initialState(state) = browserEvent, state.all.contains(tab.url) { return event }
			}
		}
		return nil
	}
}
