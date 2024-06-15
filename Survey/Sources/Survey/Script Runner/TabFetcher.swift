//
//  AppleScript.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/11/21.
//

import Foundation

extension AppleScript {
	public enum TabFetcher: String, CaseIterable, Identifiable, Hashable, RunnableScript {
		case safariFrontmostTab = "Frontmost Tab for Safari", safariAllFrontWindowTabs = "All Front Tabs for Safari", safariAllVisibleTabs = "All Visible Tabs for Safari", safariAllTabs = "All Tabs for Safari"
		
		case chromeFrontmostTab = "Frontmost Tab for Chrome", chromeAllFrontWindowTabs = "All Front Tabs for Chrome", chromeAllVisibleTabs = "All Visible Tabs for Chrome", chromeAllTabs = "All Tabs for Chrome"

		case operaFrontmostTab = "Frontmost Tab for Opera", operaAllFrontWindowTabs = "All Tabs for Opera", operaAllVisibleTabs = "All Visible Tabs for Opera"
		
		public var script: String {
			switch self {
			case .safariFrontmostTab: return "tell application \"Safari\" to get {name, URL} of current tab of front window"
			case .safariAllFrontWindowTabs: return "tell application \"Safari\" to get {name, URL} of every tab of front window"
			case .safariAllVisibleTabs: return "tell application \"Safari\" to get {name, URL} of current tab of every window"
			case .safariAllTabs: return "tell application \"Safari\" to get {name, URL} of every tab of every window"

			case .chromeFrontmostTab: return "tell application \"Google Chrome\" to get (title, URL) of active tab of front window"
			case .chromeAllFrontWindowTabs: return "tell application \"Google Chrome\" to get (title, URL) of every tab of front window"
			case .chromeAllVisibleTabs: return "tell application \"Google Chrome\" to get (title, URL) of active tab of every window"
			case .chromeAllTabs: return "tell application \"Google Chrome\" to get (title, URL) of every tab of every window"

			case .operaFrontmostTab: return "tell application \"Opera\" to get (title, URL) of active tab of front window"
			case .operaAllFrontWindowTabs: return "tell application \"Opera\" to get (title, URL) of every tab of front window"
			case .operaAllVisibleTabs: return "tell application \"Opera\" to get (title, URL) of active tab of every window"
			}
		}
		
		public var title: String { rawValue }
		public var id: String { rawValue }
		public func hash(into hasher: inout Hasher) {
			rawValue.hash(into: &hasher)
		}
		
		public var browser: BrowserKind {
			switch self {
			case .safariAllTabs, .safariFrontmostTab, .safariAllVisibleTabs, .safariAllFrontWindowTabs: .safari
			case .chromeAllTabs, .chromeFrontmostTab, .chromeAllVisibleTabs, .chromeAllFrontWindowTabs: .chrome
			case .operaFrontmostTab, .operaAllVisibleTabs, .operaAllFrontWindowTabs: .opera
			}
		}
		
		public func tabs(from string: String) throws -> [BrowserTabInformation] {
			switch self {
			case .safariAllTabs: try [BrowserTabInformation](safariNamesAndURLsByWindow: string)
			case .safariFrontmostTab: try [BrowserTabInformation](safariTabNameAndURL: string)
			case .safariAllVisibleTabs: try [BrowserTabInformation](safariNamesAndURLs: string)
			case .safariAllFrontWindowTabs: try [BrowserTabInformation](safariNamesAndURLs: string)
				
			default: []
			}
		}
	}
}

extension [AppleScript.TabFetcher] {
	public static var allSafariScripts: [AppleScript.TabFetcher] { [ .safariFrontmostTab, .safariAllFrontWindowTabs, .safariAllVisibleTabs, .safariAllTabs ] }
	public static var allChromeScripts: [AppleScript.TabFetcher] { [ .chromeFrontmostTab, .chromeAllFrontWindowTabs, .chromeAllVisibleTabs, .chromeAllTabs ] }
	public static var allOperaScripts: [AppleScript.TabFetcher] { [ .operaFrontmostTab, .operaAllFrontWindowTabs, .operaAllVisibleTabs ] }
}
