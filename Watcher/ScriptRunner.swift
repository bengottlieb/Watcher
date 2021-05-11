//
//  ScriptRunner.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/10/21.
//

import Foundation
import Combine

class ScriptRunner {
    // osascript -e 'tell application "Safari" to get URL of current tab of front window'
    
    static let instance = ScriptRunner()
    enum ScriptError: Error { case noOSAScriptFOund }

    var cancellables = Set<AnyCancellable>()
    init() {
        Process.which("osascript")
            .sink { completion in
                switch completion {
                case .failure(let err):
                    print(err)
                default: break
                }
            } receiveValue: { path in
                print("Found osascript: \(path)")
                self.osascriptPath.send(path)
            }
            .store(in: &cancellables)
    }
    
    var osascriptPath = CurrentValueSubject<String, Never>("")
    
    func run(script: String) -> AnyPublisher<Data, Error> {
      guard osascriptPath.value != "" else { return Fail(outputType: Data.self, failure: <#T##_#>)}
        return osascriptPath
            .filter { $0 != "" }
            .flatMap() { path in
                Process(path: path, arguments: ["-e", "'\(script)'"])
                    .publisher()
            }
            .eraseToAnyPublisher()
        
    }
}
