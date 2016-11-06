//
//  DataManager.swift
//  scrub
//
//  Created by Jason Smith on 11/5/16.
//  Copyright © 2016 Jason Smith. All rights reserved.
//

import Foundation

// For this exercise I'm not storing any data locally, so this is just
// an in memory store of the data that will be used to create the timeline.
class DataManager {
  var downloader: RecordingDownloader
  var recordingProcessor: DataProcessor
  var eventProcessor: DataProcessor
  var devices: [CaptureDevice] = [Camera(id: "10", name: "camera-10"), Camera(id: "12", name: "camera-12")]
  
  init(downloader: RecordingDownloader, recordingProcessor: DataProcessor, eventProcessor: DataProcessor) {
    self.downloader = downloader
    self.recordingProcessor = recordingProcessor
    self.eventProcessor = eventProcessor
  }
  
  func populateRecordings(completion: @escaping (Bool, Error?) -> Void) {
    for device in devices {
      downloader.downloadRecordings(for: device) {
        data, error in
        guard let jsonData = data else {
          completion(false, error)
          return
        }
        
        self.recordingProcessor.process(data: jsonData, for: device)
        self.populateEvents(for: device, completion: completion)
      }
    }
  }
  
  func populateEvents(for device: CaptureDevice, completion: @escaping (Bool, Error?) -> Void) {
    downloader.downloadEvents(for: device) {
      data, error in
      guard let jsonData = data else {
        completion(false, error)
        return
      }
      
      self.eventProcessor.process(data: jsonData, for: device)
      completion(true, nil)
    }
  }
}
