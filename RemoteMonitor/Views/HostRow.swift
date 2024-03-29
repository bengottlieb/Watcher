//
//  HostRow.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/14/21.
//

import SwiftUI
import Suite

struct HostRow: View {
	@ObservedObject var host: NearbyHost
	@State var frontAppImage: UIImage?
	@State private var lastFetchedDeviceID = ""
	@State private var lastFetchedImageIdentity = ""
	
	var body: some View {
		HStack() {
			if let image = frontAppImage {
				Image(uiImage: image)
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(50)
			} else {
				Image(systemName: "laptopcomputer")
			}
			VStack(alignment: .leading) {
				Text(host.name)
					.font(.title)
				Text(host.machineName ?? "")
					.font(.caption2)

				Text(host.state.description)
					.font(.caption)
					.opacity(0.5)
				if let current = host.currentTimelineEntry {
					Text(current.description)
						.multilineTextAlignment(.leading)
						.font(.caption)
				}
				
				Text(host.lastUpdatedAt.localTimeString(date: .none, time: .short))
					.font(.caption)
			}
			
			Spacer()
			
			if host.canRefresh {
				if host.isRefreshing {
					ProgressView()
				} else {
					Button(action: refresh) {
						Image(.arrow_clockwise)
							.padding()
					}
					.buttonStyle(.plain)
				}
			}
			
		}
		.addSwipeActions(trailing: killButton, id: host.deviceID)
		.onAppear { updateImage() }
		.onChange(of: host.frontmostAppIdentifier) { ident in
			updateImage()
		}
	}
	
	func updateImage() {
		if let ident = host.frontmostAppIdentifier, let device = host.device, (ident != lastFetchedImageIdentity || device.id != lastFetchedDeviceID) {
			Task {
				do {
					frontAppImage = try await IconImagesCache.instance.fetchRemoteImage(for: ident, from: device)
					lastFetchedImageIdentity = ident
					lastFetchedDeviceID = device.id
				} catch {
					
				}
			}
		}
	}
	
	func refresh() {
		host.refresh()
	}
	
	var killButton: some View {
		Button(action: sendQuit) {
			Text("Force\nQuit")
				.foregroundColor(.white)
				.padding(10)
				.background(Color.red)
				.multilineTextAlignment(.center)
		}
	}
	
	func sendQuit() {
		host.device?.send(message: TerminateMessage())
	}
}

