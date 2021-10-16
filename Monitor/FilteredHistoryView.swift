//
//  FilteredHistoryView.swift
//  Watcher
//
//  Created by Ben Gottlieb on 10/15/21.
//

import SwiftUI

struct FilteredHistoryView: View {
	enum Visible: String { case all, apps, tabs, raw }
	@State var filter = Visible.all
	let history: [Timeline.Entry]

	var contents: [Timeline.Entry] {
		switch filter {
		case .all: return history.diffs()
		case .apps: return history.appsOnly.diffs()
		case .tabs: return history.tabsOnly.diffs()
		case .raw: return history
		}
	}
	
	var body: some View {
		VStack() {
			Picker("", selection: $filter) {
				Text("All").tag(Visible.all)
				Text("Apps").tag(Visible.apps)
				Text("Tabs").tag(Visible.tabs)
				Text("Raw").tag(Visible.raw)
			}
			.pickerStyle(SegmentedPickerStyle())
			.padding(.horizontal)
			
			HistoryView(history: contents)
		}
	}
}

struct FilteredHistoryView_Previews: PreviewProvider {
	static var previews: some View {
		FilteredHistoryView(history: Timeline.sample)
	}
}
