//
//  MonitoredDevicesScreen.swift
//  Monitor
//
//  Created by Ben Gottlieb on 10/16/21.
//

import SwiftUI
import Nearby

struct MonitoredDevicesScreen: View {
	@State var showingHUD = false
	
	var body: some View {
		VStack() {
			HostListView()
			if showingHUD {
				NearbyDevicesHUD()
			}
		}
		.navigationTitle("Nearby Devices")
		.overlay(alignment: .bottomTrailing) {
			Button(action: { showingHUD.toggle() }) {
				Image(systemName: "info.circle")
					.padding()
			}
			.padding()
			.buttonStyle(.bordered)
		}
	}
}

struct MonitoredDevicesScreen_Previews: PreviewProvider {
	static var previews: some View {
		MonitoredDevicesScreen()
	}
}
