//
//  BioController.h
//  mobitrainner
//
//  Created by Reginaldo Lopes on 03/12/14.
//  Copyright (c) 2014 4mobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UtilityClass.h"
#import "Global.h"
#import "CoreDataService.h"
#import <MessageUI/MessageUI.h>

@class UtilityClass;
@class CoreDataService;

@interface BioVC : UITableViewController<MFMailComposeViewControllerDelegate>
{
    UtilityClass *utils;
    CoreDataService *coreDataService;
    UIActivityIndicatorView *spinner;
    dispatch_group_t group;
    dispatch_queue_t queue;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageTrainer;
@property (weak, nonatomic) IBOutlet UILabel *labelTrainerName;
@property (weak, nonatomic) IBOutlet UILabel *labelTrainerEmail;
@property (weak, nonatomic) IBOutlet UILabel *labelDocument;
@property (weak, nonatomic) IBOutlet UITextView *textViewSobre;
- (IBAction)facebookBtn:(id)sender;
- (IBAction)instagramBtn:(id)sender;
- (IBAction)phonrBtn:(id)sender;
- (IBAction)emailBtn:(id)sender;
- (IBAction)webBtn:(id)sender;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
