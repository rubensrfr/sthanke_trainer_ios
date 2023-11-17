//
//  ApagarConta.m
//  ricardocosta
//
//  Created by Rubens Rosa on 31/08/23.
//  Copyright © 2023 Mobitrainer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApagarConta.h"

@interface ApagarConta()

@end

@implementation ApagarConta


@synthesize textFieldEmail;
@synthesize textFieldSenha;
@synthesize textFieldConfirmarSenha;
@synthesize btnCancelar;
@synthesize btnCadastrar;
//@synthesize pickerView;
//@synthesize pickerIsShowing;

@synthesize lblCrieSuaConta;

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - VIEW LIFECYCLE

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.tableView.delegate = self;
    [self.tableView setScrollEnabled:NO];

    
    flagEmail = NO;
    flagSenha = NO;
    flagCSenha = NO;
    flagEnd = NO;
	
    utils = [[UtilityClass alloc] init];

	
    // Inicializa o helper do Banco de dados.
    coreDataService = [[CoreDataService alloc] init];
    [coreDataService initialize];
	
    textFieldEmail.delegate = self;
	 textFieldSenha.delegate = self;
	 textFieldConfirmarSenha.delegate = self;
	
    // Configura um gesture recognizer para esconder o teclado quando clicar na tableView.
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(hideKeyboard)];
	
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:gestureRecognizer];

    // Initialize Data
 //   pickerData = @[@"Personal Trainer", @"Estúdio", @"Academia", @"Aluno", @"Outro"];


}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (!IS_IPHONE5)
    {
        [self.tableView setScrollEnabled:YES];
    }
	
    self.btnCadastrar.enabled = YES;
    self.btnCadastrar.alpha = 0.5f;
	
    if (flagEnd || ( flagEmail && flagSenha && flagCSenha))
    {
        self.btnCadastrar.enabled = YES;
        self.btnCadastrar.alpha = 1.0f;
    }
    else
    {
		 
//         [utils showAlertWithTitle:kTEXT_ALERT_TITLE
//                              AndText:@"Leia atentamente o termos de uso, preencha todos os campos e pressione o botão Criar!"
//                         AndTargetVC:self];
                         
	//	 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Atenção!"
     //                                                   message:@"Ao prosseguir você confirma estar ciente que todos seus dados serão definitivamente apagados e que este processo é irreversível!"
//
       //                                                delegate:self
         //                                     cancelButtonTitle:@"Desejo Prosseguir!"
           //                                   otherButtonTitles:nil];
		 
       // [alert show];
		 
		 
		 //Step 1: Create a UIAlertController
    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"Atenção"
                                                              message: @"Ao prosseguir você confirma estar ciente que todos seus dados serão definitivamente apagados e que este processo é irreversível!"
//"
                                                              preferredStyle:UIAlertControllerStyleAlert                   ];

    //Step 2: Create a UIAlertAction that can be added to the alert
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Confirmar."
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             //Do some thing here, eg dismiss the alertwindow
                             [myAlertController dismissViewControllerAnimated:YES completion:nil];

                         }];

    //Step 3: Add the UIAlertAction ok that we just created to our AlertController
    [myAlertController addAction: ok];

    //Step 4: Present the alert to the user
    [self presentViewController:myAlertController animated:YES completion:nil];
		 
    }
    [self.textFieldEmail becomeFirstResponder];
}


- (BOOL)shouldAutorotate
{
    return NO;
}



#pragma mark - UITEXTFIELD DELEGATE

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.textFieldEmail)
    {
        [self.textFieldSenha becomeFirstResponder];
        return YES;
    }
	
    else if (textField == self.textFieldSenha)
    {
        [self.textFieldConfirmarSenha becomeFirstResponder];
        return YES;
    }
    else if (textField == self.textFieldConfirmarSenha)
    {
        [self.textFieldConfirmarSenha resignFirstResponder];
        return YES;
    }
	
    return NO;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
     if (textField == textFieldEmail) return YES;
    if (textField == textFieldSenha) return YES;
    if (textField == textFieldConfirmarSenha) return YES;
	

	
    return NO;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////


- (void)textFieldDidEndEditing:(UITextField *)textField
{
   
    ///////////////////////////////////////////////////////////////////////////////
    /// TEXTFIELD EMAIL ///////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////
	
    if (textField == self.textFieldEmail)
    {
        /////////////////////////////////////////////////////////////
        /// TESTA SE O EMAIL É VALIDO ///////////////////////////////
        /////////////////////////////////////////////////////////////
		 
        if (![utils validateEmailWithString:textFieldEmail.text])
        {
            flagEmail = NO;
			  
            [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                              AndText:@"Dados inválidos!"
                         AndTargetVC:self];
        }
        else
        {
            flagEmail = YES;
        }
    }
	
    ///////////////////////////////////////////////////////////////////////////////
    /// TEXTFIELD SENHA ///////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////
	
    if (textField == self.textFieldConfirmarSenha)
    {
        if (textField.text > 0)
        {
            flagSenha = YES;
        }
    }
	
    ///////////////////////////////////////////////////////////////////////////////
    /// TEXTFIELD CONFIRMA SENHA //////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////
	
    if (textField == self.textFieldConfirmarSenha)
    {
        /////////////////////////////////////////////////////////////
        ///////////////////////////// ///////////////////////////////
        /////////////////////////////////////////////////////////////
		 
        if ((![self.textFieldConfirmarSenha.text isEqualToString:self.textFieldSenha.text]) ||
               self.textFieldSenha.text.length <= 5 || textFieldConfirmarSenha.text.length <= 5)
        {
            flagCSenha = NO;
            [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                              AndText:@"Senha iválida. As senhas devem ser iguais, com pelo menos 6 caracteres!"
                          AndTargetVC:self];
        }
        else
        {
            flagEnd = YES;
            flagCSenha = YES;
        }
    }
	
    if (flagEmail &&  flagSenha && flagCSenha)
    {
        self.btnCadastrar.enabled = YES;
        self.btnCadastrar.alpha = 1.0f;
    }
    else
    {
        if (flagEnd)
        {
            self.btnCadastrar.enabled = YES;
            self.btnCadastrar.alpha = 0.5f;

			  
        }

    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)textField:(UITextField *)textField_ shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textFieldEmail.editing ||  textFieldSenha.editing || textFieldConfirmarSenha.editing)
    {
        return YES;
    }
	
   
	
    return NO;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - ACTIONS

- (IBAction)btnCancelarClicado:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (IBAction)btnApagarClicado:(id)sender
{
	if (!(flagEnd || ( flagEmail && flagSenha && flagCSenha)))
	{
	[utils showAlertWithTitle:kTEXT_ALERT_TITLE
                          AndText:@"Verifique se todos os campos estão preenchidos corretamente!"
                      AndTargetVC:self];
                      return;
	}
	if (![utils validateEmailWithString:textFieldEmail.text]) {
	
        [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                          AndText:@"Email Inválido! Por Favor verifique o email digitado."
                      AndTargetVC:self];
	
        return;
    }
	dispatch_async(dispatch_get_main_queue(), ^{
		
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Atenção"
                                                  message:@"Se você não tem certeza que deseja apagar sua conta, clique em Cancelar! Para concluir a remoção, clique em Prosseguir."
                                                  preferredStyle:UIAlertControllerStyleAlert];
#ifdef NEW_STYLE
            alertController.view.tintColor=[UIColor colorNamed:@"myCellTextColor"];
#endif
            UIAlertAction *actionYES = [UIAlertAction actionWithTitle:@"Prosseguir"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action){
																					  
	[SVProgressHUD showWithStatus:@"Deletando sua conta..." maskType:SVProgressHUDMaskTypeGradient];
	
    // Cria um operation manager para realizar a solicitação via POST.
  //  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//		[manager.requestSerializer setTimeoutInterval:AFHHTTP_TIMEOUT];
    NSUserDefaults *Defaults = [NSUserDefaults standardUserDefaults];
	 NSString *token = [Defaults objectForKey:@"deviceTokenKey"];
    if (token.length == 0 || token == nil )
		{
			 token = @"";
		}
		
		
    // Monta a string de acesso a validação do login.
    NSMutableString *urlString = [[NSMutableString alloc] init];
    [urlString appendString:kBASE_URL_MOBITRAINER];
    [urlString appendString:@"api/account/delete"];

	User *userData = (User *) [self->coreDataService getDataFromUserTable];
	NSString *salt = [KKBCrypt generateSaltWithNumberOfRounds:8];
	NSString *hashPassword = [KKBCrypt hashPassword:self->textFieldSenha.text withSalt:salt];
     // Parametros validados.
    NSDictionary *parameters = @{
                                 @"apikey":userData.apiKey,
											@"email":self->textFieldEmail.text,
											@"password":hashPassword,
										};
	
	
    // Realiza o POST das informações e aguarda o retorno.
 //   [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
	 AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
 			[manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
 			NSString *path=[[NSString alloc]initWithFormat:@"%@",urlString];
 			[manager POST:[NSURL URLWithString:path].absoluteString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
 			{
        if (![[responseObject objectForKey:@"response_error"] boolValue])
        {
				 [SVProgressHUD dismiss];
				 [self->utils showAlertWithTitle:kTEXT_ALERT_TITLE
                                      AndText:KTEXT_ACCOUNT_DELETED
                                  AndTargetVC:self];
			    [self logOff];
        }
        else
        {
            [SVProgressHUD dismiss];
            switch([[responseObject objectForKey:@"response_error_code"] longValue])
            {
                
                
                case 615:
						[self->utils showAlertWithTitle:kTEXT_ALERT_TITLE
                                      AndText:KTEXT_ERROR_EMAIL_INVALID
                                  AndTargetVC:self];
                    break;
					
                case 666:
						[self->utils showAlertWithTitle:kTEXT_ALERT_TITLE
                                      AndText:KTEXT_ERROR_DATA
                                  AndTargetVC:self];
                    break;
					
					
                default:
						[self->utils showAlertWithTitle:kTEXT_ALERT_TITLE
                                      AndText:kTEXT_SERVER_ERROR_DEFAULT
                                  AndTargetVC:self];
                    break;
					
            }
        }
		 
		 
		 
    } failure:^(NSURLSessionTask *operation, NSError *error) {
		 
        NSLog(@"Error: %@", error);
		 
        [SVProgressHUD dismiss];
		 
		 [self->utils showAlertWithTitle:kTEXT_ALERT_TITLE
                          AndText:kTEXT_SERVER_ERROR_DEFAULT
                      AndTargetVC:self];
    }];
																																												// Configura um custom AlertView.
																					  
																								  return;
																						
                                                              }];
		
            UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancelar"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * action){
                     
                                                                     [alertController dismissViewControllerAnimated:YES completion:nil];
																						  
                                                                 }];
		
		
            [alertController addAction:actionCancel];
            [alertController addAction:actionYES];
		
		
            [self presentViewController:alertController animated:YES completion:nil];
        });
	 
	
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - CUSTOM METHODS

- (void)hideKeyboard
{
	
    [textFieldEmail resignFirstResponder];
    [textFieldSenha resignFirstResponder];
    [textFieldConfirmarSenha resignFirstResponder];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////



- (void)logOff
{
    User *userData = (User *) [coreDataService getDataFromUserTable];
    
    ////////////////////////////////////////////////////////////////////////
    /// SALVA OS DADOS NO DEFAULTS /////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    
    NSUserDefaults *Defaults = [NSUserDefaults standardUserDefaults];
    [Defaults setBool:FALSE forKey:@"userStatus"];
    [Defaults setObject: userData.apiKey forKey:@"userOldAPIKey"];
    [Defaults synchronize];
    
    ////////////////////////////////////////////////////////////////////////
    /// LIMPA A TABELA DE UPDATES //////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    
    LastUpdates *lastUpdate = (LastUpdates *) [coreDataService getDataFromLastUpdatesTable];
    
	
    lastUpdate.chat = @"1970-01-01 00:00:00";
    lastUpdate.radio = @"1970-01-01 00:00:00";
    lastUpdate.trainerInfo = @"1970-01-01 00:00:00";
	
    NSError *error;
    
    [self.managedObjectContext save:&error];
    
    if(!([self.managedObjectContext save:&error])) {
        // Handle Error here.
        NSLog(@"LOG: %@", [error localizedDescription]);
    }
    
    ////////////////////////////////////////////////////////////////////////
    /// LIMPA AS OUTRAS TABELAS ////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    
    //[coreDataService dropExercisesTable];
    //[coreDataService dropHistoryTable];
    [coreDataService dropClassScheduleItemTable];
    [coreDataService dropClassScheduleTable];
    
    ////////////////////////////////////////////////////////////////////////
    /// CARREGA A TELA DE LOGIN ////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    
 //   [[NSNotificationCenter defaultCenter] postNotificationName:@"stopTimerUpdateThread" object:self];
    
 //   UIStoryboard *storyboard = [UIApplication sharedApplication].delegate.window.rootViewController.storyboard;
//    LoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"Login"];
//    LoginViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    [super.view.window.rootViewController presentViewController:LoginViewController animated:YES completion:nil];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}


@end

////////////////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
