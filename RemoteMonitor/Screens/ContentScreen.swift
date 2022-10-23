//
//  ContentScreen.swift
//  Monitor
//
//  Created by Ben Gottlieb on 5/12/21.
//

import SwiftUI

struct ContentScreen: View {
	@State var selectedIdentifier: String?
	var testing = true
	var body: some View {
		NavigationView() {
			if testing {
				SummaryView(summaries: Timeline.sample.diffs().summary, selectedIdentifier: $selectedIdentifier)
					.padding()
//				FilteredHistoryView(history: Timeline.sample)
			} else {
				MonitoredDevicesScreen()
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentScreen(testing: true)
	}
}
