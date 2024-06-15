//
//  BrowserTabInformation.swift
//  Survey
//
//  Created by Ben Gottlieb on 6/14/24.
//

import Foundation
import Suite

public struct BrowserTabInformation: Codable {
	public let url: URL
	public let title: String?
	public let browser: BrowserKind
}

enum BrowserTabInformationError: Error {
	case missingNameOrURLComponents
	case urlNameCountMismatch
	case unableToExtract3DStringArray
}

extension [BrowserTabInformation] {
	init(allSafariTabs raw: String) throws {
		guard let arrays = raw.threeDArray else { throw BrowserTabInformationError.unableToExtract3DStringArray }
		var tabs: [BrowserTabInformation] = []
		
		if arrays.count != 2 {
			throw BrowserTabInformationError.missingNameOrURLComponents
		}
		
		let allNames = arrays[0]
		let allUrls = arrays[1]
		
		if allNames.count != allUrls.count { throw BrowserTabInformationError.urlNameCountMismatch }
		
		for (names, urls) in zip(allNames, allUrls) {
			if names.count != urls.count { throw BrowserTabInformationError.urlNameCountMismatch }
			tabs += zip(names, urls).compactMap { name, raw in
				guard let url = URL(string: raw) else { return nil }
				return BrowserTabInformation(url: url, title: name, browser: .safari)
			}
		}
		
		self = tabs
	}
	
	init(currentSafariTabs raw: String) throws {
		guard let arrays = raw.twoDArray else { throw BrowserTabInformationError.unableToExtract3DStringArray }
		let names = arrays[0]
		let urls = arrays[1]
		
		if names.count != urls.count { throw BrowserTabInformationError.urlNameCountMismatch }
		
		self = zip(names, urls).compactMap { name, raw in
			guard let url = URL(string: raw) else { return nil }
			return BrowserTabInformation(url: url, title: name, browser: .safari)
		}
	}
}

extension String {
	var scriptedArrayElements: [String] {
		trimmingCharacters(in: .init(charactersIn: "{")).components(separatedBy: "\", \"").map { $0.trimmingCharacters(in: .init(charactersIn: "\" ")) }
	}
	
	var bracketize: String {
		replacingOccurrences(of: "{", with: "[").replacingOccurrences(of: "}", with: "]")
	}
	
	var twoDArray: [[String]]? {
		guard let data = bracketize.data(using: .utf8) else { return nil }
		
		do {
			return try JSONDecoder().decode([[String]].self, from: data)
		} catch {
			print("Failed to decode a 2D string array: \(error)")
			return nil
		}
	}
	
	var threeDArray: [[[String]]]? {
		guard let data = bracketize.data(using: .utf8) else { return nil }
		
		do {
			return try JSONDecoder().decode([[[String]]].self, from: data)
		} catch {
			print("Failed to decode a 3D string array: \(error)")
			return nil
		}
	}
}
