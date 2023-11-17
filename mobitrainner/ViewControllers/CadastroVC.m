//
//  CadastroViewController.m
//  mobitrainer
//
//  Created by Reginaldo Lopes on 28/07/15.
//  Copyright (c) 2015 4mobi. All rights reserved.
//

#import "CadastroVC.h"

@interface CadastroVC()

@end

@implementation CadastroVC

@synthesize textFieldNome;
@synthesize textFieldSobrenome;
@synthesize textFieldEmail;
@synthesize textFieldDocumento;
@synthesize textFieldTipo;
@synthesize textFieldSenha;
@synthesize textFieldConfirmarSenha;
@synthesize btnCancelar;
@synthesize btnCadastrar;
//@synthesize pickerView;
//@synthesize pickerIsShowing;
@synthesize btnTermos;
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

    flagNome = NO;
    flagSobrenome = NO;
    flagEmail = NO;
    flagDocumento = NO;
    flagSenha = NO;
    flagCSenha = NO;
    flagEnd = NO;
	
    utils = [[UtilityClass alloc] init];

	
    // Inicializa o helper do Banco de dados.
    coreDataService = [[CoreDataService alloc] init];
    [coreDataService initialize];
	
//    // Configura o background da tableview.
//    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
//                                                                      self.view.frame.size.width,
//                                                                      self.view.frame.size.height)];
//
//    UIImageView *imageBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"FrostBackground"]];
//    [backgroundView addSubview:imageBG];
//
 //   [self.tableView setBackgroundView:backgroundView];
    // add Padding no textfield Nome.
//    UIView *tfNomePad = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 36, 20)];
//    textFieldNome.leftView = tfNomePad;
//    textFieldNome.leftViewMode = UITextFieldViewModeAlways;
    textFieldNome.delegate = self;
	
    // add Padding no textfield Sobrenome.
//    UIView *tfSNomePad = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 36, 20)];
//    textFieldSobrenome.leftView = tfSNomePad;
//    textFieldSobrenome.leftViewMode = UITextFieldViewModeAlways;
    textFieldSobrenome.delegate = self;
	
    // add Padding no textfield Email.
//    UIView *tfEmailPad = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 36, 20)];
//    textFieldEmail.leftView = tfEmailPad;
//    textFieldEmail.leftViewMode = UITextFieldViewModeAlways;
    textFieldEmail.delegate = self;
	
//    // add Padding no textfield CREF.
//    UIView *tfCREFPad = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 36, 20)];
//    textFieldDocumento.leftView = tfCREFPad;
//    textFieldDocumento.leftViewMode = UITextFieldViewModeAlways;
//    textFieldDocumento.delegate = self;
//
    // add Padding no textfield Tipo.
//    UIView *tfTipoPad = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 36, 20)];
//    textFieldTipo.leftView = tfTipoPad;
//    textFieldTipo.leftViewMode = UITextFieldViewModeAlways;
//    textFieldTipo.delegate = self;
	
    // add Padding no textfield Senha.
//    UIView *tfSenhaPad = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 36, 20)];
//    textFieldSenha.leftView = tfSenhaPad;
//    textFieldSenha.leftViewMode = UITextFieldViewModeAlways;
    textFieldSenha.delegate = self;
	
    // add Padding no textfield Senha.
//    UIView *tfCSenhaPad = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 36, 20)];
//    textFieldConfirmarSenha.leftView = tfCSenhaPad;
//    textFieldConfirmarSenha.leftViewMode = UITextFieldViewModeAlways;
    textFieldConfirmarSenha.delegate = self;
	
    // Configura um gesture recognizer para esconder o teclado quando clicar na tableView.
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(hideKeyboard)];
	
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:gestureRecognizer];

    // Initialize Data
 //   pickerData = @[@"Personal Trainer", @"Estúdio", @"Academia", @"Aluno", @"Outro"];

#if 0
    NSString *btnNome = btnTermos.titleLabel.text;
	
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:btnNome];
	
    [text addAttribute:NSUnderlineStyleAttributeName
                 value:[NSNumber numberWithInt:1]
                 range:NSMakeRange(0, [btnNome length])];
	
    // Formata a fonte e a cor do texto dentro do range configurado.
    [text addAttribute:NSForegroundColorAttributeName
                 value:UIColorFromRGB(0xFFFFFF)
                 range:NSMakeRange(0, [btnNome length])];
	
    [text addAttribute:NSFontAttributeName
                 value:[UIFont boldSystemFontOfSize:12]
                 range:NSMakeRange(0, [btnNome length])];
	
    [btnTermos setAttributedTitle:text forState:UIControlStateNormal];

	
    NSMutableAttributedString *textHigh = [[NSMutableAttributedString alloc] initWithString:btnNome];


    [textHigh addAttribute:NSUnderlineStyleAttributeName
                               value:[NSNumber numberWithInt:1]
                               range:NSMakeRange(0, [btnNome length])];
	
    [textHigh addAttribute:NSFontAttributeName
                               value:[UIFont boldSystemFontOfSize:12]
                               range:NSMakeRange(0, [btnNome length])];
	
    [textHigh addAttribute:NSForegroundColorAttributeName
                               value:UIColorFromRGB(0xA62B2B)
                               range:NSMakeRange(0, [btnNome length])];

    [btnTermos setAttributedTitle:textHigh forState:UIControlStateHighlighted];
#endif
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
	
    if (flagEnd || (flagNome && flagSobrenome && flagEmail && flagDocumento && flagSenha && flagCSenha))
    {
        self.btnCadastrar.enabled = YES;
        self.btnCadastrar.alpha = 1.0f;
    }
    else
    {
		 
//         [utils showAlertWithTitle:kTEXT_ALERT_TITLE
//                              AndText:@"Leia atentamente o termos de uso, preencha todos os campos e pressione o botão Criar!"
//                         AndTargetVC:self];
                         
		 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Atenção!"
                                                        message:@"Leia atentamente o termos de uso, preencha todos os campos e pressione o botão Criar!"
//                         
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
		 
        [alert show];
		 
    }
    [self.textFieldNome becomeFirstResponder];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationPortrait;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)shouldAutorotate
{
    return NO;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////



////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - UITEXTFIELD DELEGATE

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.textFieldNome)
    {
        [self.textFieldSobrenome becomeFirstResponder];
        return YES;
    }
    else if (textField == self.textFieldSobrenome)
    {
        [self.textFieldEmail becomeFirstResponder];
        return YES;
    }
    else if (textField == self.textFieldEmail)
    {
        [self.textFieldSenha becomeFirstResponder];
        return YES;
    }
	
    else if (textField == self.textFieldDocumento)
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
    if (textField == textFieldNome) return YES;
    if (textField == textFieldSobrenome) return YES;
    if (textField == textFieldEmail) return YES;
    if (textField == textFieldSenha) return YES;
    if (textField == textFieldConfirmarSenha) return YES;
	
//    if (textField == textFieldDocumento)
//    {
//        if (isCNPJ)
//        {
//            [textField setKeyboardType:UIKeyboardTypeNumberPad];
//        }
//        else
//        {
//           [textField setKeyboardType:UIKeyboardTypeNamePhonePad];
//        }
//
//        return YES;
//    }
	
    return NO;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    ///////////////////////////////////////////////////////////////////////////////
    /// TEXTFIELD NOME ////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////
	
    if (textField == self.textFieldNome)
    {
        if (textField.text > 0)
        {
            flagNome = YES;
        }
    }
	
    ///////////////////////////////////////////////////////////////////////////////
    /// TEXTFIELD SOBRENOME ///////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////
	
    if (textField == self.textFieldSobrenome)
    {
        if (textField.text > 0)
        {
            flagSobrenome = YES;
        }
    }
	
	
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
                              AndText:@"Email inválido!"
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
	
    if (flagNome && flagSobrenome && flagEmail &&  flagSenha && flagCSenha)
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
//        else
//        {
//			  [utils showAlertWithTitle:kTEXT_ALERT_TITLE
//                              AndText:@"Preencha todos os campos para prosseguir!"
//                         AndTargetVC:self];
//		  }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)textField:(UITextField *)textField_ shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textFieldNome.editing || textFieldSobrenome.editing || textFieldEmail.editing || textFieldTipo.editing || textFieldSenha.editing || textFieldConfirmarSenha.editing)
    {
        return YES;
    }
	
    if (textFieldDocumento.editing)
    {
        if (isCNPJ)
        {
            if ([textFieldDocumento.text length] == 2)
            {
                if ([string isEqualToString:@""])
                {
                    //backspace button pressed
                    return YES;
                }
                else
                {
                    NSString *str = [NSString stringWithFormat:@"%@",textFieldDocumento.text];
                    textFieldDocumento.text = [str stringByAppendingString:@"."];
                }
            }
			  
            if ([textFieldDocumento.text length] == 6)
            {
                if ([string isEqualToString:@""])
                {
                    //backspace button pressed
                    return YES;
                }
                else
                {
                    NSString *str = [NSString stringWithFormat:@"%@",textFieldDocumento.text];
                    textFieldDocumento.text = [str stringByAppendingString:@"."];
                }
            }
			  
            if ([textFieldDocumento.text length] == 10)
            {
                if ([string isEqualToString:@""])
                {
                    //backspace button pressed
                    return YES;
                }
                else
                {
                    NSString *str = [NSString stringWithFormat:@"%@",textFieldDocumento.text];
                    textFieldDocumento.text = [str stringByAppendingString:@"/"];
                }
            }
			  
            if ([textFieldDocumento.text length] == 15)
            {
                if ([string isEqualToString:@""])
                {
                    //backspace button pressed
                    return YES;
                }
                else
                {
                    NSString *str = [NSString stringWithFormat:@"%@",textFieldDocumento.text];
                    textFieldDocumento.text = [str stringByAppendingString:@"-"];
                }
            }
			  
            if (textFieldDocumento.text.length >= 18 && range.length == 0) return NO;

            return YES;
        }
        else
        {
            if ([textFieldDocumento.text length] == 6)
            {
                if ([string isEqualToString:@""])
                {
                    //backspace button pressed
                    return YES;
                }
                else
                {
                    NSString *str = [NSString stringWithFormat:@"%@",textFieldDocumento.text];
                    textFieldDocumento.text = [str stringByAppendingString:@"-"];
                }
            }
			  
            if ([textFieldDocumento.text length] == 8)
            {
                if ([string isEqualToString:@""])
                {
                    //backspace button pressed
                    return YES;
                }
                else
                {
                    NSString *str = [NSString stringWithFormat:@"%@",textFieldDocumento.text];
                    textFieldDocumento.text = [str stringByAppendingString:@"/"];
                }
            }
			  
            if (textFieldDocumento.text.length >= 11 && range.length == 0) return NO;
			  
            return YES;
        }
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

- (IBAction)btnCadastrarClicado:(id)sender
{
	if (!(flagEnd || (flagNome && flagSobrenome && flagEmail && flagDocumento && flagSenha && flagCSenha)))
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
                                                  alertControllerWithTitle:@"Termos de Uso"
                                                  message:@"Ao clicar em Prosseguir você declara ter lido integralmente os termos de uso deste aplicativo disponível nesta tela e estar de acordo com os termos ali descritos."
                                                  preferredStyle:UIAlertControllerStyleAlert];
#ifdef NEW_STYLE
            alertController.view.tintColor=[UIColor colorNamed:@"myCellTextColor"];
#endif
            UIAlertAction *actionYES = [UIAlertAction actionWithTitle:@"Prosseguir"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action){
																					  
	[SVProgressHUD showWithStatus:@"Adicionando novo aluno..." maskType:SVProgressHUDMaskTypeGradient];
	
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
    [urlString appendString:@"api/signupprospect"];

	
	
     // Parametros validados.
    NSDictionary *parameters = @{
                                 @"master_apikey":API_KEY_TRAINER,
                                 @"name":textFieldNome.text,
                                 @"lastname":textFieldSobrenome.text,
                                 @"email":textFieldEmail.text,
                                 @"password":textFieldSenha.text,
                                 @"tokenid":token,
                                 @"tokenos":@"2"
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
        		User *userData = (User *) [coreDataService getDataFromUserTable];
            userData.firstName = textFieldNome.text;
            userData.lastName = textFieldSobrenome.text;
			   userData.email = textFieldEmail.text;
			  
			  
            [coreDataService saveData];
			  
           // [self startTraineesUpdateProcess];
            NSUserDefaults *Defaults = [NSUserDefaults standardUserDefaults];
			  
			  [Defaults setBool:TRUE forKey:@"TrainingNeedUpdate"];
			 
			  [Defaults synchronize];
			  
            [SVProgressHUD showSuccessWithStatus:@"Cadastro realizado com sucesso!" maskType:SVProgressHUDMaskTypeGradient];
          // [self.navigationController popViewControllerAnimated:YES];
			 [self doLoginServer];
        }
        else
        {
            [SVProgressHUD dismiss];
            switch([[responseObject objectForKey:@"response_error_code"] longValue])
            {
                case 805:
                    [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                                      AndText:KTEXT_ERROR_EMAIL_USED
                                  AndTargetVC:self];
                    break;
                case 615:
                    [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                                      AndText:KTEXT_ERROR_EMAIL_INVALID
                                  AndTargetVC:self];
                    break;
					
                case 10000:
                case 617:
                    [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                                      AndText:KTEXT_ERROR_TRAINEES_EXCEEDED
                                  AndTargetVC:self];
                    break;
					
                default:
                    [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                                      AndText:kTEXT_SERVER_ERROR_DEFAULT
                                  AndTargetVC:self];
                    break;
					
            }
        }
		 
		 
		 
    } failure:^(NSURLSessionTask *operation, NSError *error) {
		 
        NSLog(@"Error: %@", error);
		 
        [SVProgressHUD dismiss];
		 
        [utils showAlertWithTitle:kTEXT_ALERT_TITLE
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
	
    [textFieldNome resignFirstResponder];
    [textFieldSobrenome resignFirstResponder];
    [textFieldEmail resignFirstResponder];
    [textFieldSenha resignFirstResponder];
    [textFieldConfirmarSenha resignFirstResponder];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)doLoginServer
{
    // Verifica se todos os campos estão preenchidos.
    if ((textFieldEmail.text.length > 0) && (textFieldSenha.text.length > 0))
    {
        // Verifica se o email está formatado corretamente.
        if ([utils validateEmailWithString:textFieldEmail.text])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showWithStatus:@"Validando as credenciais..." maskType: SVProgressHUDMaskTypeGradient];
            });
    
            ///////////////////////////////////////////////////////////////////////
            /// INICIA A VALIDAÇÃO DO LOGIN ///////////////////////////////////////
            ///////////////////////////////////////////////////////////////////////
			  
            // Cria um operation manager para realizar a solicitação via POST.
          //  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
			 //  [manager.requestSerializer setTimeoutInterval:AFHHTTP_TIMEOUT];
            NSUserDefaults *Defaults = [NSUserDefaults standardUserDefaults];
            NSString *token = [Defaults objectForKey:@"deviceTokenKey"];
			  
            if (token.length == 0 || token == nil )
            {
                token = @"";
            }
			  
            NSString *salt = [KKBCrypt generateSaltWithNumberOfRounds:8];
            NSString *hashPassword = [KKBCrypt hashPassword:textFieldSenha.text withSalt:salt];
			  
            // Parametros validados.
            NSDictionary *parameters = @{@"email": textFieldEmail.text, @"password": hashPassword, @"tokenid":token, @"tokenos":@"2", @"app":APPLICATION_ID};
			  
            // Monta a string de acesso a validação do login.
            NSMutableString *urlString = [[NSMutableString alloc] init];
            [urlString appendString:kBASE_URL_MOBITRAINER];
            [urlString appendString:@"api/authorize_v2"];
  
            // Realiza o POST das informações e aguarda o retorno.
 //           [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
				AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
 			[manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
 			NSString *path=[[NSString alloc]initWithFormat:@"%@",urlString];
 			[manager POST:[NSURL URLWithString:path].absoluteString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
                if (![[responseObject objectForKey:@"response_error"] boolValue])
                {
                    // Se login, grava status no NSDefaults.
                    NSUserDefaults *Defaults = [NSUserDefaults standardUserDefaults];
                    [Defaults setObject:[responseObject objectForKey:@"response_email"] forKey:@"userLastValidEmail"];
						 
						  [Defaults setBool:TRUE forKey:@"TrainingNeedUpdate"];
						  [Defaults setBool:TRUE forKey:@"userStatus"];
                    [Defaults synchronize];
						 
						 
                    // APAGA OS DADOS DA TABELA TREINOS
                    [coreDataService dropUserTable];
						 
						 
						 
                    ////////////////////////////////////////////////////////////////////////
                    /// CARREGA OS DADOS DO USUARIO ////////////////////////////////////////
                    ////////////////////////////////////////////////////////////////////////
						 
                    User *userData = (User *)[NSEntityDescription insertNewObjectForEntityForName:@"User"
                                                                           inManagedObjectContext:coreDataService.getManagedContext];
						 
                    userData.email = [utils checkString:[responseObject objectForKey:@"response_email"]];
                    userData.apiKey = [utils checkString:[responseObject objectForKey:@"response_apikey"]];
                    userData.createAt = [utils checkString:[responseObject objectForKey:@"response_create_at"]];
                    userData.firstName = [utils checkString:[responseObject objectForKey:@"response_name"]];
                    userData.lastName = [utils checkString:[responseObject objectForKey:@"response_lastname"]];
                    userData.level = [NSNumber numberWithInteger:[[utils checkString:[responseObject objectForKey:@"response_level"]] integerValue]];
                    userData.image = [utils checkString:[responseObject objectForKey:@"response_photo"]];
                    userData.birthday = [utils checkString:[responseObject objectForKey:@"response_birthday"]];
                    userData.gender = [utils checkString:[responseObject objectForKey:@"response_gender"]];
                    userData.height = [NSNumber numberWithFloat:[[utils checkString:[responseObject objectForKey:@"response_height"]] floatValue]];
                    userData.weight = [NSNumber numberWithFloat:[[utils checkString:[responseObject objectForKey:@"response_weight"]] floatValue]];
                    userData.userID = [utils checkString:[responseObject objectForKey:@"response_id"]];
                    userData.trainerID = [utils checkString:[responseObject objectForKey:@"response_trainer_id"]];
						 
                    [coreDataService saveData];
						  [utils updateTransactionsToServer];
				//		  [coreDataService dropInAppTransactionsTable];
						  [self.navigationController popToRootViewControllerAnimated:YES];
						//  [self performSegueWithIdentifier:@"TreinosLogado" sender:self];
						 
						 
						 
						 
                 }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                    });
						 
                    [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                                      AndText:@"Senha e/ou email Incorretos. \n Por favor, tente novamente!"
                                  AndTargetVC:self];
                }
					
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
					
            } failure:^(NSURLSessionTask *operation, NSError *error){
					
                NSLog(@"Error: %@", error);
					
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
					
                [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                                  AndText:kTEXT_SERVER_ERROR_DEFAULT
                              AndTargetVC:self];
            }];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
			  
            [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                              AndText:@"Verifique se todos os campos estão preenchidos corretamente!"
                          AndTargetVC:self];
        }
    }
	
}



@end

////////////////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
