//
//  NearbyMonitor.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/13/21.
//

import Foundation
import Nearby
import Combine

class NearbyMonitor: Identifiable, ObservableObject, Codable {
	enum CodingKeys: String, CodingKey { case deviceID, name, id, lastUpdatedAt }
	weak var device: NearbyDevice? { didSet {
		if let name = device?.name { self.name = name }
		state = device?.state ?? .none
	}}
	var deviceID: String
	var name: String
	var state: NearbyDevice.State = .disconnected
	var id: String { deviceID }
	var lastUpdatedAt: Date
	var deviceUpdateCancellable: AnyCancellable?
	var machineName: String? { device?.displayName }
	
	var connectedDevice: NearbyDevice? {
		if let state = device?.state, state == .connected { return device }
		return nil
	}
	
	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		deviceID = try container.decode(String.self, forKey: .deviceID)
		name = try container.decode(String.self, forKey: .name)
		lastUpdatedAt = try container.decode(Date.self, forKey: .lastUpdatedAt)
		deviceUpdateCancellable = device?.objectWillChange
			.sink { [weak self] _ in
				self?.deviceChanged()
			}
	}
	
	func deviceChanged() {
		objectWillChange.sendOnMain()
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		
		try container.encode(deviceID, forKey: .deviceID)
		try container.encode(name, forKey: .name)
		try container.encode(lastUpdatedAt, forKey: .lastUpdatedAt)
	}
	
	init(device: NearbyDevice) {
		lastUpdatedAt = Date()
		deviceID = device.uniqueID
		state = device.state
		name = device.name
		self.device = device
	}
	
	func matches(_ device: NearbyDevice) -> Bool {
		if device === self.device { return true }
		if deviceID == device.uniqueID {
			self.device = device
			self.lastUpdatedAt = Date()
			return true
		}
		
		return false
	}
}
