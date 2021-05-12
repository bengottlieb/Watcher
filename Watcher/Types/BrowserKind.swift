//
//  BrowserKind.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/12/21.
//

import Foundation

enum BrowserKind: String, CaseIterable { case safari, chrome
	var bundleIdentifier: String {
		switch self {
		case .chrome: return "com.google.Chrome"
		case .safari: return "com.apple.Safari"
		}
	}
	
}
