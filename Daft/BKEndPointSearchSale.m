//
//  BKEndPointSearchSale.m
//  Daft
//
//  Created by Bill Kastanakis on 7/30/14.
//  Copyright (c) 2014 Bill Kastanakis. All rights reserved.
//

#import "BKEndPointSearchSale.h"
#import "BKGlobalConstants.h"
#import "BKURLHelpers.h"
#import "BKProperty.h"

@interface BKEndPointSearchSale()

@end

@implementation BKEndPointSearchSale

NSString *const kAPISearchSaleKeyAddress = @"address";
NSString *const kAPISearchSaleKeyBedrooms = @"bedrooms";
NSString *const kAPISearchSaleKeyCity = @"city";
NSString *const kAPISearchSaleKeyPrice = @"price";
NSString *const kAPISearchSaleKeySmallThumbnailURL = @"small_thumbnail_url";

+ (NSArray *)processPropertiesWithResults:(NSArray *)results {
    
    NSMutableArray *properties = [NSMutableArray array];
    
    for (NSDictionary *property in results) {
        
        BKProperty *newProperty = [[BKProperty alloc] initWithAddress:[property valueForKey:kAPISearchSaleKeyAddress] city:[property valueForKey:kAPISearchSaleKeyCity] bedrooms:[[property valueForKey:kAPISearchSaleKeyBedrooms] intValue] price:[[property valueForKey:kAPISearchSaleKeyPrice] intValue] andSmallThumbnailURL:[NSURL URLWithString:[property valueForKey:kAPISearchSaleKeySmallThumbnailURL]]];
        [properties addObject:newProperty];
    }
    
    return properties;
    
}


+ (void)searchSaleStartingFromPage:(int)startingPage withResults:(void (^)(NSArray *results, NSDictionary *pagination))resultsCompletionBlock error:(void (^)(NSError *error))errorCompletionBLock {
    
    NSDictionary *parameters = @{@"api_key" : kAPIKey,
                                 @"query" : @{@"perpage" : @10,
                                              @"page" : [NSNumber numberWithInt:startingPage] }};
    
    NSString *jsonParameters = [BKURLHelpers dictionaryToJSONString:parameters];
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/v2/json/search_sale?parameters=%@", kAPIServer, jsonParameters]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:60];
        
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    [configuration setHTTPAdditionalHeaders:@{@"Accept" : @"application/json",
                                              @"Content-Type" : @"application/json"}];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    
    NSURLSessionDataTask *datatask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error) {
            
            NSError *serializationError;
            NSDictionary *results = [[NSJSONSerialization JSONObjectWithData:data options:0 error:&serializationError] valueForKeyPath:@"result.results"];
            NSArray *processedResults = [self processPropertiesWithResults:[results valueForKey:@"ads"]];
            
            NSDictionary *pagination = @{@"totalResults" : [results valueForKeyPath:@"pagination.total_results"],
                                         @"resultsPerPage" : [results valueForKeyPath:@"pagination.results_per_page"],
                                         @"numberOfPages" : [results valueForKeyPath:@"pagination.num_pages"],
                                         @"currentPage" : [results valueForKeyPath:@"pagination.current_page"]};
            
            resultsCompletionBlock(processedResults, pagination);
            
        } else {
            
            errorCompletionBLock(error);
        }
    }];
    [datatask resume];
}

@end
