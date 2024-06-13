//
//  DurationText.swift
//  Watcher
//
//  Created by Ben Gottlieb on 10/22/22.
//

import SwiftUI
import Suite

struct SummaryView: View {
	let timeline: [Timeline.Entry]
	let summaries: [Timeline.Summary]
	@Binding var selectedIdentifier: String?

	func toggle(_ id: String) {
		if selectedIdentifier == id {
			selectedIdentifier = nil
		} else {
			selectedIdentifier = id
		}
	}
	
	var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			ForEach(summaries) { summary in
				Button(action: { toggle(summary.identifier) }) {
					Row(summary: summary, selected: selectedIdentifier == summary.identifier)
				}
				.padding(.horizontal, 14)
				.padding(2)
				.background(Color.white)
			}
			
			ForEach(timeline.allRootURLs, id: \.self) { url in
				Button(action: { }) {
					Text(url.absoluteString.removingPercentEncoding ?? "")
						.lineLimit(1)
				}
				.padding(.horizontal, 14)
				.frame(maxWidth: .infinity, alignment: .leading)
				.padding(2)
				.background(Color.white)
			}
		}
		.buttonStyle(.plain)
	}
	
	struct Row: View {
		let summary: Timeline.Summary
		let selected: Bool
		
		var body: some View {
			HStack() {
				if summary.isWebsite { Image(systemName: "globe").resizable().frame(width: 15, height: 15).opacity(0.25) }
				Text(summary.displayTitle)
				Spacer()
				Text(summary.totalTime.durationString(style: .seconds, showLeadingZero: true))
					.digitFont()
			}
			.frame(height: 20)
			.padding(.horizontal)
			.foregroundColor(selected ? .white : .black)
			.background(selected ? Color.blue : Color.white)
		}
	}
}

extension View {
	@ViewBuilder func monoDigits() -> some View {
		if #available(macOS 12.0, *) {
			self
				.monospacedDigit()
		} else {
			self
		}
	}
}

struct SummaryView_Previews: PreviewProvider {
	static var previews: some View {
		SummaryView(timeline: Timeline.sample, summaries: Timeline.sample.diffs().summary, selectedIdentifier: .constant(nil))
	}
}

extension View {
	@ViewBuilder func digitFont() -> some View {
		if #available(iOS 15, macOS 12, *) {
			self.monospacedDigit()
		} else {
			self
		}
	}
}
