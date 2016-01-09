//
//  ViewController.swift
//  CircleIrregularTransformSwift
//
//  Created by thatsoul on 16/1/2.
//  Copyright © 2016年 chenms.m2. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var animationView: UIView!

    var animationLayer: CircleIrregularTransformLayer!

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        addAnimationLayer()
    }

    private func addAnimationLayer() {
        animationLayer = CircleIrregularTransformLayer()
        animationLayer.contentsScale = UIScreen.mainScreen().scale
        animationLayer.frame = animationView.bounds
        animationLayer.progress = 0;
        animationView.layer.addSublayer(animationLayer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - user event
    @IBAction func startAnimation(sender: AnyObject) {
        // reset
        animationLayer.removeAllAnimations()

        // end status
        animationLayer.progress = 1;

        // animation
        let animation = CABasicAnimation(keyPath: "progress")
        animation.duration = 2
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animationLayer.addAnimation(animation, forKey: nil)
    }
}

