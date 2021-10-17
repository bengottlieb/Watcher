//
//  HistoryBrowserRow.swift
//  Watcher
//
//  Created by Ben Gottlieb on 10/15/21.
//

import SwiftUI

struct HistoryBrowserRow: View {
	let entry: Timeline.Entry
    var body: some View {
			if let urls = entry.tabURLs {
				VStack(alignment: .leading) {
					DateLine(date: entry.date, labelType: entry.dateLabel)
					ForEach(urls) { browserURL in
						if let title = browserURL.title {
							Text(title)
						}
						Text(browserURL.url.absoluteString)
							.padding(5)
							.overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 0.5))
							.padding(2)
					}
				}
				.frame(maxWidth: .infinity, alignment: .leading)
				Divider()
			}
    }
}
//
//struct HistoryBrowserRow_Previews: PreviewProvider {
//    static var previews: some View {
//        HistoryBrowserRow()
//    }
//}
