//
//  TableViewCell.m
//  mobitrainer
//
//  Created by Reginaldo Lopes on 25/08/15.
//  Copyright (c) 2015 4mobi. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.selectedBackgroundView.frame = CGRectMake(self.frame.origin.x + 1.0f, self.frame.origin.y, self.frame.size.width - 22.0f, self.frame.size.height);
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
