//
//  ListAllViewController.h
//
//
//  Created by Rubens Rosa on 15/03/2018.
//  Copyright © 2018 4mobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Global.h"
#import "UtilityClass.h"
#import "SVProgressHUD.h"
#import "serieViewController.h"
#import "MeusTreinosCell.h"
#import "CoreDataService.h"
#import "productCell.h"
#import "AssesoriaTableViewController.h"
#import "transactionClass.h"
#import "MeusInAPPViewController.h"
#import "MeusTreinosViewController.h"
#import "welcomeViewController.h"


#define TRAINING_ON @"1"
#define TRAINING_OFF @"2"
@class IMManager;
@class UtilityClass;
@class CoreDataService;

@interface StoreViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    UtilityClass *utils;
    CoreDataService *coreDataService;
    UIView *dimmer;
    UIView *background;
    NSMutableArray *inAppProdutosMutArray;
    NSMutableArray *inAppTransactionsMutArray;
    UILabel *lblMessage;
    dispatch_group_t group;
    dispatch_queue_t queue;
    UIActivityIndicatorView *spinner;
    BOOL flagUpdate;
    NSInteger unreadCount;
    UIRefreshControl *refreshControl;
}

//@property (strong, nonatomic) NSTimer *timerCheckUpdate;
@property (strong, nonatomic) NSTimer *timerMessageCount;
@property (weak, nonatomic) IBOutlet UIImageView *loginBackgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *iconBackgroungImage;

@property (weak, nonatomic) IBOutlet UIButton *buttonLogin;
@property (weak, nonatomic) IBOutlet UIButton *buttonMais;


@property (weak, nonatomic) IBOutlet UIImageView *imageUser;
@property (weak, nonatomic) IBOutlet UILabel *nameUser;
@property (weak, nonatomic) IBOutlet UILabel *emailUser;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnReload;
@property (nonatomic, retain) NSString  *treineeID;
@property (nonatomic, retain) NSString  *treineeEmail;
@property (nonatomic) BOOL isHistory;
@property (weak, nonatomic) IBOutlet UITableView *tableViewMeusTreinos;
@property (weak, nonatomic) IBOutlet UINavigationItem *chatIcon;


@end
