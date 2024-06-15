//
//  BrowserEvent.swift
//
//
//  Created by Ben Gottlieb on 6/15/24.
//

import Foundation

public enum BrowserEvent: Codable, CustomStringConvertible {
	case initialState(BrowserState)
	case openedTab(BrowserTabInformation)
	case closedTab(BrowserTabInformation)
	case switchedToTab(BrowserTabInformation)
	
	public var description: String {
		switch self {
		case .initialState(let state): "Starting tabs: \(state.all.count)"
		case .openedTab(let tab): "Opened \(tab.title ?? "--")"
		case .closedTab(let tab): "Closed \(tab.title ?? "--")"
		case .switchedToTab(let tab): "Switched to \(tab.title ?? "--")"
		}
	}
}
