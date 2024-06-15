//
//  String+ArrayExtraction.swift
//  
//
//  Created by Ben Gottlieb on 6/15/24.
//

import Foundation

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
	
	var oneDArray: [String]? {
		guard let data = bracketize.data(using: .utf8) else { return nil }
		
		do {
			return try JSONDecoder().decode([String].self, from: data)
		} catch {
			print("Failed to decode a 1D string array: \(error)")
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
