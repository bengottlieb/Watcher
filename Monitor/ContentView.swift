//
//  ContentView.swift
//  Monitor
//
//  Created by Ben Gottlieb on 5/12/21.
//

import SwiftUI

struct ContentView: View {
	let testing = false
	var body: some View {
		NavigationView() {
			if testing {
				FilteredHistoryView(history: Timeline.sample)
			} else {
				MonitoredDevicesScreen()
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
