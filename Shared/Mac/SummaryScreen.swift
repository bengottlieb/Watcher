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
	@State var selectedIdentifier: String?
	
	var body: some View {
		VStack() {
			SummaryView(summaries: timeline.summary, selectedIdentifier: $selectedIdentifier)
		}
		.onAppear {
			updateDate()
		}
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
