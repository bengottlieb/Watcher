//
//  Messages.swift
//  Watcher
//
//  Created by Ben Gottlieb on 5/12/21.
//

import Foundation
import Nearby

class StatusMessage: NearbyMessage {
  var command = "Status"
}


class RequestStatusMessage: NearbyMessage {
  var command = "RequestStatus"
}
