//
//  RecordingDownloader.swift
//  scrub
//
//  Created by Jason Smith on 11/5/16.
//  Copyright © 2016 Jason Smith. All rights reserved.
//

import Foundation

protocol RecordingDownloader {
  func downloadRecordings(for device: CaptureDevice, completion: @escaping (Data?, Error?) -> Void)
  func downloadEvents(for device: CaptureDevice, completion: @escaping (Data?, Error?) -> Void)
}

enum RecordingDownloadError: Error {
  case invalidCaptureDevice
  case couldNotFindFile
  case couldNotReadFile

}
