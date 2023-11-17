//
//  PerfilViewController.h
//  mobitrainner
//
//  Created by Reginaldo Lopes on 03/12/14.
//  Copyright (c) 2014 4mobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataService.h"
#import "UtilityClass.h"
#import "Global.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"

#define kDatePickerIndex 5
#define kDatePickerCellHeight 162
@class IMManager;
@class UtilityClass;
@class CoreDataService;

@interface PerfilVC : UITableViewController <UINavigationControllerDelegate, UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate>
{
    UtilityClass *utils;
    CoreDataService *coreDataService;
    UIActivityIndicatorView *spinner;
    dispatch_group_t group;
    dispatch_queue_t queue;
    BOOL flagNeedsUploadPicture;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageUser;
@property (weak, nonatomic) IBOutlet UITextField *textFieldFistName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldLastName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldBirthDate;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *textFieldHeight;
@property (weak, nonatomic) IBOutlet UITextField *textFieldWeight;
@property (weak, nonatomic) IBOutlet UIButton *buttonSave;
@property (weak, nonatomic) IBOutlet UIButton *buttonChangePicture;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (strong, nonatomic) NSDate *dateBirth;
@property (nonatomic) BOOL datePickerIsShowing;

- (void)hideKeyboard;

- (IBAction)buttonSaveClicked:(id)sender;
- (IBAction)buttonChangePictureClicked:(id)sender;
- (IBAction)buttonCloseClicked:(id)sender;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
