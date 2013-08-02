//
//  RearViewController.m
//  shake paris v1.3
//
//  Created by user on 06/06/13.
//  Copyright (c) 2013 com.bowenstudio.*. All rights reserved.
//

#import "RearViewController.h"
#import "RevealController.h"
#import "MapViewController.h"
#import "restaurantTableViewController.h"

@interface RearViewController ()

@end

@implementation RearViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma marl - UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (nil == cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
	}
	
	if (indexPath.row == 0)
	{
		cell.textLabel.text = @"地图模式";
	}
	else
	{
		cell.textLabel.text = @"列表模式";
	}
	
	return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	RevealController *revealController = [self.parentViewController isKindOfClass:[RevealController class]] ? (RevealController *)self.parentViewController : nil;
	
	if (indexPath.row == 0)
	{
		if (![revealController.frontViewController isKindOfClass:[MapViewController class]])
		{
            MapViewController *mapViewController;
            mapViewController = [[MapViewController alloc] initWithNibName:@"地图模式" bundle:nil];

			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mapViewController];
			[revealController setFrontViewController:navigationController animated:NO];
		}
	}
	else
	{
		if (![revealController.frontViewController isKindOfClass:[restaurantTableViewController class]])
		{
			restaurantTableViewController *restaurantTVC;

            restaurantTVC = [[restaurantTableViewController alloc] initWithNibName:@"列表模式" bundle:nil];
	
			
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:restaurantTVC];
			[revealController setFrontViewController:navigationController animated:NO];
		}
	}
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
