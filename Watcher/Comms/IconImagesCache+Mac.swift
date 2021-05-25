//
//  IconImagesCache+Mac.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/23/21.
//

import Cocoa
import Combine
import CrossPlatformKit
import Nearby

extension IconImagesCache {
  func fetchImage(for identifier: String, from device: NearbyDevice) -> AnyPublisher<UXImage, Error> {
    if let current = NSRunningApplication.runningApplications(withBundleIdentifier: identifier).first {
      
      if let image = current.icon {
        return Just(image).setFailureType(to: Error.self).eraseToAnyPublisher()
      }
    }
    return Fail(outputType: UXImage.self, failure: ImageError.noImageAvailable).eraseToAnyPublisher()
  }
}

extension NSRunningApplication {
  
}
