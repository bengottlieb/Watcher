//
//  IconImagesCache.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/19/21.
//

import Foundation
import Combine
import CrossPlatformKit
import Suite

public class IconImagesCache {
  static let instance = IconImagesCache()
  
  enum ImageError: Error { case noImageAvailable }
  var pendingRequests: [String: (Result<UXImage, Error>) -> Void] = [:]
  
  func store(image: UXImage, for identifier: String) {
    ImageCache.instance.store(image, for: identifier.identifierImageURL)
    
    if let request = pendingRequests[identifier] {
      request(.success(image))
      pendingRequests.removeValue(forKey: identifier)
    }
  }

}

extension String {
  var identifierImageURL: URL {
    URL(string: "image://\(self)")!
  }
}
