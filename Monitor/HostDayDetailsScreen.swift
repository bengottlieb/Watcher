//
//  HostDayDetailsScreen.swift
//  Monitor
//
//  Created by Ben Gottlieb on 10/16/21.
//

import SwiftUI

struct HostDayDetailsScreen: View {
	@ObservedObject var remoteTimeline: RemoteTimeline
	let host: NearbyHost
	let date: Date
	
	init(host: NearbyHost, date: Date) {
		self.host = host
		self.date = date
		self.remoteTimeline = RemoteTimelineManager.instance.timeline(for: host.device!)
	}
	
	var body: some View {
		FilteredHistoryView(history: remoteTimeline.timeline(for: date))
			.onAppear {
				remoteTimeline.refresh(date)
			}
	}
}

//struct HostDayDetailsScreen_Previews: PreviewProvider {
//	static var previews: some View {
//		HostDayDetailsScreen()
//	}
//}
