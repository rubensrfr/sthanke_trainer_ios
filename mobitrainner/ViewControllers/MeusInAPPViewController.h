#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Global.h"
#import "UtilityClass.h"
#import "SVProgressHUD.h"
#import "serieViewController.h"
#import "MeusTreinosCell.h"
#import "CoreDataService.h"
#import "welcomeViewController.h"
#import "AssesoriaTableViewController.h"




#define TRAINING_ON @"1"
#define TRAINING_OFF @"2"
@class IMManager;
@class UtilityClass;
@class CoreDataService;

@interface MeusInAPPViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
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
- (IBAction)btnReload:(id)sender;

//@property (strong, nonatomic) NSTimer *timerCheckUpdate;
@property (strong, nonatomic) NSTimer *timerMessageCount;

@property (nonatomic, retain) NSString  *training_id;
@property (nonatomic, retain) NSString  *digitalproduct_id;
@property (nonatomic, retain) NSString  *product_id;
@property (nonatomic, retain) NSString  *welcome_video;
@property (nonatomic, retain) NSString  *training_name;
@property (nonatomic, retain) NSString  *training_description;
@property (nonatomic, retain) NSString  *sale_video;
@property (nonatomic) BOOL  training_is_inapp;
@property (weak, nonatomic) IBOutlet UIImageView *imageUser;
@property (weak, nonatomic) IBOutlet UILabel *nameUser;
@property (weak, nonatomic) IBOutlet UILabel *emailUser;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnReload;
@property (nonatomic, retain) NSString  *treineeID;
@property (nonatomic, retain) NSString  *treineeEmail;
@property (nonatomic) BOOL isHistory;
@property (weak, nonatomic) IBOutlet UITableView *tableViewMeusTreinos;
@property (weak, nonatomic) IBOutlet UINavigationItem *chatIcon;
@property (weak, nonatomic) IBOutlet UITextView *trainingNameTV;
- (IBAction)sobreBtn:(id)sender;
- (IBAction)historicoBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *semTreinoTV;


@end
