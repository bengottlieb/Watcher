//
//  OtherDevices.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/12/21.
//

import Foundation
import Combine
import Suite
import Nearby

struct Keys {
  static let deviceName = "name"
  static let userName = "user"
  static let role = "role"
}

class OtherDevices {
  static let instance = OtherDevices()
  
  var role: NearbyDevice.Role = .host
  
  func setup(mode: NearbyDevice.Role) {
    self.role = mode
    NotificationCenter.default.addObserver(self, selector: #selector(discoveredDevice), name: NearbyDevice.Notifications.deviceConnectedWithInfo, object: nil)
    
    NearbySession.instance.serviceType = "WatchSAI"
    NearbySession.instance.localDeviceInfo = [
      Keys.userName: NSUserName(),
      Keys.deviceName: Gestalt.deviceName,
      Keys.role: role.rawValue
    ]
    NearbySession.instance.startup(withRouter: self, application: .app)
  }
  
  @objc func discoveredDevice(note: Notification) {
    if let device = note.object as? NearbyDevice {
			print("Discovered: \(device)")
      if device.role == .host, role == .monitor {
        device.send(message: RequestStatusMessage())
      }
    }
  }
}


extension OtherDevices: NearbyMessageRouter {
  func route(_ payload: NearbyMessagePayload, from device: NearbyDevice) -> NearbyMessage? {
		if payload.modulelessClassName == String(describing: RequestStatusMessage.self), let message = try? payload.reconstitute(RequestStatusMessage.self) {
			NearbyMonitorManager.instance.received(request: message, from: device)
			return message
		}

    if payload.modulelessClassName == String(describing: StatusMessage.self), let message = try? payload.reconstitute(StatusMessage.self) {
      NearbyHostManager.instance.record(timelineEntry: message.timelineEntry, for: device)
      return message
    }
    
    if payload.modulelessClassName == String(describing: RequestTodayMessage.self), let message = try? payload.reconstitute(RequestTodayMessage.self) {
      device.send(message: TodayReportMessage(request: message))
      return message
    }
    
    if payload.modulelessClassName == String(describing: TerminateMessage.self), let message = try? payload.reconstitute(TerminateMessage.self) {
      
      NearbySession.instance.shutdown()
      
      DispatchQueue.main.async() {
        Notifications.willTerminate.notify()
      }
      
      DispatchQueue.main.async(after: 5) {
        exit(0)
      }
      return message
    }
    
		return nil
  }
  
  func received(dictionary: [String : String], from device: NearbyDevice) {
    print("Received \(dictionary)")
  }
  
  
}
