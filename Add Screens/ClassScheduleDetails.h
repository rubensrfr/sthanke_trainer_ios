//
//  ScheduleClassDetails.h
//  mobitrainer
//
//  Created by Reginaldo Lopes on 02/08/16.
//  Copyright © 2016 4mobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassScheduleItem.h"
#import "UtilityClass.h"
#import "CoreDataService.h"
#import "Global.h"


@interface ClassScheduleDetails : UIView

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblTeacher;
@property (weak, nonatomic) IBOutlet UILabel *lblStartAt;
@property (weak, nonatomic) IBOutlet UILabel *lblAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblRoom;
@property (weak, nonatomic) IBOutlet UILabel *lblDuration;
@property (weak, nonatomic) IBOutlet UITextView *tvObjective;
@property (weak, nonatomic) IBOutlet UIButton *btnClose;

- (id) initWithParameter:(id)parameter;
- (IBAction)btnClosePressed:(id)sender;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
