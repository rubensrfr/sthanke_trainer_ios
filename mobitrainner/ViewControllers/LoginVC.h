//
//  ViewController.h
//  treino
//
//  Created by Reginaldo Lopes on 25/11/14.
//  Copyright (c) 2014 4mobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "UtilityClass.h"
#import "CoreDataService.h"
#import "UpdateCheck.h" 
#import "User.h"
#import "KKBCrypt.h"


@class UtilityClass;
@class CoreDataService;

@interface LoginVC : UITableViewController <UITextFieldDelegate>
{
    UtilityClass *utils;
    CoreDataService *coreDataService;
}

@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *textFieldSenha;
@property (weak, nonatomic) IBOutlet UIButton *buttonLogin;
@property (weak, nonatomic) IBOutlet UIButton *buttonEsqueceu;
@property (weak, nonatomic) IBOutlet UIButton *buttonCadastro;

- (IBAction)buttonLoginClicked:(id)sender;
- (IBAction)buttonForgotPasswordClicked:(id)sender;

- (void)hideKeyboard;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

