//
//  DateLine.swift
//  Watcher
//
//  Created by Ben Gottlieb on 10/15/21.
//

import SwiftUI
import Foundation

struct DateLine: View {
	let date: Date?
	let labelType: Timeline.Entry.DateLabel?
	
	var body: some View {
		HStack() {
			if let type = labelType, let date = date {
				if type == .time {
					Text(date.localTimeString(date: .none))
				} else if type == .date {
					Text(date.localTimeString())
				}
			} else if let date = date {
				Text(date.localTimeString()).opacity(0.35)
			}
			
			Rectangle()
				.fill(Color.gray)
				.frame(height: 0.5)
		}
		.font(.caption)
	}
}

struct DateLine_Previews: PreviewProvider {
	static var previews: some View {
		DateLine(date: Date(), labelType: .time)
	}
}
