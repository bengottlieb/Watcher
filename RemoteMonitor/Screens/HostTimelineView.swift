//
//  HostTimelineView.swift
//  RemoteMonitor
//
//  Created by Ben Gottlieb on 12/5/22.
//

import SwiftUI
import Nearby

struct HostTimelineView: View {
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

//struct HostTimelineView_Previews: PreviewProvider {
//    static var previews: some View {
//		 HostTimelineView()
//    }
//}
