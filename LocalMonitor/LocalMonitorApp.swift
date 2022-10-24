//
//  LocalMonitorApp.swift
//  LocalMonitor
//
//  Created by Ben Gottlieb on 10/22/22.
//

import SwiftUI

@main
struct LocalMonitorApp: App {
	init() {
		DispatchQueue.main.async {
			MenuItem.instance.setup()
		}
	}

	var body: some Scene {
		WindowGroup {
			ContentView()
		}
	}
}
