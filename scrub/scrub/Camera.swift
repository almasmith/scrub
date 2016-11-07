//
//  Camera.swift
//  scrub
//
//  Created by Jason Smith on 11/5/16.
//  Copyright © 2016 Jason Smith. All rights reserved.
//

import Foundation

class Camera: CaptureDevice {
  var id: String
  var name: String
  var recordings: [Recordable] = []
  var events: [Recordable] = []
  
  init(id: String, name: String) {
    self.id = id
    self.name = name
  }
}
