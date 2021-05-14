//
//  NearbyHostManager.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/13/21.
//

import Foundation
import Nearby

class NearbyHostManager: ObservableObject {
	static let instance = NearbyHostManager()
	var hosts: [NearbyHost] = []
	var serializer = DispatchQueue(label: "NearbyHostManager", qos: .userInitiated, attributes: [])
	
	func record(timelineEntry: Timeline.Entry?, for device: NearbyDevice) {
		host(matching: device).record(timelineEntry: timelineEntry)
	}
	
	func host(matching device: NearbyDevice) -> NearbyHost {
		serializer.sync {
			if let host = hosts.first(where: { $0.matches(device) }) { return host }
			
			let newHost = NearbyHost(device: device)
			hosts.append(newHost)
      self.objectWillChange.sendOnMain()
			return newHost
		}
	}
}
