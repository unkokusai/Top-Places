//
//  TPTopPlacesTableViewController.m
//  Top Places
//
//  Created by Yasuyuki Pham on 5/15/14.
//  Copyright (c) 2014 Code Coalition. All rights reserved.
//

#import "TPTopPlacesTableViewController.h"
#import "TPFactory.h"
#import "TPPhotosForPlaceTableViewController.h"

#import "FlickrFetcher.h"

#define CITY @"city"
#define PROVINCE @"province"
#define COUNTRY @"country"
#define RECENTLY_VIEWED @"recently viewed places"

@interface TPTopPlacesTableViewController ()

@property (strong, nonatomic) NSDictionary *topPlaces;
@property (strong, nonatomic) NSArray *location;
@property (strong, nonatomic) NSMutableArray *recentlyViewedPlaces;

@end

@implementation TPTopPlacesTableViewController

-(NSDictionary *)topPlaces
{
    if (!_topPlaces) _topPlaces = [[NSDictionary alloc] initWithDictionary:[TPFactory topPlacesURLRequest]];
//    NSLog(@"%@", _topPlaces);
    return _topPlaces;
}

-(NSMutableArray *)recentlyViewedPlaces
{
    if (!_recentlyViewedPlaces) _recentlyViewedPlaces = [@[] mutableCopy];
    return _recentlyViewedPlaces;
}

-(NSArray *)location
{
    if (!_location) _location = [self locationStringToArray];
    return _location;
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //result of topPlaces dictionary anatomy > places(dic) > place(dic) > returns array > which contains a dictionary
    [self locationStringToArray];
    NSString *string = [FlickrFetcher extractRegionNameFromPlaceInformation:self.topPlaces];
    NSLog(@"%@", string);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return [self.location count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return ([self.location[section] count] - 1) / 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = self.location[indexPath.section][0];
    cell.detailTextLabel.text = self.location[indexPath.section][1];
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.location[section] lastObject];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"Photos For Place"]) {
        if ([segue.destinationViewController isKindOfClass:[TPPhotosForPlaceTableViewController class]]) {
            TPPhotosForPlaceTableViewController *recentlyViewedVC = segue.destinationViewController;
        }
    }
}


#pragma mark - Helper Methods

// divide NSDictionary of top places obtained from [TPFactory topPlacesURLRequest] into:
//first Tab sections by country organized alphabetically
//second Tab 20 most recently vieweed places in chronological order with most recent at top and no duplicates.

-(NSDictionary *)topPlacesSortedByCountry
{
    //tab bar 1
    
    return nil;
}

-(NSDictionary *)lastTwentyRecentlyViewedPlaces
{
    //tab bar 2
    return nil;
}

//return dictionary of "_content" which contains information of location in order of city, state/province, country divided by commas
//NSArray *butt = self.topPlaces[@"places"][@"place"];
//NSLog(@"%@", butt[0][@"_content"]);

-(NSArray *)topPlacesLocationInformation //returns array of string city, state/province, country divided by commas
{
    NSMutableArray *location = [@[]mutableCopy];
    NSArray *places = self.topPlaces[@"places"][@"place"];
    for (NSDictionary *dic in places) {
        [location addObject:dic[@"_content"]];
    }
//    NSLog(@"%@", location);
    return location;
}

-(NSArray *)locationStringToArray //converts string results of -(NSArray *)topPlacesLocationInformation to array
{
    NSMutableArray *convertedArray = [@[] mutableCopy];
    NSArray *location = [self topPlacesLocationInformation];
    for (NSString *string in location) {
        NSArray *loc = [string componentsSeparatedByString:@", "];
        [convertedArray addObject:loc];
    }
    
    return convertedArray;
}

-(void)recordRecentlyViewedPlaces // add most recent 20 views of (NSMutableArray *)recentlyViewedPlaces ot NSUserDefaults
{
    [[NSUserDefaults standardUserDefaults] setObject:self.recentlyViewedPlaces forKey:RECENTLY_VIEWED];
    [[NSUserDefaults standardUserDefaults] synchronize];
}





@end
