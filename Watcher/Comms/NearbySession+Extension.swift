//
//  NearbySession+Extension.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/13/21.
//

import Foundation
import Nearby

extension NearbySession {
	var nearbyHosts: [NearbyDevice] {
		connectedDevices.filter { $0.role == .host }
	}

	var nearbyMonitors: [NearbyDevice] {
		connectedDevices.filter { $0.role == .monitor }
	}
}