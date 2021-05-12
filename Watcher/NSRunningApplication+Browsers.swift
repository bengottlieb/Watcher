//
//  NSRunningApplication+Browsers.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/12/21.
//

import Foundation
import Cocoa

extension NSRunningApplication {
	enum BrowserKind: String { case safari, chrome }
	var isBrowser: Bool {
		browserKind != nil
	}
	
	var browserKind: BrowserKind? {
		if bundleIdentifier?.lowercased() == "com.apple.safari" { return .safari }
		if bundleIdentifier?.lowercased() == "com.google.chrome" { return .chrome }
		return nil
	}
}
