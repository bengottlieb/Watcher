//
//  HistoryBrowserRow.swift
//  Watcher
//
//  Created by Ben Gottlieb on 10/15/21.
//

import SwiftUI

struct HistoryBrowserRow: View {
	let entry: Timeline.Entry
	let next: Timeline.Entry?
	var browserKind: BrowserKind?
	
	var body: some View {
		if let urls = entry.tabURLs {
			HStack() {
				VStack(spacing: 2) {
					if let kind = browserKind {
						Image(kind.imageName)
							.resizable()
							.aspectRatio(contentMode: .fit)
							.frame(width: 30)
					}
					DurationText(from: entry, to: next)
						.font(.caption)
						.foregroundColor(.gray)
				}
				VStack(alignment: .leading) {
					DateLine(date: entry.date, labelType: entry.dateLabel)
					ForEach(urls) { browserURL in
						NavigationLink(destination: SafariView(url: browserURL.url)) {
							if let title = browserURL.title {
								Text(title)
							}
							Text(browserURL.url.absoluteString)
								.padding(5)
								.overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 0.5))
								.padding(2)
						}
					}
				}
				.frame(maxWidth: .infinity, alignment: .leading)
			}
		}
	}
}
//
//struct HistoryBrowserRow_Previews: PreviewProvider {
//    static var previews: some View {
//        HistoryBrowserRow()
//    }
//}
