//
//  ScriptRunner.Command.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/11/21.
//

import Foundation

// osascript -e 'tell application "Safari" to get URL of current tab of front window'

extension ScriptRunner {
	public enum Command: String, CaseIterable, Identifiable, Hashable {
		case safariCurrentTab = "Current Tab for Safari", safariAllFrontWindowTabs = "All Front Tabs for Safari", safariAllCurrentTabs = "All Visible Tabs for Safari", safariAllTabs = "All Tabs for Safari"
		
		case chromeCurrentTab = "Current Tab for Chrome", chromeAllFrontWindowTabs = "All Front Tabs for Chrome", chromeAllCurrentTabs = "All Visible Tabs for Chrome", chromeAllTabs = "All Tabs for Chrome"

		case operaCurrentTab = "Current Tab for Opera", operaAllFrontWindowTabs = "All Tabs for Opera", operaAllCurrentTabs = "All Visible Tabs for Opera"
		
		public var script: String {
			switch self {
			case .safariCurrentTab: return "tell application \"Safari\" to get {name, URL} of current tab of front window"
			case .safariAllFrontWindowTabs: return "tell application \"Safari\" to get {name, URL} of current tab of every window"
			case .safariAllCurrentTabs: return "tell application \"Safari\" to get {name, URL} of current tab of every window"
			case .safariAllTabs: return "tell application \"Safari\" to get {name, URL} of every tab of every window"

			case .chromeCurrentTab: return "tell application \"Google Chrome\" to get (title, URL) of active tab of front window"
			case .chromeAllFrontWindowTabs: return "tell application \"Google Chrome\" to get (title, URL) of every tab of front window"
			case .chromeAllCurrentTabs: return "tell application \"Google Chrome\" to get (title, URL) of active tab of every window"
			case .chromeAllTabs: return "tell application \"Google Chrome\" to get (title, URL) of every tab of every window"

			case .operaCurrentTab: return "tell application \"Opera\" to get (title, URL) of active tab of front window"
			case .operaAllFrontWindowTabs: return "tell application \"Opera\" to get (title, URL) of every tab of front window"
			case .operaAllCurrentTabs: return "tell application \"Opera\" to get (title, URL) of active tab of every window"
			}
		}
		
		public var title: String { rawValue }
		public var id: String { rawValue }
		public func hash(into hasher: inout Hasher) {
			rawValue.hash(into: &hasher)
		}
	}
}

