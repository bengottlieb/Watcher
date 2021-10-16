//
//  HostDetailScreen.swift
//  Monitor
//
//  Created by Ben Gottlieb on 10/16/21.
//

import SwiftUI

struct HostDetailScreen: View {
	let host: NearbyHost
	@ObservedObject var remoteTimeline: RemoteTimeline
	
	init(host: NearbyHost) {
		self.host = host
		self.remoteTimeline = RemoteTimelineManager.instance.timeline(for: host.device!)
	}
	
	var body: some View {
		VStack() {
			Text(host.name)
			ScrollView() {
				VStack() {
					ForEach(remoteTimeline.dates, id: \.self) { date in
						NavigationLink(destination: HostDayDetailsScreen(host: host, date: date)) {
							Text(date.localTimeString(date: .short, time: .none))
								.frame(maxWidth: .infinity, alignment: .leading)
								.padding()
						}
					}
					Spacer()
				}
			}
		}
		.onAppear() {
			self.remoteTimeline.refreshDates()
		}
	}
}

//struct HostDetailScreen_Previews: PreviewProvider {
//	static var previews: some View {
//		HostDetailScreen()
//	}
//}
