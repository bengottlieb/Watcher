//
//  Process+Extensions.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/10/21.
//

import Foundation
import Combine

extension Process {
    enum ProcessError: Error { case systemResult(String) }
    class func which(_ name: String) -> AnyPublisher<String, Error> {
        Process(path: "/usr/bin/which", arguments: [name])
            .publisher()
            .map { data in
                String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            }
            .eraseToAnyPublisher()
    }
    
    convenience init(path: String, arguments args: [String]) {
        self.init()
        launchPath = path
        arguments = args
    }
    
    var launchURL: URL { URL(fileURLWithPath: self.launchPath ?? "") }
    
    func publisher() -> AnyPublisher<Data, Error> {
        return Future { promise in
            DispatchQueue.global(qos: .userInitiated).async {
                let outputPipe = Pipe()
                let errorPipe = Pipe()

                self.standardOutput = outputPipe
                self.standardError = errorPipe
                
                do {
                    try self.run()
                    self.waitUntilExit()

                    let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
                    let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()

                    if !outputData.isEmpty {
                        promise(.success(outputData))
                    } else if !errorData.isEmpty {
                        let errorString = String(data: errorData, encoding: .utf8) ?? "Error when running \(self.launchURL.lastPathComponent)"
                        promise(.failure(ProcessError.systemResult(errorString)))
                    } else {
                        promise(.success(outputData))
                    }
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
