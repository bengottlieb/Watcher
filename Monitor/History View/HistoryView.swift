//
//  HistoryView.swift
//  Watcher
//
//  Created by Ben Gottlieb on 10/15/21.
//

import SwiftUI

struct HistoryView: View {
	let history: [Timeline.Entry]
	var body: some View {
		VStack() {
			ScrollView() {
				LazyVStack() {
					ForEach(history.indices, id: \.self) { index in
						let entry = history[index]
						let next = index < (history.count - 1) ? history[index + 1] : nil
						
						if entry.isAppEntry {
							HistoryAppRow(entry: entry, next: next)
						} else if entry.isTabEntry {
							HistoryBrowserRow(entry: entry, next: next)
						} else {
							HistoryRow(entry: entry, next: next)
						}
					}
				}
				.padding(.horizontal)
			}
		}
	}
}

struct HistoryView_Previews: PreviewProvider {
	static var previews: some View {
		HistoryView(history: Timeline.sample.diffs())
	}
}
