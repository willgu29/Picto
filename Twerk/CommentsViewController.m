//
//  CommentsViewController.m
//  Picto
//
//  Created by William Gu on 9/19/14.
//  Copyright (c) 2014 William Gu. All rights reserved.
//

#import "CommentsViewController.h"
#import "CommentTableViewCell.h"
#import "CommentDataWrapper.h"

@interface CommentsViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation CommentsViewController


#pragma mark - Helper functions


//THIS IS NOT MY CODE: USE IT TO RESIZE CELL HEIGHTS in heightForRowAtIndexPath
//-(CGFloat)heightForTextViewRectWithWidth:(CGFloat)width andText:(NSString *)text
//{
//    UIFont * font = [UIFont systemFontOfSize:12.0f];
//    
//    // this returns us the size of the text for a rect but assumes 0, 0 origin
//    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName: font}];
//    
//    // so we calculate the area
//    CGFloat area = size.height * size.width;
//    
//    CGFloat buffer = whateverExtraBufferYouNeed.0f;
//    
//    // and then return the new height which is the area divided by the width
//    // Basically area = h * w
//    // area / width = h
//    // for w we use the width of the actual text view
//    return floor(area/width) + buffer;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"Comments Data: %@", _commentsData);
    [self parseComments];
    
}

-(void)parseComments
{
    _dataArray = [[NSMutableArray alloc] init];

    for (id commentData in [_commentsData valueForKeyPath:@"data"])
    {
        CommentDataWrapper *wrapper = [[CommentDataWrapper alloc] initWith:commentData];
        [_dataArray addObject:wrapper];
    }
}



-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -IBAction

-(IBAction)backButton:(UIButton *)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -TableView Data

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.numberOfComments.integerValue;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"commentsCell";
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommentTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    
    //TODO: format cell with comments data
    CommentDataWrapper *data = [_dataArray objectAtIndex:indexPath.row];
    
    
    [(CommentTableViewCell *)cell loadProfilePic:data.profileURL];
    [(CommentTableViewCell *)cell formatCellWith:data.username andComment:data.comment andTime:data.timeOfPost.integerValue];

//    cell.profilePic =
//    cell.username =
//    cell.comment =
//    cell.timeSincePost =
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //TODO: return a height for every row based on how much space we need
    
//    find how much space the cell at indexPath.row needs
//    return that height
  
    
    
    return 64;
}



#pragma mark -Textfield Delegates

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}




@end
