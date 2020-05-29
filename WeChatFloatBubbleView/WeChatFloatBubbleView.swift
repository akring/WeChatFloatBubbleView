//
//  WeChatFloatBubbleView.swift
//  WeChatFloatBubbleView
//
//  Created by 吕俊 on 2020/5/29.
//  Copyright © 2020 吕俊. All rights reserved.
//

import UIKit

public class WeChatFloatBubbleView: UIView {
    
    enum FloatingViewShape {
        case circle
        case attachLeft
        case attachRight
    }
    
    var rootView: UIView?
    
    var currentShape :FloatingViewShape?
    
    public init(frame: CGRect, rootView: UIView?) {
        super.init(frame: frame)
        
        self.rootView = rootView
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WeChatFloatBubbleView {
    
    /// Init User Interface
    func initUI() {
        self.backgroundColor = .lightGray
        
        self.isHidden = true
        
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(pan(pan:))))
        
        addToRootViewIfNeeded()
        
        transationToShape(shape: .attachLeft)
    }
    
    func addToRootViewIfNeeded() {
        
        let alreadyAdded = rootView?.subviews.reduce(false, { (previousResult, subView) -> Bool in
            return previousResult || subView is WeChatFloatBubbleView
        }) ?? false
        
        if !alreadyAdded {
            self.rootView?.addSubview(self)
        }
    }
}

extension WeChatFloatBubbleView {
    
    @objc func pan(pan: UIPanGestureRecognizer) {
        
        let transP = pan.translation(in: self)
        
        self.transform = self.transform.translatedBy(x: transP.x, y: transP.y);
        
        pan.setTranslation(.zero, in: self)
        
        switch pan.state {
            
        case .began:
            transationToShape(shape: .circle)
            
        case .ended:
            adsorbToScreenEdge()
            
        default:
            break
        }
    }
}

extension WeChatFloatBubbleView {
    
    func transationToShape(shape: FloatingViewShape) {
        
        guard self.currentShape != shape else { return }
        
        self.currentShape = shape;
        
        switch self.currentShape {
            
        case .circle:
            setRoundForCorners(corners: .allCorners)
            
        case .attachLeft:
            setRoundForCorners(corners: [.topRight, .bottomRight])
            
        case .attachRight:
            setRoundForCorners(corners: [.topLeft, .bottomLeft])
            
        case .none:
            break
        }
    }
    
    func setRoundForCorners(corners: UIRectCorner) {
        
        let cornerRadius = self.frame.size.height / 2.0
        
        let bezierPath = UIBezierPath(roundedRect: self.bounds,
                                      byRoundingCorners: corners,
                                      cornerRadii: CGSize(width: cornerRadius,
                                                          height: cornerRadius))
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = bezierPath.cgPath
        self.layer.mask = maskLayer
    }
    
    func adsorbToScreenEdge() {
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        let topEdge: CGFloat = 20.0
        let bottomEdge: CGFloat = screenHeight - self.bounds.height - 20.0
        let middleX = (screenWidth - self.bounds.width) / 2.0
        
        var resultFrame = self.frame
        
        if (resultFrame.origin.y < topEdge) {
            resultFrame.origin.y = topEdge;
        }
        
        if (resultFrame.origin.y > bottomEdge) {
            resultFrame.origin.y = bottomEdge;
        }
        
        if self.frame.origin.x >= middleX {
            
            /// Attach to right Edge
            UIView.animate(withDuration: 0.25, animations: {
                
                resultFrame.origin.x = screenWidth - self.bounds.width
                
                self.frame = resultFrame
                
            }) { (isFinished) in
                
                if isFinished {
                    
                    self .transationToShape(shape: .attachRight)
                }
            }
        } else {
            
            /// Attach to left Edge
            UIView.animate(withDuration: 0.25, animations: {
                
                resultFrame.origin.x = 0
                
                self.frame = resultFrame
                
            }) { (isFinished) in
                
                if isFinished {
                    
                    self .transationToShape(shape: .attachLeft)
                }
            }
        }
    }
}

extension WeChatFloatBubbleView {
    public func show() {
        self.isHidden = false;
    }
}

extension WeChatFloatBubbleView {
    
    func topEdge() -> CGFloat {
        return self.safeAreaInsets.top
    }
    
    func bottomEdge() -> CGFloat {
        return self.safeAreaInsets.bottom
    }
}
