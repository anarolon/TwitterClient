//
//  TweetCell.m
//  twitter
//
//  Created by Chaliana Rolon on 7/2/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"


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

- (IBAction)didTapFavorite:(id)sender {
    // Update the local tweet model
    int favorite = self.tweet.favorited;
    if(favorite==1) {
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
    } else {
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
    }
    // Update cell UI
    [self refreshView];
    
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
    
    self.favoriteLabel.text = [NSString stringWithFormat: @"%i", self.tweet.favoriteCount];
    self.retweetLabel.text = [NSString stringWithFormat:@"%i", self.tweet.retweetCount];
    
}

@end
