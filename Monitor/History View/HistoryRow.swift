//
//  HistoryRow.swift
//  Watcher
//
//  Created by Ben Gottlieb on 10/15/21.
//

import SwiftUI

struct HistoryRow: View {
	let entry: Timeline.Entry
	var body: some View {
		HStack() {
			if let event = entry.special {
				Text(event.rawValue)
			}
			Rectangle()
				.fill(Color.gray)
				.frame(height: 0.5)
		}
	}
}
//
//struct HistoryRow_Previews: PreviewProvider {
//    static var previews: some View {
//        HistoryRow()
//    }
//}
