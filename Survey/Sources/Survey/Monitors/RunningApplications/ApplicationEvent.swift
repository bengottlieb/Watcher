//
//  ApplicationEvent.swift
//
//
//  Created by Ben Gottlieb on 6/15/24.
//

import Foundation

public enum ApplicationEvent: Codable {
	case initialState(RunningApplicationCollection)
	case openedApp(RunningApplication)
	case closedApp(RunningApplication)
	case switchedToApp(RunningApplication)
}
