//
//  NearbyDevices.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/12/21.
//

import Foundation
import Combine
import Suite
import Nearby

class NearbyDevices {
  static let instance = NearbyDevices()
  
  var role: NearbyDevice.Role = .host
  
  func setup(mode: NearbyDevice.Role) {
    self.role = mode
    NotificationCenter.default.addObserver(self, selector: #selector(discoveredDevice), name: NearbyDevice.Notifications.deviceConnectedWithInfo, object: nil)
    
    NearbySession.instance.serviceType = "WatchSAI"
    NearbySession.instance.localDeviceInfo = ["name": Gestalt.deviceName, "role": role.rawValue]
    NearbySession.instance.startup(withRouter: self, application: .app)
  }
  
  @objc func discoveredDevice(note: Notification) {
    if let device = note.object as? NearbyDevice {
      if device.role == .host, role == .monitor {
        device.send(message: StatusMessage())
      }
    }
  }
  
  var nearbyHosts: [NearbyDevice] {
    NearbySession.instance.connectedDevices.filter { $0.role == .host }
  }

  var nearbyMonitors: [NearbyDevice] {
    NearbySession.instance.connectedDevices.filter { $0.role == .monitor }
  }
}


extension NearbyDevices: NearbyMessageRouter {
  func route(_ payload: NearbyMessagePayload, from device: NearbyDevice) -> NearbyMessage? {
    print(payload)
    return nil
  }
  
  func received(dictionary: [String : String], from device: NearbyDevice) {
    print("Received \(dictionary)")
  }
  
  
}
