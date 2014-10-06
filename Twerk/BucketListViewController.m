//
//  BucketListViewController.m
//  Picto
//
//  Created by William Gu on 10/5/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import "BucketListViewController.h"

@interface BucketListViewController ()

@property (nonatomic, weak) IBOutlet UITableView *toDo;
@property (nonatomic, weak) IBOutlet UITableView *completed;

@property (nonatomic, strong) NSMutableArray *toDoList;
@property (nonatomic, strong) NSMutableArray *completedList;

@end

@implementation BucketListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //Fetch current toDo list and completed
    [self fetchData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [_toDo reloadData];
    [_completed reloadData];
}

-(void)fetchData
{
    //TODO: actually fetch data
    
    _toDoList = [[NSMutableArray alloc] init];
    [_toDoList addObject:@"Test item 1"];
    [_toDoList addObject:@"Sky Diving"];
    
    _completedList = [[NSMutableArray alloc] init];
    [_completedList addObject:@"Die and Live"];
    [_completedList addObject:@"Become asexual"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backButton:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self addStringToBucketList:textField.text];
    [textField resignFirstResponder];
    return YES;
}

-(void)addStringToBucketList:(NSString *)text
{
    //save bucket list item to server
    //display bucket list item
    
    [_toDoList addObject:text];
    [_toDo reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _toDo)
    {
        return [_toDoList count];
    }
    else if (tableView == _completed)
    {
        return [_completedList count];
    }
    else
    {
        NSLog(@"ERROR NO TABLE");
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    
    //FOR custom cell later
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        //TODO: if user.. if hashtag... if location
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];

        
    }
    
    
    if (tableView == _toDo)
    {
        cell.textLabel.text = [_toDoList objectAtIndex:indexPath.row];
    }
    else if (tableView == _completed)
    {
        cell.textLabel.text = [_completedList objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = @"## Photos";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _completed)
    {
        //present vc of pictures associated with row
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _toDo)
    {
        //present view to add pictures and move to completed
    }
    else if (tableView == _completed)
    {
        //move item back to toDo
        return;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
