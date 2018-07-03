//
//  ComposeViewController.m
//  twitter
//
//  Created by Chaliana Rolon on 7/3/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"
#import "Tweet.h"

@interface ComposeViewController ()

@property (weak, nonatomic) IBOutlet UITextView *composeText;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onClose:(id)sender {
    
    [self dismissViewControllerAnimated:true completion:nil];
    
}
- (IBAction)onTweet:(id)sender {
    
    [[APIManager shared] postStatusWithText: self.composeText.text completion:^(Tweet *tweet, NSError *error) {
        
        if (error == nil) {
            [self.delegate didTweet:tweet];
            NSLog(@"Compose Tweet Success!");
        } else {
            NSLog(@"Error composing Tweet: %@", error.localizedDescription);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

@end
