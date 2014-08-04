//
//  BKProperty.m
//  Daft
//
//  Created by Bill Kastanakis on 8/2/14.
//  Copyright (c) 2014 Bill Kastanakis. All rights reserved.
//

#import "BKProperty.h"

@implementation BKProperty

- (instancetype)initWithAddress:(NSString *)address city:(NSString *)city bedrooms:(int)bedrooms price:(int)price andSmallThumbnailURL:(NSURL *)smallThumbnailURL
{
    self = [super init];
    if (self) {
        self.address = address;
        self.city = city;
        self.price = price;
        self.bedrooms = bedrooms;
        self.smallThumbnailURL = smallThumbnailURL;
    }
    return self;
}

@end
