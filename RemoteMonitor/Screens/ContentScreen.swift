//
//  ContentScreen.swift
//  Monitor
//
//  Created by Ben Gottlieb on 5/12/21.
//

import SwiftUI

struct ContentScreen: View {
	
	var testing = true
	var body: some View {
		NavigationView() {
			MonitoredDevicesScreen()
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentScreen(testing: true)
	}
}
