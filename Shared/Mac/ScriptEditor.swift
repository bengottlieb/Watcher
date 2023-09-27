//
//  ScriptEditor.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/11/21.
//

import SwiftUI
import Suite
import Combine

@available(macOS 12.0, *)
@MainActor struct ScriptEditor: View {
	@State var cancellables = Set<AnyCancellable>()
	@State var scriptCancellable: AnyCancellable?
	@State var script = ScriptRunner.Command.chromeCurrentTab.script
	@State var command = ScriptRunner.Command.chromeCurrentTab
	@State var result = ""
	@State var error: Error?
	@State var isRunning = false
	@State var runTime: TimeInterval?
	
	func run() async {
		error = nil
		result = ""
		isRunning = true
		let startedAt = Date()
		
		do {
			result = try await ScriptRunner.instance.run(script: script)
		} catch {
			self.error = error
		}
		isRunning = false
		runTime = abs(startedAt.timeIntervalSinceNow)
	}

	var body: some View {
		VStack() {
			Picker("Command", selection: $command.onChange { command in
				script = command.script
				Task { await run() }
			}) {
				ForEach(ScriptRunner.Command.allCases) { command in
					Text(command.title).tag(command)
				}
			}
			TextEditor(text: $script)
			if let runTime = runTime {
				Text(runTime.durationString(style: .milliseconds))
					.font(.caption)
			}
			AsyncButton(action: run) {
				Text("Run")
			}
			Text("Result")
			Text(result)
				.frame(minHeight: 100)
			if let err = error {
				Text("Error")
				Text(err.localizedDescription)
			}
		}
	}
}

@available(macOS 12.0, *)
struct ScriptEditor_Previews: PreviewProvider {
    static var previews: some View {
        ScriptEditor()
    }
}
