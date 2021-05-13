//
//  NearbyDevice+Extensions.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/12/21.
//

import Foundation
import Nearby

extension NearbyDevice {
  enum Role: String { case unknown, host, monitor }

  var role: Role {
    guard let raw = deviceInfo?[Keys.role] else { return .unknown }
    return Role(rawValue: raw) ?? .unknown
  }
	
	var name: String {
    self.deviceInfo?[Keys.userName] ?? self.deviceInfo?[Keys.deviceName] ?? "Unknown Device"
	}
}
