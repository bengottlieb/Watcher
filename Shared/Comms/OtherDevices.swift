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

#if os(iOS)
extension UIImage: @unchecked Sendable { }
#endif

#if os(macOS)
extension NSImage: @unchecked Sendable { }
#endif

struct Keys {
	static let deviceName = "name"
	static let userName = "user"
	static let role = "role"
}

class OtherDevices {
	static let instance = OtherDevices()
	
	var role: NearbyDevice.Role = .host
	var seenDevices: [String] = []
	
	func setup(mode: NearbyDevice.Role) {
		self.role = mode

		NearbySession.instance.serviceType = "WatchSAI"
		NearbySession.instance.localDeviceInfo = [
			Keys.userName: NSUserName(),
			Keys.deviceName: Gestalt.deviceName,
			Keys.role: role.rawValue
		]
		NearbySession.instance.startup(withRouter: self, application: .app)
	}
}


extension OtherDevices: NearbyMessageRouter {
	func didProvision(device: Nearby.NearbyDevice) {
		logg("Provisioned: \(device), \(device.role)")
		if !seenDevices.contains(device.id) {
			seenDevices.append(device.id)
		}
		if device.role == .host, role == .monitor {
			device.send(message: RequestStatusMessage())
		}
	}
	
	func didDiscover(device: Nearby.NearbyDevice) {
		logg("Discovered: \(device), \(device.role)")
		if !seenDevices.contains(device.id) {
			seenDevices.append(device.id)
		}
		if device.role == .host, role == .monitor {
			device.send(message: RequestStatusMessage())
		}
	}
	
	var fileID: String { #fileID }
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
			
			Task { await NearbySession.instance.shutdown() }
			
			DispatchQueue.main.async() {
				Notifications.willTerminate.notify()
			}
			
			DispatchQueue.main.async(after: 5) {
				exit(0)
			}
			return message
		}
		
		if payload.modulelessClassName == String(describing: RequestImageMessage.self), let message = try? payload.reconstitute(RequestImageMessage.self) {
			Task {
				do {
					#if os(macOS)
						let image = try await IconImagesCache.instance.fetchLocalImage(for: message.identifier, from: device)
						device.send(message: SendImageMessage(image: image, identifier: message.identifier))
					#endif
				} catch {
					device.send(message: NoImageMessage(identifier: message.identifier))
				}
			}
		}
		
		if payload.modulelessClassName == String(describing: RequestAvailableDaysMessage.self) {
			device.send(message: SendAvailableDaysMessage(Timeline.instance.availableDays))
		}
		
		if payload.modulelessClassName == String(describing: SendAvailableDaysMessage.self), let message = try? payload.reconstitute(SendAvailableDaysMessage.self) {
			
			RemoteTimelineManager.instance.setAvailableDays(message.dates, for: device)
		}
		
		if payload.modulelessClassName == String(describing: SendDayMessage.self), let message = try? payload.reconstitute(SendDayMessage.self) {
			
			RemoteTimelineManager.instance.setTimeline(message.timeline, for: device)
		}
		
		if payload.modulelessClassName == String(describing: RequestDayMessage.self), let message = try? payload.reconstitute(RequestDayMessage.self) {
			
			device.send(message: SendDayMessage(Timeline.instance.timeline(for: message.date)))
		}
		
		if payload.modulelessClassName == String(describing: SendImageMessage.self), let message = try? payload.reconstitute(SendImageMessage.self) {
			Task {
				await IconImagesCache.instance.store(image: message.image, for: message.identifier)
			}
		}
		
		if payload.modulelessClassName == String(describing: NoImageMessage.self), let message = try? payload.reconstitute(NoImageMessage.self) {
			Task {
				await IconImagesCache.instance.store(image: nil, for: message.identifier)
			}
		}
		
		return nil
	}
	
	func received(dictionary: [String : String], from device: NearbyDevice) {
		logg("Received \(dictionary)")
	}
	
	
}
