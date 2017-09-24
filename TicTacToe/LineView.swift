//
//  LineView.swift
//  TicTacToe
//
//  Created by Anteneh Sahledengel on 9/19/17.
//  Copyright © 2017 Anteneh Sahledengel. All rights reserved.
//

import UIKit

class LineView: UIView {
    
    var lineLayer = CAShapeLayer()
    var startPoint = CGPoint() {
        didSet {
            updateLineLayer()
        }
    }
    var endPoint = CGPoint() {
        didSet {
            updateLineLayer()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !self.bounds.equalTo(lineLayer.frame) {
            updateLineLayer()
        }
    }
    
    func commonInit() {
        self.isUserInteractionEnabled = false
        self.layer.addSublayer(lineLayer)
        
        lineLayer.fillColor = nil
        lineLayer.lineCap = kCALineCapRound
        lineLayer.lineWidth = 10
        
        lineLayer.strokeColor = UIColor.black.cgColor
        
        startPoint = CGPoint(x: 0, y: 0)
        endPoint = CGPoint(x: self.bounds.width, y: self.bounds.height)
        endPoint = CGPoint(x: 0, y: self.bounds.height)
    }
    
    func updateLineLayer() {
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        
        lineLayer.path = path.cgPath
        lineLayer.frame = self.bounds
    }
    
    func beginAnimation() {

        let startAnimation = CASpringAnimation()
        startAnimation.damping = 8
        startAnimation.keyPath = "strokeStart"
        startAnimation.duration = startAnimation.settlingDuration
        startAnimation.fromValue = 0.5
        startAnimation.toValue = 0
        
        let endAnimation = CASpringAnimation()
        endAnimation.damping = 8
        endAnimation.keyPath = "strokeEnd"
        endAnimation.duration = endAnimation.settlingDuration
        endAnimation.fromValue = 0.5
        endAnimation.toValue = 1
        
        let duration = startAnimation.settlingDuration + endAnimation.settlingDuration
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = duration
        animationGroup.animations = [startAnimation, endAnimation]
        
        
        self.lineLayer.add(animationGroup, forKey: "animation")
    }
    
    func endAnimation() {
        self.lineLayer.removeAnimation(forKey: "animation")
    }

}
