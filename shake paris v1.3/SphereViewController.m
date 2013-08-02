//
//  SphereViewController.m
//  shake paris v1.3
//
//  Created by user on 13/05/13.
//  Copyright (c) 2013 com.bowenstudio.*. All rights reserved.
//

#import "SphereViewController.h"
#import "PFSphereView.h"

@interface SphereViewController ()

@end

@implementation SphereViewController

-(UIColor *)randomColor
{
    static BOOL seeded = NO;
    if (!seeded) {
        seeded = YES;
        srandom(time(NULL));
    }
    CGFloat red =  (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.restaurants = [LocalRestaurant getRestaurants];
    if ([self.restaurants count]==0||!self.restaurants) {
        NSLog(@"标签云中数据读取失败");
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
	PFSphereView *sphereView = [[PFSphereView alloc] initWithFrame:CGRectMake(10, 60, 300, 300)];
    
	NSMutableArray *labels = [[NSMutableArray alloc] init];
     self.types = [LocalRestaurant getRestaurantTypes];
    NSLog(@"%d",[self.types count]);
    
    
    for (NSUInteger i = 0; i<[self.types count]; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [self randomColor];
        label.font = [UIFont systemFontOfSize:13];
        label.text = [self.types objectAtIndex:i];
        label.tag = i;
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [label addGestureRecognizer:recognizer];
        [labels addObject:label];
    }
    
	[sphereView setItems:labels];
        
	[self.view addSubview:sphereView];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)tapAction:(UITapGestureRecognizer *)gesture
{
    NSInteger tag = gesture.view.tag;
    self.type = [self.types objectAtIndex:tag];
    self.restaurantsSelected = [[NSMutableArray alloc] init];
    for (LocalRestaurant *restaurant in self.restaurants) {
        NSString *str=restaurant.type;
        NSRange range = [str rangeOfString:self.type];
        if (range.location!=NSNotFound) {
            NSLog(@"Yes");
            [self.restaurantsSelected addObject:restaurant];
        }else {
            NSLog(@"NO");
        }
    }
    for (LocalRestaurant *restaurant in self.restaurantsSelected) {
        NSLog(@"当前类型的餐馆有：%@",restaurant.name);
    }
    [self performSegueWithIdentifier:@"ShowInTableView" sender:self];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowInTableView"]) {
        [segue.destinationViewController initWithRestaurantsSelected:self.restaurantsSelected WithType:self.type];
    }
}

@end
