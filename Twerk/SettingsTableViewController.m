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
#import "AppDelegate.h"
#import "LoginViewController.h"

@interface SettingsTableViewController ()

@property (nonatomic, strong) NSArray *settingsArray;
@property (nonatomic, strong) NSArray *actionsArray;

@end

@implementation SettingsTableViewController


-(void)createSettingsArray
{
    //TODO: Load proper on from correct state
    TVSettingsObject *row1 = [[TVSettingsObject alloc] initWithMainTitle:@"View Recent or All" andSubText:@"Switch between viewing pictures posted in the last 24 hours or all"];
    TVSettingsObject *row2 = [[TVSettingsObject alloc] initWithMainTitle:@"View Friends Only" andSubText:@"Picto will only display who you are following when browsing the map"];
    TVSettingsObject *row3 = [[TVSettingsObject alloc] initWithMainTitle:@"Filler Option" andSubText:@"Something that could possibly go here"];
    _settingsArray = [[NSArray alloc] initWithObjects:row1, row2, row3, nil];
}

-(void)createActionsArray
{
    _actionsArray = @[@"Share this app", @"Rate this app", @"Logout"];
}

-(void)createArrayOfOptionsToDisplay
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    
    [self createSettingsArray];
    [self createActionsArray];
    [self setUpHeader];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)setUpHeader
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 36, 40, 40)];
    backButton.titleLabel.text = @"Back";
    [backButton setImage:[UIImage imageNamed:@"Fill 128.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backToMap) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 30, 180, 40)];
    headerLabel.text = @"Settings";
    UIFont *headline = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    [headerLabel setFont:headline];
    
    [view addSubview:backButton];
    [view addSubview:headerLabel];
    
    [self.view addSubview:view];
}

-(void)viewWillAppear:(BOOL)animated
{
    [(MapViewController *)self.presentingViewController setZoomToLocationOnLaunch:NO];
    [self displayProperButtonHighlights];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSettings) name:@"Switch Pressed" object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return ([_settingsArray count]+[_actionsArray count]);

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"TVTableSettingsViewCell";
    TVTableSettingsViewCell *cell = (TVTableSettingsViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];

    if (indexPath.row >= [_settingsArray count])
    {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"basic"];
        cell.textLabel.text = [_actionsArray objectAtIndex:(indexPath.row - [_settingsArray count])];
        cell.textLabel.textColor = [UIColor colorWithRed:0.557 green:0.709 blue:0.919 alpha:1];
        return cell;
    }
    else
    {
       
//        TVTableSettingsViewCell *cell = [[UITableView alloc] init];
        if (cell == nil)
        {
            //Use the TVTableViewCell.xib file
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TVTableSettingsViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        TVSettingsObject *myObjectForRow = [_settingsArray objectAtIndex:indexPath.row];
        cell.mainTitle.text = myObjectForRow.mainTitle;
        cell.subText.text = myObjectForRow.subText;
        cell.onOffSwitch.on = myObjectForRow.on;
        cell.workAroundIdentifier = indexPath.row;
        return cell;
    }
   
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//   
//    
//    
//    //TODO: return a proper view
//    return view;
//}

-(void)updateSettings
{
    
}

-(void)backToMap
{
    //settings saved in TVTableViewCell... oops sorry
    [self removeAllPins];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)removeAllPins
{
    WGMap *myMap = [(MapViewController *)self.presentingViewController mapView];
    [myMap removeAnnotations:myMap.annotations];
}



-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    
    return 80;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row < [_settingsArray count])
//    {
//        return 80;
//    }
//    else
//    {
//        return 40;
//    }
    return 80;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //TODO:
    if (indexPath.row == ([_settingsArray count] + [_actionsArray count] - 1))
    {
        [self logout];
    }
}

-(void)logout
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.instagram logout];
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    [self presentViewController:loginVC animated:YES completion:nil];
    //TODO: THIS IS INCORRECT (SHOULD DISMISS ALL VCs NOT PRESENT)
}

-(void)igDidLogout
{
    NSLog(@"Instagram did logout");
    // remove the accessToken
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"accessToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
