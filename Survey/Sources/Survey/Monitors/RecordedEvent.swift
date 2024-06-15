//
//  RecordedEvent.swift
//
//
//  Created by Ben Gottlieb on 6/15/24.
//

import Foundation

public enum RecordedEvent: Codable {
	case browserEvent(BrowserEvent, Date)
}
