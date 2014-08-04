//
//  BKPropertiesListCell.h
//  Daft
//
//  Created by Bill Kastanakis on 8/2/14.
//  Copyright (c) 2014 Bill Kastanakis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BKPropertiesListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *header;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;
@property (weak, nonatomic) IBOutlet UILabel *price;

@end
