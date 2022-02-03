//
//  HistoryAppRow.swift
//  Watcher
//
//  Created by Ben Gottlieb on 10/15/21.
//

import SwiftUI



struct HistoryAppRow: View {
	let entry: Timeline.Entry
	let next: Timeline.Entry?
	
	var body: some View {
		if entry.isLoginWindow {
			EmptyView()
		} else {
			VStack() {
				DateLine(date: entry.date, labelType: entry.dateLabel)
				Text(entry.bundleIDs?.joined(separator: ", ") ?? "--")
					.frame(maxWidth: .infinity, alignment: .leading)
				if let duration = entry.duration(until: next) {
					Text(duration.durationString())
						.font(.caption)
						.padding(.leading)
						.frame(maxWidth: .infinity, alignment: .leading)
				}
			}
		}
	}
}
//
//struct HistoryAppRow_Previews: PreviewProvider {
//	static var previews: some View {
//		HistoryAppRow()
//	}
//}
