//
//  HistoryAppRow.swift
//  Watcher
//
//  Created by Ben Gottlieb on 10/15/21.
//

import SwiftUI

struct HistoryAppRow: View {
	let entry: Timeline.Entry
	
	var body: some View {
		VStack() {
			DateLine(date: entry.date, labelType: entry.dateLabel)
			Text(entry.bundleIDs?.joined(separator: ", ") ?? "--")
				.frame(maxWidth: .infinity, alignment: .leading)
		}
	}
}
//
//struct HistoryAppRow_Previews: PreviewProvider {
//	static var previews: some View {
//		HistoryAppRow()
//	}
//}
