//
//  TimelineManager.Save.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/13/21.
//

import Foundation
import Suite

extension Timeline {
  
  var saveURL: URL {
    let dateString = Date().localTimeString(date: .abbr, time: .none).replacingOccurrences(of: "/", with: "-")
    let filename = dateString + ".txt"
    
    return directory.appendingPathComponent(filename)
  }
  
  func load() {
    let url = saveURL
    
    do {
      let data = try Data(contentsOf: url)
      timeline = try JSONDecoder().decode([Entry].self, from: data)
    } catch {
      logg(error: error, "Problem loading timeline")
    }
  }
  
  @objc func save() {
    let url = saveURL
    try? FileManager.default.removeItem(at: url)
    
    do {
      let json = try JSONEncoder().encode(timeline)
      try json.write(to: url)
    } catch {
      logg(error: error, "Problem saving timeline")
    }
    
    if url != lastSaveURL {
      lastSaveURL = url
      timeline = []
    }
  }
}
