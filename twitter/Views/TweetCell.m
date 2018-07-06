//
//  TweetCell.m
//  twitter
//
//  Created by Chaliana Rolon on 7/2/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"
#import "Tweet.h"

@interface TweetCell()
@end
@implementation TweetCell



- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    // [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
- (IBAction)didTapRetweet:(id)sender {
    
    UIButton *butt = sender;
    
    if(!self.tweet.retweeted) {
        [butt setSelected:YES];
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        NSLog(@"WASN'T SELECTED");
    } else {
        [butt setSelected:NO];
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        NSLog(@"WAS SELECTED");
    }
    
    [self refreshView];
    
    [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error) {
            NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
        } else {
            if(self.tweet.retweeted) {
            NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
            } else {
            NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
            }
        }
    }];
}

- (IBAction)didTapFavorite:(id)sender {
    // Update the local tweet model
    BOOL favorite = self.tweet.favorited;
    UIButton *butt = sender;
    
    NSLog(@"%@", butt.titleLabel.text);
    
    if(favorite) {
        [butt setSelected:NO];
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
    } else {
        [butt setSelected:YES];
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
    }
    // Update cell UI
    [self refreshView];
    
    NSLog(@"%@", butt.titleLabel.text);
    // Send a POST request to the POST favorites/create endpoint
    [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
        }
        else{
            if(self.tweet.favorited) {
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            } else {
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
            }
        }
    }];
    
    
}

- (void) refreshView {

    [self.favoriteButton setTitle:[NSString stringWithFormat: @"%i", self.tweet.favoriteCount] forState:UIControlStateNormal];
    [self.favoriteButton setTitle:[NSString stringWithFormat: @"%i", self.tweet.favoriteCount] forState:UIControlStateSelected];
    
    [self.retweetButton setTitle:[NSString stringWithFormat: @"%i", self.tweet.retweetCount] forState:UIControlStateNormal];
    [self.retweetButton setTitle:[NSString stringWithFormat: @"%i", self.tweet.retweetCount] forState:UIControlStateSelected];
    
    // Change Retweet button image
    [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green.png"] forState:UIControlStateSelected];
    [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon.png"] forState:UIControlStateNormal];
    // Change favorite button image
    [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon-red.png"] forState:UIControlStateSelected];
    [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon.png"] forState:UIControlStateNormal];
    
}

@end
