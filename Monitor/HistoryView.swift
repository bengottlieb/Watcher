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
		ScrollView() {
			LazyVStack() {
				ForEach(history) { entry in
					Text(entry.description)
				}
			}
		}
	}
}

struct HistoryView_Previews: PreviewProvider {
	static var previews: some View {
		HistoryView(history: Timeline.sample)
	}
}
