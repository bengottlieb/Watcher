//
//  SummaryScreen.swift
//  LocalMonitor
//
//  Created by Ben Gottlieb on 10/24/22.
//

import SwiftUI

struct SummaryScreen: View {
	@State var date = Date()
	
	@State var timeline: [Timeline.Entry] = []
	@ObservedObject var settings = Settings.instance
	
	var body: some View {
		VStack() {
			Text("Today")
			SortedSummaryView(timeline: timeline, selectedIdentifier: $settings.menuBarIdentifier)
		}
		.onAppear {
			updateDate()
		}
		.frame(minWidth: 300, minHeight: 300)
	}
	
	func updateDate() {
		timeline = Timeline.instance.timeline(for: date)
	}
}

struct SummaryScreen_Previews: PreviewProvider {
	static var previews: some View {
		SummaryScreen()
	}
}
