//
//  ViewController.swift
//  DynamicAnimator
//
//  Created by Mathien on 2/23/16.
//  Copyright © 2016 Mathien. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    var myDynamicAnimator = UIDynamicAnimator()
    
    //UI
    var paddle = UIView()
    var ball = UIView()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // add ball to view
        ball = UIView(frame: CGRectMake(view.center.x - 10, view.center.y, 20, 20))
        ball.backgroundColor = UIColor.lightGrayColor()
        ball.layer.cornerRadius = 10.25
        ball.clipsToBounds = true
        view.addSubview(ball)
        
        //add paddle
        paddle = UIView(frame: CGRectMake(view.center.x - 40, view.center.y * 1.7, 80, 20))
        paddle.backgroundColor = UIColor.yellowColor()
        paddle.layer.cornerRadius = 5
        paddle.clipsToBounds = true
        view.addSubview(paddle)
        
        myDynamicAnimator = UIDynamicAnimator(referenceView: view)
        
        
        //behaviors for ball
        let ballDynamicBehavior = UIDynamicItemBehavior(items: [ball])
        ballDynamicBehavior.friction = 0.0 //transfer of energy
        ballDynamicBehavior.resistance = 0.0 //decel over time
        ballDynamicBehavior.elasticity = 1.0 // bounce factor
        ballDynamicBehavior.allowsRotation = false
        myDynamicAnimator.addBehavior(ballDynamicBehavior)
        
        // behaviors for paddle
        let paddleDynamicBehavior = UIDynamicItemBehavior(items: [paddle])
        paddleDynamicBehavior.density = 1000
        paddleDynamicBehavior.resistance = 100 //decel over time
        paddleDynamicBehavior.allowsRotation = false
        myDynamicAnimator.addBehavior(paddleDynamicBehavior)
        
        //push item into motion
        let pushBehavior = UIPushBehavior(items: [ball], mode: .Instantaneous)
        pushBehavior.angle = 1.1
        pushBehavior.magnitude = 0.5// force given
        myDynamicAnimator.addBehavior(pushBehavior)
        
        let collisionBehavior = UICollisionBehavior(items: [ball, paddle])
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        collisionBehavior.collisionMode = .Everything
        
        myDynamicAnimator.addBehavior(collisionBehavior)
    }
    

    @IBAction func dragPaddle(sender: UIPanGestureRecognizer)
    {
        let panGuesture = sender.locationInView(view).x
        paddle.center = CGPointMake(panGuesture, paddle.center.y)
        myDynamicAnimator.updateItemUsingCurrentState(paddle)
    }
    



}

