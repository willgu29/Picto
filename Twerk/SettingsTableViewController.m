//
//  SettingsTableViewController.m
//  Picto
//
//  Created by William Gu on 9/5/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "TVSettingsObject.h"
#import "TVTableSettingsViewCell.h"
#import "MapViewController.h"

@interface SettingsTableViewController ()

@property (nonatomic, strong) NSArray *settingsArray;

@end

@implementation SettingsTableViewController

-(void)createSettingsArray
{
    //TODO: Load proper on from correct state
    TVSettingsObject *row1 = [[TVSettingsObject alloc] initWithMainTitle:@"View Recent or All" andSubText:@"Switch between viewing pictures posted in the last 24 hours or all pictures"];
    TVSettingsObject *row2 = [[TVSettingsObject alloc] initWithMainTitle:@"View Friends Only" andSubText:@"Picto will only display who you are following when browsing the map"];
    TVSettingsObject *row3 = [[TVSettingsObject alloc] initWithMainTitle:@"Filler Option" andSubText:@"Something that could possibly go here"];
    _settingsArray = @[row1, row2, row3];
}



-(void)createArrayOfOptionsToDisplay
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createSettingsArray];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self displayProperButtonHighlights];
}

-(void)displayProperButtonHighlights
{
    [self displayProperFollowing];
    [self displayProperAllRecent];
    
}

-(void)displayProperAllRecent
{
    TVSettingsObject *allRecent = [_settingsArray objectAtIndex:0];

    if ([(MapViewController *)self.presentingViewController globalType] == ALL)
    {
        allRecent.on = YES;
    }
    else if ([(MapViewController *)self.presentingViewController globalType] == RECENT)
    {
        allRecent.on = NO;
    }
}

-(void)displayProperFollowing
{
    TVSettingsObject *friendsOnly = [_settingsArray objectAtIndex:1];
    if ([(MapViewController *)self.presentingViewController onlyFriends] == YES)
    {
        friendsOnly.on = YES;
    }
    else
    {
        friendsOnly.on = NO;
    }
}


- (void)removeAllPinsButUserLocation
{
    WGMap *myMap = [(MapViewController *)self.presentingViewController mapView];
    [myMap removeAnnotations:myMap.annotations];
    
    
    // id userLocation = [myMap userLocation];
    
    //if ( userLocation != nil ) {
    //[myMap addAnnotation:userLocation]; // will cause user location pin to blink
    //[myMap setShowsUserLocation:YES];
    // }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [_settingsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"TVTableSettingsViewCell";
    
    TVTableSettingsViewCell *cell = (TVTableSettingsViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    // Configure the cell...
    
    if (cell == nil)
    {
        //Use the TVTableViewCell.xib file
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TVTableSettingsViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        //cell = [[TVTableViewCell alloc] initWithRow:indexPath.row];
        //cell = [[TVTableViewCell alloc] init];
    }
    
    if (indexPath.row >= [_settingsArray count])
    {
        //Other settings (Logout, share, etc.)
        
        return cell;
    }
    
    TVSettingsObject *myObjectForRow = [_settingsArray objectAtIndex:indexPath.row];
    
    cell.mainTitle.text = myObjectForRow.mainTitle;
    cell.subText.text = myObjectForRow.subText;
    cell.onOffSwitch.on = myObjectForRow.on;
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    //TODO: return a proper view
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    
    return 80;
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

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

@end
