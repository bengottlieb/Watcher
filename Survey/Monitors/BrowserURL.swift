//
//  BrowserURL.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/12/21.
//

import Foundation
import Suite

struct BrowserURL: Codable, Comparable, Equatable, CustomStringConvertible, Hashable, Identifiable {
  let url: URL
  let browser: BrowserKind
	let title: String?
	var id: String { url.absoluteString + "\(browser.rawValue)" }
	static let ignoreThese: [String] = ["chrome://newtab/", "favorites://"] 
  
	func hash(into hasher: inout Hasher) {
		url.hash(into: &hasher)
		browser.hash(into: &hasher)
	}
  var host: String? { url.host }
  
  var description: String {
    "\(browser.abbreviation): \(host ?? url.absoluteString)"
  }

  static func <(lhs: BrowserURL, rhs: BrowserURL) -> Bool {
    if lhs.browser != rhs.browser { return lhs.browser < rhs.browser }
    return lhs.url.absoluteString < rhs.url.absoluteString
  }
  
  init?(_ rawString: String, _ browser: BrowserKind) {
		if let url = URL(string: rawString.trimmingCharacters(in: .whitespacesAndNewlines)) {
			self.init(url, browser: browser, title: nil)
		}
		
		let chunks = rawString.components(separatedBy: ",")
		guard let last = chunks.last, let url = URL(string: last.trimmingCharacters(in: .whitespacesAndNewlines)) else { return nil }
		
		let title = chunks.dropLast().joined(separator: ",")
		self.init(url, browser: browser, title: title)
  }
  
	init?(_ url: URL?, browser: BrowserKind, title: String?) {
    self.browser = browser

    guard let url = url else {
      self.url = .blank
      return nil
    }
    
		self.title = title?.isEmpty == false ? title : nil
    self.url = url
		
		if Self.ignoreThese.contains(url.absoluteString) { return nil }
  }
}
