//
//  ApagarConta.h
//  ricardocosta
//
//  Created by Rubens Rosa on 31/08/23.
//  Copyright © 2023 Mobitrainer. All rights reserved.
//

#ifndef ApagarConta_h
#define ApagarConta_h



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

@interface ApagarConta : UITableViewController <UITextFieldDelegate>
{
    UtilityClass *utils;
    CoreDataService *coreDataService;
    NSArray *pickerData;
    BOOL isCNPJ;
        BOOL flagEmail;
    BOOL flagSenha;
    BOOL flagCSenha;
    BOOL flagEnd;
}
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;

@property (weak, nonatomic) IBOutlet UITextField *textFieldSenha;
@property (weak, nonatomic) IBOutlet UITextField *textFieldConfirmarSenha;
@property (weak, nonatomic) IBOutlet UILabel *lblCrieSuaConta;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) IBOutlet UIButton *btnCancelar;
@property (strong, nonatomic) IBOutlet UIButton *btnCadastrar;
@property (weak, nonatomic) IBOutlet UIButton *btnTermos;

@property (nonatomic) BOOL pickerIsShowing;


- (IBAction)btnApagarClicado:(id)sender;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#endif /* ApagarConta_h */
