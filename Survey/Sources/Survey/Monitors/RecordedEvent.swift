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
}
