//
//  BrowserURL.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/12/21.
//

import Foundation
import Suite

struct BrowserURL: Codable, Comparable, Equatable, CustomStringConvertible {
  let url: URL
  let browser: BrowserKind
  
  var host: String? { url.host }
  
  var description: String {
    "\(browser.abbreviation): \(host ?? url.absoluteString)"
  }

  static func <(lhs: BrowserURL, rhs: BrowserURL) -> Bool {
    if lhs.browser != rhs.browser { return lhs.browser < rhs.browser }
    return lhs.url.absoluteString < rhs.url.absoluteString
  }
  
  init?(_ rawString: String, _ browser: BrowserKind) {
    self.init(URL(string: rawString.trimmingCharacters(in: .whitespacesAndNewlines)), browser: browser)
  }
  
  init?(_ url: URL?, browser: BrowserKind) {
    self.browser = browser

    guard let url = url else {
      self.url = .blank
      return nil
    }
    
    self.url = url
  }
}
