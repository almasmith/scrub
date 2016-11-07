//
//  DataProcessor.swift
//  scrub
//
//  Created by Jason Smith on 11/5/16.
//  Copyright © 2016 Jason Smith. All rights reserved.
//

import Foundation

// The contract for a data processor
protocol DataProcessor {
  func process(data: Data, for device: CaptureDevice) throws
}

enum DataProcessingError: Error {
  case invalidJSON
  case invalidKey
}
