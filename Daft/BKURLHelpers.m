//
//  BKURLHelpers.m
//  Daft
//
//  Created by Bill Kastanakis on 7/30/14.
//  Copyright (c) 2014 Bill Kastanakis. All rights reserved.
//

#import "BKURLHelpers.h"

@implementation BKURLHelpers

+ (NSString *)dictionaryToJSONString:(NSDictionary *)dictionary {
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
    
    return [jsonString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
