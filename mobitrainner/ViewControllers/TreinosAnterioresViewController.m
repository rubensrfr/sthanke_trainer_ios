//
//  MeusTreinosViewController.m
//  mobitrainer
//
//  Created by Rubens Rosa on 09/11/2017.
//  Copyright © 2017 4mobi. All rights reserved.
//


#import "TreinosAnterioresViewController.h"

@interface TreinosAnterioresViewController()

@end

@implementation TreinosAnterioresViewController

@synthesize treineeID;
@synthesize btnReload;
@synthesize isHistory;
@synthesize treineeEmail;
@synthesize tableViewMeusTreinos;
@synthesize imageUser;
@synthesize nameUser;
@synthesize emailUser;
@synthesize chatIcon;

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
		 
		 
		 
        if(indexPath.section==0)
        {
			  if([arrayEnabledTraining count]>0)
              training = (Training *) [arrayEnabledTraining objectAtIndex:indexPath.row];
			  else if([arrayDisabledTraining count]>0)
						training = (Training *) [arrayDisabledTraining objectAtIndex:indexPath.row];
		 }
		 else if(indexPath.section==1)
            training = (Training *) [arrayDisabledTraining objectAtIndex:indexPath.row];
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
		if(indexPath.section==0)
		{
			if([arrayEnabledTraining count]>0)
				training = (Training *) [arrayEnabledTraining objectAtIndex:indexPath.row];
			else if([arrayDisabledTraining count]>0)
						training = (Training *) [arrayDisabledTraining objectAtIndex:indexPath.row];
					else
						return NO;
		}
		else if(indexPath.section==1)
        	training = (Training *) [arrayDisabledTraining objectAtIndex:indexPath.row];
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
	 self.isHistory =TRUE;
    coreDataService = [[CoreDataService alloc] init];
    [coreDataService initialize];
	
	
     // Tweak para linhas extra na tabela.
     [self.tableViewMeusTreinos setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0,0, 320,70)]];

//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"TREINOS"
//                                                                   style:UIBarButtonItemStylePlain
//                                                                  target:nil
//                                                                  action:nil];
//    self.navigationItem.backBarButtonItem = backButton;
//
     self.navigationItem.leftBarButtonItem = self.navigationItem.backBarButtonItem;
	
//     [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(becomeActive:)
//                                                 name:UIApplicationWillEnterForegroundNotification
//                                               object:nil];
//	
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(becomeInactive:)
//                                                 name:UIApplicationDidEnterBackgroundNotification
//                                               object:nil];
	
	
//    // Configura o background da tableview.
//    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
//	
//    [backgroundView setBackgroundColor:UIColorFromRGB(0xDFDFDF)];
//    [self.tableViewMeusTreinos setBackgroundView:backgroundView];
//    self.tableViewMeusTreinos.backgroundView.layer.zPosition -= 1;
//	
    User *userData = (User *) [coreDataService getDataFromUserTable];
	
    if ([userData.level integerValue] == USER_LEVEL_TRAINEE)
    {
        [arrayEnabledTraining removeAllObjects];
        arrayEnabledTraining = [coreDataService getDataFromTrainingTable:self.isHistory  withStatus:TRAINING_ON];
        [self.tableViewMeusTreinos reloadData];
    }
	
	
	self.navigationItem.leftBarButtonItem=nil;
	self.navigationItem.hidesBackButton=YES;
	

}



////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
	

}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
	
	
    [self.tableViewMeusTreinos reloadData];
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

////////////////////////////////////////////////////////////////////////////////////////////////////
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
    if((indexPath.section==0 && indexPath.row == arrayEnabledTraining.count-1)
    ||
		 (indexPath.section==1 && indexPath.row == arrayDisabledTraining.count-1))
    {
        return 110;
    }
    else
    {
        return 90;
    }
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
    static NSString *CellIdentifier = @"Cell";
	
    MeusTreinosCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
	
    if (!cell)
    {
        cell = [[MeusTreinosCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    Training *training;
    if(indexPath.section==0 && [arrayEnabledTraining count]>0)
        training = (Training *) [arrayEnabledTraining objectAtIndex:indexPath.row];
    else
        training = (Training *) [arrayDisabledTraining objectAtIndex:indexPath.row];
    [cell.labelSeriesName setHighlightedTextColor:UIColorFromRGB(0xE3E8EA)];
    [cell.labelShelfLife setHighlightedTextColor:UIColorFromRGB(0xE3E8EA)];
    [cell configureCell:training isHistory:self.isHistory];
	
    return cell;
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
	
	
	lblMessage.text = @"Não há histórico de treinos passados!\n ";
		
      lblMessage.alpha = 0;
	
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
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	
    lblMessage.alpha = 0;
    [lblMessage removeFromSuperview];
	
    [UIView commitAnimations];
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

- (IBAction)btnClose:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}
@end

////////////////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////


