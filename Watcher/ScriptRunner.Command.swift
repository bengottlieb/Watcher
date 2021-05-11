//
//  ScriptRunner.Command.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/11/21.
//

import Foundation

// osascript -e 'tell application "Safari" to get URL of current tab of front window'

extension ScriptRunner {
	enum Command: String, CaseIterable, Identifiable, Hashable {
		case safariCurrentTab = "Current Tab for Safari", safariAllFrontWindowTabs = "All Tabs for Safari"
		
		case chromeCurrentTab = "Current Tab for Chrome"
		case chromeAllFrontWindowTabs = "All Tabs for Chrome"

		
		var script: String {
			switch self {
			case .safariCurrentTab: return "tell application \"Safari\" to get URL of current tab of front window"
			case .safariAllFrontWindowTabs: return "tell application \"Safari\" to get URL of current tab of every window"

			case .chromeCurrentTab: return "tell application \"Google Chrome\" to get URL of active tab of front window"
			case .chromeAllFrontWindowTabs: return "tell application \"Google Chrome\" to get URL of active tab of front window"
			}
		}
		
		var title: String { rawValue }
		var id: String { rawValue }
		func hash(into hasher: inout Hasher) {
			rawValue.hash(into: &hasher)
		}
	}
}

