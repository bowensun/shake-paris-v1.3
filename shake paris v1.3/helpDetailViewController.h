//
//  helpDetailViewController.h
//  shake paris v1.3
//
//  Created by user on 24/04/13.
//  Copyright (c) 2013 com.bowenstudio.*. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface helpDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *helpTextView;
@property (strong, nonatomic) NSString *infoString;
-(void)initWithInfoString:(NSString *)string;
@end
