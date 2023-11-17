//
//  HistoricoViewController.h
//  treino
//
//  Created by Reginaldo Lopes on 27/11/14.
//  Copyright (c) 2014 4mobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKCalendarView.h"
#import "UtilityClass.h"
#import "Global.h"
#import "AppDelegate.h"
#import "HistoricoCell.h"
#import "CoreDataService.h"

@class UtilityClass;
@class CoreDataService;

@interface HistoricoVC : UIViewController <CKCalendarDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UtilityClass *utils;
    CoreDataService *coreDataService;
    NSMutableArray *arrayDates;
    NSMutableArray *arrayFiltered;
    NSMutableArray *arrayHistory;
    NSString *selected;
    UILabel *lblMessage;
    BOOL flagSelect;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) BOOL flagByID;
@property(nonatomic, strong) NSString *treineeID;

@property(nonatomic, strong) CKCalendarView *calendar;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;
@property(nonatomic, strong) NSArray *disabledDates;

- (IBAction)todayDateClicked:(id)sender;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////


#if 0
//
//  HistoricoViewController.h
//  treino
//
//  Created by Reginaldo Lopes on 27/11/14.
//  Copyright (c) 2014 4mobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKCalendarView.h"
#import "UtilityClass.h"
#import "Global.h"
#import "AppDelegate.h" 
#import "HistoricoCell.h"
#import "CoreDataService.h"

@class UtilityClass;
@class CoreDataService;

@interface HistoricoVC : UIViewController <CKCalendarDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UtilityClass *utils;
    CoreDataService *coreDataService;
    NSMutableArray *arrayDates;
    NSMutableArray *arrayFiltered;
    NSMutableArray *arrayHistory;
    NSString *selected;
    UILabel *lblMessage;
    BOOL flagSelect;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) BOOL flagByID;
@property(nonatomic, strong) NSString *treineeID;

@property(nonatomic, strong) CKCalendarView *calendar;
//@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;
@property(nonatomic, strong) NSArray *disabledDates;

- (IBAction)todayDateClicked:(id)sender;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#endif
