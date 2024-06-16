//
//  AppDelegate.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/10/21.
//

import Cocoa
import SwiftUI
import Suite
import Survey

@main
class AppDelegate: NSObject, NSApplicationDelegate {
	override init() {
		SuiteLogger.instance.prefix = "𐃂"
		
		Task {
			await Surveyor.instance.setup()

			var sequence = await Surveyor.instance.recordedEvents().makeAsyncIterator()
			while let event = await sequence.next() {
				
				print("Event: \(event.description)")
			}
		}
		
		if !CommandLine.bool(for: "disableNearby") {
			OtherDevices.instance.setup(mode: .host)
		}
	}
	
	var window: NSWindow!
	
	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Create the SwiftUI view that provides the window contents.
		if Gestalt.isAttachedToDebugger {
			setupWindow()
		}
	}
	
	func setupWindow() {
		let contentView = ContentView()
		
		// Create the window and set the content view.
		window = NSWindow(
			contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
			styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
			backing: .buffered, defer: false)
		window.isReleasedWhenClosed = false
		window.center()
		window.setFrameAutosaveName("Main Window")
		window.contentView = NSHostingView(rootView: contentView)
		window.makeKeyAndOrderFront(nil)
	}
	
	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}
  
  var windows: [NSWindow] = []
	
  func application(_ application: NSApplication, open urls: [URL]) {
    for url in urls {
      do {
        let timeline = try [Timeline.Entry].loadJSON(file: url)
        DispatchQueue.main.async {
          let window = HostingWindow(root: TimelineScreen(timeline: timeline.sorted()), title: url.lastPathComponent)
          self.windows.append(window)
          window.makeKeyAndOrderFront(nil)
        }
      } catch {
			logg("Problem opening \(url.path): \(error)")
      }
    }
  }
}

