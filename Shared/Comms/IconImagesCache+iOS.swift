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
	func fetchRemoteImage(for identifier: String, from device: NearbyDevice) async throws -> UXImage {
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
		
		logg("🖼️ Requesting Image \(identifier) from \(device.name)")
		let image = try await withCheckedThrowingContinuation { continuation in
			device.send(message: RequestImageMessage(identifier))
			Task {
				pendingRequests[identifier] = [
					{ result in
						logg("🖼️ Fetched image for \(identifier)")
						continuation.resume(with: result)
					}
				]
			}
		}
		
		return image
	}
}
