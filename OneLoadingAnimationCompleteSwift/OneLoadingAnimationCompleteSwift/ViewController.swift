//
//  ViewController.swift
//  OneLoadingAnimationCompleteSwift
//
//  Created by thatsoul on 15/12/13.
//  Copyright © 2015年 chenms.m2. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - property
    @IBOutlet weak var animationView: OneLoadingAnimationView!

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor(red: 0xf0/255.0, green: 0xf4/255.0, blue: 0xf5/255.0, alpha: 1.0)
    }

    // MARK: - user event
    @IBAction func onTapStart(sender: AnyObject) {
        self.animationView.startSuccess()
    }
    @IBAction func onTapFail(sender: AnyObject) {
        self.animationView.startFail()
    }

}

