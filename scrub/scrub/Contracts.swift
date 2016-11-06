//
//  Contracts.swift
//  scrub
//
//  Created by Jason Smith on 11/5/16.
//  Copyright © 2016 Jason Smith. All rights reserved.
//

import Foundation

protocol Identity {
  var id: String { get }
}

protocol CaptureDevice: Identity {
  var name: String { get }
  var recordings: [Recordable] { get }
}

protocol Recordable: Identity {
  var device: CaptureDevice { get }
  var startTime: Date { get }
  var endTime: Date { get }
  var duration: TimeInterval { get }
}

protocol Eventful {
  var events: [Recordable] { get }
}
