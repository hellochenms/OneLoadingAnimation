//
//  ViewController.m
//  OneLoadingAnimationStep1
//
//  Created by thatsoul on 15/11/15.
//  Copyright © 2015年 chenms.m2. All rights reserved.
//

#import "ViewController.h"
#import "OneLoadingAnimationView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet OneLoadingAnimationView *animationView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - user event
- (IBAction)onTapStartAnimation:(id)sender {
    [self.animationView startAnimation];
}


@end
