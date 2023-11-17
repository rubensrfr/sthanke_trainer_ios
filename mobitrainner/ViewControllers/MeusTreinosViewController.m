//
//  MeusTreinosViewController.m
//  mobitrainer
//
//  Created by Rubens Rosa on 09/11/2017.
//  Copyright © 2017 4mobi. All rights reserved.
//


#import "MeusTreinosViewController.h"

@interface MeusTreinosViewController()

@end

@implementation MeusTreinosViewController

@synthesize treineeID;
@synthesize btnReload;
@synthesize isHistory;
@synthesize treineeEmail;
@synthesize tableViewMeusTreinos;
@synthesize imageUser;
@synthesize nameUser;
@synthesize emailUser;
@synthesize chatIcon;
@synthesize trainingNameTV;

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - SEGUE

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	
    NSIndexPath *indexPath = [self.tableViewMeusTreinos indexPathForSelectedRow];
    
    if ([[segue identifier] isEqualToString:@"segueExercicioLista"])
    {
        Training *training;
		 
		 
		 
		 
		
		  training = (Training *) [arrayEnabledTraining objectAtIndex:indexPath.row];

        serieViewController *elvc = [segue destinationViewController];
        elvc.title = @"Série";
        elvc.trainingID = training.trainingID;
        elvc.trainingName = training.name;
        elvc.trainingDescription = training.fullDescription;
        elvc.trainingDifficulty = training.difficulty;
        elvc.isHistory = self.isHistory;
        elvc.trainingpublickey = training.publickey;
        elvc.serieOnOffStatus = training.serieOnOffStatus;
        elvc.isMeusTreinosCalling = TRUE;
        elvc.decricaoSerieLabel.text = training.description;
        User *userData = (User *) [coreDataService getDataFromUserTable];
        
        if ([userData.level integerValue] == USER_LEVEL_TRAINER || [userData.level integerValue] == USER_LEVEL_MASTERTRAINER || [userData.level integerValue] == USER_LEVEL_ADMINISTRATOR)
        {
            elvc.treineeID = training.treineeID;
        }
    }
	
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableViewMeusTreinos indexPathForSelectedRow];
    
    // VERIFICA SE EXISTEM EXERCICIOS ASSOCIADOS AO TREINO, SE NÃO GERA ALERT.
    if ([identifier isEqualToString:@"segueExercicioLista"])
    {
    	Training *training;
		
			if([arrayEnabledTraining count]>0)
				training = (Training *) [arrayEnabledTraining objectAtIndex:indexPath.row];
			else
				return NO;
		
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Exercises"];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [fetchRequest setSortDescriptors:sortDescriptors];
         
        User *userData = (User *) [coreDataService getDataFromUserTable];
        
        NSPredicate *predicate;
        
        if ([userData.level integerValue] == USER_LEVEL_TRAINEE && self.isHistory)
        {
            predicate = [NSPredicate predicateWithFormat:@"trainingID==%@ && circuitID==%@ && isHistory==%d",training.trainingID,@"0",isHistory];
        }
        else if([userData.level integerValue] == USER_LEVEL_TRAINEE && !self.isHistory)
        {
            predicate = [NSPredicate predicateWithFormat:@"trainingID==%@ && circuitID==%@",training.trainingID,@"0"];
        }
        else
        {
            predicate = [NSPredicate predicateWithFormat:@"trainingID==%@ && circuitID==%@ && treineeID==%@ ",training.trainingID,@"0",self.treineeID];
        }
        /*
         NSArray *arrayFiltered = [mutableFetchResults filteredArrayUsingPredicate:predicate];
         
         if(arrayFiltered.count == 0)
         {
         [utils showAlertWithTitle:kTEXT_ALERT_TITLE
         AndText:@"Não existem exercícios \nassociados a este treino. \n Entre em contato com seu treinador!"
         AndTargetVC:self];
         return NO;
         }
         else
         {
         return YES;
         }
         */
    }
    
    return YES;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - VIEW LIFECYCLE

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableViewMeusTreinos.delegate = self;
    
    utils = [[UtilityClass alloc] init];
    
    arrayEnabledTraining = [[NSMutableArray alloc] init];
    arrayDisabledTraining = [[NSMutableArray alloc] init];
    
    coreDataService = [[CoreDataService alloc] init];
    [coreDataService initialize];
    
  
     // Tweak para linhas extra na tabela.
     [self.tableViewMeusTreinos setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0,0, 320,70)]];

    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"TREINOS"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:nil
                                                                  action:nil];
    self.navigationItem.backBarButtonItem = backButton;
	
	
//     [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(becomeActive:)
//                                                 name:UIApplicationWillEnterForegroundNotification
//                                               object:nil];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(becomeInactive:)
//                                                 name:UIApplicationDidEnterBackgroundNotification
//                                               object:nil];
//
                                               
//    // Configura o background da tableview.
//    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
//    
//    [backgroundView setBackgroundColor:UIColorFromRGB(0xDFDFDF)];
//    [self.tableViewMeusTreinos setBackgroundView:backgroundView];
//    self.tableViewMeusTreinos.backgroundView.layer.zPosition -= 1;
    
	 [arrayEnabledTraining removeAllObjects];
	 arrayEnabledTraining = [coreDataService getDataFromTrainingTable:self.isHistory  withStatus:TRAINING_ON];
	
    if([arrayEnabledTraining count]==0)
    {
       [self updateTrainingWithDatesToCheck];
		 [self updateHistory];
    }
    else
	 	[self.tableViewMeusTreinos reloadData];
		 
    self.navigationController.navigationBar.translucent = NO;
//	self.navigationItem.leftBarButtonItem=nil;
//	self.navigationItem.hidesBackButton=YES;
	
	chatIcon.rightBarButtonItem.image=[UIImage imageNamed:@"chat0"];
	
//	[self.tableViewMeusTreinos initWithFrame:self.tableViewMeusTreinos.frame style:UITableViewStyleGrouped];

//	[self startUpdateProcess];

}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
	
	// Pega o status do usuário, logado ou não.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL login = [defaults boolForKey:@"userStatus"];
	
    // Verifica se o usuário esta logado.
    if (login == FALSE)
    {
		 
      flagUpdate = FALSE;
	//	[[NSNotificationCenter defaultCenter] postNotificationName:@"stopTimerUpdateThread" object:self];
		[self.navigationController popToRootViewControllerAnimated:YES];
	 }
	 else
	 		[self checkUpdateStatus];
	
	
    // Configura observadores.
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(startTimerUpdateThread:)
//                                                 name:@"startTimerUpdateThread"
//                                               object:nil];
//
    // Configura observadores.
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(stopTimerUpdateThread:)
//                                                 name:@"stopTimerUpdateThread"
//                                               object:nil];
//
	
	
	 trainingNameTV.text=@"Treino atual";
	
	// [self btnReload2];
    [self.tableViewMeusTreinos reloadData];
    
    
}



////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
	
	 User *userData = (User *) [coreDataService getDataFromUserTable];
	
	// Pega o status do usuário, logado ou não.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL login = [defaults boolForKey:@"userStatus"];
	
    // Verifica se o usuário esta logado.
    if (login == FALSE)
    {
		 
      flagUpdate = FALSE;
	//	[[NSNotificationCenter defaultCenter] postNotificationName:@"stopTimerUpdateThread" object:self];
		[self.navigationController popToRootViewControllerAnimated:YES];
		 

    }
	 
	// VERIFICA SE TEM CONEXÃO COM A INTERNET.
    BOOL flagInternetStatus = [IMManager sharedManager].hasConnection;
	  
	 NSUserDefaults *Defaults = [NSUserDefaults standardUserDefaults];
    BOOL updateNeed = [Defaults boolForKey:@"TrainingNeedUpdate"];

	 if(updateNeed == TRUE || ([arrayEnabledTraining count]  == 0 && [arrayDisabledTraining count]==0))

	 {
	   if(flagInternetStatus == TRUE)
	   {
//
			if ([userData.level integerValue] != USER_LEVEL_TRAINEE)
				[self updateTrainingWithDatesToCheck];
			
			
			[Defaults setBool:FALSE forKey:@"TrainingNeedUpdate"];
			[Defaults synchronize];
			
		}
		 
	 }
	// RECUPERA AS CONFIGURACÃO DO APP DESGIN DO BANCOD E DADOS.
 //   Design *appDesign = (Design *) [coreDataService getDataFromDesignTable];
	 imageUser.layer.cornerRadius = imageUser.frame.size.width / 2;
    imageUser.clipsToBounds = YES;
   // imageUser.layer.borderColor = UIColorFromRGB(kPRIMARY_COLOR).CGColor;
   // imageUser.layer.borderWidth = 3.0f;
	
	 nameUser.text = [userData.firstName stringByAppendingString: @" "];
	 emailUser.text = userData.email;
    NSMutableString *pathImage = [[NSMutableString alloc] init];
    [pathImage appendString:[utils returnDocumentsPath]];
    [pathImage appendString:@"/Caches/ProfileImages/"];
    [pathImage appendString:[utils md5HexDigest:userData.image]];
    [pathImage appendString:@".png"];
	
    BOOL imageExists = [[NSFileManager defaultManager] fileExistsAtPath:pathImage];
	
    group = dispatch_group_create();
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	
    if (!imageExists)
    {
        dispatch_group_enter(group);
        dispatch_async(queue, ^{
			  
            // Faz o download
            [self getExercisesImagesWithURL:userData.image];
			  
        });
    }
	
    dispatch_group_notify(group, queue, ^{
		 
        dispatch_sync(dispatch_get_main_queue(), ^{
			  
            [spinner stopAnimating];
			  
            UIImage *image = [UIImage imageWithContentsOfFile:pathImage];
			  
            imageUser.image = image;
			  
            CATransition *transition = [CATransition animation];
            transition.type = kCATransitionFade;
            transition.duration = 0.3f;
            [imageUser.layer addAnimation:transition forKey:nil];
        });
    });
	
	unreadCount = [Defaults integerForKey:@"UnreadCounter"] ;
		if (login == TRUE)
		{
				// Pega os dados do usuário...
				Chat *chat = (Chat *) [coreDataService getDataFromChatTable];

				if ([chat.hasChat boolValue])
				{
					[self checkMessageCount];
				}
				
		}
	//   // Verifica se o usuário esta logado.
	//        if (login == TRUE)
	//        {
	//            // Pega os dados do usuário...
	//            Chat *chat = (Chat *) [coreDataService getDataFromChatTable];
	//
	//            if ([chat.hasChat boolValue])
	//            {
	//                dispatch_async(dispatch_get_main_queue(), ^{
	//
	//                    // Seta o timer para verificar o update.
	//                    self.timerMessageCount = [NSTimer scheduledTimerWithTimeInterval:6.0f
	//                                                                              target:self
	//                                                                            selector:@selector(checkMessageCount:)
	//                                                                            userInfo:nil
	//                                                                             repeats:YES];
	//
	//                    // Dispare o timer, imediatamente.
	//                    [self.timerMessageCount fire];
	//
	//                    unreadCount = 0;
	//                });
	//            }
	//        }
}




////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
	
    [SVProgressHUD dismiss];
	
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopTimerUpdateThread" object:self];
//
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:@"updateFeaturedImages"
//                                                  object:nil];
//
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:@"updateFeaturedImages"
//                                                  object:nil];
//
//    flagUpdate = FALSE;
	
    dispatch_async(dispatch_get_main_queue(), ^{
		 
        [self.timerMessageCount invalidate];
   //     [self.timerCheckUpdate invalidate];
		 
		 
        self.timerMessageCount = nil;
   //     self.timerCheckUpdate = nil;
       
		 
    });
      [SVProgressHUD dismiss];
    [self removeDimerView];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - TABLE VIEW DATA SOURCE & DELEGATE

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
		return 1;
	
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    v.backgroundColor = [UIColor clearColor];
    
	
	
		UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
		label.textAlignment = NSTextAlignmentCenter;

		label.font = [UIFont systemFontOfSize:14];
		label.textColor = [UIColor blackColor];

		label.backgroundColor = [UIColor clearColor];
		LastUpdates *lastUpdate = (LastUpdates *) [coreDataService getDataFromLastUpdatesTable];

		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
		NSDate *dateFromString = [[NSDate alloc] init];
		dateFromString = [dateFormatter dateFromString:lastUpdate.training];

		NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
		[dateFormatter2 setDateFormat:@"dd/MM/yyyy 'às' HH:mm"];
		NSString *stringDate = [dateFormatter2 stringFromDate:dateFromString];

		NSMutableString *strUpdate = [[NSMutableString alloc]init];

		[strUpdate appendString:@"Atualizado em: "];

		NSString *strDate = [stringDate stringByReplacingOccurrencesOfString:@":" withString:@"h"];
		[strUpdate appendString:strDate];

		label.text = strUpdate;
		[v addSubview:label];
	
	
	
    return v;
}



////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	
	return 0.0f;

}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	
    	return [arrayEnabledTraining count];
	}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if((indexPath.section==0 && indexPath.row == arrayEnabledTraining.count-1)
//    ||
//		 (indexPath.section==1 && indexPath.row == arrayDisabledTraining.count-1))
//    {
//        return 110;
//    }
//    else
//    {
//        return 90;
//    }
	return 90;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
	
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
	
    // Romove qq objeto com a mesma tag para não empilhar na view.
    [[cell.contentView viewWithTag:123] removeFromSuperview];
	
    // Configura a seta
//    UIImageView *accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Table_Seta"]];
//    accessoryView.frame = CGRectMake((self.view.frame.size.width - 20), ((cell.frame.size.height / 2) - 7), 14, 14);
//    accessoryView.tag = 123;
//    [cell.contentView addSubview:accessoryView];
	
	
	
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
  //  cell.contentView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.6f];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	if([arrayEnabledTraining count]>0)
	{
		 static NSString *CellIdentifier = @"Cell";
		
		 MeusTreinosCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
		
		 if (!cell)
		 {
			  cell = [[MeusTreinosCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		 }
		 Training *training;
		 training = (Training *) [arrayEnabledTraining objectAtIndex:indexPath.row];
		
		 [cell.labelSeriesName setHighlightedTextColor:UIColorFromRGB(0xE3E8EA)];
		 [cell.labelShelfLife setHighlightedTextColor:UIColorFromRGB(0xE3E8EA)];
		 [cell configureCell:training isHistory:self.isHistory];
		
		 return cell;
    }
	return nil;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	
		 
}




////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([self.tableViewMeusTreinos respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableViewMeusTreinos setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableViewMeusTreinos respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableViewMeusTreinos setLayoutMargins:UIEdgeInsetsZero];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - BUTTON CALBACK

- (void)closeViewButtonPressed:(id)sender
{
    [self removeDimerView];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - ACTIONS



////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - CUSTOM METHODS

- (void)removeDimerView
{
    dimmer.alpha = 1;
    background.transform = CGAffineTransformIdentity;
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        background.transform = CGAffineTransformMakeScale(0.01, 0.01);
        dimmer.alpha = 0;
        
    } completion:^(BOOL finished){
        
        // if you want to do something once the animation finishes, put it here
        [dimmer removeFromSuperview];
        self.tableViewMeusTreinos.scrollEnabled = YES;
        
    }];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)showNoDataMessage
{
    lblMessage = [[UILabel alloc]initWithFrame:CGRectMake(((self.view.frame.size.width/2)-140),
                                                          ((self.view.frame.size.height/2)-40), 280, 80)];
    
    // Configura o label.
    lblMessage.numberOfLines = 0;
    lblMessage.textAlignment = NSTextAlignmentCenter;
    lblMessage.backgroundColor = [UIColor clearColor];
    lblMessage.textColor = UIColorFromRGB(0x333333);
    lblMessage.shadowColor = [UIColor colorWithWhite:0.9 alpha:0.5];
    lblMessage.shadowOffset = CGSizeMake(1,1);
    lblMessage.font = [UIFont systemFontOfSize:17];
    
	User *userData = (User *) [coreDataService getDataFromUserTable];

	
    if(self.isHistory)
    {
		
           lblMessage.text = @"Não há histórico de treinos passados!\n ";
		
    }
    else
    {
        // Mensagem do label.
		 // Mensagem do label.
        if ([userData.level integerValue] == USER_LEVEL_TRAINEE)
         lblMessage.text = @"Não há treinos disponíveis!\n ";
		 
    }
    
    lblMessage.alpha = 0;
    lblMessage.tag =17;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    lblMessage.alpha = 1;
    
    // Adiciona o label na view.
    [self.view addSubview:lblMessage];
    
    [UIView commitAnimations];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)hideNoDataMessage
{
	//for (UIView *view in [self.view subviews]) {

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		
    UIView *viewToRemove = [self.view viewWithTag:17];
	[viewToRemove removeFromSuperview];

	
    lblMessage.alpha = 0;
    [lblMessage removeFromSuperview];
    
    [UIView commitAnimations];
// }
}



- (IBAction)btnReloadSelected:(id)sender {
	
	// VERIFICA SE TEM CONEXÃO COM A INTERNET.
    BOOL flagInternetStatus = [IMManager sharedManager].hasConnection;
	
    // SE TEM CONEXÃO
    if (flagInternetStatus)
    {
		 
        [self updateTrainingWithDatesToCheck];
		  [self updateHistory];
		  [tableViewMeusTreinos reloadData];
		 
    }
    else
    {
        [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                          AndText:kTEXT_INTERNET_ERROR_DEFAULT
                      AndTargetVC:self];
    }
}

- (void)btnReload2{
	
	// VERIFICA SE TEM CONEXÃO COM A INTERNET.
    BOOL flagInternetStatus = [IMManager sharedManager].hasConnection;
	
    // SE TEM CONEXÃO
    if (flagInternetStatus)
    {
		 
        [self updateTrainingWithDatesToCheck];
		  [self updateHistory];
		  [tableViewMeusTreinos reloadData];
		 
    }
    else
    {
        [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                          AndText:kTEXT_INTERNET_ERROR_DEFAULT
                      AndTargetVC:self];
    }
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - CUSTOM METHODS

- (void)getExercisesImagesWithURL:(NSString *)url
{
    if(url.length > 0)
    {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
		 
        NSURL *URL = [NSURL URLWithString:url];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
		 
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
			  
            NSString *imagesCachePath = [[utils returnDocumentsPath] stringByAppendingPathComponent:@"/Caches/ProfileImages/"];
			  
            NSURL *path = [NSURL fileURLWithPath:imagesCachePath];
			  
            NSMutableString *filename = [[NSMutableString alloc] init];
            [filename appendString:[utils md5HexDigest:url]];
            [filename appendString:@".png"];
			  
            return [path URLByAppendingPathComponent:filename];
			  
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
			  
            dispatch_group_leave(group);
        }];
		 
        [downloadTask resume];
    }
    else
    {
        dispatch_group_leave(group);
    }
}


















///////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - NOTIFICATION METHODS

- (void)startTimerUpdateThread:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
		 
        // Seta o timer para verificar o update.
//        self.timerCheckUpdate = [NSTimer scheduledTimerWithTimeInterval:kCHECK_UPDATE_TIMER
//                                                                 target:self
//                                                               selector:@selector(checkUpdateStatus:)
//                                                               userInfo:nil
//                                                                repeats:YES];
//
//        // Dispare o timer, imediatamente.
//        [self.timerCheckUpdate fire];
		 
        unreadCount = 0;
    });
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

//- (void)stopTimerUpdateThread:(NSNotification *)notification
//{
//    dispatch_async(dispatch_get_main_queue(), ^{
//
//        [self.timerCheckUpdate invalidate];
//        self.timerCheckUpdate = nil;
//    });
//}



////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

//- (void)becomeActive:(NSNotification *)notification
//{
//    // Pega o status do usuário, logado ou não.
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    BOOL login = [defaults boolForKey:@"userStatus"];
//
//    // Verifica se o usuário esta logado.
//    if (login == TRUE)
//    {
//        // Pega os dados do usuário...
//        Chat *chat = (Chat *) [coreDataService getDataFromChatTable];
//
//        if ([chat.hasChat boolValue])
//        {
//            // Seta o timer para verificar o update.
//            self.timerMessageCount = [NSTimer scheduledTimerWithTimeInterval:5.0f
//                                                                      target:self
//                                                                    selector:@selector(checkMessageCount:)
//                                                                    userInfo:nil
//                                                                     repeats:YES];
//
//            // Dispare o timer, imediatamente.
//            [self.timerMessageCount fire];
//
//            unreadCount = 0;
//        }
//    }
	
//    // Seta o timer para verificar o update.
//    self.timerCheckUpdate = [NSTimer scheduledTimerWithTimeInterval:kCHECK_UPDATE_TIMER
//                                                             target:self
//                                                           selector:@selector(checkUpdateStatus:)
//                                                           userInfo:nil
//                                                            repeats:YES];
//
//    // Dispare o timer, imediatamente.
//    [self.timerCheckUpdate fire];
//
	
    
//}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

//- (void)becomeInactive:(NSNotification *)notification
//{
//    // DESATIVA O TIMER QUE VERIFICA AS QUANTIDADES DE MENSAGENS.
//    [self.timerMessageCount invalidate];
//
//    // DESATIVA O TIMER QUE VERIFCA O UPDATE DA BASE DE DADOS.
// //   [self.timerCheckUpdate invalidate];
//}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - CUSTOM METHODS


- (void)startUpdateProcess
{
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		 
        [SVProgressHUD showWithStatus:@"Atualizando..."
                             maskType:SVProgressHUDMaskTypeGradient];
		 
    });
	
    // Cria um operation manager para realizar a solicitação via POST.
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//	 [manager.requestSerializer setTimeoutInterval:AFHHTTP_TIMEOUT];
    User *userData = [coreDataService getDataFromUserTable];
	
    // Parametros validados.
    NSDictionary *parameters = @{@"apikey": userData.apiKey};
	
    // Monta a string de acesso a validação do login.
    NSMutableString *urlString = [[NSMutableString alloc] init];
    [urlString appendString:kBASE_URL_MOBITRAINER];
    [urlString appendString:@"api/update"];
	
    // Realiza o POST das informações e aguarda o retorno.
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
 			[manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
 			NSString *path=[[NSString alloc]initWithFormat:@"%@",urlString];
 			[manager POST:[NSURL URLWithString:path].absoluteString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
      {
        if (![[responseObject objectForKey:@"response_error"] boolValue])
        {
            // Pega os dados do JSON.
            NSDictionary *dataUpdate = [responseObject objectForKey:@"response_update"];
			  
            // Se existirem dados a serem verificados.
            if ([dataUpdate count] > 0)
            {
                UpdateCheck *uCheck = [[UpdateCheck alloc] init];
					
					 uCheck.trainingLastUpdate = [utils checkString:[dataUpdate objectForKey:@"training"]];
                uCheck.traineeLastUpdate = [utils checkString:[dataUpdate objectForKey:@"trainee"]];
                uCheck.chatLastUpdate = [dataUpdate objectForKey:@"chat"];
					
                /// CARREGA O TEMA DO APP
                [self updateChatWithDatesToCheck:uCheck];
                 [SVProgressHUD dismiss];
            }
        }
		 
        flagUpdate = TRUE;
		 
    } failure:^(NSURLSessionTask *operation, NSError *error) {
		 
        NSLog(@"Error: %@", error);
		 
        dispatch_async(dispatch_get_main_queue(), ^{
			  
            [SVProgressHUD dismiss];
        });
		 
        [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                          AndText:kTEXT_SERVER_ERROR_DEFAULT
                      AndTargetVC:self];
		 
        flagUpdate = TRUE;
    }];
}




////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)updateChatWithDatesToCheck:(UpdateCheck *)uCheck
{
    // Pega os dados do usuário...
    User *userData = (User *) [coreDataService getDataFromUserTable];
	
    // Cria um operation manager para realizar a solicitação via POST.
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//	 [manager.requestSerializer setTimeoutInterval:AFHHTTP_TIMEOUT];
    // Parametros validados.
    NSDictionary *parameters = @{@"apikey": userData.apiKey, @"filter": @"chat"};
	
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
            NSDictionary *dataChat = [responseObject objectForKey:@"appconfig_chat"];
			  
            // Se existirem dados a serem verificados.
            if ([dataChat count] > 0)
            {
                LastUpdates *lastUpdate = (LastUpdates *) [coreDataService getDataFromLastUpdatesTable];
					
                // Apaga dos dados da tabela.
                [coreDataService dropChatTable];
					
                Chat *chat = (Chat *) [NSEntityDescription insertNewObjectForEntityForName:@"Chat"
                                                                    inManagedObjectContext:coreDataService.getManagedContext];
					
                chat.hasChat = [NSNumber numberWithBool:[[utils checkString:[dataChat objectForKey:@"chat_has"]] boolValue]];
					
                if ([utils checkString:uCheck.chatLastUpdate].length == 0)
                {
                    lastUpdate.chat = @"1970-01-01 00:00:00";
                }
                else
                {
                    // Atualiza a data do ultimo update da tabela chat...
                    lastUpdate.chat = uCheck.chatLastUpdate;
                }
					
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
					
                lastUpdate.chat = dateString;
					
                [coreDataService saveData];
            }
			  
            [self updateProfileInfoWithDatesToCheck:uCheck];
        }
		 
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


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)updateProfileInfoWithDatesToCheck:(UpdateCheck *)uCheck
{
    // Pega os dados do usuário...
    User *userData = (User *) [coreDataService getDataFromUserTable];
	
    // Cria um operation manager para realizar a solicitação via POST.
 //   AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//	 [manager.requestSerializer setTimeoutInterval:AFHHTTP_TIMEOUT];
    // Parametros validados.
    NSDictionary *parameters = @{@"apikey": userData.apiKey, @"filter": @"profile"};
	
    // Monta a string de acesso a validação do login.
    NSMutableString *urlString = [[NSMutableString alloc] init];
    [urlString appendString:kBASE_URL_MOBITRAINER];
    [urlString appendString:@"api/profile"];
	
    // Realiza o POST das informações e aguarda o retorno.
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
 			[manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
 			NSString *path=[[NSString alloc]initWithFormat:@"%@",urlString];
 			[manager POST:[NSURL URLWithString:path].absoluteString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
       if (![[responseObject objectForKey:@"response_error"] boolValue])
        {
            // Pega os dados do JSON.
            NSDictionary *dataUserInfo = [responseObject objectForKey:@"profile"];
			  
            // Se existirem dados a serem verificados.
            if (dataUserInfo.count > 0)
            {
                LastUpdates *lastUpdate = (LastUpdates *) [coreDataService getDataFromLastUpdatesTable];

                User *userData = [coreDataService getDataFromUserTable];
					
                userData.firstName = [utils checkString:[dataUserInfo objectForKey:@"response_profile_username"]];
                userData.lastName = [utils checkString:[dataUserInfo objectForKey:@"response_profile_userlastname"]];
                userData.image = [utils checkString:[dataUserInfo objectForKey:@"response_profile_photo"]];
                userData.birthday = [utils checkString:[dataUserInfo objectForKey:@"response_profile_birthday"]];
                userData.gender = [utils checkString:[dataUserInfo objectForKey:@"response_profile_gender"]];
                userData.trainerID = [utils checkString:[dataUserInfo objectForKey:@"response_profile_trainerid"]];
                userData.email = [utils checkString:[dataUserInfo objectForKey:@"response_profile_email"]];
                userData.height = [NSNumber numberWithFloat:[[utils checkString:[dataUserInfo objectForKey:@"response_profile_height"]] floatValue]];
                userData.weight = [NSNumber numberWithFloat:[[utils checkString:[dataUserInfo objectForKey:@"response_profile_weight"]] floatValue]];
					
					
                if ([utils checkString:uCheck.userProfileLastUpdate].length == 0)
                {
                    lastUpdate.userProfile = @"1970-01-01 00:00:00";
                }
                else
                {
                    lastUpdate.userProfile = uCheck.userProfileLastUpdate;
                }

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
					
                lastUpdate.userProfile = dateString;
					
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

- (void)updateTrainingWithDatesToCheck
{
	// VERIFICA SE TEM CONEXÃO COM A INTERNET.
    BOOL flagInternetStatus = [IMManager sharedManager].hasConnection;
	
    // SE TEM CONEXÃO
    if (!flagInternetStatus)
    {
        [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                          AndText:kTEXT_INTERNET_ERROR_DEFAULT
                      AndTargetVC:self];
			return;
    }
	
    User *userData = (User *) [coreDataService getDataFromUserTable];
	
    [SVProgressHUD showWithStatus:@"Atualizando Treinos..." maskType: SVProgressHUDMaskTypeGradient];
	
    // Monta a string de acesso a validação do login.
    NSMutableString *urlString = [[NSMutableString alloc] init];
    [urlString appendString:kBASE_URL_MOBITRAINER];
    [urlString appendString:@"api/training_v3"];
	
     // Inicializa o manager.
  //  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	// [manager.requestSerializer setTimeoutInterval:AFHHTTP_TIMEOUT];
    NSDictionary *parameters;
	
	  if (self.isHistory)
	  {
			parameters = @{@"apikey":userData.apiKey,@"history":@"1"};
	  }
	  else
	  {
			parameters = @{@"apikey":userData.apiKey};
	  }
	
	
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
 			[manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
 			NSString *path=[[NSString alloc]initWithFormat:@"%@",urlString];
 			[manager POST:[NSURL URLWithString:path].absoluteString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
        if (![[responseObject objectForKey:@"response_error"] boolValue])
        {
    														        ////////////////////////////////////////////////////////////////////////
            /// PEGA OS DADOS DOS TREINOS //////////////////////////////////////////
            ////////////////////////////////////////////////////////////////////////
			  
            NSArray *arrayDataTraining = [[NSArray alloc] initWithArray:[responseObject objectForKey:@"training"]];
            Training *training = nil;
			  
			  
			  
			//  [coreDataService  deleteDataFromExercisesTable:self.isHistory];
			//  [coreDataService deleteDataFromTrainingTable:self.isHistory];
			  
			 [coreDataService deleteDataFromExerciseTableByTrainingID:@"0"];
			  [coreDataService deleteTrainingWithTrainingID:@"0"];
		//	  [coreDataService dropTrainingTable];
		//	  [coreDataService dropExercisesTable];
			  
            if (arrayDataTraining.count > 0)
            {
					
					
                for (NSInteger i = 0; i < [arrayDataTraining count]; i++)
                {
						 
                   NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
						  [dateFormat setDateFormat:@"yyyy-MM-dd"];
						  NSDate *dateInit = [dateFormat dateFromString:[utils checkString:[[arrayDataTraining objectAtIndex:i] objectForKey:@"response_serie_date_init"]]];
						  NSDate *dateEnd = [dateFormat dateFromString:[utils checkString:[[arrayDataTraining objectAtIndex:i] objectForKey:@"response_serie_date_end"]]];
						  NSDate *today = [NSDate date];
						  if(dateInit!=nil && [userData.level integerValue]==USER_LEVEL_TRAINEE && [dateInit timeIntervalSinceDate:today] >0)
						  {
								continue;
						  }
					 
                    //Objeto ainda não existe, precisa fazer o "INSERT"
                    training = (Training *) [NSEntityDescription insertNewObjectForEntityForName:@"Training"
                                                                          inManagedObjectContext:coreDataService.getManagedContext];
                    training.publickey = [utils checkString:[[arrayDataTraining objectAtIndex:i] objectForKey:@"response_serie_publickey"]];
                    training.trainingID = [utils checkString:[[arrayDataTraining objectAtIndex:i] objectForKey:@"response_serie_id"]];
                    training.order = [NSNumber numberWithInteger:[[[arrayDataTraining objectAtIndex:i] objectForKey:@"response_serie_order"]integerValue]];
                    training.expireDate = [utils checkString:[[arrayDataTraining objectAtIndex:i] objectForKey:@"response_serie_expiry"]];
                    training.name = [utils checkString:[[arrayDataTraining objectAtIndex:i] objectForKey:@"response_serie_name"]];
                    training.fullDescription = [utils checkString:[[arrayDataTraining objectAtIndex:i] objectForKey:@"response_serie_description"]];
                    training.difficulty = [NSNumber numberWithInteger:[[[arrayDataTraining objectAtIndex:i] objectForKey:@"response_serie_difficulty"]integerValue]];
                    training.treineeID = treineeID;
                    training.serieOnOffStatus = [utils checkString:[[arrayDataTraining objectAtIndex:i] objectForKey:@"response_serie_status"]];
						  training.serieDateInit = dateInit;
					     training.serieDateEnd = dateEnd;
						  training.training_id = @"0";
						 
						 if ([dateEnd timeIntervalSinceDate:today] >0 || dateEnd == nil)
						    training.isHistory = [NSNumber numberWithBool:NO];
						 else
						    training.isHistory = [NSNumber numberWithBool:YES];
						 
						 
                    [coreDataService saveData];
						 
                    ////////////////////////////////////////////////////////////////////////
                    /// PEGA OS DADOS DOS EXERCICIOS ///////////////////////////////////////
                    ////////////////////////////////////////////////////////////////////////
						 
                    NSArray *arrayExercises = [[NSArray alloc]initWithArray:[[arrayDataTraining objectAtIndex:i] objectForKey:@"response_serie_exercises"]];
						 
                    // Varre todos os exercícios dentro do array...
                    for (NSInteger i = 0; i < [arrayExercises count]; i++)
                    {
                        Exercises *exercise = (Exercises *) [NSEntityDescription insertNewObjectForEntityForName:@"Exercises"
                                                                                          inManagedObjectContext:coreDataService.getManagedContext];
							  
                        exercise.trainingID = training.trainingID;
                        exercise.exerciseID = [utils checkString:[[arrayExercises objectAtIndex:i] objectForKey:@"id"]];
                        exercise.name = [utils checkString:[[arrayExercises objectAtIndex:i] objectForKey:@"name"]];
                        exercise.type = [utils checkString:[[arrayExercises objectAtIndex:i] objectForKey:@"type"]];
                        exercise.video = [utils checkString:[[arrayExercises objectAtIndex:i] objectForKey:@"video"]];
                        exercise.fullExecution = [utils checkString:[[arrayExercises objectAtIndex:i] objectForKey:@"instruction"]];
                        exercise.fullDescription = [utils checkString:[[arrayExercises objectAtIndex:i] objectForKey:@"description"]];
                        exercise.muscle = [utils checkString:[[arrayExercises objectAtIndex:i] objectForKey:@"muscle"]];
                        exercise.icon = [utils checkString:[[arrayExercises objectAtIndex:i] objectForKey:@"icon"]];
                        exercise.isCircuit = [NSNumber numberWithBool:[[utils checkString:[[arrayExercises objectAtIndex:i] objectForKey:@"iscircuit"]] boolValue]];
                        exercise.circuitID = [utils checkString:[[arrayExercises objectAtIndex:i] objectForKey:@"circuit_id"]];
                        exercise.order = [NSNumber numberWithInteger:[[[arrayExercises objectAtIndex:i] objectForKey:@"order"]integerValue]];
                        exercise.instruction = [utils checkString:[[arrayExercises objectAtIndex:i] objectForKey:@"execution"]];
                        exercise.image1 = [utils checkString:[[arrayExercises objectAtIndex:i] objectForKey:@"image1"]];
                        exercise.image2 = [utils checkString:[[arrayExercises objectAtIndex:i] objectForKey:@"image2"]];
                        exercise.isDone = [NSNumber numberWithBool:NO];
                        exercise.treineeID = treineeID;
								exercise.relexercise_id = [utils checkString:[[arrayExercises objectAtIndex:i] objectForKey:@"relexercise_id"]];
								exercise.notes = [utils checkString:[[arrayExercises objectAtIndex:i] objectForKey:@"notes"]];
					
//                        if (self.isHistory)
//                        {
//                            exercise.isHistory = [NSNumber numberWithBool:YES];
//                        }
//                        else
//                        {
//                            exercise.isHistory = [NSNumber numberWithBool:NO];
//                        }
							  
                        if( [today timeIntervalSinceDate:training.serieDateInit] > 0 && [today timeIntervalSinceDate:training.serieDateEnd]<0)
									exercise.isHistory = [NSNumber numberWithBool:NO];
			 	         	else
			 	         		exercise.isHistory = [NSNumber numberWithBool:YES];
						 
							  
                        [coreDataService saveData];
							  
                        if ([exercise.isCircuit boolValue])
                        {
                            ////////////////////////////////////////////////////////////////////////
                            /// PEGA OS DADOS EXERCICOS COMBINADOS /////////////////////////////////
                            ////////////////////////////////////////////////////////////////////////
									
                            NSArray *arrayCombinedExercises = [[arrayExercises objectAtIndex:i] objectForKey:@"exercises"];
									
                            for (NSInteger i = 0; i < [arrayCombinedExercises count]; i++)
                            {
                                Exercises *exerciseInComb = (Exercises *)[NSEntityDescription insertNewObjectForEntityForName:@"Exercises"
                                                                                                       inManagedObjectContext:coreDataService.getManagedContext];
                                exerciseInComb.trainingID = training.trainingID;
                                exerciseInComb.exerciseID = [utils checkString:[[arrayCombinedExercises objectAtIndex:i] objectForKey:@"id"]];
                                exerciseInComb.name = [utils checkString:[[arrayCombinedExercises objectAtIndex:i] objectForKey:@"name"]];
                                exerciseInComb.type = [utils checkString:[[arrayCombinedExercises objectAtIndex:i] objectForKey:@"type"]];
                                exerciseInComb.video = [utils checkString:[[arrayCombinedExercises objectAtIndex:i] objectForKey:@"video"]];
                                exerciseInComb.fullExecution = [utils checkString:[[arrayCombinedExercises objectAtIndex:i] objectForKey:@"instruction"]];
                                exerciseInComb.fullDescription = [utils checkString:[[arrayCombinedExercises objectAtIndex:i] objectForKey:@"description"]];
                                exerciseInComb.muscle = [utils checkString:[[arrayCombinedExercises objectAtIndex:i] objectForKey:@"muscle"]];
                                exerciseInComb.icon = [utils checkString:[[arrayCombinedExercises objectAtIndex:i] objectForKey:@"icon"]];
										 
                                exerciseInComb.isCircuit = [NSNumber numberWithBool:[[utils checkString:[[arrayCombinedExercises objectAtIndex:i] objectForKey:@"iscircuit"]] boolValue]];
										 
                                exerciseInComb.circuitID = [utils checkString:[[arrayCombinedExercises objectAtIndex:i] objectForKey:@"circuit_id"]];
                                exerciseInComb.order = [NSNumber numberWithInteger:[[[arrayCombinedExercises objectAtIndex:i] objectForKey:@"order"]integerValue]];
                                exerciseInComb.instruction = [utils checkString:[[arrayCombinedExercises objectAtIndex:i] objectForKey:@"execution"]];
										 
                                exerciseInComb.image1 = [utils checkString:[[arrayCombinedExercises objectAtIndex:i] objectForKey:@"image1"]];
                                exerciseInComb.image2 = [utils checkString:[[arrayCombinedExercises objectAtIndex:i] objectForKey:@"image2"]];
										 
                                exerciseInComb.isDone = [NSNumber numberWithBool:NO];
                                exerciseInComb.treineeID = treineeID;
										 
                                exerciseInComb.instruction = [utils checkString:[[arrayCombinedExercises objectAtIndex:i] objectForKey:@"execution"]];
                                exerciseInComb.relexercise_id = [utils checkString:[[arrayCombinedExercises objectAtIndex:i] objectForKey:@"relexercise_id"]];
										  exerciseInComb.notes = [utils checkString:[[arrayCombinedExercises objectAtIndex:i] objectForKey:@"notes"]];
					
										 
//                                if (self.isHistory)
//                                {
//                                    exerciseInComb.isHistory = [NSNumber numberWithBool:YES];
//                                }
//                                else
//                                {
//                                    exerciseInComb.isHistory = [NSNumber numberWithBool:NO];
//                                }
										 
										   if( [today timeIntervalSinceDate:training.serieDateInit] > 0 && [today timeIntervalSinceDate:training.serieDateEnd]<0)
												exercise.isHistory = [NSNumber numberWithBool:NO];
			 	         				else
			 	         					exercise.isHistory = [NSNumber numberWithBool:YES];
						 
										 
                                [coreDataService saveData];
                            }
                        }
                    }
                }
					
                [SVProgressHUD showSuccessWithStatus:@"Treino atualizado \ncom sucesso!"];
					
                    LastUpdates *lastUpdate = (LastUpdates *) [coreDataService getDataFromLastUpdatesTable];
					
					  // CONFIGURA A DATA ATUAL.
					  NSDateFormatter *format = [[NSDateFormatter alloc] init];
					  [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
					  NSDate *now = [[NSDate alloc] init];
					  NSString *dateString = [format stringFromDate:now];
					
					  lastUpdate.training = dateString;
					
					  [coreDataService saveData];
					
					
                if (arrayDataTraining.count > 0)
                {
						 
						 
							[arrayEnabledTraining removeAllObjects];
							arrayEnabledTraining = [coreDataService getDataFromTrainingTable:self.isHistory withStatus:TRAINING_ON];
							if([arrayEnabledTraining count]>0) [self hideNoDataMessage]; else [self showNoDataMessage];
							[self.tableViewMeusTreinos reloadData];
						 
                }
                else
                {
						   [arrayEnabledTraining removeAllObjects];
							[arrayDisabledTraining removeAllObjects];
							[self.tableViewMeusTreinos reloadData];
                    [self showNoDataMessage];
                }
            }
            else
            {
					  [arrayEnabledTraining removeAllObjects];
					  arrayEnabledTraining = [coreDataService getDataFromTrainingTable:self.isHistory  withStatus:TRAINING_ON];
					  if([arrayEnabledTraining count]>0) [self hideNoDataMessage]; else [self showNoDataMessage];
					  [self.tableViewMeusTreinos reloadData];
					
                if (self.isHistory)
                {
                    [SVProgressHUD showSuccessWithStatus:@"Não existem treinos registrados em seu histórico!"];
                }
					
					
                [self.tableViewMeusTreinos reloadData];
                [SVProgressHUD dismiss];
					
            }
        }
		 
    } failure:^(NSURLSessionTask *operation, NSError *error) {
		 
        [SVProgressHUD dismiss];
        NSLog(@"Error: %@", error);
		 
    }];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)updateHistory
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showWithStatus:@"Sincronizando Histórico..." maskType: SVProgressHUDMaskTypeGradient];
    });

    // RECUPERA A APIKEY
    User *userData = (User *) [coreDataService getDataFromUserTable];
	
    ///////////////////////////////////////////////////////////////////////////////////
    /// VERIFICA SE EXISTEM ITENS DO HISTÓRICO DE TREINO PARA SEREM SINCORNIZAR //////
    ///////////////////////////////////////////////////////////////////////////////////
	
    NSArray *arrayFilteredT = [coreDataService getDataFromHistoryTableWithIsSync:NO IsClass:NO];
	
    if ([arrayFilteredT count] > 0)
    {
        for (NSInteger i = 0; i < [arrayFilteredT count]; i++)
        {
            History *historyEntry = [arrayFilteredT objectAtIndex:i];
			  
//            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//			   [manager.requestSerializer setTimeoutInterval:AFHHTTP_TIMEOUT];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *apiKey = [defaults objectForKey:@"userOldAPIKey"];
			  
            if (apiKey.length == 0)
            {
                [self insertNewUpdateHistoryWithApiKey:userData.apiKey];
					
                return;
            }
			  
            // Parametros validados.
            NSDictionary *parameters = @{
                                            @"apikey": apiKey,
                                            @"serie": historyEntry.trainingID,
                                            @"datetime": historyEntry.endDate
                                        };
			  
            // Monta a string de acesso a validação do login.
            NSMutableString *urlString = [[NSMutableString alloc] init];
            [urlString appendString:kBASE_URL_MOBITRAINER];
            [urlString appendString:@"api/sync/training"];
			  
            // Realiza o POST das informações e aguarda o retorno.
     AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
 			[manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
 			NSString *path=[[NSString alloc]initWithFormat:@"%@",urlString];
 			[manager POST:[NSURL URLWithString:path].absoluteString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
		{
                if (![[responseObject objectForKey:@"response_error"] boolValue])
                {
                    historyEntry.isSync = [NSNumber numberWithBool:YES];
						 
                    [coreDataService saveData];
						 
                    [self insertNewUpdateHistoryWithApiKey:userData.apiKey];
                }
                else
                {
                    [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                                      AndText:[responseObject objectForKey:@"message"]
                                  AndTargetVC:self];
                }
					
            } failure:^(NSURLSessionTask *operation, NSError *error){
					
                NSLog(@"Error: %@", error);
					
                [self insertNewUpdateHistoryWithApiKey:userData.apiKey];
            }];
        }
    }
	
    /////////////////////////////////////////////////////////////////////////////////
    /// VERIFICA SE EXISTEM ITENS DO HISTÓRICO DE AULAS PARA SEREM SINCORNIZAR //////
    /////////////////////////////////////////////////////////////////////////////////
	
    NSArray *arrayFilteredCS = [coreDataService getDataFromHistoryTableWithIsSync:NO IsClass:YES];
	
    if ([arrayFilteredCS count] > 0)
    {
        for (NSInteger i = 0; i < [arrayFilteredCS count]; i++)
        {
            History *historyEntry = [arrayFilteredCS objectAtIndex:i];
			  
//            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//			   [manager.requestSerializer setTimeoutInterval:AFHHTTP_TIMEOUT];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *apiKey = [defaults objectForKey:@"userOldAPIKey"];
			  
            if (apiKey.length == 0)
            {
                [self insertNewUpdateHistoryWithApiKey:userData.apiKey];
					
                return;
            }
			  
            // Parametros validados.
            NSDictionary *parameters = @{
                                            @"apikey": apiKey,
                                            @"classid": historyEntry.trainingID,
                                            @"datetime": historyEntry.endDate
                                        };
			  
            // Monta a string de acesso a validação do login.
            NSMutableString *urlString = [[NSMutableString alloc] init];
            [urlString appendString:kBASE_URL_MOBITRAINER];
            [urlString appendString:@"api/sync/classSchedule"];
			  
            // Realiza o POST das informações e aguarda o retorno.
   		  AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
 			[manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
 			NSString *path=[[NSString alloc]initWithFormat:@"%@",urlString];
 			[manager POST:[NSURL URLWithString:path].absoluteString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
  			{
                if (![[responseObject objectForKey:@"response_error"] boolValue])
                {
                    historyEntry.isSync = [NSNumber numberWithBool:YES];
						 
                    [coreDataService saveData];
						 
                    [self insertNewUpdateHistoryWithApiKey:userData.apiKey];
                }
                else
                {
                    [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                                      AndText:[responseObject objectForKey:@"message"]
                                  AndTargetVC:self];
                }
					
            } failure:^(NSURLSessionTask *operation, NSError *error) {
					
                NSLog(@"Error: %@", error);
					
                [self insertNewUpdateHistoryWithApiKey:userData.apiKey];
            }];
        }
    }

    if(arrayFilteredT.count == 0 && arrayFilteredCS.count == 0) // NÃO TEM ITENS DO HISTORICO PARA SEREM SINCRONIZADOS.
    {
        [self insertNewUpdateHistoryWithApiKey:userData.apiKey];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)insertNewUpdateHistoryWithApiKey:(NSString *)apikey
{
    // APAGA OS DADOS DA TABELA EXERCICOS
    [coreDataService dropHistoryTable];
	
    ////////////////////////////////////////////////////////////////////////
    /// MONTA URL E FAZ A REQUISIÇÃO AO SERVIDOR ///////////////////////////
    ////////////////////////////////////////////////////////////////////////
	
    // Monta a string de acesso a validação do login.
    NSMutableString *urlString = [[NSMutableString alloc] init];
    [urlString appendString:kBASE_URL_MOBITRAINER];
    [urlString appendString:@"api/history"];
	NSDictionary *parameters = @{@"apikey": apikey};
    // Inicializa o manager.
  AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
 			[manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
 			NSString *path=[[NSString alloc]initWithFormat:@"%@",urlString];
 			[manager POST:[NSURL URLWithString:path].absoluteString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
   		 
        if (![[responseObject objectForKey:@"response_error"] boolValue])
        {
            NSArray *arrayData = [responseObject objectForKey:@"history"];
			  
            if (!(arrayData == (id)[NSNull null] || [arrayData count] == 0))
            {
                for (NSInteger i = 0; i< arrayData.count; i++)
                {
                    History *historyEntry = (History *) [NSEntityDescription insertNewObjectForEntityForName:@"History"
                                                                                      inManagedObjectContext:coreDataService.getManagedContext];
						 
                    historyEntry.trainingID = [utils checkString:[[arrayData objectAtIndex:i] objectForKey:@"response_history_serie_id"]];
                    historyEntry.trainingName = [utils checkString:[[arrayData objectAtIndex:i] objectForKey:@"response_history_serie_name"]];
                    historyEntry.endDate = [utils checkString:[[arrayData objectAtIndex:i] objectForKey:@"response_history_datetime"]];
                    historyEntry.isSync = [NSNumber numberWithBool:YES];
                    historyEntry.isClass = [NSNumber numberWithBool:[[[arrayData objectAtIndex:i] objectForKey:@"response_history_is_class"]boolValue]];
						 
                    [coreDataService saveData];
                }
            }
        }
		 
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
		 
        // Se login, grava status no NSDefaults.
        NSUserDefaults *Defaults = [NSUserDefaults standardUserDefaults];
        [Defaults setBool:TRUE forKey:@"userStatus"];
        [Defaults synchronize];
		 
//        [[NSNotificatimerMessageCounttionCenter defaultCenter] postNotificationName:@"updateFeaturedImages" object:self];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"startTimerUpdateThread" object:self];
		 
      //  self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
       // [self dismissViewControllerAnimated:YES completion:nil];
       //   [self performSegueWithIdentifier:@"TreinosLogado" sender:self];
		 
    } failure:^(NSURLSessionTask *operation, NSError *error) {
		 
        NSLog(@"Error: %@", error);
    }];
	
	
}



////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - TIMER METHODS

- (void)checkUpdateStatus
{
	
    // VERIFICA SE TEM CONEXÃO COM A INTERNET.
    BOOL flagInternetStatus = [IMManager sharedManager].hasConnection;
	
    if (flagInternetStatus)
    {
		 
            NSLog(@"Meus Treinos VC: Checking update...");
			  
            User *userData = (User *) [coreDataService getDataFromUserTable];

            if(userData == nil)
            {
                ////////////////////////////////////////////////////////////////////////
                /// SALVA OS DADOS NO DEFAULTS /////////////////////////////////////////
                ////////////////////////////////////////////////////////////////////////

                NSUserDefaults *Defaults = [NSUserDefaults standardUserDefaults];
                [Defaults setBool:FALSE forKey:@"userStatus"];
                [Defaults synchronize];
                return;
            }
            // Cria um operation manager para realizar a solicitação via POST.
//            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//			   [manager.requestSerializer setTimeoutInterval:AFHHTTP_TIMEOUT];
            // Parametros validados.
            NSDictionary *parameters = @{@"apikey": userData.apiKey};
			  
            // Monta a string de acesso a validação do login.
            NSMutableString *urlString = [[NSMutableString alloc] init];
            [urlString appendString:kBASE_URL_MOBITRAINER];
            [urlString appendString:@"api/update"];
			  
            // Realiza o POST das informações e aguarda o retorno.
      	  AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
 			[manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
 			NSString *path=[[NSString alloc]initWithFormat:@"%@",urlString];
 			[manager POST:[NSURL URLWithString:path].absoluteString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
    			
                if (![[responseObject objectForKey:@"response_error"] boolValue])
                {
                    // Pega os dados do JSON.
                    NSDictionary *dataUpdate = [responseObject objectForKey:@"response_update"];
						 
                    // Se existirem dados a serem verificados.
                    if ([dataUpdate count] > 0)
                    {
                        // Salva os dados de update do servidor para comparar.
                        UpdateCheck* uCheck = [[UpdateCheck alloc] init];
							  
								uCheck.trainingLastUpdate = [dataUpdate objectForKey:@"training"];
								uCheck.traineeLastUpdate = [dataUpdate objectForKey:@"trainee"];
								uCheck.chatLastUpdate = [dataUpdate objectForKey:@"chat"];
								uCheck.userProfileLastUpdate = [dataUpdate objectForKey:@"profile"];
								uCheck.chatLastUpdate = [dataUpdate objectForKey:@"chat"];
								uCheck.classScheduleLastUpdate = [dataUpdate objectForKey:@"classschedule"];
							  
							  
							  
                        // Recupera os dados de update salvo na base de dados.
                        LastUpdates *lastUpdate = (LastUpdates *) [coreDataService getDataFromLastUpdatesTable];
							  
							  
							  
                        ///////////////////////////////////////////////////////////////////////
                        /// VERIFICA SE AS TABELAS PRECISAM DE ATUALIZAÇÃO ////////////////////
                        ///////////////////////////////////////////////////////////////////////
							  
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
							  
							  
                        ////////////////////////////////////////
                        /// TRAINING CHECK DATE ////////////////
                        ////////////////////////////////////////
							  
                        NSLog(@"LOCAL TRAINING DATE:%@",lastUpdate.training);
                        NSLog(@"SERVER TRAINING DATE:%@",uCheck.trainingLastUpdate);
							  
                        NSDate *serverTrainingLastUpdate = [dateFormatter dateFromString:uCheck.trainingLastUpdate];
                        NSDate *localTrainingLastUpdate = [dateFormatter dateFromString:lastUpdate.training];
                        NSInteger statusTraining = [utils compareDatesServer:serverTrainingLastUpdate AndLocal:localTrainingLastUpdate];
							  
                          ////////////////////////////////////////
                        /// USER PROFILE CHECK DATE ////////////
                        ////////////////////////////////////////
							  
                        NSLog(@"LOCAL USER PROFILE DATE:%@",lastUpdate.userProfile);
                        NSLog(@"SERVER USER PROFILE DATE:%@",uCheck.userProfileLastUpdate);
							  
                        NSDate *serverUserProfileLastUpdate = [dateFormatter dateFromString:uCheck.userProfileLastUpdate];
                        NSDate *localUserProfileLastUpdate = [dateFormatter dateFromString:lastUpdate.userProfile];
                        NSInteger statusUserProfile = [utils compareDatesServer:serverUserProfileLastUpdate AndLocal:localUserProfileLastUpdate];
							  
                        ////////////////////////////////////////
                        /// CHAT CHECK DATE ////////////////////
                        ////////////////////////////////////////
							  
                        NSLog(@"LOCAL USER CHAT DATE:%@",lastUpdate.chat);
                        NSLog(@"SERVER USER CHAT DATE:%@",uCheck.chatLastUpdate);
							  
                        NSDate *serverChatLastUpdate = [dateFormatter dateFromString:uCheck.chatLastUpdate];
                        NSDate *localChatLastUpdate = [dateFormatter dateFromString:lastUpdate.chat];
                        NSInteger statusChat = [utils compareDatesServer:serverChatLastUpdate AndLocal:localChatLastUpdate];
							  
							  
							  
                        if ((statusTraining == NEED_UPDATE ) || (statusChat == NEED_UPDATE) || (statusUserProfile == NEED_UPDATE))
                        {
                            flagUpdate = FALSE;
									 [self startUpdateProcess];
                            NSLog(@"NECESSITA ATUALIZAR!");
									
                        }
                        else
                        {
                            flagUpdate = TRUE;
									
                            NSLog(@"Meus Treinos VC: NÃO NECESSITA ATUALIZAR!");
                        }
                    }
                }
					
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                NSLog(@"Error Servidor Update");
                flagUpdate = TRUE;
					
            }];
		 
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)checkMessageCount//:(NSTimer *)timer
{
    // Pega o status do usuário, logado ou não.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL login = [defaults boolForKey:@"userStatus"];
	 NSLog(@"checkMessageCount CHECK MESSAGE");
    // VERIFICA SE TEM CONEXÃO COM A INTERNET.
    BOOL flagInternetStatus = [IMManager sharedManager].hasConnection;
	
    if (flagInternetStatus == TRUE && login == TRUE)
    {
        // Pega os dados do usuário...
        User *userData = (User *) [coreDataService getDataFromUserTable];
		 
        // Cria um operation manager para realizar a solicitação via POST.
     //   AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
		//  [manager.requestSerializer setTimeoutInterval:AFHHTTP_TIMEOUT];
        // Parametros validados.
        NSDictionary *parameters = @{@"apikey": userData.apiKey};
		 
        // Monta a string de acesso a validação do login.
        NSMutableString *urlString = [[NSMutableString alloc] init];
        [urlString appendString:kBASE_URL_MOBITRAINER];
        [urlString appendString:@"api/message/unread"];
		 
        // Realiza o POST das informações e aguarda o retorno.
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
 			[manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
 			NSString *path=[[NSString alloc]initWithFormat:@"%@",urlString];
 			[manager POST:[NSURL URLWithString:path].absoluteString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
 			{
     	   NSUserDefaults *Defaults = [NSUserDefaults standardUserDefaults];
            if (![[responseObject objectForKey:@"response_error"] boolValue])
            {

                unreadCount = [[responseObject objectForKey:@"total"] integerValue];
					 [Defaults setInteger:unreadCount forKey:@"UnreadCounter"];
					 [Defaults synchronize];
					 switch(unreadCount)
					 {
					 	case 0:
					 		chatIcon.rightBarButtonItem.image=[UIImage imageNamed:@"chat0"];
					 	break;
					 	case 1:
					 		chatIcon.rightBarButtonItem.image=[UIImage imageNamed:@"chat1"];
					 	break;
					 	case 2:
					 		chatIcon.rightBarButtonItem.image=[UIImage imageNamed:@"chat2"];
					 	break;
					 	case 3:
					 		chatIcon.rightBarButtonItem.image=[UIImage imageNamed:@"chat3"];
					 	break;
					 	default:
					 		chatIcon.rightBarButtonItem.image=[UIImage imageNamed:@"chat4"];
					 	break;
					 	
					 }
					
					
            }
            else
            {
					NSLog(@"$$$$$$$$$RECUPEROU READ");
               unreadCount = [Defaults integerForKey:@"UnreadCounter"] ;
					switch(unreadCount)
					{
					  case 0:
						  chatIcon.rightBarButtonItem.image=[UIImage imageNamed:@"chat0"];
					  break;
					  case 1:
						  chatIcon.rightBarButtonItem.image=[UIImage imageNamed:@"chat1"];
					  break;
					  case 2:
						  chatIcon.rightBarButtonItem.image=[UIImage imageNamed:@"chat2"];
					  break;
					  case 3:
						  chatIcon.rightBarButtonItem.image=[UIImage imageNamed:@"chat3"];
					  break;
					  default:
						  chatIcon.rightBarButtonItem.image=[UIImage imageNamed:@"chat4"];
					  break;
					}
					
				}
			  
        } failure:^(NSURLSessionTask *operation, NSError *error) {
			  
            NSLog(@"Error: %@", error);
        }];
    }
}



//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
//
//- (void)setFlagUpdate:(NSTimer *)timer
//{
//    flagUpdate = TRUE;
//
//    // Seta o timer para verificar o update.
//    self.timerCheckUpdate = [NSTimer scheduledTimerWithTimeInterval:kCHECK_UPDATE_TIMER
//                                                             target:self
//                                                           selector:@selector(checkUpdateStatus:)
//                                                           userInfo:nil
//                                                            repeats:YES];
//}



- (IBAction)reloadBtn:(id)sender {
}
@end

////////////////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

