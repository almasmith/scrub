//
//  DataManager.swift
//  scrub
//
//  Created by Jason Smith on 11/5/16.
//  Copyright © 2016 Jason Smith. All rights reserved.
//

import Foundation

// For this exercise I'm not storing any data locally, so this is just
// an in-memory store of the data that will be used to create the timeline.
class DataManager {
  var downloader: RecordingDownloader
  var recordingProcessor: DataProcessor
  var eventProcessor: DataProcessor
  var deviceOrganizer: DeviceOrganizer
  var devices: [CaptureDevice] = [Camera(id: "10", name: "camera-10"), Camera(id: "12", name: "camera-12")]
  
  init(downloader: RecordingDownloader, recordingProcessor: DataProcessor, eventProcessor: DataProcessor, deviceOrganizer: DeviceOrganizer) {
    self.downloader = downloader
    self.recordingProcessor = recordingProcessor
    self.eventProcessor = eventProcessor
    self.deviceOrganizer = deviceOrganizer
  }
  
  func populateRecordings(completion: @escaping (Bool, Error?) -> Void) {
    for device in devices {
      downloader.downloadRecordings(for: device) {
        data, error in
        guard let jsonData = data else {
          completion(false, error)
          return
        }
        
        do {
          try self.recordingProcessor.process(data: jsonData, for: device)
        }
        catch {
          completion(false, error)
        }
        
        self.populateEvents(for: device) {
          success, error in
          guard success else {
            completion(success, error)
            return
          }
          
          self.deviceOrganizer.organize(device: device)
          completion(success, error)
        }
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
      
      do {
        try self.eventProcessor.process(data: jsonData, for: device)
      }
      catch {
        completion(false, error)
      }
      
      completion(true, nil)
    }
  }
}
