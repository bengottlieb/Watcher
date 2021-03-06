//
//  ScriptEditor.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/11/21.
//

import SwiftUI
import Suite
import Combine

@available(macOS 11.0, *)
struct ScriptEditor: View {
	@State var cancellables = Set<AnyCancellable>()
	@State var scriptCancellable: AnyCancellable?
	@State var script = ScriptRunner.Command.chromeCurrentTab.script
	@State var command = ScriptRunner.Command.chromeCurrentTab
	@State var result = ""
	@State var error: Error?
	@State var isRunning = false
	@State var runTime: TimeInterval?
	
	func run() {
		error = nil
		result = ""
		isRunning = true
		let startedAt = Date()
		
		scriptCancellable = ScriptRunner.instance.run(script: script)
			.sink { completion in
				isRunning = false
				runTime = abs(startedAt.timeIntervalSinceNow)
				switch completion {
				case .failure(let err):
					self.error = err
				default:
					break
				}
			} receiveValue: { result in
				self.result = result
			}

	}

	var body: some View {
		VStack() {
			Picker("Command", selection: $command.onChange { command in
				script = command.script
				run()
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
			Button(action: run) {
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

@available(macOS 11.0, *)
struct ScriptEditor_Previews: PreviewProvider {
    static var previews: some View {
        ScriptEditor()
    }
}
