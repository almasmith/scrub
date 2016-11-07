//
//  ScrubSegmentCell.swift
//  scrub
//
//  Created by Jason Smith on 11/6/16.
//  Copyright © 2016 Jason Smith. All rights reserved.
//

import UIKit

class ScrubSegmentCell: UICollectionViewCell {
  @IBOutlet var timeline: UIView!
  
  var sizePerSecond: Double = 0.05
  var eventLayers = [CALayer]()
  
  var recording: Recording! {
    didSet {
      if recording is RecordingGap {
        timeline.backgroundColor = UIColor.black
      } else {
        timeline.backgroundColor = UIColor.white
      }
      
      addEvents()
    }
  }
  
  private func addEvents() {
    for layer in eventLayers {
      layer.removeFromSuperlayer()
    }
    
    eventLayers.removeAll()
    
    for event in recording.events {
      let width = event.duration * sizePerSecond
      let recordingStart = recording.startTime.timeIntervalSince1970
      let eventStart = event.startTime.timeIntervalSince1970
      let x = (eventStart - recordingStart) * sizePerSecond
      
      let eventLayer = CALayer()
      eventLayer.frame = CGRect(x: x, y: 29, width: width, height: 20)
      eventLayer.backgroundColor = UIColor.white.cgColor
      contentView.layer.addSublayer(eventLayer)
      eventLayers.append(eventLayer)
    }
  }
}
