//
//  MaisViewController.m
//  treino
//
//  Created by Reginaldo Lopes on 26/11/14.
//  Copyright (c) 2014 4mobi. All rights reserved.
//

#import "MaisVC.h"


@interface MaisVC()

@end

@implementation MaisVC
@synthesize loginImage;
@synthesize loginText;
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - SEGUE

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segueTreinosAnteriores"]){
        TreinosAnterioresViewController *tavc = [segue destinationViewController];
        tavc.isHistory = YES;
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    
    utils = [[UtilityClass alloc] init];
    
    // Acessa o appDelegate para acessar os methodos do CoreData.
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    _managedObjectContext = [appDelegate managedObjectContext];
    
    coreDataService = [[CoreDataService alloc] init];
    [coreDataService initialize];
	
    
    // Configura o texto do botão back.
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Mais"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:nil
                                                                  action:nil];
	 self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.backBarButtonItem = backButton;
    
    // Configura o background.
//    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    [backgroundView setBackgroundColor:UIColorFromRGB(0xDFDFDF)];
//    [self.tableView setBackgroundView:backgroundView];
//    
    // Tweak para linhas extra na tabela.
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    // Label rodape com a versão do aplicativo.
    UILabel *labelVersion = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    labelVersion.numberOfLines = 0;
    labelVersion.textAlignment = NSTextAlignmentCenter;
    labelVersion.backgroundColor = [UIColor clearColor];
    labelVersion.shadowColor = [UIColor colorWithWhite:0.9 alpha:0.5];
    labelVersion.shadowOffset = CGSizeMake(0,1);
    labelVersion.font = [UIFont systemFontOfSize:11];
    labelVersion.textColor = UIColorFromRGB(0x333333);
    
    NSMutableString *versionString = [[NSMutableString alloc] init];
    [versionString appendString:@"Copyright 2023 - Mobitrainer | v"];
    [versionString appendString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    [versionString appendString:@"Build"];
    [versionString appendString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
    labelVersion.text = versionString;
    self.tableView.tableFooterView = labelVersion;
	
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
//    Design *appDesign = (Design *) [coreDataService getDataFromDesignTable];
//
//    BOOL flagBlackStatusBar = appDesign.blackStatusBar.boolValue;
	
    // Pega o status do usuário, logado ou não.
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		BOOL login = [defaults boolForKey:@"userStatus"];

		if (login == TRUE)
		{
			loginText.text=@"Desconectar";
			loginImage.image=[UIImage imageNamed:@"Table_Logout"];
		}
		else
		{
			loginText.text=@"Login";
			loginImage.image=[UIImage imageNamed:@"Table_Login"];
		
     }
	
//    // COR DO TEXTO NA STATUSBAR.
//    if (flagBlackStatusBar)
//    {
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//    }
//    else
//    {
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - TABLE VIEW DATA SOURCE & DELEGATE

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 50;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }

     if(indexPath.row >= 0 && indexPath.row <= 3) {
        // Romove qq objeto com a mesma tag para não empilhar na view.
        [[cell.contentView viewWithTag:123] removeFromSuperview];
         
        // Configura a seta
        UIImageView *accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Table_Seta"]];
        accessoryView.frame = CGRectMake((self.view.frame.size.width - 20), ((cell.frame.size.height / 2) - 7), 14, 14);
        accessoryView.tag = 123;
        [cell.contentView addSubview:accessoryView];
     }
    
    
    
    UIView *bgColorView = [[UIView alloc] init];
#ifdef OLD_STYLE
    Design *appDesign = (Design *) [coreDataService getDataFromDesignTable];
    [bgColorView setBackgroundColor: UIColorFromRGB(kPRIMARY_COLOR)];
#endif
#ifdef NEW_STYLE
    [bgColorView setBackgroundColor: UIColorFromRGB(MENU_CLICK_COLOR)];
#endif
   
    [bgColorView setClipsToBounds:YES];
    bgColorView.alpha = 0.1f;
    [cell setSelectedBackgroundView:bgColorView];
    cell.contentView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.6f];
    
	
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Pega o status do usuário, logado ou não.
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		BOOL login = [defaults boolForKey:@"userStatus"];

	
	
    // Verifica se a celula Login Logout foi clicado.
    if(indexPath.row == 3) {
        if (login != TRUE)
        {
				 [self performSegueWithIdentifier:@"segueLogin" sender:self];
			}
			else
			{
			  dispatch_async(dispatch_get_main_queue(), ^{
					
					UIAlertController *alertController = [UIAlertController
																	  alertControllerWithTitle:kTEXT_ALERT_TITLE
																	  message:@"Encerrar a sessão?"
																	  preferredStyle:UIAlertControllerStyleAlert];
	#ifdef NEW_STYLE
					alertController.view.tintColor=[UIColor colorNamed:@"myCellTextColor"];
	#endif
					UIAlertAction *actionYES = [UIAlertAction actionWithTitle:@"Sim"
																						 style:UIAlertActionStyleDefault
																					  handler:^(UIAlertAction * action){
																							
																							[self logOff];
																							loginText.text=@"Login";
																							loginImage.image=[UIImage imageNamed:@"Table_Login"];
																							[alertController dismissViewControllerAnimated:YES completion:nil];
																							
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
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    // Verifica se usuario logou e precisa puxar lista atualizada de compras
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
    // VERIFICA SE EXISTEM EXERCICIOS ASSOCIADOS AO TREINO, SE NÃO GERA ALERT.
    if ([identifier isEqualToString:@"seguePerfil"])
    {
		 BOOL login = [defaults boolForKey:@"userStatus"];
	
	 	if (login != TRUE)
	 	{
	 		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Atenção!"
																				  message:@"Você precisa fazer o login para acessar seu perfil!"
																				 delegate:self
																	 cancelButtonTitle:@"Ok"
																	 otherButtonTitles:nil];
			
				  [alert show];
				  return NO;
		}
		 
   }
	return YES;
	
	
}
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]){
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]){
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - CUSTOM METHODS

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
