//
//  BKEndPointSearchSale.h
//  Daft
//
//  Created by Bill Kastanakis on 7/30/14.
//  Copyright (c) 2014 Bill Kastanakis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BKEndPointSearchSale : NSObject

/**
    Connects to search_sale endpoint and fetches properties. Returns a block with results array, pagination, or an error.
 
    @discussion Use this endpoint to get properties in pages of 10. Set the startingPage parameter to manage pagination.
 
    @param startingPage: The starting page results.
 
    @return results: An array of BKProperties.

 */

+ (void)searchSaleStartingFromPage:(int)startingPage withResults:(void (^)(NSArray *results, NSDictionary *pagination))resultsCompletionBlock error:(void (^)(NSError *error))errorCompletionBLock;

@end
