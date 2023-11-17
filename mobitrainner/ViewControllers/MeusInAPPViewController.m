#import "MeusInAPPViewController.h"

@interface MeusInAPPViewController()

@end

@implementation MeusInAPPViewController

@synthesize treineeID;
@synthesize btnReload;
@synthesize isHistory;
@synthesize treineeEmail;
@synthesize tableViewMeusTreinos;
@synthesize imageUser;
@synthesize nameUser;
@synthesize emailUser;
@synthesize chatIcon;
@synthesize training_id;
@synthesize digitalproduct_id;
@synthesize product_id;
@synthesize welcome_video;
@synthesize training_name;
@synthesize trainingNameTV;
@synthesize training_description;
@synthesize sale_video;
@synthesize training_is_inapp;
@synthesize semTreinoTV;
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
        elvc.digitalproduct_id=training.training_id; //digitalproduc_id
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
	
    if ([[segue identifier] isEqualToString:@"segueWelcome"]) 
    {
     		  welcomeViewController *wtvc = [segue destinationViewController];
		  InAppTransactions *thisTranasaction= [coreDataService getInAppTransactionDataWithProductId:product_id];
		
        wtvc.product_id = thisTranasaction.product_id;
		  wtvc.training_id = thisTranasaction.training_id;
		  wtvc.welcome_video = thisTranasaction.welcome_video;
		  wtvc.response_days=[thisTranasaction.response_days stringValue];;
		   wtvc.productImage=thisTranasaction.image_product;
		   
    }
	if ([[segue identifier] isEqualToString:@"segueDetalhes"])
    {
        AssesoriaTableViewController *aatvc = [segue destinationViewController];
		 InAppTransactions *thisTranasaction= [coreDataService getInAppTransactionDataWithProductId:product_id];
		 
		 
        aatvc.title = @"Detalhes";
        aatvc.productId = product_id;
   //     aatvc.productPrice = Product.preco;
        aatvc.productDescription = training_description;
        aatvc.productVideo=sale_video;
        aatvc.show_details_only=TRUE;
        aatvc.productImage=thisTranasaction.image_product;
		 
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
		 
        NSError *error = nil;
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Exercises"];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [fetchRequest setSortDescriptors:sortDescriptors];
        NSMutableArray *mutableFetchResults = [[coreDataService.getManagedContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
		 
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
	
	trainingNameTV.text=training_name;
	
     // Tweak para linhas extra na tabela.
     [self.tableViewMeusTreinos setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0,0, 320,70)]];

    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"TREINOS"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:nil
                                                                  action:nil];
    self.navigationItem.backBarButtonItem = backButton;
	
	
	
//    // Configura o background da tableview.
//    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
//
//    [backgroundView setBackgroundColor:UIColorFromRGB(0xDFDFDF)];
//    [self.tableViewMeusTreinos setBackgroundView:backgroundView];
//    self.tableViewMeusTreinos.backgroundView.layer.zPosition -= 1;
	
	
	
	
//	self.navigationItem.leftBarButtonItem=nil;
//	self.navigationItem.hidesBackButton=YES;
	
	chatIcon.rightBarButtonItem.image=[UIImage imageNamed:@"chat0"];
	
//	[self.tableViewMeusTreinos initWithFrame:self.tableViewMeusTreinos.frame style:UITableViewStyleGrouped];

//	[self startUpdateProcess];

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
//	 [arrayEnabledTraining removeAllObjects];
	
	 if([digitalproduct_id isEqualToString:@""])
		arrayEnabledTraining = [coreDataService getDataFromTrainingTableWithTrainingId:self.training_id];
	 else
		arrayEnabledTraining = [coreDataService getDataFromTrainingTableWithTrainingId:self.digitalproduct_id];
	
    if([arrayEnabledTraining count]==0)
    {
       [self updateTraining];
    }
    else
    {
    	semTreinoTV.hidden=YES;
	 	[self.tableViewMeusTreinos reloadData];
	 }
	
	 InAppTransactions *thisTransaction= [coreDataService getInAppTransactionDataWithProductId:product_id];
	 NSMutableString *mensagem = [[NSMutableString alloc] init];
	 if(thisTransaction.showanamnese)
	 {
		 
		  [mensagem appendString:@"Parabéns! Suas respostas já foram encaminhadas para o treinador "];
		  [mensagem appendString:NOME_COMPLETO];
		  [mensagem appendString:@". Seu treino ficará pronto em até "];
	     [mensagem appendString:[thisTransaction.response_days stringValue]];
	     [mensagem appendString:@" dias, e seu período de assessoria só passará a contar a partir da entrega do primeiro treino. \n\nSe tiver dúvidas entre em contato com seu treinador através do recurso de Chat no aplicativo, pelo Telefone: "];
	     [mensagem appendString:PHONE_NUMBER];
	     [mensagem appendString:@" ou pelo email: "];
	     [mensagem appendString:BIO_EMAIL_RECIPIENT];
	     [mensagem appendString:@" . \n\nPara revisar suas respostas, acesse os questionários o quanto antes através do botão <SOBRE O TREINO> acima. "];
	  }
	  else
	  {
		  [mensagem appendString:NOME_COMPLETO];
		  [mensagem appendString:@" ativou esta assessoria online para você. Em breve seu treino está disponível aqui. "];
	     [mensagem appendString:@"\n\nSe tiver dúvidas entre em contato com seu treinador através do recurso de Chat no aplicativo."];
	  }
	
	  semTreinoTV.text=mensagem;
	// Parabéns! Suas respostas foram encaminhadas para o treinador. Seu treino ficará pronto nos próximos dias e seu período de assessoria só passará a contar a partir da entrega do primeiro treino. Se tiver dúvidas entre em contato com seu treinador através do recurso de Chat, Telefone ou Email indicados na tela sobre do treinador. Para revisar suas respostas acesse o o botão <SOBRE O TREINO> acima.
	
//	[self btnReload2];
}



////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
	 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	    
	 [defaults setBool:FALSE forKey:@"purchaseNeedUpdate"];
	 [defaults synchronize];

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
//	if([arrayEnabledTraining count]>0)
//	{
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
//   }
 //  return nil;
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



- (void)btnReload2{
	
	// VERIFICA SE TEM CONEXÃO COM A INTERNET.
    BOOL flagInternetStatus = [IMManager sharedManager].hasConnection;
	
    // SE TEM CONEXÃO
    if (flagInternetStatus)
    {
		 
        [self updateTraining];
		
		  [tableViewMeusTreinos reloadData];
		 
    }
    else
    {
        [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                          AndText:kTEXT_INTERNET_ERROR_DEFAULT
                      AndTargetVC:self];
    }
}

- (IBAction)btnReload:(id)sender {
	
	// VERIFICA SE TEM CONEXÃO COM A INTERNET.
    BOOL flagInternetStatus = [IMManager sharedManager].hasConnection;
	
    // SE TEM CONEXÃO
    if (flagInternetStatus)
    {
		 
        [self updateTraining];
		
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



////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)updateTraining
{
	// VERIFICA SE TEM CONEXÃO COM A INTERNET.
    BOOL flagInternetStatus = [IMManager sharedManager].hasConnection;
	
    // SE TEM CONEXÃO
    if (!flagInternetStatus || training_id==nil)
    {
        [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                          AndText:kTEXT_INTERNET_ERROR_DEFAULT
                      AndTargetVC:self];
			return;
    }
	
    [SVProgressHUD showWithStatus:@"Recuperando seu Treino..." maskType: SVProgressHUDMaskTypeGradient];
	
	
	 // Monta a string de acesso a validação do login.
		 NSMutableString *urlString = [[NSMutableString alloc] init];
		 [urlString appendString:kBASE_URL_MOBITRAINER];
	NSDictionary *parameters;
	 if([digitalproduct_id isEqualToString:@""])
	 {
		 [urlString appendString:@"api/inapp/getworkout"];
		 parameters = @{@"apikey":API_KEY_TRAINER,@"training_id":training_id};
	 }
	 else
	 {
		 [urlString appendString:@"api/inapp/getworkout_product"];
		 parameters = @{@"apikey":API_KEY_TRAINER,@"product_id":digitalproduct_id};
	 }
	
	
   
     // Inicializa o manager.
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//	 [manager.requestSerializer setTimeoutInterval:AFHHTTP_TIMEOUT];

	
	 //NSDictionary *parameters = @{@"apikey":API_KEY_TRAINER,@"training_id":training_id};
	
	
    //[manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
		  
			NSArray *arrayDataTraining = [[NSArray alloc] initWithArray:[responseObject objectForKey:@"workout"]];
			Training *training = nil;
		  
		  if([digitalproduct_id isEqualToString:@""])
			{
				[coreDataService deleteDataFromExerciseTableByTrainingID:training_id];
		      [coreDataService deleteTrainingWithTrainingID:training_id];
	      }
	      else
	      {
	          [coreDataService deleteDataFromExerciseTableByTrainingID:digitalproduct_id];
		      [coreDataService deleteTrainingWithTrainingID:digitalproduct_id];
	      }
		  
		  
		  
		//  [coreDataService deleteDataFromExerciseTableByTrainingID:training_id];
		//  [coreDataService deleteTrainingWithTrainingID:training_id];
		//  [coreDataService dropTrainingTable];
		//  [coreDataService dropExercisesTable];
		  
			if (arrayDataTraining.count > 0)
			{
				
				
				 for (NSInteger i = 0; i < [arrayDataTraining count]; i++)
				 {
				 		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
						  [dateFormat setDateFormat:@"yyyy-MM-dd"];
						  NSDate *dateInit = [dateFormat dateFromString:[utils checkString:[[arrayDataTraining objectAtIndex:i] objectForKey:@"response_serie_date_init"]]];
						  NSDate *dateEnd = [dateFormat dateFromString:[utils checkString:[[arrayDataTraining objectAtIndex:i] objectForKey:@"response_serie_date_end"]]];
						  NSDate *today = [NSDate date];
						  if(dateInit!=nil  && [dateInit timeIntervalSinceDate:today] >0)
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
						training.serieIsLock = [NSNumber numberWithInteger:[[[arrayDataTraining objectAtIndex:i] objectForKey:@"response_serie_islock"]integerValue]];
						
						
						if([digitalproduct_id isEqualToString:@""])
							training.training_id = training_id;
						else
							training.training_id=digitalproduct_id;
					 
						if ([dateEnd timeIntervalSinceDate:today] >0 || dateEnd == nil)
						    training.isHistory = [NSNumber numberWithBool:NO];
						 else
						    training.isHistory = [NSNumber numberWithBool:YES];

					  [coreDataService saveData];
					 
					  ////////////////////////////////////////////////////////////////////////
					  /// PEGA OS DADOS DOS EXERCICIOS ///////////////////////////////////////
					  ////////////////////////////////////////////////////////////////////////
					 
					  NSArray *arrayExercises = [[NSArray alloc]initWithArray:[[arrayDataTraining objectAtIndex:i] objectForKey:@"exercises"]];
					 
					  // Varre todos os exercícios dentro do array...
					  for (NSInteger i = 0; i < [arrayExercises count]; i++)
					  {
							Exercises *exercise = (Exercises *) [NSEntityDescription insertNewObjectForEntityForName:@"Exercises"
																													inManagedObjectContext:coreDataService.getManagedContext];
//						  if([digitalproduct_id isEqualToString:@""])
//							exercise.trainingID = training.trainingID;
//						  else
//							exercise.trainingID = training.training_id;
							
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
							exercise.relexercise_id = [utils checkString:[[arrayExercises objectAtIndex:i] objectForKey:@"relexercise_id"]];
							exercise.notes = [utils checkString:[[arrayExercises objectAtIndex:i] objectForKey:@"notes"]];
				
					 
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
									 
									 
									  [coreDataService saveData];
								 }
							}
					  }
				 }
				
				 [SVProgressHUD showSuccessWithStatus:@"Treino atualizado \ncom sucesso!"];
				
				 if (arrayDataTraining.count > 0)
				 {
					 
					   semTreinoTV.hidden=YES;
						[arrayEnabledTraining removeAllObjects];
						if([digitalproduct_id isEqualToString:@""])
						{
								arrayEnabledTraining = [coreDataService getDataFromTrainingTableWithTrainingId:self.training_id];
					
						}
						else
						{
								arrayEnabledTraining = [coreDataService getDataFromTrainingTableWithTrainingId:digitalproduct_id];
						}
						[self.tableViewMeusTreinos reloadData];
					 
				 }
				 else
				 {
						[arrayEnabledTraining removeAllObjects];
						[arrayDisabledTraining removeAllObjects];
						[self.tableViewMeusTreinos reloadData];
					   semTreinoTV.hidden=NO;
			        //[self showNoDataMessage];
				 }
			}
			else
			{
				  [SVProgressHUD showSuccessWithStatus:@"Treino atualizado \ncom sucesso!"];
				  [arrayEnabledTraining removeAllObjects];
				  arrayEnabledTraining = [coreDataService getDataFromTrainingTableWithTrainingId:self.training_id];
				  [self.tableViewMeusTreinos reloadData];
				
				 if (self.isHistory)
				 {
					  [SVProgressHUD showSuccessWithStatus:@"Não existem treinos registrados em seu histórico!"];
				 }
				
				
				 [self.tableViewMeusTreinos reloadData];
			  //  [self showNoDataMessage];
			  semTreinoTV.hidden=NO;
			}
	  }
		 
    } failure:^(NSURLSessionTask *operation, NSError *error)
	 { 
        [SVProgressHUD dismiss];
        NSLog(@"Error: %@", error);
		 
    }];
}


- (IBAction)sobreBtn:(id)sender {

	if(training_is_inapp==FALSE)
		[self performSegueWithIdentifier:@"segueWelcome" sender:self];
	else
		[self performSegueWithIdentifier:@"segueDetalhes" sender:self];
}

- (IBAction)historicoBtn:(id)sender {

		// Pega o status do usuário, logado ou não.
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		BOOL login = [defaults boolForKey:@"userStatus"];

		if (login != TRUE)
				 [self performSegueWithIdentifier:@"segueLogin" sender:self];
		else
				 [self performSegueWithIdentifier:@"segueHistorico" sender:self];

		 
	
	
}
@end

////////////////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

