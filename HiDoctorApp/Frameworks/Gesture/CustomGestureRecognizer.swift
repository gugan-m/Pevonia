//
//  CustomGestureRecognizer.swift
//  HiDoctorApp
//
//  Created by Admin on 7/13/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit.UIGestureRecognizerSubclass
class CustomGestureRecognizer: UIGestureRecognizer {

    var strokePrecision : Float = 10.0
    var strokePart = 0
    var firstTap = CGPoint()
    var recognized = false
    var gestureType = 0
    
     override func reset() {
        super.reset()
        self.strokePart = 0
    }
   
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        
        super.touchesBegan(touches, with: event) // Call the super.

        recognized = false
        self.gestureType = 0;
        
        self.strokePrecision = 10.0; //Points of allowable variation in line direction
        
        if (touches.count > 1) //
        {
            self.state = .failed; //This makes sure there is not a two or more finger touch.  Multiple finger touch is something you can do though!
            return;
        }
        
        self.firstTap = (touches.first?.location(in: self.view?.superview))! //The first tap location will be set here in touches began. _recognized = false;
        self.gestureType = 0;
        print("Touches Began!")
 
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        
        if ((self.state == .failed) || (self.state == .recognized))           //This stops the touches from being observed once the gesture has been recognized
        {
            return;
        }
        
        
        let  superView = self.view?.superview     //This allows us to get the points from the same coordinate system of the superview.
        let currentPoint = touches.first?.location(in: superView)
        let previousPoint = touches.first?.previousLocation(in: superView)
        
        //
        //    if ((self.strokePart == 0) && ((currentPoint.x - self.firstTap.x) > 20.00) && (currentPoint.x > previousPoint.x) && ((currentPoint.y - self.firstTap.y) <= self.strokePrecision))   //This set the fist stroke, a horizontal stroke from left to right.
        //    {
        //        NSLog(@"Stroke PART 1 COMPLETE!!!!!");
        //        self.strokePart = 1;
        //    }
        //    else if ((self.strokePart == 1) && (currentPoint.x < previousPoint.x) && (currentPoint.y > previousPoint.y))
        //    {
        //        NSLog(@"Stroke PART 2 COMPLETE!!!!!");
        //        self.strokePart = 2;
        //    }
        //    else if ((self.strokePart == 2) && (currentPoint.x > previousPoint.x) && ((currentPoint.y - previousPoint.y) <= self.strokePrecision))   //This set the fist stroke, a horizontal stroke from left to right.
        //    {
        //        self.strokePart = 3;
        //        self.state = UIGestureRecognizerStateRecognized;
        //
        //        NSLog(@"Gesture Recognized!!!!!!");
        //
        //    }
        
        
        
        if ((self.strokePart == 0) && (currentPoint!.y > previousPoint!.y) && (Float(currentPoint!.x - self.firstTap.x) <= self.strokePrecision))   //This set the fist stroke, a vertical stroke from top to bottom.
        {
            print("Stroke PART 01 COMPLETE!!!!!")
            self.strokePart = 1
            self.gestureType = 1
            recognized = true
        }
        
        if ((self.strokePart == 0) && (currentPoint!.y < previousPoint!.y) && (Float(currentPoint!.x - self.firstTap.x) >= self.strokePrecision))   //This set the fist stroke, a vertical stroke from top to bottom.
        {
            print("Stroke PART 11 COMPLETE!!!!!")
            self.strokePart = 1
            self.gestureType = 2
        }
        
        if ((self.strokePart == 0) && (currentPoint!.y < previousPoint!.y) && (Float( self.firstTap.x - currentPoint!.x) >= self.strokePrecision))   //This set the fist stroke, a vertical stroke from top to bottom.
        {
            print("Stroke PART 21 COMPLETE!!!!!")
            self.strokePart = 1
            self.gestureType = 2
        }
        
        
        if (gestureType == 1 ){
            if ((self.strokePart == 1) && (currentPoint!.x > previousPoint!.x) && (currentPoint!.y > previousPoint!.y))
            {
                print("Stroke PART 12 COMPLETE!!!!!")
                self.strokePart = 2
                
            }else if ((self.strokePart == 1) && (currentPoint!.x < previousPoint!.x) && (currentPoint!.y > previousPoint!.y))
            {
                print("Stroke PART 42 COMPLETE!!!!!")
                self.strokePart = 2
                self.gestureType = 4
            }
                
           else if ((self.strokePart == 2) && (currentPoint!.y < previousPoint!.y) && (Float(currentPoint!.x - previousPoint!.x) <= self.strokePrecision) &&   (self.firstTap.y * 2 >=  (currentPoint?.y)!) )    //This set the fist stroke, a vertical stroke from bottom to top.
            {
                print("Stroke PART 13 COMPLETE!!!!!")
                
                self.gestureType = 3
                recognized = true
                print("Gesture Recognized!!!!!!")
            }
        }
        
        
        if (gestureType == 4){
            
             if ((self.strokePart == 2) && (currentPoint!.y < previousPoint!.y) && (Float( previousPoint!.x - currentPoint!.x) <= self.strokePrecision)  &&   (self.firstTap.y * 2 >=  (currentPoint?.y)!))   //This set the fist stroke, a vertical stroke from bottom to top.
            {
                print("Stroke PART 43 COMPLETE!!!!!")
                self.strokePart = 3
                self.gestureType = 5
                recognized = true
                print("Gesture Recognized!!!!!!")
            }
        }
        
        if (gestureType == 2){
            if ((self.strokePart == 1) && (currentPoint!.y < (previousPoint!.y)))
            {
                print("Stroke PART 2 2 COMPLETE!!!!!")
                self.strokePart = 2
            }
                
            else if ((self.strokePart == 2) && (currentPoint!.y > previousPoint!.y) && (Float(currentPoint!.x - previousPoint!.x) <= self.strokePrecision) &&   (self.firstTap.y * 1.3 >=  (currentPoint?.y)!)  )   //This set the first stroke, a vertical stroke from bottom to top.
            {
                print("Stroke PART2  3 COMPLETE!!!!!")
                self.strokePart = 3
                
            }else if( (self.strokePart == 3) && (self.firstTap.y  <=  ((currentPoint?.y)! * 1.5 ))){
                print("Stroke PART 2 4 COMPLETE!!!!!")
                self.strokePart = 4
                recognized = true;
                print("Gesture Recognized!!!!!!")
            }
            
            
        }
        
        
        
        print("currentpoint" , currentPoint?.x , currentPoint?.y , firstTap.y, gestureType);
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        if (!recognized) {
            self.gestureType = 6
        }
        self.state = .recognized

        self.reset()
        print("Touches ENDED!")
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        self.state = .cancelled
        self.reset()
    }
    
}
