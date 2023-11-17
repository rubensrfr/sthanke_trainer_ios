//
//  ClassScheduleCell.m
//  mobitrainer
//
//  Created by Reginaldo Lopes on 29/07/16.
//  Copyright © 2016 4mobi. All rights reserved.
//

#import "ClassScheduleCell.h"

@implementation ClassScheduleCell

@synthesize lblTitle;
@synthesize lblTeacher;
@synthesize lblStartAt;
@synthesize lblDuration;
@synthesize lblMoreInfo;
@synthesize imgMoreInfo;

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)configureCell:(ClassScheduleItem *)classScheduleItem
{
   
    self.lblTitle.text = classScheduleItem.name;
    /* RFR
    [self.lblTitle setHighlightedTextColor:UIColorFromRGB(0xE3E8EA)];
    self.lblTeacher.text = classScheduleItem.teacher;
    [self.lblTeacher setHighlightedTextColor:UIColorFromRGB(0xE3E8EA)];
    
    [self.lblStartAt setHighlightedTextColor:UIColorFromRGB(0xE3E8EA)];
    self.lblStartAt.layer.cornerRadius = 10.0f;
    self.lblStartAt.clipsToBounds = YES;
    */
    CoreDataService *coreDataService = [[CoreDataService alloc] init];
    [coreDataService initialize];
   
    
   // self.lblStartAt.backgroundColor = UIColorFromRGB(kPRIMARY_COLOR);
    
    NSString *strStartAt = [classScheduleItem.startAt stringByReplacingOccurrencesOfString:@":" withString:@"h"];

    self.lblStartAt.text = strStartAt;
    
    self.lblDuration.text = [NSString stringWithFormat:@"%@min.",[classScheduleItem.duration stringValue] ];
    self.lblTeacher.text = classScheduleItem.teacher;
    [self.lblDuration setHighlightedTextColor:UIColorFromRGB(0xE3E8EA)];
    
    self.lblMoreInfo.textColor = UIColorFromRGB(kPRIMARY_COLOR);
    [self.lblMoreInfo setHighlightedTextColor:UIColorFromRGB(0xE3E8EA)];
    
    self.imgMoreInfo.tintColor = UIColorFromRGB(kPRIMARY_COLOR);
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    
    CoreDataService *coreDataService = [[CoreDataService alloc] init];
    [coreDataService initialize];
    
    
    
    UIView* container = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                                 self.contentView.frame.size.width,
                                                                 self.contentView.frame.size.height)];
    
    container.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    UIView *selectedViewColor = [[UIView alloc] initWithFrame:CGRectMake(7, 7,
                                                                         self.contentView.frame.size.width - 14,
                                                                         self.contentView.frame.size.height - 7)];
#ifdef OLD_STYLE
    Design *appDesign = (Design *) [coreDataService getDataFromDesignTable];
    [selectedViewColor setBackgroundColor:UIColorFromRGB(kPRIMARY_COLOR)];
#endif
#ifdef NEW_STYLE
    [selectedViewColor setBackgroundColor:UIColorFromRGB( MENU_CLICK_COLOR )];
#endif
    
    [container addSubview:selectedViewColor];
    self.selectedBackgroundView = container;
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
