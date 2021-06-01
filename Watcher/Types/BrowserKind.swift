//
//  BrowserKind.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/12/21.
//

import Foundation

enum BrowserKind: Int, CaseIterable, Codable, Comparable { case safari, chrome, opera
	var bundleIdentifier: String {
		switch self {
		case .chrome: return "com.google.Chrome"
		case .safari: return "com.apple.Safari"
		case .opera: return "com.operasoftware.Opera"
		}
	}
  
  static func <(lhs: BrowserKind, rhs: BrowserKind) -> Bool {
    lhs.rawValue < rhs.rawValue
  }
  
  var abbreviation: String {
    switch self {
    case .safari: return "S"
		case .chrome: return "G"
		case .opera: return "O"
    }
  }
}
