//
//  CircularScaleTransition.swift
//  MyTFT
//
//  Created by João Pedro De Souza Coutinho on 05/11/19.
//  Copyright © 2019 João Pedro De Souza Coutinho. All rights reserved.
//

import UIKit

public class CircularScaleTransition: NSObject {
    private var scalingView = UIView()
    private var startingPoint = CGPoint.zero {
        didSet {
            scalingView.center = startingPoint
        }
    }
    public var viewColor = UIColor.white
    public var triggeringFrame: CGRect?
    public var duration = 0.3
}

extension CircularScaleTransition: UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        if let presentedViewController = transitionContext.viewController(forKey: .to),
            let presentedView = presentedViewController.view {
            
            presentedView.frame = transitionContext.finalFrame(for: presentedViewController)
            let viewCenter = presentedView.center
            let viewSize = presentedView.frame.size
            
            scalingView.alpha = 1
            scalingView.frame = frameForScale(center: viewCenter,
                                              size: viewSize,
                                              viewFrame: triggeringFrame ?? CGRect(origin: startingPoint,
                                                                                   size: viewSize))
            
            scalingView.layer.cornerRadius = scalingView.frame.size.height/2
            scalingView.center = CGPoint(x: triggeringFrame?.midX ?? 0, y: triggeringFrame?.midY ?? 0)
            scalingView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            scalingView.backgroundColor = viewColor
            
            containerView.addSubview(scalingView)
            
            presentedView.center = viewCenter
            presentedView.alpha = 0

            containerView.addSubview(presentedView)
            
            UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseIn, animations: {
                self.scalingView.transform = .identity
                self.scalingView.alpha = 0
                presentedView.alpha = 1
            }, completion: { success in
                transitionContext.completeTransition(success)
            })
        }
    }
    
    private func frameForScale(center: CGPoint, size: CGSize, viewFrame: CGRect) -> CGRect {
        let xLenght = fmax(viewFrame.minX, size.width - viewFrame.minX)
        let yLenght = fmax(viewFrame.minY, size.height - viewFrame.minY)
        
        let scale = viewFrame.width / viewFrame.height
        let offestVector = sqrt(xLenght*xLenght + yLenght*yLenght) * 2
        
        let size = CGSize(width: offestVector * scale, height: offestVector)
        return CGRect(origin: .zero, size: size)
    }
}
