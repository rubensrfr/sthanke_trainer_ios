//
//  CadastroViewController.h
//  mobitrainer
//
//  Created by Reginaldo Lopes on 28/07/15.
//  Copyright (c) 2015 4mobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"
#import "UtilityClass.h"
#import "CoreDataService.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "CWSBrasilValidate.h"

#define kPickerIndex 6
#define kPickerCellHeight 164
@class CoreDataService;

@interface CadastroVC : UITableViewController <UITextFieldDelegate>
{
    UtilityClass *utils;
    CoreDataService *coreDataService;
    NSArray *pickerData;
    BOOL isCNPJ;
    BOOL flagNome;
    BOOL flagSobrenome;
    BOOL flagEmail;
    BOOL flagDocumento;
    BOOL flagSenha;
    BOOL flagCSenha;
    BOOL flagEnd;
}

@property (weak, nonatomic) IBOutlet UITextField *textFieldNome;
@property (weak, nonatomic) IBOutlet UITextField *textFieldSobrenome;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *textFieldDocumento;
@property (weak, nonatomic) IBOutlet UITextField *textFieldTipo;
@property (weak, nonatomic) IBOutlet UITextField *textFieldSenha;
@property (weak, nonatomic) IBOutlet UITextField *textFieldConfirmarSenha;
@property (weak, nonatomic) IBOutlet UILabel *lblCrieSuaConta;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) IBOutlet UIButton *btnCancelar;
@property (strong, nonatomic) IBOutlet UIButton *btnCadastrar;
@property (weak, nonatomic) IBOutlet UIButton *btnTermos;

@property (nonatomic) BOOL pickerIsShowing;

- (IBAction)btnCancelarClicado:(id)sender;
- (IBAction)btnCadastrarClicado:(id)sender;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
