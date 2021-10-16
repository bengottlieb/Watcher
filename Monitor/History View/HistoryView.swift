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
					ForEach(history) { entry in
						if entry.isAppEntry {
							HistoryAppRow(entry: entry)
						} else if entry.isTabEntry {
							HistoryBrowserRow(entry: entry)
						} else {
							HistoryRow(entry: entry)

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
