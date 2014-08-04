//
//  BKPropertiesListCell.m
//  Daft
//
//  Created by Bill Kastanakis on 8/2/14.
//  Copyright (c) 2014 Bill Kastanakis. All rights reserved.
//

#import "BKPropertiesListCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation BKPropertiesListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib
{
    [self.thumbnail.layer setCornerRadius:29.0];
    [self.thumbnail.layer setMasksToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
