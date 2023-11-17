//
//  ScheduleClassDetails.m
//  mobitrainer
//
//  Created by Reginaldo Lopes on 02/08/16.
//  Copyright © 2016 4mobi. All rights reserved.
//

#import "ClassScheduleDetails.h"

@implementation ClassScheduleDetails

@synthesize lblTitle;
@synthesize lblTeacher;
@synthesize lblStartAt;
@synthesize lblAmount;
@synthesize lblRoom;
@synthesize lblDuration;
@synthesize tvObjective;
@synthesize btnClose;

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (id) initWithParameter:(id)parameter
{
    ClassScheduleItem *classScheduleItem = (ClassScheduleItem *)parameter;

    CoreDataService *coreDataService = [[CoreDataService alloc] init];
    [coreDataService initialize];
    
  //  self.lblTitle.text =   classScheduleItem.name;
    lblTitle.text = [NSString stringWithFormat:@"   %@",classScheduleItem.name] ;
    
    lblTeacher.text = classScheduleItem.teacher;
    
    if(classScheduleItem.room.length > 0)
    {
        lblRoom.text = classScheduleItem.room;
    }
    else
    {
        lblRoom.text = @"--";
    }

    lblAmount.text = [NSString stringWithFormat:@"%@ alunos",[classScheduleItem.amount stringValue]];
    lblDuration.text = [NSString stringWithFormat:@"%@min.",[classScheduleItem.duration stringValue]];

  //  self.lblStartAt.layer.cornerRadius = 10.0f;
  //  self.lblStartAt.clipsToBounds = YES;
    //lblStartAt.backgroundColor = UIColorFromRGB(kPRIMARY_COLOR);
    NSString *strStartAt = [classScheduleItem.startAt stringByReplacingOccurrencesOfString:@":" withString:@"h"];
    lblStartAt.text = strStartAt;

    btnClose.tintColor = UIColorFromRGB(kPRIMARY_COLOR);
    tvObjective.text = classScheduleItem.objective;

    return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    
    if (self)
    {
        self.alpha = 0.0f;
        
        [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{

            self.alpha = 1.0f;
            
        } completion:^(BOOL finished){}];
    }
    
    return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (IBAction)btnClosePressed:(id)sender
{
    self.alpha = 1.0f;
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.alpha = 0.0f;
        
    } completion:^(BOOL finished){
    
        [[NSNotificationCenter defaultCenter] postNotificationName:@"unlockClassScheduleTableview" object:self];
        [self removeFromSuperview];
    
    }];
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
