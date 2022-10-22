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
		List() {
			ForEach(hosts.hosts) { host in
				NavigationLink(destination: HostDetailScreen(host: host)) {
					HostRow(host: host)
				}
			}
		}
		.refreshable {
			NearbySession.instance.cycle()
		}
	}
}

struct OtherDeviceListView_Previews: PreviewProvider {
	static var previews: some View {
		HostListView()
	}
}
