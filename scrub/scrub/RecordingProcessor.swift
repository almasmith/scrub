//
//  RecordingProcessor.swift
//  scrub
//
//  Created by Jason Smith on 11/6/16.
//  Copyright © 2016 Jason Smith. All rights reserved.
//

import Foundation

/// Processes recording json data for a device.
class RecordingProcessor: DataProcessor {
  private let microsInSecond: Double = 1000000
  
  func process(data: Data, for device: CaptureDevice) throws {
    guard let json = try? JSONSerialization.jsonObject(with: data) as! [String: [[String: Double]]] else {
      throw DataProcessingError.invalidJSON
    }
    
    guard let recordingsData = json["Ranges"] else {
      throw DataProcessingError.invalidKey
    }
    
    for recordingData in recordingsData {
      let startTime = recordingData["StartTime"]! / microsInSecond
      let startDate = Date(timeIntervalSince1970: startTime)
      
      let endTime = recordingData["EndTime"]! / microsInSecond
      let endDate = Date(timeIntervalSince1970: endTime)
      
      let recording = Recording(id: UUID().uuidString, device: device, startTime: startDate, endTime: endDate)
      device.recordings.append(recording)
    }
  }
}
