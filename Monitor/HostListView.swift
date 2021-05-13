//
//  OtherDeviceListView.swift
//  Monitor
//
//  Created by Ben Gottlieb on 5/13/21.
//

import SwiftUI
import Nearby
import Suite

struct HostListView: View {
	@ObservedObject var hosts = NearbyHostManager.instance
	var body: some View {
		VStack() {
			ForEach(hosts.hosts) { host in
				HStack() {
					Image(systemName: "laptopcomputer")
					
					VStack(alignment: .leading) {
						Text(host.name)
							.font(.title)
						Text(host.state.description)
							.font(.body)
						if let current = host.currentTimelineEntry {
							Text(current.description)
								.multilineTextAlignment(.leading)
								.font(.caption)
						}
					}
					
					Spacer()
				}
			}
		}
	}
}

struct OtherDeviceListView_Previews: PreviewProvider {
	static var previews: some View {
		HostListView()
	}
}
