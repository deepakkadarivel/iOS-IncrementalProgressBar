//
//  ViewController.swift
//  IncrementalProgressBar
//
//  Created by Deepak Kadarivel on 29/01/16.
//  Copyright © 2016 upbeatios. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NSURLSessionDownloadDelegate {

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var progressView: ProgressView!
    @IBOutlet weak var downloadButton: DownloadButton!
    
    private var downloadTask:  NSURLSessionDownloadTask!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        statusLabel.text = ""
        addBackgroundGradientLayer()
    }
    
    @IBAction func downloadButtonPressed(sender: AnyObject) {
        if let downloadTask = downloadTask {
            statusLabel.text = ""
            downloadTask.cancel()
        } else {
            statusLabel.text = "Downloading Video"
            downloadButton.setTitle("Stop Download", forState: .Normal)
            createDownloadTask()
        }
    }
    
    func createDownloadTask() {
        let downloadRequest = NSMutableURLRequest(URL: NSURL(string: "https://www.dropbox.com/s/r6lr4zlw12ipafm/SpeedTracker_movie.mov?dl=1")!)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        downloadTask = session.downloadTaskWithRequest(downloadRequest)
        downloadTask.resume()
    }

    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        progressView.animateProgressViewToProgress(progress)
        progressView.updateProgressViewLabelWithProgress(progress * 100)
        progressView.updateProgressViewWith(Float(totalBytesWritten), totalFileSize: Float(totalBytesExpectedToWrite))
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        statusLabel.text = "Download finished"
        
        resetView()
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if let error = error {
            statusLabel.text = "Download failed"
        } else {
            statusLabel.text = "Download finished"
        }
        resetView()
    }
    
    func resetView() {
        downloadButton.setTitle("Start download", forState: .Normal)
        downloadTask!.cancel()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return.LightContent
    }
    
    func addBackgroundGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.frame
        
        let colorTop: AnyObject = UIColor(red: 73.0/255.0, green: 233.0/255.0, blue: 185.0/255, alpha: 1.0).CGColor
        let colorBottom: AnyObject = UIColor(red: 36.0/255.0, green: 115.0/255.0, blue: 192.0/255.0, alpha: 1.0).CGColor
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        
        view.layer.insertSublayer(gradientLayer, atIndex: 0)
    }

}

