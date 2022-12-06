//
//  HostRow.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/14/21.
//

import SwiftUI
import Suite

struct HostRow: View {
  @ObservedObject var host: NearbyHost
  @State var frontAppImage: UIImage?
  
  var body: some View {
    
    HStack() {
      if let image = frontAppImage {
        Image(uiImage: image)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(50)
      } else {
        Image(systemName: "laptopcomputer")
      }
      VStack(alignment: .leading) {
        Text(host.name)
          .font(.title)
        Text(host.state.description)
          .font(.body)
        if let current = host.currentTimelineEntry {
          Text(current.description)
            .multilineTextAlignment(.leading)
            .font(.caption)
        }
        
        Text(host.lastUpdatedAt.localTimeString(date: .none, time: .short))
          .font(.caption)
      }
      
      Spacer()
      
      if host.isRefreshing {
        ProgressView()
      } else {
        Button(action: refresh) {
          Image(.arrow_clockwise)
            .padding()
        }
      }
      
    }
    .addSwipeActions(trailing: killButton, id: host.deviceID)
	 .task {
		 do {
			 if let ident = host.frontmostAppIdentifier, let device = host.device {
				 frontAppImage = try await IconImagesCache.instance.fetchImage(for: ident, from: device)
			 }
		 } catch {
			 
		 }
	 }
  }
  
  func refresh() {
    host.refresh()
  }
  
  var killButton: some View {
    Button(action: sendQuit) {
      Text("Force\nQuit")
        .foregroundColor(.white)
        .padding(10)
        .background(Color.red)
        .multilineTextAlignment(.center)
    }
  }
  
  func sendQuit() {
    host.device?.send(message: TerminateMessage())
  }
}

