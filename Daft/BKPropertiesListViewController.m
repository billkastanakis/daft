//
//  BKPropertiesListViewController.m
//  Daft
//
//  Created by Bill Kastanakis on 8/2/14.
//  Copyright (c) 2014 Bill Kastanakis. All rights reserved.
//

#import "BKPropertiesListViewController.h"
#import "BKEndPointSearchSale.h"
#import "BKPropertiesListCell.h"
#import "BKProperty.h"
#import "UIColor+Extensions.h"

@interface BKPropertiesListViewController ()
@property (nonatomic, strong) NSMutableArray *properties;
@property (nonatomic, strong) NSDictionary *pagination;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, assign) long totalRows;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *propertiesLabel;
@end

@implementation BKPropertiesListViewController


#pragma mark - ScrollView Delegates

// Setting the status bar style depending the header is visibility
// Details that matter! :)

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y > self.tableView.tableHeaderView.bounds.size.height - ([UIApplication sharedApplication].statusBarFrame.size.height / 2)) {
        if ([UIApplication sharedApplication].statusBarStyle != UIStatusBarStyleDefault) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        }
    } else {
        if ([UIApplication sharedApplication].statusBarStyle != UIStatusBarStyleLightContent) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        }
    }
}

#pragma mark - Helper Methods

- (NSArray *)returnIndexPathsForUpdate {
    
    int currentPage = [[self.pagination valueForKey:@"currentPage"] intValue];
    int resultsPerPage = [[self.pagination valueForKey:@"resultsPerPage"] intValue];
    
    int firstIndex = resultsPerPage * (currentPage - 1) ;
    
    int lastIndex = firstIndex + resultsPerPage;
    
    if (lastIndex > [[self.pagination valueForKey:@"totalResults"] intValue]) {
        lastIndex = [[self.pagination valueForKey:@"totalResults"] intValue];
    }
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (int i=firstIndex; i<lastIndex; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [indexPaths addObject:indexPath];
    }
    
    return indexPaths;
    
}

- (UIView *)generateTableFooterView {
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    [footer setBackgroundColor:[UIColor daftOrangeColor]];
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [indicatorView setCenter:footer.center];
    
    [indicatorView startAnimating];
    
    [footer addSubview:indicatorView];
    return footer;
}


#pragma mark - Image Fetch

- (void)fetchDataFromPage:(int)page {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [BKEndPointSearchSale searchSaleStartingFromPage:page withResults:^(NSArray *results, NSDictionary *pagination) {
        [self.properties addObjectsFromArray:results];
        self.pagination = pagination;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([self.activityIndicator isAnimating]) {
                [self.activityIndicator stopAnimating];
                [UIView animateWithDuration:0.5 animations:^{
                    [self.propertiesLabel setAlpha:1.0];
                } completion:nil];
            }
            
            NSArray *indexPathsForUpdate = [self returnIndexPathsForUpdate];
            
            self.totalRows = [self.properties count];
            
            UIView *tableFooterView = [self.tableView tableFooterView];
            if (tableFooterView) {
                [tableFooterView setTransform:CGAffineTransformMakeTranslation(0, 0)];
                [UIView animateWithDuration:0.5 animations:^{
                    [tableFooterView setTransform:CGAffineTransformMakeTranslation(0, 50)];
                    [tableFooterView setAlpha:0.0];
                } completion:^(BOOL finished) {
                    [self.tableView setTableFooterView:nil];
                }];
            }

            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [self.tableView insertRowsAtIndexPaths:indexPathsForUpdate withRowAnimation:UITableViewRowAnimationFade];

        
        });
    } error:^(NSError *error) {
        NSLog(@"Error fetching search_sales: %@", error.localizedDescription);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }];
    
}

#pragma mark - View Lifecycle

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.propertiesLabel setAlpha:0.0];
    [self.activityIndicator startAnimating];
    
    [self fetchDataFromPage:1];
    
    self.properties = [NSMutableArray array];

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    [configuration setRequestCachePolicy:NSURLRequestReturnCacheDataElseLoad];
    NSUInteger memorySize = 25*1024*1024;
    NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:memorySize diskCapacity:memorySize diskPath:@"imageCache"];
    [configuration setURLCache:cache];
    
    self.session = [NSURLSession sessionWithConfiguration:configuration];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - TableView Datasource 


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.totalRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    BKPropertiesListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PropertiesListCell" forIndexPath:indexPath];
    BKProperty *property = [self.properties objectAtIndex:indexPath.row];
    
    NSMutableAttributedString *attributedHeader = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d bedrooms, %@, %@", property.bedrooms, property.address, property.city]];
    NSRange cityRange = NSMakeRange(attributedHeader.length - [property.city length], [property.city length]);
    [attributedHeader addAttribute:NSForegroundColorAttributeName value:[UIColor daftOrangeColor] range:cityRange];
    [cell.header setAttributedText:attributedHeader];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    [numberFormatter setCurrencySymbol:@"€"];
    [numberFormatter setMaximumFractionDigits:0];
    NSString *priceString = [numberFormatter stringFromNumber:[NSNumber numberWithInt:property.price]];

    [cell.price setText:priceString];
    
    if (property.smallThumbnailURL) {
        
        NSURLSessionDataTask *fetchImageTask = [_session dataTaskWithURL:property.smallThumbnailURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (!error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImage *image = [[UIImage alloc] initWithData:data];
                    [cell.thumbnail setImage:image];
                });
            }
        }];
        
        [fetchImageTask resume];
        
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int currentPage = [[self.pagination valueForKey:@"currentPage"] intValue];
    int numberOfPages = [[self.pagination valueForKey:@"numberOfPages"] intValue];
    long lastRow = [self.properties count] - 1;
    
    if (indexPath.row == lastRow && currentPage < numberOfPages) {
        
        UIView *tableFooterView = [self generateTableFooterView];
        
        [self.tableView setTableFooterView:tableFooterView];
        [tableFooterView setTransform:CGAffineTransformMakeTranslation(0, 50)];
        [tableFooterView setAlpha:0.0];
        [UIView animateWithDuration:0.5 animations:^{
            [tableFooterView setTransform:CGAffineTransformMakeTranslation(0, 0)];
            [tableFooterView setAlpha:1.0];
        } completion:nil];
        
        int nextPage = [[self.pagination valueForKey:@"currentPage"] intValue] + 1;
        [self fetchDataFromPage:nextPage];
    }
}

@end
