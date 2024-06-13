//
//  SurveyEvent.swift
//  Survey
//
//  Created by Ben Gottlieb on 6/13/24.
//

import Foundation

public enum SurveyEvent {
	case appLaunched(String)
	case appBroughtToFront(String)
	case appQuit(String)
	
	case browserTabOpened(URL, String?)
	case browserTabBroughtToFront(URL)
	case browserTabClosed(URL)
}
