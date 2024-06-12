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
import Convey

public actor IconImagesCache {
	static let instance = IconImagesCache()
	
	enum ImageError: Error { case noImageAvailable }
	var pendingRequests: [String: [(Result<UXImage, Error>) -> Void]] = [:]
	
	func store(image: UXImage?, for identifier: String) async {
		var result: Result<UXImage, Error>
		
		if let image {
			await ImageCache.instance.store(image: image, for: identifier.identifierImageURL)
			result = .success(image)
		} else {
			result = .failure(ImageError.noImageAvailable)
		}
		
		if let requests = pendingRequests[identifier] {
			requests.forEach { request in request(result) }
			pendingRequests.removeValue(forKey: identifier)
		}
	}
	
}

extension String {
	var identifierImageURL: URL {
		URL(string: "image://\(self)")!
	}
}
