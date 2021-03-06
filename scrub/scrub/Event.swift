//
//  Event.swift
//  scrub
//
//  Created by Jason Smith on 11/5/16.
//  Copyright © 2016 Jason Smith. All rights reserved.
//

import Foundation

class Event: Recordable {
  var id: String
  unowned var device: CaptureDevice
  var startTime: Date
  var endTime: Date
  var duration: TimeInterval
  
  init(id: String, device: CaptureDevice, startTime: Date, endTime: Date, duration: TimeInterval) {
    self.id = id
    self.device = device
    self.startTime = startTime
    self.endTime = endTime
    self.duration = duration
  }
}
