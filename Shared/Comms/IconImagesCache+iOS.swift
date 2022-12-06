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
	func fetchImage(for identifier: String, from device: NearbyDevice) async throws -> UXImage {
		print("REQUESTING \(identifier) from \(device.name)")
		if let image = ImageCache.instance.cachedValue(for: identifier.identifierImageURL) {
			return image
		}
		
		if var current = self.pendingRequests[identifier] {
			let image = try await withCheckedThrowingContinuation { continuation in
				current.append { result in
					continuation.resume(with: result)
				}
				Task { self.pendingRequests[identifier] = current }
			}
			return image
		}
		
		let image = try await withCheckedThrowingContinuation { continuation in
			device.send(message: RequestImageMessage(identifier))
			Task {
				pendingRequests[identifier] = [
					{ result in
						print("Fetched image for \(identifier)")
						continuation.resume(with: result)
					}
				]
			}
		}
		
		return image
	}
}
