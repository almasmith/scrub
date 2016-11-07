//
//  Recording.swift
//  scrub
//
//  Created by Jason Smith on 11/5/16.
//  Copyright © 2016 Jason Smith. All rights reserved.
//

import Foundation

class Recording: Recordable {
  var id: String
  unowned var device: CaptureDevice
  var startTime: Date
  var endTime: Date
  var events: [Recordable] = []
  
  init(id: String, device: CaptureDevice, startTime: Date, endTime: Date) {
    self.id = id
    self.device = device
    self.startTime = startTime
    self.endTime = endTime
  }
  
  var duration: TimeInterval {
    return endTime.timeIntervalSince(startTime)
  }
}
