//
//  BrowserState.swift
//
//
//  Created by Ben Gottlieb on 6/15/24.
//

import Foundation

public struct BrowserTabCollection: Codable {
	let tabs: Set<BrowserTabInformation>
	
	public struct Diffs: Codable, CustomStringConvertible {
		let opened: Set<BrowserTabInformation>
		let closed: Set<BrowserTabInformation>

		public var isEmpty: Bool { opened.isEmpty && closed.isEmpty }
		public var description: String {
			var results = ""
			if !opened.isEmpty { results += "Opened \(Array(opened).names)" }
			if !opened.isEmpty, !closed.isEmpty { results += ", " }
			if !closed.isEmpty { results += "Closed \(Array(closed).names)" }
			return results
		}
	}
	
	func diffs(since origin: BrowserTabCollection) -> Diffs {
		let opened = self.tabs.subtracting(origin.tabs)
		let closed = origin.tabs.subtracting(self.tabs)
		
		return .init(opened: opened, closed: closed)
	}
	
	public static func +(lhs: Self, rhs: Self) -> Self {
		BrowserTabCollection(tabs: lhs.tabs.union(rhs.tabs))
	}
	
	public static let empty = BrowserTabCollection(tabs: [])
}


public struct BrowserState: Codable {
	let all: BrowserTabCollection
	let visible: BrowserTabCollection

	func diffs(since origin: BrowserState) -> Diffs {
		.init(all: all.diffs(since: origin.all), visible: visible.diffs(since: origin.visible))
	}

	struct Diffs: Codable, CustomStringConvertible {
		let all: BrowserTabCollection.Diffs
		let visible: BrowserTabCollection.Diffs
		
		var isEmpty: Bool { all.isEmpty && visible.isEmpty }
		
		var description: String {
			"All: \(all), Visible: \(visible)"
		}
	}
}
