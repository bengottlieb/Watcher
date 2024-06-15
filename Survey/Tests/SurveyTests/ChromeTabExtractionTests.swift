//
//  ChromeTabExtractionTests.swift
//  
//
//  Created by Ben Gottlieb on 6/14/24.
//

import XCTest

final class ChromeTabExtractionTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}


/*			Samples
 
 SCRIPT: All Tabs for Chrome
 {{"Neural engineering - Wikipedia", "osascript Man Page - macOS - SS64.com", "The Most Mind Blowing Chat GPT Prompts | by Antonis Iliakis | Generative AI"}, {"https://en.wikipedia.org/wiki/Neural_engineering", "https://ss64.com/mac/osascript.html", "https://generativeai.pub/the-most-mind-blowing-chat-gpt-prompts-de991ea5dd4d"}}

 SCRIPT END -----------------------------
 SCRIPT: Current Tab for Chrome
 Peer [athenas-arm-macbook-pro.local,0F4CD8E4] error in connectedHandler [Unable to connect].
 {{"Neural engineering - Wikipedia", "osascript Man Page - macOS - SS64.com", "The Most Mind Blowing Chat GPT Prompts | by Antonis Iliakis | Generative AI"}, {"https://en.wikipedia.org/wiki/Neural_engineering", "https://ss64.com/mac/osascript.html", "https://generativeai.pub/the-most-mind-blowing-chat-gpt-prompts-de991ea5dd4d"}}

 SCRIPT END -----------------------------
 SCRIPT: All Visible Tabs for Chrome
 {{"Neural engineering - Wikipedia", "osascript Man Page - macOS - SS64.com", "The Most Mind Blowing Chat GPT Prompts | by Antonis Iliakis | Generative AI"}, {"https://en.wikipedia.org/wiki/Neural_engineering", "https://ss64.com/mac/osascript.html", "https://generativeai.pub/the-most-mind-blowing-chat-gpt-prompts-de991ea5dd4d"}}

 SCRIPT END -----------------------------
 SCRIPT: All Front Tabs for Chrome
 {{"Neural engineering - Wikipedia", "osascript Man Page - macOS - SS64.com", "The Most Mind Blowing Chat GPT Prompts | by Antonis Iliakis | Generative AI"}, {"https://en.wikipedia.org/wiki/Neural_engineering", "https://ss64.com/mac/osascript.html", "https://generativeai.pub/the-most-mind-blowing-chat-gpt-prompts-de991ea5dd4d"}}

 SCRIPT END -----------------------------
 */
