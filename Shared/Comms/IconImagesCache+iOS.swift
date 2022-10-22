//
//  IconImagesCache+iOS.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/23/21.
//

import Combine
import CrossPlatformKit
import Suite
import Nearby

extension IconImagesCache {
  func fetchImage(for identifier: String, from device: NearbyDevice) -> AnyPublisher<UXImage, Error> {
    if let image = ImageCache.instance.cachedValue(for: identifier.identifierImageURL) {
      return Just(image).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    return Future<UXImage, Error>() { promise in
      device.send(message: RequestImageMessage(identifier))
      
      self.pendingRequests[identifier] = { result in
        promise(result)
      }
    }
    .eraseToAnyPublisher()
    
//    return Fail(outputType: UXImage.self, failure: ImageError.noImageAvailable).eraseToAnyPublisher()
  }
}
