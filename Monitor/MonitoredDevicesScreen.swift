//
//  MonitoredDevicesScreen.swift
//  Monitor
//
//  Created by Ben Gottlieb on 10/16/21.
//

import SwiftUI

struct MonitoredDevicesScreen: View {
	var body: some View {
		VStack() {
			ScrollView() {
				HostListView()
					.padding()
			}
		}
		.navigationTitle("Nearby Devices")
	}
}

struct MonitoredDevicesScreen_Previews: PreviewProvider {
	static var previews: some View {
		MonitoredDevicesScreen()
	}
}
