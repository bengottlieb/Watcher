//
//  RunningApplicationState.swift
//
//
//  Created by Ben Gottlieb on 6/15/24.
//

import Foundation
import Cocoa

extension Set where Element == RunningApplication {
	var description: String {
		Array(self).map { $0.name }.joined(separator: ", a")
	}
}

public struct RunningApplicationCollection: Codable, Equatable, Hashable, CustomStringConvertible {
	let apps: Set<RunningApplication>
	public var description: String {
		apps.map { $0.name }.joined(separator: ", ")
	}
	
	public struct Diffs: Codable, CustomStringConvertible {
		public let opened: Set<RunningApplication>
		public let closed: Set<RunningApplication>

		public var isEmpty: Bool { opened.isEmpty && closed.isEmpty }
		
		public var description: String {
			if opened.isEmpty, closed.isEmpty { return "" }
			if opened.isEmpty { return "Quit \(closed.description)" }
			return "Launched \(opened.description)"
		}
	}
	
	func diffs(since origin: RunningApplicationCollection) -> Diffs {
		let opened = self.apps.subtracting(origin.apps)
		let closed = origin.apps.subtracting(self.apps)
		
		return .init(opened: opened, closed: closed)
	}
	
	static var current: RunningApplicationCollection {
		.init(apps: .init(NSWorkspace.shared.runningApplications.compactMap { RunningApplication($0) }))
	}
}

public struct RunningApplicationState: Codable {
	public let all: RunningApplicationCollection
	public let front: RunningApplication?
	
	public static var current: RunningApplicationState {
		.init(all: .current, front: .frontmost)
	}

	func diffs(since origin: RunningApplicationState) -> Diffs {
		.init(all: all.diffs(since: origin.all), front: origin.front == front ? nil : front)
	}
	
	struct Diffs: Codable, CustomStringConvertible {
		let all: RunningApplicationCollection.Diffs
		let front: RunningApplication?
		
		var isEmpty: Bool { all.isEmpty && front == nil }
		
		var description: String {
			if all.isEmpty, front == nil {
				return ""
			} else if let front {
				if all.isEmpty {
					return "Switched to \(front.name)"
				} else {
					return all.description + ", Switched to \(front.name)"
				}
			} else {
				return all.description
			}
		}
	}
}
