//
//  SortedSummaryView.swift
//  Watcher
//
//  Created by Ben Gottlieb on 10/23/22.
//

import SwiftUI

struct SortedSummaryView: View {
	let timeline: [Timeline.Entry]
	@Binding var selectedIdentifier: String?
	
	private let summaries: [Timeline.Summary]
	@State private var sortOrder = Sort.duration
	
	enum Sort: String, Identifiable, CaseIterable { case chronologically, duration, alpha
		var id: String { rawValue }
		var title: String {
			switch self {
			case .chronologically: return "Chron."
			case .duration: return "Duration"
			case .alpha: return "Alpha."
			}
		}
	}
	
	init(timeline: [Timeline.Entry], selectedIdentifier: Binding<String?>?) {
		self.timeline = timeline
		summaries = timeline.summary
		_selectedIdentifier = selectedIdentifier ?? .constant(nil)
	}
	
	var body: some View {
		VStack() {
			Picker("", selection: $sortOrder) {
				ForEach(Sort.allCases) { sort in
					Text(sort.title).tag(sort)
				}
			}
			.pickerStyle(.segmented)
			.padding()
			ScrollView() {
				SummaryView(summaries: summaries.sorted(by: sortOrder), selectedIdentifier: $selectedIdentifier)
					.padding(.horizontal)
			}
		}
	}
}

extension Array where Element == Timeline.Summary {
	func sorted(by order: SortedSummaryView.Sort) -> [Element] {
		sorted { s1, s2 in
			switch order {
			case .alpha: return s1.displayTitle < s2.displayTitle
			case .duration: return s1.totalTime > s2.totalTime
			case .chronologically: return s1.firstUse < s2.firstUse
			}
		}
	}
	
	func time(for id: String) -> TimeInterval? {
		guard let item = first(where: { $0.identifier == id }) else { return nil }
		
		return item.totalTime
	}
}

struct SortedSummaryView_Previews: PreviewProvider {
	static var previews: some View {
		SortedSummaryView(timeline: Timeline.sample.diffs(), selectedIdentifier: nil)
	}
}
