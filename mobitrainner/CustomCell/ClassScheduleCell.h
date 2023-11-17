//
//  ClassScheduleCell.h
//  mobitrainer
//
//  Created by Reginaldo Lopes on 29/07/16.
//  Copyright © 2016 4mobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"
#import "ClassScheduleItem.h"
#import "CoreDataService.h"
#import "Global.h"
#import "UtilityClass.h"
#import "AulasVC.h"

@interface ClassScheduleCell : MGSwipeTableCell

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblTeacher;
@property (weak, nonatomic) IBOutlet UILabel *lblStartAt;
@property (weak, nonatomic) IBOutlet UILabel *lblDuration;
@property (weak, nonatomic) IBOutlet UILabel *lblMoreInfo;
@property (weak, nonatomic) IBOutlet UIImageView *imgMoreInfo;

-(void)configureCell:(ClassScheduleItem *)csi;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
