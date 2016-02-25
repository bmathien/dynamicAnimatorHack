//
//  ViewController.swift
//  DynamicAnimator
//
//  Created by Mathien on 2/23/16.
//  Copyright © 2016 Mathien. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollisionBehaviorDelegate //add delegate protocol
{
    var myDynamicAnimator = UIDynamicAnimator()
    
    //UI
    @IBOutlet weak var livesLabel: UILabel! //add
    var paddle = UIView()
    var ball = UIView()
    var brick = UIView()
    var lives = 5 //add
    var collisionBehavior = UICollisionBehavior()
    var pushBehavior = UIPushBehavior()
    @IBOutlet weak var mybutton: UIButton!

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
        
        //add brick
        brick = UIView(frame: CGRectMake(view.center.x - 30, 20, 60, 30 ))
        brick.backgroundColor = UIColor.cyanColor()
        view.addSubview(brick)
        
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
        paddleDynamicBehavior.density = 10000
        paddleDynamicBehavior.resistance = 100 //decel over time
        paddleDynamicBehavior.allowsRotation = false
        myDynamicAnimator.addBehavior(paddleDynamicBehavior)
        
        //brick behavior
        let brickDynamicBehavior = UIDynamicItemBehavior(items: [brick])
        brickDynamicBehavior.density = 10000
        brickDynamicBehavior.resistance = 100
        brickDynamicBehavior.allowsRotation = false
        myDynamicAnimator.addBehavior(brickDynamicBehavior)
        
        //push item into motion
        pushBehavior = UIPushBehavior(items: [ball], mode: .Instantaneous)
        pushBehavior.angle = -1.1
        pushBehavior.magnitude = 0.3// force given
        
        collisionBehavior = UICollisionBehavior(items: [ball, paddle, brick])
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        collisionBehavior.collisionMode = .Everything
        collisionBehavior.collisionDelegate = self //add
        
        myDynamicAnimator.addBehavior(collisionBehavior)
    }
    
    @IBAction func startbuttonPressed(sender: UIButton)
    {
        myDynamicAnimator.addBehavior(pushBehavior)
        mybutton.hidden = true
        livesLabel.text = "Lives: 5"

    }

    @IBAction func dragPaddle(sender: UIPanGestureRecognizer)
    {
        let panGuesture = sender.locationInView(view).x
        paddle.center = CGPointMake(panGuesture, paddle.center.y)
        myDynamicAnimator.updateItemUsingCurrentState(paddle)
    }
    
    
    //collision behavior delegate method 1 item
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, atPoint p: CGPoint)
    {
        if item.isEqual(ball) && p.y > paddle.center.y
        {
            print("lost a life")
            lives--
            if lives > 0
            {
                livesLabel.text = "Lives: \(lives)"
                ball.center = view.center
                myDynamicAnimator.updateItemUsingCurrentState(ball)
            }
            else
            {
                livesLabel.text = "Game Over"
                ball.removeFromSuperview()
            }
        }
        
    }
    
    //collision for 2 items
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item1: UIDynamicItem, withItem item2: UIDynamicItem, atPoint p: CGPoint)
    {
        if item1.isEqual(ball) && item2.isEqual(brick)  || item2.isEqual(brick) && item2.isEqual(ball)
        {
            print("hit")
            if brick.backgroundColor == UIColor.cyanColor()
            {
            brick.backgroundColor = UIColor.magentaColor()
            }
            else
            {
                brick.hidden = true
                collisionBehavior.removeItem(brick)
                myDynamicAnimator.updateItemUsingCurrentState(paddle)
            }
        }
    }
    



}

