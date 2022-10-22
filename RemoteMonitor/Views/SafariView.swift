//
//  SafariView.swift
//  Monitor
//
//  Created by Ben Gottlieb on 10/16/21.
//

import SwiftUI
import SafariServices
import Suite

struct SafariView: View {
	let url: URL
	
	var body: some View {
		SafariControllerView(url: url)
			.navigationBarHidden(true)
		
	}
}

struct SafariControllerView: UIViewControllerRepresentable {
	@Environment(\.presentationMode) var presentationMode
	let url: URL
	
	func makeUIViewController(context: UIViewControllerRepresentableContext<SafariControllerView>) -> SFSafariViewController {
		context.coordinator.controller
	}
	
	func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariControllerView>) {
		
	}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(url: url, presentationMode: presentationMode)
	}
	
	class Coordinator: NSObject, SFSafariViewControllerDelegate {
		let controller: SFSafariViewController
		let presentationMode: Binding<PresentationMode>
		
		init(url: URL, presentationMode present: Binding<PresentationMode>) {
			controller = SFSafariViewController(url: url)
			presentationMode = present
			super.init()
			controller.delegate = self
		}
		
		func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
			presentationMode.wrappedValue.dismiss()
		}
	}
	
}
