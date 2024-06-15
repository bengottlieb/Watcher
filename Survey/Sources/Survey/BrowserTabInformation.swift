//
//  BrowserTabInformation.swift
//  Survey
//
//  Created by Ben Gottlieb on 6/14/24.
//

import Foundation
import Suite

public struct BrowserTabInformation: Codable, Hashable, Equatable {
	public let url: URL
	public let title: String?
	public let browser: BrowserKind
}

enum BrowserTabInformationError: Error {
	case incorrectDataFormat
	case missingNameOrURLComponents
	case urlNameCountMismatch
	case unableToExtract3DStringArray
	case incorrectNumberOfTabComponents
}

extension [BrowserTabInformation] {
	var names: String {
		compactMap { $0.title }.joined(separator: ", ")
	}
	
	init(safariNamesAndURLsByWindow raw: String) throws {
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
	
	init(safariNamesAndURLs raw: String) throws {
		guard let arrays = raw.twoDArray else { throw BrowserTabInformationError.unableToExtract3DStringArray }
		let names = arrays[0]
		let urls = arrays[1]
		
		if names.count != urls.count { throw BrowserTabInformationError.urlNameCountMismatch }
		
		self = zip(names, urls).compactMap { name, raw in
			guard let url = URL(string: raw) else { return nil }
			return BrowserTabInformation(url: url, title: name, browser: .safari)
		}
	}
	
	init(safariTabNameAndURL raw: String) throws {
		guard let parts = raw.oneDArray else { throw BrowserTabInformationError.incorrectDataFormat }
		
		if parts.count != 2 { throw BrowserTabInformationError.incorrectNumberOfTabComponents }
		
		if let url = URL(string: parts[0]) {
			self = [BrowserTabInformation(url: url, title: parts[1], browser: .safari)]
		} else {
			self = []
		}
	}
}

