//
//  AulasViewController.h
//  mobitrainer
//
//  Created by Reginaldo Lopes on 28/07/16.
//  Copyright © 2016 4mobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "UtilityClass.h"
#import "CoreDataService.h"
#import "UpdateCheck.h"
#import "User.h"
#import "MGSwipeButton.h"
#import "ClassScheduleItem.h"
#import "ClassScheduleCell.h"
#import "ClassScheduleDetails.h"

@class UtilityClass;
@class CoreDataService;

@interface AulasVC : UITableViewController <MGSwipeTableCellDelegate>
{
    UtilityClass *utils;
    CoreDataService *coreDataService;
    NSMutableArray *arrayClassScheduleItens;
    UILabel *lblMessage;
    UILabel *lblWeekDay;
}


@property (weak, nonatomic) IBOutlet UIButton *btnWeekBarBack;
@property (weak, nonatomic) IBOutlet UIButton *btnWeekBarForward;


- (IBAction)btnWeekBarBackClicked:(id)sender;
- (IBAction)btnWeekBarForwardClicked:(id)sender;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

