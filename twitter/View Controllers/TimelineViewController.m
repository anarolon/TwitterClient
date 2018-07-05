//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "TweetCell.h"
#import "Tweet.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"

@interface TimelineViewController () <UITableViewDataSource, UITableViewDelegate, ComposeViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *tweetsArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation TimelineViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setRowHeight: 200];
    
    [self getTimeLine];
    
    // Refresh Control Initilize
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getTimeLine) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
}


- (void) getTimeLine {
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            for (Tweet *tweet in tweets) {
                NSString *text = tweet.text;
                NSLog(@"%@", text);
            }
            self.tweetsArray =  (NSMutableArray *) tweets;
            
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweetsArray.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    
    Tweet *currTweet = self.tweetsArray[indexPath.row];
    
    if(currTweet != nil)
    {
        cell.tweet = currTweet;
        cell.username.text = currTweet.user.name;
        cell.screenName.text = currTweet.user.screenName;
        cell.date.text = currTweet.createdAtString;
        cell.tweetText.text = currTweet.text;
        cell.favoriteLabel.text = [NSString stringWithFormat:@"%i", currTweet.favoriteCount];
        cell.retweetLabel.text = [NSString stringWithFormat: @"%i", currTweet.retweetCount];
        cell.replyLabel.text = [NSString stringWithFormat:@"%i", currTweet.replyCount];
        [cell.userImage setImageWithURL:currTweet.user.profileImageURL];
        
        // For retweet button image
        if(currTweet.retweeted) {
            [cell.retweetButton setSelected:YES];
        } else {
            [cell.retweetButton setSelected:NO];
        }
        
        // For favorite button image
        if(currTweet.favorited) {
            [cell.favoriteButton setSelected:YES];
        } else {
            [cell.favoriteButton setSelected:NO];
        }
    }
    
    [cell refreshView];
    return cell;
}

- (IBAction)onSignOut:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
    [[APIManager shared] logout];
    NSLog(@"Logged out");
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *navigationController = [segue destinationViewController];
    ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
    composeController.delegate = self;
 }


- (void)didTweet:(Tweet *)tweet {
    
    [self.tweetsArray addObject: tweet];
    [self.tableView reloadData];
    
}

@end
