//
//  NearbyMonitorManager.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/13/21.
//

import Foundation
import Nearby

class NearbyMonitorManager: ObservableObject {
	static let instance = NearbyMonitorManager()
	var monitors: [NearbyMonitor] = []
	var serializer = DispatchQueue(label: "NearbyMonitorManager", qos: .userInitiated, attributes: [])
	
	func received(request: RequestStatusMessage, from device: NearbyDevice) {
		let _ = monitor(matching: device)
		
		device.send(message: StatusMessage(request: request))
	}
	
	func sendStatusToAllMonitors() {
		for device in monitors.compactMap({ $0.connectedDevice }) {
			device.send(message: StatusMessage(request: nil))
		}
	}
		
	func monitor(matching device: NearbyDevice) -> NearbyMonitor {
		serializer.sync {
			if let monitor = monitors.first(where: { $0.matches(device) }) { return monitor }
			
			let newMonitor = NearbyMonitor(device: device)
			monitors.append(newMonitor)
			return newMonitor
		}
	}
}
