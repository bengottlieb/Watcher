//
//  SurveyEvent.swift
//  Survey
//
//  Created by Ben Gottlieb on 6/13/24.
//

import Foundation

public struct ApplicationInformation: Codable {
	public let identifier: String
}

public enum SurveyEvent {
	case activeApps([ApplicationInformation])
	case appLaunched(ApplicationInformation)
	case appBroughtToFront(ApplicationInformation)
	case appQuit(ApplicationInformation)
	
	case browserTabOpened(BrowserTabInformation)
	case browserTabBroughtToFront(BrowserTabInformation)
	case browserTabClosed(BrowserTabInformation)
}
