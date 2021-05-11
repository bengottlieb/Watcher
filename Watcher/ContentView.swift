//
//  ContentView.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/10/21.
//

import SwiftUI
import Combine

struct ContentView: View {
	
	var body: some View {
		if #available(macOS 11.0, *) {
			ScriptEditor()
				.padding()
		} else {
			Text("Unsupported OS")
		}
	}
}


struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
