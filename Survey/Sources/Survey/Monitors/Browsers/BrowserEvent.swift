//
//  File.swift
//  
//
//  Created by Ben Gottlieb on 6/15/24.
//

import Foundation

public enum BrowserEvent: Codable {
	case initialState(BrowserTabCollection)
	case openedTab(BrowserTabInformation)
	case closedTab(BrowserTabInformation)
	case switchedToTab(BrowserTabInformation)
}
