//
//  User.m
//  twitter
//
//  Created by Chaliana Rolon on 7/2/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        NSURL *imageURL = [NSURL URLWithString: dictionary[@"profile_image_url"]];
        self.profileImageURL = imageURL;
    }
    return self;
}

@end
