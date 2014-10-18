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
#import "AppDelegate.h"

@interface CommentsViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;


@property (strong, nonatomic) NSMutableArray *dataArray;


@end

@implementation CommentsViewController


#pragma mark - Helper functions


- (void)tableTapped:(UITapGestureRecognizer *)tap
{
    CGPoint location = [tap locationInView:self.tableView];
    NSIndexPath *path = [self.tableView indexPathForRowAtPoint:location];
    
    if(path)
    {
        // tap was on existing row, so pass it to the delegate method
//        [self tableView:self.tableView didSelectRowAtIndexPath:path];
    }
    else
    {
        // handle tap on empty space below existing rows however you want
        if ([_textField isFirstResponder])
        {
            [_textField resignFirstResponder];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"Comments Data: %@", _commentsData);
    [self parseComments];
    
    // in viewDidLoad or somewhere similar
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableTapped:)];
    [self.tableView addGestureRecognizer:tap];
    //.........
    
    
    //remove this when approval for comments is granted
    [self disableComments];
    
}

-(void)disableComments
{
    _textField.hidden = YES;
    _sendButton.hidden = YES;
    _textField.enabled = NO;
    _sendButton.enabled = NO;
}

-(void)parseComments
{
    _dataArray = [[NSMutableArray alloc] init];

//    CommentDataWrapper *caption = [[CommentDataWrapper alloc] initWith:_captionData];
//    [_dataArray addObject:caption];
    
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

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    NSLog(@"touch detected");
//    UITouch *touch = [[event allTouches] anyObject];
//    [self tapOutOfSearchBar:touch];
//}
//
//-(void)tapOutOfSearchBar:(UITouch *)touch
//{
//    if ([_textField isFirstResponder] && [touch view] != _textField) {
//        [_textField resignFirstResponder];
//    }
//}

#pragma mark -IBAction

-(IBAction)backButton:(UIButton *)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark -TableView Data

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return self.numberOfComments.integerValue;
    return [_dataArray count];
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

//     data.estimatedHeight = [self heightForTextLabel:cell.comment].height;
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
  
//    CommentDataWrapper *object = [_dataArray objectAtIndex:indexPath.row];
//    NSLog(@"ESTIMATED HEIGHT: %f", object.estimatedHeight);
//    
//    if (object.estimatedHeight < 64)
//    {
//        return 64;
//    }
//    return object.estimatedHeight;
    
    return 64;
}
//
//-(CGSize)heightForTextLabel:(UILabel *)myLabel
//{
//    
//    return [myLabel.text boundingRectWithSize:CGSizeMake(236, MAXFLOAT)
//                                      options:NSStringDrawingUsesLineFragmentOrigin
//                                   attributes:@{
//                                                NSFontAttributeName : myLabel.font
//                                                }
//                                      context:nil].size;
//}

#pragma mark -Textfield Delegates

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //move VC view
    [self moveVC];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //revert VC view
    [self revertVC];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendButton:_sendButton];
    
    return YES;
}

-(IBAction)sendButton:(UIButton *)sender
{
    
    if ([_textField.text isEqualToString:@""])
    {
        return;
    }
    
    [_textField resignFirstResponder];
    
    NSLog(@"SEND BETTON: ");
    //post
    [self postComment];
    [self addToTable];
    //add to tableView
    [_textField setText:@""];
    [_textField setPlaceholder:@"Add a comment..."];
    
}

-(void)moveVC
{
    [self.view setFrame:CGRectMake(0, -246, self.view.frame.size.width, self.view.frame.size.height)];
}

-(void)revertVC
{
    [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];

}

-(void)addToTable
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    id commentData = delegate.mapVC.someUser.userData;
    time_t todayInUnix = (time_t) [[NSDate date] timeIntervalSince1970];
    NSString *time = [NSString stringWithFormat:@"%ld",todayInUnix];
    CommentDataWrapper *wrapper = [[CommentDataWrapper alloc] initWithComment:_textField.text andTime:time andProfile:[commentData valueForKeyPath:@"profile_picture"] andUsername:[commentData valueForKeyPath:@"username"]];
    
    [_dataArray addObject:wrapper];
    [self.tableView reloadData];
    
}

-(void)postComment
{
    //POSTING COMMENTS REQUIRES INSTAGRAMS APPROVAL (FILL OUT FORM) https://help.instagram.com/contact/185819881608116
    
    
    
    NSString *text = [NSString stringWithFormat:@"%@", _textField.text];
    [self updateComments];
    
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    NSString* methodName = [NSString stringWithFormat:@"media/%@/comments", _mediaID];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:text, @"text", nil];
    [appDelegate.instagram requestWithMethodName:methodName
                                          params: params
                                      httpMethod:@"POST"
                                        delegate: self];
}

-(void)updateComments
{
    int commentCount = _referencedAnnotation.numberOfComments.integerValue;
    commentCount++;
    _referencedAnnotation.numberOfComments = [NSString stringWithFormat:@"%d",commentCount];
}

-(void)request:(IGRequest *)request didLoad:(id)result
{
    
}

-(void)request:(IGRequest *)request didFailWithError:(NSError *)error
{
    
}

@end
