//
//  BrowserEvent.swift
//
//
//  Created by Ben Gottlieb on 6/15/24.
//

import Foundation

public enum BrowserEvent: Codable, CustomStringConvertible, Equatable, Hashable {
	case initialState(BrowserState)
	case openedTab(BrowserTabInformation)
	case closedTab(BrowserTabInformation, TimeInterval?)
	case switchedToTab(BrowserTabInformation)
	case switchedAwayFromTab(BrowserTabInformation, TimeInterval?)
	
	public var description: String {
		switch self {
		case .initialState(let state): "Starting tabs: \(state.all.count)"
		case .openedTab(let tab): "Opened \(tab.title ?? "--")"
		case .closedTab(let tab, let duration): "Closed \(tab.title ?? "--") \(duration?.durationString(style: .secondsMaybeHours, showLeadingZero: true) ?? "")"
		case .switchedToTab(let tab): "Switched to \(tab.title ?? "--")"
		case .switchedAwayFromTab(let tab, let duration):
			"Switched away from \(tab.title ?? "") \(duration?.durationString(style: .secondsMaybeHours, showLeadingZero: true) ?? "")s"
		}
	}
}
