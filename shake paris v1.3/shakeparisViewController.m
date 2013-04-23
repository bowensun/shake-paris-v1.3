//
//  shakeparisViewController.m
//  shake paris v1.3
//
//  Created by user on 28/03/13.
//  Copyright (c) 2013 com.bowenstudio.*. All rights reserved.
//

#import "shakeparisViewController.h"


@interface shakeparisViewController ()

@end

@implementation shakeparisViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.lableTest.text = @"begin";
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}


-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(void) viewDidDisappear:(BOOL)animated
{
    [self resignFirstResponder];
    [super viewDidDisappear:animated];
}

-(void) motionBegan:(UIEventSubtype)motion withEvent:(UIEvent*) event
{
    if(motion == UIEventSubtypeMotionShake)
    {
        self.lableTest.text = @"shaking";
    }
    
}

-(void) motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent*) event
{
    if(motion == UIEventSubtypeMotionShake)
        self.lableTest.text = @"shaked";
}

-(void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent*) event
{
    if(motion == UIEventSubtypeMotionShake)
    {
        self.lableTest.text = @"shake";
        [self vibrate];
    }
}

//震动函数
- (void)vibrate
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}
@end
