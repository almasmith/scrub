//
//  DeviceOrganizer.swift
//  scrub
//
//  Created by Jason Smith on 11/6/16.
//  Copyright © 2016 Jason Smith. All rights reserved.
//

import Foundation

// Organizes the recordings and events for a device
class DeviceOrganizer {
  let maxDeadSpace: Double = 1
  
  func organize(device: CaptureDevice) {
    device.recordings.sort { $0.startTime < $1.startTime }
    device.events.sort { $0.startTime < $1.startTime }
    addEventsToRecordings(for: device)
    addGapsToRecordings(for: device)
  }
  
  private func addEventsToRecordings(for device: CaptureDevice) {
    var recordingIndex = 0
    var eventIndex = 0
    var orphanedEvents = [Recordable]()
    
    while eventIndex < device.events.count {
      let event = device.events[eventIndex]
      let recording = device.recordings[recordingIndex] as! Recording
      
      // event is before any recordings
      guard event.startTime >= recording.startTime else {
        orphanedEvents.append(event)
        eventIndex += 1
        continue
      }
      
      // event is after this recording
      guard event.startTime <= recording.endTime else {
        recordingIndex += 1
        
        // no more recordings
        guard recordingIndex < device.recordings.count else {
          break
        }
        
        continue
      }
      
      recording.events.append(event)
      eventIndex += 1
    }
    
    if eventIndex < device.events.endIndex - 1 {
      orphanedEvents.append(contentsOf: device.events[eventIndex..<device.events.endIndex])
    }
    
    // TODO: Do something with orphaned events
  }
  
  private func addGapsToRecordings(for device: CaptureDevice) {
    var recordingsWithGaps = [Recordable]()
    
    for (index, thisRecording) in device.recordings.enumerated() {
      let nextIndex = index + 1
      
      // exit on last item
      guard nextIndex < device.recordings.endIndex else {
        recordingsWithGaps.append(thisRecording)
        break
      }
      
      let nextRecording = device.recordings[nextIndex]
      let thisEnd = thisRecording.endTime.timeIntervalSince1970
      let nextStart = nextRecording.startTime.timeIntervalSince1970
      
      recordingsWithGaps.append(thisRecording)
      
      // if more than a second, add gap in timeline
      if nextStart - thisEnd > maxDeadSpace {
        let gapStart = Date(timeIntervalSince1970: thisEnd + 1)
        let gapEnd = Date(timeIntervalSince1970: nextStart - 1)
        let gap = RecordingGap(id: UUID().uuidString, device: device, startTime: gapStart, endTime: gapEnd)
        recordingsWithGaps.append(gap)
      }
    }
    
    device.recordings = recordingsWithGaps
  }
}
