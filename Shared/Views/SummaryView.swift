//
//  DurationText.swift
//  Watcher
//
//  Created by Ben Gottlieb on 10/22/22.
//

import SwiftUI
import Suite

struct SummaryView: View {
	let summaries: [Timeline.Summary]
	
	init(history: [Timeline.Entry]) {
		summaries = history.summary
	}
	
	var body: some View {
		VStack() {
			ForEach(summaries) { summary in
				HStack() {
					Text(summary.displayTitle)
					Spacer()
					Text(summary.totalTime.durationString(style: .secondsNoHours, showLeadingZero: true))
				}
			}
		}
	}
}


struct SummaryView_Previews: PreviewProvider {
	static var previews: some View {
		SummaryView(history: Timeline.sample.diffs())
	}
}
