//
//  TimelineScreen.swift
//  Watcher
//
//  Created by Ben Gottlieb on 6/1/21.
//

import Suite

struct TimelineScreen: View {
	let pixelsPerHour: CGFloat = 200
	let timeline: [Timeline.Entry]
	let vInset: CGFloat = 10
	
	var body: some View {
		let duration = timeline.duration
		
		ScrollView() {
			HStack() {
				if let start = timeline.startTime, let end = timeline.endTime {
					HourLabelsView(start: start, end: end, vInset: vInset)
						.frame(width: 30)
				}
				TimelineView(timeline: timeline, vInset: vInset)
			}
			.frame(height: (CGFloat(duration / 3600) * pixelsPerHour))
			.padding(5)
		}
		.frame(minHeight: 400)
	}
}

extension TimelineScreen {
	struct HourLabelsView: View {
		let start: Date
		let end: Date
		let vInset: CGFloat
		
		var body: some View {
			GeometryReader() { geo in
				let duration = end.timeIntervalSince(start)
				let pps = (geo.height - vInset * 2) / CGFloat(duration)
				let startTime = start.time
				let endTime = end.time
				let hours = startTime.allHours(until: endTime)
				
				ZStack(alignment: .top) {
					ForEach(hours) { hour in
						let offsetT = endTime.timeInterval(since: hour)
						let offsetY = vInset + CGFloat(offsetT) * pps
						
						Text("\(hour.hour)")
							.offset(x: 4, y: offsetY)
					}
				}
				.foregroundColor(.black)
				.font(.system(size: 9))
			}
		}
	}
}


extension TimelineScreen {
	struct TimelineView: View {
		let timeline: [Timeline.Entry]
		let vInset: CGFloat
		var body: some View {
			GeometryReader() { geo in
				let duration = timeline.duration
				let pps = (geo.height - vInset * 2) / CGFloat(duration)
				let last = timeline.endTime ?? Date()
				
				ZStack(alignment: .top) {
					ForEach(timeline) { entry in
						let offsetT = last.timeIntervalSince(entry.date)
						let offsetY = vInset + CGFloat(offsetT) * pps
						
						Rectangle()
							.frame(height: 1)
							.offset(x: 0, y: offsetY)
					}
				}
			}
		}
	}
}

struct TimelineScreen_Previews: PreviewProvider {
	static var previews: some View {
		TimelineScreen(timeline: [])
	}
}
