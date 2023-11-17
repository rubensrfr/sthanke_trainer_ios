//
//  UIViewController+HomeViewController.h
//  mobitrainer
//
//  Created by Rubens Rosa on 19/02/2018.
//  Copyright © 2018 4mobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"
#import "AppDelegate.h"
#import "PageViewManager.h"
#import "AFNetworking.h"
#import "TDBadgedCell.h"
#import "UtilityClass.h"
#import "MeusTreinosViewController.h"
#import "CoreDataService.h"
#import "UpdateCheck.h"
#import "LoginVC.h"
#import "AulasVC.h"
#import "BlogCell.h"
#import "BlogDetalhesVC.h"
#import "BlogFeeds+CoreDataClass.h"


@class UtilityClass;
@class CoreDataService;

#define HOME_ROW_TREINOS 0
#define HOME_ROW_LIB 1
#define HOME_ROW_HIST 2
#define HOME_ROW_CHAT 3
#define HOME_ROW_CLASS 4
#define HOME_ROW_BLOG 5

@interface HomeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,NSXMLParserDelegate>
{
    UtilityClass *utils;
    CoreDataService *coreDataService;
    BOOL flagUpdate;
    NSInteger unreadCount;
	
	 UIRefreshControl *refreshControl;
    NSMutableArray *arrayFeeds;
    NSMutableArray *arrayLocalFeeds;
	
    NSXMLParser *rssParser, *parseDestaque;
    NSMutableDictionary *item;
    NSString *currentElement;
    NSMutableString *guid;
    NSMutableString *currentTitle, *currentDate, *currentDescription, *currentGUID, *currentContent,*currentLink;
    int linha;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageDestaques;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

//@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;

//@property (strong, nonatomic) NSTimer *timerCheckUpdate;
//@property (strong, nonatomic) NSTimer *timerLater;
@property (strong, nonatomic) NSTimer *timerMessageCount;
@property (strong, nonatomic) NSMutableArray *arrayImages;
@property (strong, nonatomic) PageViewManager *pageViewManager;
@property (weak, nonatomic) IBOutlet UIView *viewImage;

- (void)fixNavBarColor;
- (void)loadImagensFromCacheFolder;
- (void)updateDesignWithDatesToCheck:(UpdateCheck *)uCheck;
- (void)updateBlogWithDatesToCheck:(UpdateCheck *)uCheck;
- (void)updateTrainerInfoWithDatesToCheck:(UpdateCheck *)uCheck;
- (IBAction)blogReloadBtn:(id)sender;



@end



////////////////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////


