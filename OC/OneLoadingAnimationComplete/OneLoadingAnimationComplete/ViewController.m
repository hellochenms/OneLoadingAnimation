//
//  ViewController.m
//  OneLoadingAnimationStep3
//
//  Created by thatsoul on 15/11/29.
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
    self.view.backgroundColor = [UIColor colorWithRed:0xf0/255.0 green:0xf4/255.0 blue:0xf5/255.0 alpha:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - user event
- (IBAction)onTapSuccessAnimation:(id)sender {
    [self.animationView startSuccess];
}

- (IBAction)onTapFailAnimation:(id)sender {
    [self.animationView startFail];
}

@end
