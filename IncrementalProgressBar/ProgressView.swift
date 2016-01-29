//
//  ProgressView.swift
//  IncrementalProgressBar
//
//  Created by Deepak Kadarivel on 29/01/16.
//  Copyright © 2016 upbeatios. All rights reserved.
//

import UIKit

@IBDesignable
class ProgressView: UIView {
    
    @IBInspectable var dashColor: UIColor = UIColor.blackColor() {
        didSet {
            dashedLayer.strokeColor = strokeColor.CGColor
        }
    }
    @IBInspectable var strokeColor: UIColor = UIColor.blackColor() {
        didSet {
            progressLayer.strokeColor = strokeColor.CGColor
        }
    }
    @IBInspectable var progressLabelColor: UIColor = UIColor.whiteColor() {
        didSet {
            progressLabel.textColor = progressLabelColor
        }
    }
    @IBInspectable var sizeProgressLabelColor: UIColor = UIColor.blackColor() {
        didSet {
            sizeProgressLabel.textColor = sizeProgressLabelColor
        }
    }
    
    @IBInspectable var progressViewStrokeWidth: CGFloat = 4.0 {
        didSet {
            progressLayer.lineWidth = progressViewStrokeWidth
        }
    }
    
    @IBInspectable var circleRadius: CGFloat = 200
    
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
        createLabel()
    }
    
    override func drawRect(rect: CGRect) {
        createProgressLayer()
    }

    func createLabel() {
        progressLabel = UILabel()
        progressLabel.textColor = progressLabelColor
        progressLabel.font = UIFont(name: "Helveticaneue-UltraLight", size: 40.0)
        progressLabel.text = "0 %"
        progressLabel.textAlignment = .Center
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(progressLabel)
        addConstraint(NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: progressLabel, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .CenterY, relatedBy: .Equal, toItem: progressLabel, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
        
        sizeProgressLabel = UILabel()
        sizeProgressLabel.textColor = sizeProgressLabelColor
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
        
        progressLayer.path = UIBezierPath(arcCenter: centerPoint, radius: circleRadius/*CGRectGetWidth(frame)/2 - 10.0*/, startAngle: startAngle, endAngle: endAngle, clockwise: true).CGPath
        progressLayer.backgroundColor = UIColor.clearColor().CGColor
        progressLayer.strokeColor = strokeColor.CGColor
        progressLayer.fillColor = nil
        progressLayer.strokeStart = 0.0
        progressLayer.strokeEnd = 0.0
        progressLayer.lineWidth = progressViewStrokeWidth
        layer.addSublayer(progressLayer)
        
        let dashedLayer = CAShapeLayer()
        dashedLayer.strokeColor = dashColor.CGColor
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
