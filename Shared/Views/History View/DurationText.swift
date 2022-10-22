//
//  DurationText.swift
//  Watcher
//
//  Created by Ben Gottlieb on 10/22/22.
//

import SwiftUI
import Suite

struct DurationText: View {
	let from: Timeline.Entry
	let to: Timeline.Entry?
	
	var body: some View {
		if let duration = from.time(until: to) {
			Text(duration.durationString(style: .secondsNoHours, showLeadingZero: true))
		}
	}
}
