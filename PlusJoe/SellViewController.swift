//
//  SellViewController.swift
//  PlusJoe
//
//  Created by D on 6/7/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import Bolts


class SellViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    @IBOutlet weak var backNavButton: UIBarButtonItem!
    
    @IBAction func backButtonAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet weak var camView: UIView!
    let session = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    var  identifiedBorder : DiscoveredQRCodeView?
    var timer : NSTimer?
    
    /* Add the preview layer here */
    func addPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer?.bounds = self.camView.bounds
        previewLayer?.position = CGPointMake(CGRectGetMidX(self.camView.bounds), CGRectGetMidY(self.camView.bounds))
        self.camView.layer.addSublayer(previewLayer!)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if(registerUserIfNecessery(self) == true) {
            
            let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
            var error : NSError?
            let inputDevice: AVCaptureDeviceInput!
            do {
                inputDevice = try AVCaptureDeviceInput(device: captureDevice)
            } catch let error1 as NSError {
                error = error1
                inputDevice = nil
            }
            
            if let inp = inputDevice {
                session.addInput(inp)
            } else {
                print(error)
            }
            addPreviewLayer()
            
            identifiedBorder = DiscoveredQRCodeView(frame: self.camView.bounds)
            identifiedBorder?.backgroundColor = UIColor.clearColor()
            identifiedBorder?.hidden = true;
            self.camView.addSubview(identifiedBorder!)
            
            
            /* Check for metadata */
            let output = AVCaptureMetadataOutput()
            session.addOutput(output)
            output.metadataObjectTypes = output.availableMetadataObjectTypes
            print(output.availableMetadataObjectTypes)
            output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            session.startRunning()
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        backNavButton.title = "\u{f053}"
        if let font = UIFont(name: "FontAwesome", size: 20) {
            backNavButton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        session.stopRunning()
    }
    
    
    func translatePoints(points : [AnyObject], fromView : UIView, toView: UIView) -> [CGPoint] {
        var translatedPoints : [CGPoint] = []
        for point in points {
            let dict = point as! NSDictionary
            let x = CGFloat((dict.objectForKey("X") as! NSNumber).floatValue)
            let y = CGFloat((dict.objectForKey("Y") as! NSNumber).floatValue)
            let curr = CGPointMake(x, y)
            let currFinal = fromView.convertPoint(curr, toView: toView)
            translatedPoints.append(currFinal)
        }
        return translatedPoints
    }
    
    func startTimer() {
        if timer?.valid != true {
            timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "removeBorder", userInfo: nil, repeats: false)
        } else {
            timer?.invalidate()
        }
    }
    
    func removeBorder() {
        /* Remove the identified border */
        self.identifiedBorder?.hidden = true
    }
    
    
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        for data in metadataObjects {
            let metaData = data as! AVMetadataObject
            let transformed = previewLayer?.transformedMetadataObjectForMetadataObject(metaData) as? AVMetadataMachineReadableCodeObject
            if let unwraped = transformed {
                identifiedBorder?.frame = unwraped.bounds
                identifiedBorder?.hidden = false
                let identifiedCorners = self.translatePoints(unwraped.corners, fromView: self.camView, toView: self.identifiedBorder!)
                identifiedBorder?.drawBorder(identifiedCorners)
                self.identifiedBorder?.hidden = false
                self.startTimer()
            }
            
            print(transformed?.stringValue!)
            if (transformed?.stringValue!.beginsWith("plusjoe://") != nil) {
                
                // there is no need to check the code here, let's check it in handleIncomingUrl() because there are potentially 2 different ways to enter the app, one here, and one from scanning the QR code with an external scanner
                
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    NSLog("$$$$$$$$$$$$$$$ navigating in background to \((transformed?.stringValue)!)")
                    
                    let nsUrl:NSURL = NSURL(string: (transformed?.stringValue)!)!
                    let bfUrl:BFURL = BFURL(URL: nsUrl)

                    handleIncomingPurchaseUrl(bfUrl)
                })
            }
        }
    }
    
}
