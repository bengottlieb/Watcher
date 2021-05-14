//
//  NearbyMonitor.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/13/21.
//

import Foundation
import Nearby

class NearbyMonitor: Identifiable, ObservableObject {
	weak var device: NearbyDevice? { didSet {
		if let name = device?.name { self.name = name }
		state = device?.state ?? .none
	}}
	var deviceID: String
	var name: String
	var state: NearbyDevice.State
	var id: String { deviceID }
  var lastUpdatedAt: Date
	
	var connectedDevice: NearbyDevice? {
		if let state = device?.state, state == .connected { return device }
		return nil
	}
	
	init(device: NearbyDevice) {
    lastUpdatedAt = Date()
		deviceID = device.uniqueID
		state = device.state
		name = device.name
		self.device = device
	}
	
	func matches(_ device: NearbyDevice) -> Bool {
		if device === device { return true }
		if deviceID == device.uniqueID {
      self.device = device
      self.lastUpdatedAt = Date()
      return true
    }
		return false
	}
}
