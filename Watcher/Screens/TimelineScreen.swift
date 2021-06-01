//
//  TimelineScreen.swift
//  Watcher
//
//  Created by Ben Gottlieb on 6/1/21.
//

import SwiftUI

struct TimelineScreen: View {
  let timeline: [Timeline.Entry]
  
  var body: some View {
    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
  }
}

struct TimelineScreen_Previews: PreviewProvider {
  static var previews: some View {
    TimelineScreen(timeline: [])
  }
}
