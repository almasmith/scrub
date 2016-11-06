//
//  MockRecordingDownloader.swift
//  scrub
//
//  Created by Jason Smith on 11/5/16.
//  Copyright © 2016 Jason Smith. All rights reserved.
//

import Foundation

class MockRecordingDownloader: RecordingDownloader {
  
  // In production, these two functions may do very different things.
  // Such as hit different endpoints, use different query strings, etc...
  // For now, they just do the same thing.
  func downloadEvents(for cameraID: String, completion: @escaping (Data?, Error?) -> Void) {
    retrieveContents(for: cameraID, type: "events", completion: completion)
  }
  
  func downloadRecordings(for cameraID: String, completion: @escaping (Data?, Error?) -> Void) {
    retrieveContents(for: cameraID, type: "recordings", completion: completion)
  }
  
  private func retrieveContents(for cameraID: String?, type: String, completion: (Data?, Error?) -> Void) {
    guard cameraID == "10" || cameraID == "12" else {
      completion(nil, RecordingDownloadError.invalidCamera)
      return
    }
    
    let fileName = "\(type)-camera-\(cameraID)"
    
    guard let url = Bundle.main.url(forResource: fileName, withExtension: "txt") else {
      completion(nil, RecordingDownloadError.couldNotFindFile)
      return
    }
    
    guard let data = try? Data(contentsOf: url) else {
      completion(nil, RecordingDownloadError.couldNotReadFile)
      return
    }
    
    completion(data, nil)
  }
}
