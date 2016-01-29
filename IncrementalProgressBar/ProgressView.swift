//
//  ProgressView.swift
//  IncrementalProgressBar
//
//  Created by Deepak Kadarivel on 29/01/16.
//  Copyright © 2016 upbeatios. All rights reserved.
//

import UIKit

class ProgressView: UIView {
    
    private let progressLayer: CAShapeLayer = CAShapeLayer()
    private var progressLabel: UILabel = UILabel()
    private var sizeProgressLabel: UILabel = UILabel()
    private var dashedLayer: CAShapeLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = UIColor.clearColor()
        createProgressLayer()
        createLabel()
    }

    func createLabel() {
        progressLabel = UILabel()
        progressLabel.textColor = UIColor.whiteColor()
        progressLabel.font = UIFont(name: "Helveticaneue-UltraLight", size: 40.0)
        progressLabel.text = "0 %"
        progressLabel.textAlignment = .Center
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(progressLabel)
        addConstraint(NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: progressLabel, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .CenterY, relatedBy: .Equal, toItem: progressLabel, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
        
        sizeProgressLabel = UILabel()
        sizeProgressLabel.textColor = UIColor.whiteColor()
        sizeProgressLabel.textAlignment = .Center
        sizeProgressLabel.text = "0.0MB / 0.0MB"
        sizeProgressLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 10.0)
        sizeProgressLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(sizeProgressLabel)
        addConstraint(NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: sizeProgressLabel, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: progressLabel, attribute: .Bottom, relatedBy: .Equal, toItem: sizeProgressLabel, attribute: .Top, multiplier: 1.0, constant: -10.0))
    }
    
    func createProgressLayer() {
        let startAngle = CGFloat(M_PI_2)
        let endAngle = CGFloat(M_PI * 2 + M_PI_2)
        let centerPoint = CGPointMake(CGRectGetWidth(frame)/2, CGRectGetHeight(frame)/2)
        
        progressLayer.path = UIBezierPath(arcCenter: centerPoint, radius: CGRectGetWidth(frame)/2 - 10.0, startAngle: startAngle, endAngle: endAngle, clockwise: true).CGPath
        progressLayer.backgroundColor = UIColor.clearColor().CGColor
        progressLayer.strokeColor = UIColor.whiteColor().CGColor
        progressLayer.fillColor = nil
        progressLayer.strokeStart = 0.0
        progressLayer.strokeEnd = 0.0
        progressLayer.lineWidth = 4.0
        layer.addSublayer(progressLayer)
        
        let dashedLayer = CAShapeLayer()
        dashedLayer.strokeColor = UIColor(white: 1.0, alpha: 0.5).CGColor
        dashedLayer.fillColor = nil
        dashedLayer.lineWidth = 2.0
        dashedLayer.lineJoin = "round"
        dashedLayer.lineDashPattern = [2,4]
        dashedLayer.path = progressLayer.path
        layer.insertSublayer(dashedLayer, below: progressLayer)
        
    }
    
    func animateProgressViewToProgress(progress: Float) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = CGFloat(progressLayer.strokeEnd)
        animation.toValue = CGFloat(progress)
        animation.duration = 0.2
        animation.fillMode = kCAFillModeForwards
        progressLayer.strokeEnd = CGFloat(progress)
        progressLayer.addAnimation(animation, forKey: "animation")
        
    }
    
    func updateProgressViewLabelWithProgress(percent: Float) {
        progressLabel.text = NSString(format: "%.0f %@", percent, "%") as String
    }
    
    func updateProgressViewWith(totalSent: Float, totalFileSize: Float) {
        sizeProgressLabel.text = NSString(format: "%.1f MB / %.1f MB", convertFileSizeToMegabyte(totalSent), convertFileSizeToMegabyte(totalFileSize)) as String
    }
    
    func convertFileSizeToMegabyte(size: Float) -> Float {
        return (size / 1024) / 1024
    }

}
