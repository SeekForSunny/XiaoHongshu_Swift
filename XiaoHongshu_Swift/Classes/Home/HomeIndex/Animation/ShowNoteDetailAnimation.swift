//
//  ShowNoteDetailAnimation.swift
//  XiaoHongshu_Swift
//
//  Created by SMART on 2017/7/25.
//  Copyright © 2017年 com.smart.swift. All rights reserved.
//

import UIKit

//弹出动画协议
protocol PresentAnimationDelegate:NSObjectProtocol {
    func presentAnimationView() -> UIView
    func presentAnimationFromFrame() -> CGRect
    func presentAnimationToFrame() -> CGRect
}

//消失动画协议
protocol DismissAnimationDelegate:NSObjectProtocol {
    func dismissAnimationView() -> UIView
    func dismissAnimationFromFrame() -> CGRect
    func dismissAnimationToFrame() -> CGRect
}

//弹出动画代理方法
class ShowNoteDetailAnimation: NSObject,UIViewControllerTransitioningDelegate {
    
    weak var presentDelegate:PresentAnimationDelegate?
    weak var dismissDelegate:DismissAnimationDelegate?
    //动画时长
    let seconds:TimeInterval = 1.0
    //标识是弹出还是消失
    var IS_PRESENT:Bool = true
    
    //    弹出动画谁来做
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        IS_PRESENT = true
        return self
    }
    
    //    消失动画谁来做
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        IS_PRESENT = false
        return self
    }
    
}

//消失动画实现代理方法
extension ShowNoteDetailAnimation:UIViewControllerAnimatedTransitioning{
    
    //    转场动画时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return seconds
    }
    
    //动画实现
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning){
        
        //承载动画视图
        let containerView =  transitionContext.containerView
        
        if IS_PRESENT {//弹出动画实现
            guard let delegate = presentDelegate else {
                return
            }
            //做动画的视图
            let animationView = delegate.presentAnimationView()
            //动画的起始位置
            let fromFrame = delegate.presentAnimationFromFrame()
            //动画的结束位置
            let toFrame = delegate.presentAnimationToFrame()
            
            containerView.addSubview(animationView)
            animationView.frame = fromFrame

            let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
            toView?.frame = UIScreen.main.bounds
            toView?.alpha = 0.0
            UIView.animate(withDuration: seconds, animations: {
                animationView.frame = toFrame
                toView?.alpha = 1.0
                containerView.addSubview(toView!)
            }) { (_) in
                transitionContext.completeTransition(true)
                animationView.removeFromSuperview()
            }
            
        }else{//消失动画实现
            guard let delegate = dismissDelegate else {
                return
            }
            
            //做动画的视图
            let animationView = delegate.dismissAnimationView()
            //动画的起始位置
            let fromFrame = delegate.dismissAnimationFromFrame()
            //动画的结束位置
            let toFrame = delegate.dismissAnimationToFrame()
            
            containerView.addSubview(animationView)
            animationView.frame = fromFrame
            
            let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
            UIView.animate(withDuration: seconds, animations: {
                animationView.frame = toFrame
                fromView?.alpha = 0.0
            }) { (_) in
                animationView.removeFromSuperview()
                fromView?.removeFromSuperview()
                transitionContext.completeTransition(true)
            }

        }
        
    }
    
}
