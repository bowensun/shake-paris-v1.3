//
//  shakeparisViewController.m
//  shake paris v1.3
//
//  Created by user on 28/03/13.
//  Copyright (c) 2013 com.bowenstudio.*. All rights reserved.
//

#import "shakeparisViewController.h"
#import "LocalRestaurant.h"


@interface shakeparisViewController ()

@end

@implementation shakeparisViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.restaurants = [LocalRestaurant getRestaurants];
    
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
        
    }
    
}

-(void) motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent*) event
{
    if(motion == UIEventSubtypeMotionShake)
    {
        
    }
}

-(void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent*) event
{
    if(motion == UIEventSubtypeMotionShake)
    {
        [self vibrate];
        [self playSystemSound];
        [self alertInit];
    }
}

-(void) alertInit
{
    self.restaurant = [self randomRestaurant];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您摇到了" message:self.restaurant.name delegate:self cancelButtonTitle:@"重新摇" otherButtonTitles:@"前去查看", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self performSegueWithIdentifier:@"showDetailByShake" sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showDetailByShake"]) {
        [segue.destinationViewController initWithRestaurant:self.restaurant];
    }
}

//随即餐馆获取
-(LocalRestaurant *) randomRestaurant
{
    int x = arc4random() % [self.restaurants count];
    return [self.restaurants objectAtIndex:x];
    
}
//声音函数
- (void)playSystemSound
{
    NSURL* system_sound_url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                      pathForResource:@"musiqueRestau" ofType:@"wav"]];
    SystemSoundID system_sound_id;
    AudioServicesCreateSystemSoundID(
                                     (__bridge CFURLRef)system_sound_url,
                                     &system_sound_id
                                     );
    // Play the System Sound
    AudioServicesPlaySystemSound(system_sound_id);
}

//震动函数
- (void)vibrate
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}
@end
