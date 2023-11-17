//
//  productCell.m
//  Tips4Life
//
//  Created by Rubens Rosa on 12/07/14.
//  Copyright (c) 2014 Rubens Rosa. All rights reserved.
//

#import "productCell.h"

@implementation productCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
     [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
