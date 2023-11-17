//
//  MaisViewController.h
//  treino
//
//  Created by Reginaldo Lopes on 26/11/14.
//  Copyright (c) 2014 4mobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UtilityClass.h"
#import "Global.h"
#import "LoginVC.h"
#import "CoreDataService.h"
#import "TreinosAnterioresViewController.h"

@class UtilityClass;
@class CoreDataService;

@interface MaisVC : UITableViewController <UITableViewDataSource, UITableViewDelegate>
{
    CoreDataService *coreDataService;
    UtilityClass *utils;
   
}

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSPersistentStoreCoordinator  *persistentStoreCoordinator;
@property (weak, nonatomic) IBOutlet UILabel *loginText;
@property (weak, nonatomic) IBOutlet UIImageView *loginImage;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
