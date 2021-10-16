//
//  ContentView.swift
//  Monitor
//
//  Created by Ben Gottlieb on 5/12/21.
//

import SwiftUI

struct ContentView: View {
	let testing = true
	var body: some View {
		if testing {
			FilteredHistoryView(history: Timeline.sample)
		} else {
			ScrollView() {
				HostListView()
					.padding()
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
