//
//  ModelProtocols.swift
//  scrub
//
//  Created by Jason Smith on 11/5/16.
//  Copyright © 2016 Jason Smith. All rights reserved.
//

import Foundation

protocol Identity {
  var id: String { get }
}

protocol CaptureDevice: class, Identity {
  var name: String { get }
  var recordings: [Recordable] { get set }
  var events: [Recordable] { get set }
}

protocol Recordable: Identity {
  var device: CaptureDevice { get }
  var startTime: Date { get }
  var endTime: Date { get }
  var duration: TimeInterval { get }
}
