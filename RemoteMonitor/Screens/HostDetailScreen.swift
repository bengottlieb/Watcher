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
	enum ScreenContent: String, Identifiable { case summary, history, raw
		var id: String { rawValue }
	}
	
	@State var screenContents = ScreenContent.summary
	@State var selectedIdentifier: String?
	@AppStorage("lastViewedDetails") var lastViewedDetails = ScreenContent.summary.rawValue

	var body: some View {
		VStack {
			Picker(selection: $screenContents, label: EmptyView()) {
				Text("Summary").tag(ScreenContent.summary)
				Text("History").tag(ScreenContent.history)
				Text("Raw").tag(ScreenContent.raw)
			}
			.pickerStyle(.segmented)
			.padding()
			
			if let remoteTimeline = remoteTimeline {
				switch screenContents {
				case .summary:
					ScrollView() {
						SummaryView(summaries: remoteTimeline.timeline(for: .now).diffs().summary, selectedIdentifier: $selectedIdentifier)
							.padding()
					}
					
				case .history:
					ScrollView() {
						FilteredHistoryView(history: remoteTimeline.timeline(for: .now))
							.padding()
					}
					
				case .raw:
					HostTimelineView(host: host, remoteTimeline: remoteTimeline)
				}
			}
			
			Spacer()
		}
		.onChange(of: lastViewedDetails) { newValue in
			if let content = ScreenContent(rawValue: newValue), content != screenContents {
				screenContents = content
			}
		}
		.onChange(of: screenContents) { newValue in
			lastViewedDetails = newValue.rawValue
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
	
}

//struct HostDetailScreen_Previews: PreviewProvider {
//	static var previews: some View {
//		HostDetailScreen()
//	}
//}
