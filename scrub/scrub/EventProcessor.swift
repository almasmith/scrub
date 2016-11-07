//
//  EventProcessor.swift
//  scrub
//
//  Created by Jason Smith on 11/6/16.
//  Copyright © 2016 Jason Smith. All rights reserved.
//

import Foundation

/// Processes event json data for a device.
class EventProcessor: DataProcessor {
  func process(data: Data, for device: CaptureDevice) throws {
    guard let json = try? JSONSerialization.jsonObject(with: data) as! [String: [[String: Any]]] else {
      throw DataProcessingError.invalidJSON
    }
    
    guard let eventsData = json["Events"] else {
      throw DataProcessingError.invalidKey
    }
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    for eventData in eventsData {
      let id = eventData["id"]! as! String
      let duration = eventData["dur"]! as! Double
      
      let startString = eventData["start"]! as! String
      let startDate = dateFormatter.date(from: startString)!
      
      let endString = eventData["end"]! as! String
      let endDate = dateFormatter.date(from: endString)!
      
      let event = Event(id: id, device: device, startTime: startDate, endTime: endDate, duration: duration)
      device.events.append(event)
    }
  }
}
