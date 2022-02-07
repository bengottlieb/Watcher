//
//  HostDetailScreen.swift
//  Monitor
//
//  Created by Ben Gottlieb on 10/16/21.
//

import SwiftUI

struct HostDetailScreen: View {
	let host: NearbyHost
	@State var remoteTimeline: RemoteTimeline?
	
	var body: some View {
		ZStack() {
			if let remoteTimeline = remoteTimeline {
				HostTimeline(host: host, remoteTimeline: remoteTimeline)
			}
		}
		.onAppear {
			if let device = host.device {
				self.remoteTimeline = RemoteTimelineManager.instance.timeline(for: device)
			} else {
				self.remoteTimeline = RemoteTimelineManager.instance.timeline(for: host.deviceID)
			}
			self.remoteTimeline?.refreshDates()
		}
		.navigationTitle(host.name)
	}
	
	struct HostTimeline: View {
		let host: NearbyHost
		@ObservedObject var remoteTimeline: RemoteTimeline
		
		var body: some View {
			VStack() {
				ScrollView() {
					VStack() {
						ForEach(remoteTimeline.dates, id: \.self) { date in
							NavigationLink(destination: HostDayDetailsScreen(host: host, date: date)) {
								Text(date.localTimeString(date: .short, time: .none))
									.frame(maxWidth: .infinity, alignment: .leading)
									.padding([.bottom, .horizontal])
							}
						}
						Spacer()
					}
				}
			}
		}
	}
}

//struct HostDetailScreen_Previews: PreviewProvider {
//	static var previews: some View {
//		HostDetailScreen()
//	}
//}
