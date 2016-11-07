//
//  ViewController.swift
//  scrub
//
//  Created by Jason Smith on 11/5/16.
//  Copyright © 2016 Jason Smith. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var dateLabel: UILabel!
  
  var dataManager: DataManager!
  var currentDevice: CaptureDevice! {
    didSet {
      let firstRecording = currentDevice.recordings.first!
      let lastRecording = currentDevice.recordings.last!
      startTime = firstRecording.startTime.timeIntervalSince1970
      endTime = lastRecording.endTime.timeIntervalSince1970
    }
  }
  
  var startTime: TimeInterval!
  var endTime: TimeInterval!
  var dateFormatter = DateFormatter()
  
  let sizePerSecond: Double = 0.05

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    dataManager = DataManager(downloader: MockRecordingDownloader(), recordingProcessor: RecordingProcessor(), eventProcessor: EventProcessor(), deviceOrganizer: DeviceOrganizer())
    dataManager.populateRecordings {
      success, error in
      self.collectionView.reloadData()
    }
    
    if let device = dataManager.devices.first {
      currentDevice = device
    }
    
    dateFormatter.dateFormat = "MMM dd HH:mm:ss"
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func didTapCamera10(_ sender: UIButton) {
    let device = dataManager.devices[0]
    if currentDevice !== device {
      currentDevice = device
      collectionView.reloadData()
    }
  }
  
  @IBAction func didTapCamera12(_ sender: UIButton) {
    let device = dataManager.devices[1]
    if currentDevice !== device {
      currentDevice = device
      collectionView.reloadData()
    }
  }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return currentDevice.recordings.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "scrubSegment", for: indexPath) as! ScrubSegmentCell
    cell.recording = currentDevice.recordings[indexPath.item] as! Recording
    cell.sizePerSecond = sizePerSecond
    
    return cell
  }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let recording = currentDevice.recordings[indexPath.item]
    let width = recording.duration * sizePerSecond
    let size = CGSize(width: width, height: 100)
    
    return size
  }
}

extension ViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let contentWidth = scrollView.contentSize.width
    let currentOffset = scrollView.contentOffset.x
    let ratio = Double(currentOffset / contentWidth)
    let timeRange = endTime - startTime
    let currentTime = timeRange * ratio + startTime
    let date = Date(timeIntervalSince1970: currentTime)
    dateLabel.text = dateFormatter.string(from: date)
  }
}
