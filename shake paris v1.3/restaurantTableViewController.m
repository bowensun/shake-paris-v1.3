//
//  restaurantTableViewController.m
//  shake paris v1.3
//
//  Created by user on 10/04/13.
//  Copyright (c) 2013 com.bowenstudio.*. All rights reserved.
//

#import "restaurantTableViewController.h"


@interface restaurantTableViewController ()

@end

@implementation restaurantTableViewController


//



//筛选条件后的餐馆初始化
-(void) initWithRestaurantsSelected:(NSMutableArray *)restaurantsSelected WithType:(NSString *)type
{
    self.restaurants = [[NSArray alloc] initWithArray:restaurantsSelected];
    self.flag = type;
}
//数组排序

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void) initGPS
{
    self.localManager = [[CLLocationManager alloc] init];
    self.localManager.delegate = self;
    
    //开启电子罗盘
    if ([CLLocationManager headingAvailable])
        [self.localManager startUpdatingHeading];//启动
    
    //开启GPS
    if([CLLocationManager locationServicesEnabled]) {
        self.localManager.desiredAccuracy = kCLLocationAccuracyBest;//设定为最佳精度
        self.localManager.distanceFilter = 5.0f;//响应位置变化的最小距离(m)
        [self.localManager startUpdatingLocation];
    }
 
}
-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.restaurants = [LocalRestaurant initDistance:newLocation withArray:self.restaurants];
    NSSortDescriptor *sortByDistance = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];
    self.restaurants = [self.restaurants sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByDistance]];
    [self.tableView reloadData];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.restaurants = [LocalRestaurant initDistance:[locations lastObject] withArray:self.restaurants];
    NSSortDescriptor *sortByDistance = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];
    self.restaurants = [self.restaurants sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByDistance]];
    [self.tableView reloadData];
}
//初始化restaurants数组中distance的值，并进行排序
- (void)initDistances
{

    if (self.sdkVersion.doubleValue >= 6)
    {
        [self.refreshControl endRefreshing];
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    }
    
    [self.tableView reloadData];

    if (([self.restaurants count]-self.items)<5) {
        self.items = [self.restaurants count];
    }else
        self.items += 5;
    
    CLLocation *userLocation = [self.localManager location];
    self.restaurants = [LocalRestaurant initDistance:userLocation withArray:self.restaurants];
    NSSortDescriptor *sortByDistance = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];
    self.restaurants = [self.restaurants sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByDistance]];
    self.navigationItem.rightBarButtonItem = self.buttonChangerMode;
    [self.spinner stopAnimating];

}
//下拉刷新控制器初始化添加
-(void)addRefreshViewController
{
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉显示更多"];
    [self.refreshControl addTarget:self action:@selector(RefreshViewControlEventValueChanged) forControlEvents:UIControlEventValueChanged];
}
//下拉执行的程序
-(void)RefreshViewControlEventValueChanged{
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新中..."];
    if ([self.viewMode isEqualToString:[NSString stringWithFormat: @"total"]]) {
        [self performSelector:@selector(initTotal) withObject:nil afterDelay:2.0f];
    }
    else
    {
        [self performSelector:@selector(initDistances) withObject:nil afterDelay:2.0f];
    }
}

- (void)viewDidLoad
{
    if (self.flag) {
        NSLog(@"%@",self.flag);
        self.navigationItem.title = self.flag;
        for (LocalRestaurant *restau in self.restaurants) {
            NSLog(@"在表里1%@",restau.name);
        }
    }else{
        self.restaurants = [LocalRestaurant getRestaurants];
    }
    self.sdkVersion = [[NSNumber alloc] initWithDouble: [[[UIDevice currentDevice] systemVersion] doubleValue]];
    self.viewMode = @"byDistance";

    self.items = [self.restaurants count] >= 6? 6: [self.restaurants count] ;

    if (self.sdkVersion.doubleValue >= 6) {
        [self addRefreshViewController];
    }
    [self initGPS];
    [self initDistances];
    for (LocalRestaurant *restau in self.restaurants) {
        NSLog(@"在表里2%@",restau.name);
    }
    [super viewDidLoad];
    NSLog(@"加载完毕");
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
    [super viewWillAppear:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //NSLog(@"%d 显示数据个数--------------",self.items );
    return self.items;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"restaurant";
    if (self.sdkVersion.doubleValue >= 6)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
        LocalRestaurant *restaurant = (LocalRestaurant *)[self.restaurants objectAtIndex:indexPath.row];
        cell.textLabel.text = restaurant.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"当前距离%0.2f km",restaurant.distance.floatValue/1000];
        return cell;
        // Configure the cell...
    }else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            LocalRestaurant *restaurant = (LocalRestaurant *)[self.restaurants objectAtIndex:indexPath.row];
            cell.textLabel.text = restaurant.name;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"当前距离%0.2f km",restaurant.distance.floatValue/1000];
            // **get** your stuff back using their tags
        }
        return cell;
    }
    
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    self.restaurant = (LocalRestaurant *)[self.restaurants objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"showRestaurantByTVC" sender:self];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showRestaurantByTVC"]) {
        [segue.destinationViewController initWithRestaurant:self.restaurant];
    }
}

-(void)initTotal
{
    self.items = [self.restaurants count];
    if (self.sdkVersion.doubleValue >= 6)
    {
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
        [self.refreshControl endRefreshing];
    }

    [self.tableView reloadData];
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"information" ascending:YES];
    self.restaurants = [self.restaurants sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByName]];
    [self.spinner stopAnimating];
    self.navigationItem.rightBarButtonItem = self.buttonChangerMode;
}

- (IBAction)changerMode:(id)sender {
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];

    self.spinner.hidesWhenStopped = YES;
    [self.spinner startAnimating];
    //self.buttonChangerMode = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.spinner];
    if ([self.viewMode isEqualToString: @"total"]) {
        self.viewMode =@"byDistance";
        self.buttonChangerMode.title = @"点击浏览全部";
        if (!self.flag) {
            self.navigationItem.title = @"最近距离模式";
        }
    }else{
        self.viewMode =@"total";
        self.buttonChangerMode.title = @"按距离浏览";
        if (!self.flag) {
        self.navigationItem.title = @"全部浏览模式";
        }
    }
    if (self.sdkVersion.doubleValue >= 6)
    {
        [self RefreshViewControlEventValueChanged];
    }
    
    [self.tableView reloadData];
    if (self.sdkVersion.doubleValue < 6)
    {
        if ([self.viewMode isEqualToString:[NSString stringWithFormat: @"total"]]) {
            [self performSelector:@selector(initTotal) withObject:nil afterDelay:1.0f];
        }
        else
        {
            [self performSelector:@selector(initDistances) withObject:nil afterDelay:1.0f];
        }
    }    
    //[spinner stopAnimating];
    //self.navigationItem.rightBarButtonItem = sender;

}
@end
