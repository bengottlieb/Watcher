//
//  HostDetailScreen.swift
//  Monitor
//
//  Created by Ben Gottlieb on 10/16/21.
//

import SwiftUI

struct HostDetailScreen: View {
	let host: NearbyHost
	
	var body: some View {
		VStack() {
			Text(host.name)
		}
		.onAppear() {
			
		}
	}
}

//struct HostDetailScreen_Previews: PreviewProvider {
//	static var previews: some View {
//		HostDetailScreen()
//	}
//}
