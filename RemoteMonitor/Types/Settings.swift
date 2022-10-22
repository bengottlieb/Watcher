//
//  Settings.swift
//  Monitor
//
//  Created by Ben Gottlieb on 2/3/22.
//

import Suite

class Settings: DefaultsBasedPreferences {
	static let instance = Settings()
	
	@objc public dynamic var nearbyHostData: Data?
	
	var nearbyHosts: [NearbyHost] {
		get {
			guard let data = nearbyHostData else { return [] }
			do {
				return try [NearbyHost].loadJSON(data: data)
			} catch {
				print("Failed to load hosts: \(error)")
				return []
			}
		}
		
		set {
			guard let data = try? newValue.asJSONData() else { return }
			self.nearbyHostData = data
		}
	}
}
