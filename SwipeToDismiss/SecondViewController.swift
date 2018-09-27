//
//  SecondViewController.swift
//  SwipeToDismiss
//
//  Created by Tandem on 17/05/2018.
//  Copyright © 2018 Tandem. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    var selfOriginalFrame: CGRect!
    
    var interactor:Interactor? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        selfOriginalFrame = self.view.frame
        
        print("this is original frame width: ", selfOriginalFrame.width)
        print("this is original frame height: ", selfOriginalFrame.height)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pan(_ sender: UIPanGestureRecognizer) {
        let percentThreshold:CGFloat = 0.3
        let scalePercentageThreshold: CGFloat = 0.65
        
        // convert y-position to downward pull progress (percentage)
        let translation = sender.translation(in: view)
        let verticalMovement = translation.y / view.bounds.height
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)
        
        let percentageToShrinkForX = 1 * (1 - progress)
        let percentageToShrinkForY = self.selfOriginalFrame.height * (1 - progress)
        
        
        print("percentageToShrinkForX : ", percentageToShrinkForX)
//        print("percentageToShrinkForY : ", percentageToShrinkForY)
        
//        self.view.transform = CGAffineTransform(scaleX: percentageToShrinkForX > scalePercentageThreshold ? percentageToShrinkForX : scalePercentageThreshold, y: percentageToShrinkForX)
        
        print("progress : ", progress)
        
        //this 2 lines to let view follow finger
//        view.frame.origin = translation
        
        guard let interactor = interactor else { return }
        
        switch sender.state {
        case .began:
            interactor.hasStarted = true
            //this 2 lines to have the vc follow user finger
//            sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x, y: sender.view!.center.y + translation.y)
//            sender.setTranslation(CGPoint.zero, in: self.view)
            dismiss(animated: true, completion: nil)
        case .changed:
            interactor.shouldFinish = progress > percentThreshold
            print("progress > threshold ??? ", progress > percentThreshold)
            //this 2 lines to have the vc follow user finger
//            sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x, y: sender.view!.center.y + translation.y)
//            sender.setTranslation(CGPoint.zero, in: self.view)
            interactor.update(progress)
        case .cancelled:
            print("in cancelled")
//            self.view.frame = selfOriginalFrame
            interactor.hasStarted = false
            interactor.cancel()
        case .ended:
            let velocity = sender.velocity(in: view)
            print("velocity: ", velocity)
            if velocity.y >= 1500{
                //dismiss view here
                print("velocity is more than 1500 here !!!!!!: ", velocity)
                interactor.finish()
            }else{
                print("in ended")
                print("this is original frame width: ", selfOriginalFrame.width)
                print("this is original frame height: ", selfOriginalFrame.height)
                print("shouldFinish: ", interactor.shouldFinish)
                interactor.hasStarted = false
                interactor.shouldFinish
                    ? interactor.finish()
                    : interactor.cancel();/* print("in cancel 2"); self.view.frame.origin = CGPoint(x: 0, y: 0)*/
            }
        default:
            break
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
