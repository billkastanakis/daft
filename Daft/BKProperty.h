//
//  BKProperty.h
//  Daft
//
//  Created by Bill Kastanakis on 8/2/14.
//  Copyright (c) 2014 Bill Kastanakis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BKProperty : NSObject
@property (nonatomic, assign) int bedrooms;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, assign) int price;
@property (nonatomic, strong) NSURL *smallThumbnailURL;

- (instancetype)initWithAddress:(NSString *)address city:(NSString *)city bedrooms:(int)bedrooms price:(int)price andSmallThumbnailURL:(NSURL *)smallThumbnailURL;

@end
