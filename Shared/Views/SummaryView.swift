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
	@Binding var selectedIdentifier: String?

	var body: some View {
		VStack(spacing: 0) {
			ForEach(summaries) { summary in
				Button(action: { selectedIdentifier = summary.identifier }) {
					Row(summary: summary, selected: selectedIdentifier == summary.identifier)
				}
			}
		}
	}
	
	struct Row: View {
		let summary: Timeline.Summary
		let selected: Bool
		
		var body: some View {
			HStack() {
				if summary.isWebsite { Image(systemName: "globe").resizable().frame(width: 15, height: 15).opacity(0.25) }
				Text(summary.displayTitle)
				Spacer()
				Text(summary.totalTime.durationString(style: .secondsNoHours, showLeadingZero: true))
			}
			.frame(height: 20)
			.foregroundColor(selected ? .white : .black)
			.background(selected ? Color.blue : Color.white)
		}
	}
}


struct SummaryView_Previews: PreviewProvider {
	static var previews: some View {
		SummaryView(summaries: Timeline.sample.diffs().summary, selectedIdentifier: .constant(nil))
	}
}
