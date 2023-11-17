//
//  ViewController.m
//  treino
//
//  Created by Reginaldo Lopes on 25/11/14.
//  Copyright (c) 2014 4mobi. All rights reserved.
//

#import "LoginVC.h"

@interface LoginVC()

@end

@implementation LoginVC

@synthesize textFieldEmail;
@synthesize textFieldSenha;
@synthesize buttonLogin;
@synthesize buttonEsqueceu;
@synthesize buttonCadastro;

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - VIEW LIFECYCLE

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
	// Se login, grava status no NSDefaults.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *email = [defaults objectForKey:@"userLastValidEmail"];
	
   	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Login"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:nil
                                                                  action:nil];
    self.navigationItem.backBarButtonItem = backButton;
  textFieldEmail.text = email;
	  BOOL login = [defaults boolForKey:@"userStatus"];
	
    // Verifica se o usuário esta logado.
    if (login == TRUE)
    {
		  [self.navigationController popToRootViewControllerAnimated:YES];
		 
    }
	
    [self.tableView setScrollEnabled:NO];
    
    utils = [[UtilityClass alloc] init];
	
	
    
    // Inicializa o helper do Banco de dados.
    coreDataService = [[CoreDataService alloc] init];
    [coreDataService initialize];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    // Configura o background da tableview.
//    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//
//    UIImageView *imageBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"FrostBackground"]];
//    [backgroundView addSubview:imageBG];
//
//    [self.tableView setBackgroundView:backgroundView];
//
    self.tableView.delegate = self;
    
    // Tweak para linhas extra na tabela.
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    // add Padding no textfield Email.
//    UIView *tfEmailPad = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 36, 20)];
//    textFieldEmail.leftView = tfEmailPad;
//    textFieldEmail.leftViewMode = UITextFieldViewModeAlways;
    textFieldEmail.delegate = self;
	
    // add Padding no textfield Senha.
//    UIView *tfSenhaPad = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 36, 20)];
//    textFieldSenha.leftView = tfSenhaPad;
//    textFieldSenha.leftViewMode = UITextFieldViewModeAlways;
    textFieldSenha.delegate = self;
	
    // Configura um gesture recognizer para esconder o teclado quando clicar na tableView.
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(hideKeyboard)];
    
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:gestureRecognizer];
    
	
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Se login, grava status no NSDefaults.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *email = [defaults objectForKey:@"userLastValidEmail"];
    
    textFieldEmail.text = email;
	  BOOL login = [defaults boolForKey:@"userStatus"];
	
    // Verifica se o usuário esta logado.
    if (login == TRUE)
    {
				[self.navigationController popToRootViewControllerAnimated:YES];
		 
    }
	// [self.textFieldEmail becomeFirstResponder];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
    
    // REMOVE OS OBSERVADORES.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
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

-(BOOL)shouldAutorotate
{
    return NO;
}



////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - UITEXTFIELD DELEGATE

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (textField == textFieldEmail)
    {
        [textFieldSenha becomeFirstResponder];
    }
    else
    {
        [textFieldSenha resignFirstResponder];
    }
    
    return YES;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - ACTIONS

- (IBAction)buttonLoginClicked:(id)sender
{
    // VERIFICA SE TEM CONEXÃO COM A INTERNET.
    BOOL flagInternetStatus = [IMManager sharedManager].hasConnection;
    
    // SE TEM CONEXÃO
    if (flagInternetStatus)
    {
        [self doLoginServer];
    }
    else
    {
        [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                          AndText:kTEXT_INTERNET_ERROR_DEFAULT
                      AndTargetVC:self];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (IBAction)buttonForgotPasswordClicked:(id)sender
{
    if (textFieldEmail.text.length == 0)
    {
        [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                          AndText:@"Use seu email cadastrado no Aplicativo STHANKE TRAINER!"
                      AndTargetVC:self];
    }
    else
    {
        if ([utils validateEmailWithString:textFieldEmail.text])
        {
            [self retrieveForgotPasswordWithEmail:textFieldEmail.text];
        }
        else
        {
            [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                              AndText:@"Use um email válido!"
                          AndTargetVC:self];
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - CUSTOM METHODS

- (void)hideKeyboard
{
    [textFieldEmail resignFirstResponder];
    [textFieldSenha resignFirstResponder];
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
         //   AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
          //  [manager.requestSerializer setTimeoutInterval:AFHHTTP_TIMEOUT];
            NSUserDefaults *Defaults = [NSUserDefaults standardUserDefaults];
            NSString *token = [Defaults objectForKey:@"deviceTokenKey"];
            
            if (token.length == 0)
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
						  [Defaults setBool:TRUE forKey:@"purchaseNeedUpdate"];
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
						  [self updateTrainerInfo];
				//		    [coreDataService dropInAppTransactionsTable];
						 [self.navigationController popToRootViewControllerAnimated:YES];
						 
						 NSMutableString *pathImage = [[NSMutableString alloc] init];
			
				 		[pathImage appendString:[utils returnDocumentsPath]];
				 		[pathImage appendString:@"/Caches/ProfileImages/"];
						 NSFileManager *fileMgr = [NSFileManager defaultManager];
							NSArray *fileArray = [fileMgr contentsOfDirectoryAtPath:pathImage error:nil];
						for (NSString *filename in fileArray)
						{

							[fileMgr removeItemAtPath:[pathImage stringByAppendingPathComponent:filename] error:NULL];
						}
						 
                    
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
                
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                
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



////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)retrieveForgotPasswordWithEmail:(NSString *)email
{
    [SVProgressHUD showWithStatus:@"Enviando a solicitação..." maskType:SVProgressHUDMaskTypeGradient];
    
    // Cria um operation manager para realizar a solicitação via POST.
 //   AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
 //   [manager.requestSerializer setTimeoutInterval:AFHHTTP_TIMEOUT];
    // Monta a string de acesso a validação do login.
    NSMutableString *urlString = [[NSMutableString alloc] init];
    [urlString appendString:kBASE_URL_MOBITRAINER];
    [urlString appendString:@"api/forgot"];
    
    // Parametros validados.
    NSDictionary *parameters = @{@"email":email};
    
    // Realiza o POST das informações e aguarda o retorno.
   AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
 			[manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
 			NSString *path=[[NSString alloc]initWithFormat:@"%@",urlString];
 			[manager POST:[NSURL URLWithString:path].absoluteString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
        if (![[responseObject objectForKey:@"response_error"] boolValue])
        {
            [SVProgressHUD showSuccessWithStatus:@"As instruções de como recuperar sua senha foram enviadas para seu email cadastrado!"
                                        maskType:SVProgressHUDMaskTypeGradient];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
            
            NSLog(@"%@",[responseObject objectForKey:@"message"]);
            
            [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                              AndText:@"Não foi possível completar a solicitação! Verifique o email informado!"
                          AndTargetVC:self];
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        
        [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                          AndText:kTEXT_SERVER_ERROR_DEFAULT
                      AndTargetVC:self];
    }];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)updateTrainerInfo
{
    // Pega os dados do usuário...
    User *userData = (User *) [coreDataService getDataFromUserTable];
	
    // Cria um operation manager para realizar a solicitação via POST.
 //   AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//	 [manager.requestSerializer setTimeoutInterval:AFHHTTP_TIMEOUT];
    // Parametros validados.
    NSDictionary *parameters = @{@"apikey": userData.apiKey, @"filter": @"trainerinfo"};
	
    // Monta a string de acesso a validação do login.
    NSMutableString *urlString = [[NSMutableString alloc] init];
    [urlString appendString:kBASE_URL_MOBITRAINER];
    [urlString appendString:@"api/appconfig"];
	
    // Realiza o POST das informações e aguarda o retorno.
   AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
 			[manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
 			NSString *path=[[NSString alloc]initWithFormat:@"%@",urlString];
 			[manager POST:[NSURL URLWithString:path].absoluteString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
		{
        if (![[responseObject objectForKey:@"response_error"] boolValue])
        {
            // Pega os dados do JSON.
            NSDictionary *dataTrainerInfo = [responseObject objectForKey:@"appconfig_trainerinfo"];
			  
            // Se existirem dados a serem verificados.
            if (dataTrainerInfo.count > 0)
            {
                LastUpdates *lastUpdate = (LastUpdates *) [coreDataService getDataFromLastUpdatesTable];
 
                // Apaga a tabela.
                [coreDataService dropTrainerInfoTable];
					
                TrainerInfo *appTrainerInfo = (TrainerInfo *) [NSEntityDescription insertNewObjectForEntityForName:@"TrainerInfo"
                                                                                            inManagedObjectContext:coreDataService.getManagedContext];
					
                appTrainerInfo.firstName = [utils checkString:[dataTrainerInfo objectForKey:@"trainerinfo_name"]];
                appTrainerInfo.lastName = [utils checkString:[dataTrainerInfo objectForKey:@"trainerinfo_lastname"]];
                appTrainerInfo.email = [utils checkString:[dataTrainerInfo objectForKey:@"trainerinfo_email"]];
                appTrainerInfo.gender = [utils checkString:[dataTrainerInfo objectForKey:@"trainerinfo_gender"]];
                appTrainerInfo.birthday = [utils checkString:[dataTrainerInfo objectForKey:@"trainerinfo_birthday"]];
                appTrainerInfo.image = [utils checkString:[dataTrainerInfo objectForKey:@"trainerinfo_image"]];
                appTrainerInfo.website = [utils checkString:[dataTrainerInfo objectForKey:@"trainerinfo_website"]];
                appTrainerInfo.facebook = [utils checkString:[dataTrainerInfo objectForKey:@"trainerinfo_facebook"]];
                appTrainerInfo.twitter = [utils checkString:[dataTrainerInfo objectForKey:@"trainerinfo_twitter"]];
                appTrainerInfo.phone = [utils checkString:[dataTrainerInfo objectForKey:@"trainerinfo_phone"]];
                appTrainerInfo.biography = [utils checkString:[dataTrainerInfo objectForKey:@"trainerinfo_biography"]];
                appTrainerInfo.cnpj = [utils checkString:[dataTrainerInfo objectForKey:@"trainerinfo_cnpj"]];
                appTrainerInfo.cref = [utils checkString:[dataTrainerInfo objectForKey:@"trainerinfo_cref"]];
					
					 lastUpdate.trainerInfo = @"1970-01-01 00:00:00";
             	
                [coreDataService saveData];
            }
            else
            {
                // ATUALIZA A DATA, PARA EVITAR PROBLEMAS DE GERAÇÃO DE ATUALIZAÇÃO EM LOOP.
                LastUpdates *lastUpdate = (LastUpdates *) [coreDataService getDataFromLastUpdatesTable];
					
                // ATUALIZA A TABELA COM A DATA ATUAL (NOW)
                NSDate *today = [NSDate date];
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *dateString = [dateFormat stringFromDate:today];
					
                lastUpdate.trainerInfo = dateString;
					
                [coreDataService saveData];
            }
			  
			  
        }
		 
    } failure:^(NSURLSessionTask *operation, NSError *error) {
		 
        NSLog(@"Error: %@", error);
		 
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
		 
        [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                          AndText:kTEXT_SERVER_ERROR_DEFAULT
                      AndTargetVC:self];
    }];
}




////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - NOTIFICATIONS METHODS

- (void)keyboardDidShow: (NSNotification *) notification
{
    // Do something here
    [self.tableView setScrollEnabled:YES];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)keyboardWillHide: (NSNotification *) notification
{
    // Do something here
    [self.tableView setContentOffset:CGPointZero animated:YES];
    [self.tableView setScrollEnabled:NO];
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
