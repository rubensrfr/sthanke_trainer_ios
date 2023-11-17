////
//  MeusTreinosViewController.h
//  mobitrainer
//
//  Created by Rubens Rosa on 09/11/2017.
//  Copyright © 2017 4mobi. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Global.h"
#import "UtilityClass.h"
#import "SVProgressHUD.h"
#import "serieViewController.h"
#import "MeusTreinosCell.h"
#import "CoreDataService.h"

#define TRAINING_ON @"1"
#define TRAINING_OFF @"2"
@class UtilityClass;
@class CoreDataService;

@interface TreinosAnterioresViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    UtilityClass *utils;
    CoreDataService *coreDataService;
    UIView *dimmer;
    UIView *background;
    NSMutableArray *arrayEnabledTraining;
    NSMutableArray *arrayDisabledTraining;
    UILabel *lblMessage;
    dispatch_group_t group;
    dispatch_queue_t queue;
    UIActivityIndicatorView *spinner;
    BOOL flagUpdate;
    NSInteger unreadCount;
}

//@property (strong, nonatomic) NSTimer *timerCheckUpdate;
@property (strong, nonatomic) NSTimer *timerMessageCount;


@property (weak, nonatomic) IBOutlet UIImageView *imageUser;
@property (weak, nonatomic) IBOutlet UILabel *nameUser;
@property (weak, nonatomic) IBOutlet UILabel *emailUser;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnReload;
@property (nonatomic, retain) NSString  *treineeID;
@property (nonatomic, retain) NSString  *treineeEmail;
@property (nonatomic) BOOL isHistory;
@property (weak, nonatomic) IBOutlet UITableView *tableViewMeusTreinos;
@property (weak, nonatomic) IBOutlet UINavigationItem *chatIcon;
- (IBAction)btnClose:(id)sender;


@end

