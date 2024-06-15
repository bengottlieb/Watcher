//
//  ApplicationEvent.swift
//
//
//  Created by Ben Gottlieb on 6/15/24.
//

import Foundation

public enum ApplicationEvent: Codable {
	case initialState(RunningApplicationCollection)
	case openedTab(RunningApplication)
	case closedTab(RunningApplication)
	case switchedToTab(RunningApplication)
}
