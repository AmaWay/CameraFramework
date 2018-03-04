//
//  CameraViewController.swift
//  CameraFramework
//
//  Created by Izabela on 04/03/2018.
//  Copyright © 2018 AmaWay. All rights reserved.
//

import UIKit
import AVFoundation


public enum CameraPosition {
  case front
  case back
}

public final class CameraViewController: UIViewController {
  public var position: CameraPosition = .back
  
  var session = AVCaptureSession()
  var discoverySession: AVCaptureDevice.DiscoverySession? {
    
    return AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
  }
  
  var videoInput: AVCaptureDeviceInput?
  
  var videoOutput = AVCaptureVideoDataOutput()
  
  public init() {
    super.init(nibName: nil, bundle: nil)

  }
  
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    createUI()
    commitConfiguration()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override public func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func createUI(){
    self.view.layer.addSublayer(getPreviewLayer(session: self.session))
  }
  
  func commitConfiguration(){
    if let currectInput = self.videoInput {
      self.session.removeInput(currectInput)
      self.session.removeOutput(self.videoOutput)
    }
    
    do {
      guard let device = getDevide(with: self.position == .front ? AVCaptureDevice.Position.front : AVCaptureDevice.Position.back) else {
        return
      }
      let input = try AVCaptureDeviceInput(device: device)
      
      if self.session.canAddInput(input) && self.session.canAddOutput(self.videoOutput) {
        self.videoInput = input
        self.session.addInput(input)
        self.session.addOutput(self.videoOutput)
        self.session.commitConfiguration()
        self.session.startRunning()
      }
      
    } catch {
      print ("Error linking device to AVInput!")
      return
    }
  }
  
  func getPreviewLayer(session: AVCaptureSession) -> AVCaptureVideoPreviewLayer {
    let previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
    previewLayer.frame = self.view.bounds
    previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
    return previewLayer
  }
  
  func getDevide(with position: AVCaptureDevice.Position) -> AVCaptureDevice? {
    guard let discoverySession = self.discoverySession
      else {
        return nil
    }
    for device in discoverySession.devices {
      if device.position ==
        position {
        return device
      }
      
    }
    
    return nil
  }
  
}
