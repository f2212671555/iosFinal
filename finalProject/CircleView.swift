//
//  CircleView.swift
//  finalProject
//
//  Created by 陸顥壬 on 2019/6/25.
//  Copyright © 2019 陸顥壬. All rights reserved.
//

import UIKit

@IBDesignable
class CircleView: UIView {
    @IBInspectable public var fillColor: UIColor = UIColor.white    { didSet { setNeedsLayout() } }
    @IBInspectable public var strokeColor: UIColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 0)  { didSet { setNeedsLayout() } }
    @IBInspectable public var lineWidth: CGFloat = 0     { didSet { setNeedsLayout() } }
    
    @IBInspectable var shadowColor: UIColor? = UIColor.black
    @IBInspectable var shadowOpacity: Float = 0.5
    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 3
    
    lazy private var shapeLayer: CAShapeLayer = {
        let _shapeLayer = CAShapeLayer()
        self.layer.insertSublayer(_shapeLayer, at: 0)
        return _shapeLayer
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = (min(bounds.size.width, bounds.size.height) - lineWidth) / 2
        let shadowPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        shapeLayer.path = shadowPath.cgPath
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = lineWidth
        
        shapeLayer.masksToBounds = false
        shapeLayer.shadowColor = shadowColor?.cgColor
        shapeLayer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        shapeLayer.shadowOpacity = shadowOpacity
        shapeLayer.shadowPath = shadowPath.cgPath
    }
}
