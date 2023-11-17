//
//  CircuitoDetalheController.m
//  mobitrainer
//
//  Created by Reginaldo Lopes on 07/07/15.
//  Copyright (c) 2015 4mobi. All rights reserved.
//

#import "CircuitoDetalheVC.h"

@interface CircuitoDetalheVC()

@end

@implementation CircuitoDetalheVC

@synthesize viewDone;
@synthesize dimmer;
@synthesize background;
@synthesize arrayExercises;
@synthesize trainingID;
@synthesize treineeID;
@synthesize lblSerieName;
@synthesize trainingName;
@synthesize tableview;
@synthesize tvTituloCombinado;
@synthesize tvCombinadoDesc;
@synthesize btnConcluido;
@synthesize delegate;
@synthesize isDone;
@synthesize selectedPath;
@synthesize viewTopFrame;
@synthesize isHistory;
@synthesize intervalData;
@synthesize confirmaNovoTimerOutlet;
@synthesize labelClock;
@synthesize iniciarBtnText;
@synthesize trainingpublickey;

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - SEGUE

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableview indexPathForSelectedRow];

    if ([[segue identifier] isEqualToString:@"segueCombinadoExercicioDetalhes"])
    {
        ExerciciosDetalhesVC *edvc = [segue destinationViewController];
        edvc.title = @"Exercício";
        edvc.exercise = (Exercises *) [arrayExercises objectAtIndex:indexPath.row];
        edvc.trainingID = self.trainingID;
        edvc.isDone = NO;
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - VIEW LIFECYCLE

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    utils = [[UtilityClass alloc] init];

	intervalData = [[NSMutableArray alloc] initWithObjects:@"15s", @"30s", @"45s", @"60s", @"1m30s", @"2m",  nil];
	 self.timerSelector.hidden = YES;
	 confirmaNovoTimerOutlet.hidden =YES;
	
	 // Initialize Data
    pickerData = @[@"15s", @"30s", @"45s", @"60s", @"1m30s", @"2m"];
    pickerDataSeconds = @[@"15", @"30", @"45", @"60", @"90", @"120"];
	
	
	 NSUserDefaults *Defaults = [NSUserDefaults standardUserDefaults];
	 NSInteger timerpadrao = [Defaults integerForKey:@"TimerDescanso"] ;
	 secondsLeft = (int)timerpadrao;
	 minutes = (secondsLeft % 3600) / 60;
	 seconds = (secondsLeft % 3600) % 60;
	 labelClock.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
	
    coreDataService = [[CoreDataService alloc] init];
    [coreDataService initialize];
    
    if (IS_IPHONE5)
    {
        self.tableview.frame = CGRectMake(0, 166, 320, 500);
    }
    else
    {
        self.tableview.frame = CGRectMake(0, 198, 320, 281);
    }
    
    viewTopFrame.layer.borderColor = UIColorFromRGB(0xD4D4D4).CGColor;
    viewTopFrame.layer.borderWidth = 0.8f;

    // Configura o texto do botão de voltar.
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"CIRCUITO"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:nil
                                                                  action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    // Configura o background da tableview.
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                                      self.view.frame.size.width,
                                                                      self.view.frame.size.height)];
    [backgroundView setBackgroundColor:UIColorFromRGB(0xDFDFDF)];
    [self.tableview setBackgroundView:backgroundView];
    
    self.tableview.delegate = self;
	
    // Tweak para linhas extra na tabela.
     [self.tableview setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0,0, 320,70)]];
    
    // Busca os dados no db.
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Exercises"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSMutableArray *mutableFetchResults = [[coreDataService.getManagedContext executeFetchRequest:fetchRequest
                                                                                            error:&error] mutableCopy];
    
    User *userData = (User *) [coreDataService getDataFromUserTable];
    
    NSPredicate *predicate;
    
    if ([userData.level integerValue] == USER_LEVEL_TRAINEE)
    {
        predicate = [NSPredicate predicateWithFormat:@"trainingID==%@ && circuitID==%@",self.trainingID, self.circuitoID];
    }
    else
    {
        predicate = [NSPredicate predicateWithFormat:@"trainingID==%@ && circuitID==%@ && treineeID==%@",self.trainingID,self.circuitoID, self.treineeID];
    }
  
    NSArray *arrayFiltered = [mutableFetchResults filteredArrayUsingPredicate:predicate];
    
    if ([arrayFiltered count] > 0)
    {
        arrayExercises = [[NSMutableArray alloc] initWithArray:arrayFiltered];
        [self.tableview reloadData];
    }
    
    // RECUPERA AS CONFIGURA"CÃO DO APP DESGIN DO BANCOD E DADOS.
//    Design *appDesign = (Design *) [coreDataService getDataFromDesignTable];
//    tvTituloCombinado.textColor = UIColorFromRGB(kPRIMARY_COLOR);
	
    lblSerieName.text = trainingName;

    NSArray *array = [coreDataService getDataFromExercisesTableWithExerciseID:self.circuitoID
                                                                AndTrainingID:self.trainingID];
    
    if(array)
    {
        Exercises *exComb = [array objectAtIndex:0];
        tvTituloCombinado.text = exComb.name;

//        if (exComb.instruction.length > 0)
//        {
//            NSString *string = [NSString stringWithFormat:@"%@\n",exComb.instruction];
//            
//            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
//            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
//            paragraphStyle.alignment= NSTextAlignmentCenter;
//            [paragraphStyle setLineSpacing:5];
//            
//            [attrString beginEditing];
//            
//            [attrString addAttribute:NSFontAttributeName
//                               value:[UIFont boldSystemFontOfSize:17.0f]
//                               range:NSMakeRange(0, string.length)];
//            
//            [attrString addAttribute:NSParagraphStyleAttributeName
//                               value:paragraphStyle
//                               range:NSMakeRange(0, string.length)];
//            
//            [attrString addAttribute:NSForegroundColorAttributeName
//                               value:UIColorFromRGB(0x545454)
//                               range:NSMakeRange(0, string.length)];
//            
//            [attrString endEditing];
//            
//            tvCombinadoDesc.text = exComb.fullDescription;
//            
//            [[tvCombinadoDesc textStorage] insertAttributedString:attrString
//                                                          atIndex:0];
//        }
//        else
//        {
//            tvCombinadoDesc.text = exComb.fullDescription;
//        }
        tvCombinadoDesc.text = exComb.fullDescription;
    }

    // PEGA OS DADOS DO USUARIO
    if (isDone || [userData.level integerValue] == USER_LEVEL_TRAINER || [userData.level integerValue] == USER_LEVEL_MASTERTRAINER || [userData.level integerValue] == USER_LEVEL_ADMINISTRATOR || isHistory)
    {
        self.navigationItem.rightBarButtonItem.enabled = NO;
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor clearColor];
    }
    //tableview.contentInset = UIEdgeInsetsMake(0, 0, 120, 0); //values
    tableview.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];

}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Remove o HUD.
    [SVProgressHUD dismiss];
    
    // Remove a view dimer e seu conteudo se estiver visivel quando o botão voltar for precionado...
    [self removeDimerView];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - UIPICKERVIEW DELEGATE

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickerData.count;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return pickerData[row];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //textFieldTrainingDifficult.text = [pickerData objectAtIndex:row];
	
   // [self hideKeyboard];
	
   // [self.textFieldTrainingDifficult becomeFirstResponder];
	secondsLeft=[pickerDataSeconds[row] intValue	];
	
}
#pragma mark - TABLE VIEW DATA SOURCE & DELEGATE

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     return [arrayExercises count];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == arrayExercises.count-1)
    {
        return 60;
    }
    else
    {
        return 60;
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove Separator Insert
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
	
    UIImageView *accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Table_Seta"]];
    
    if (indexPath.row == arrayExercises.count-1)
    {
        accessoryView.frame = CGRectMake((self.view.frame.size.width - 26), ((cell.frame.size.height / 2) - 7), 14, 14);
    }
    else
    {
        accessoryView.frame = CGRectMake((self.view.frame.size.width - 26), ((cell.frame.size.height / 2) - 2), 14, 14);
    }
    
    accessoryView.tag = 123;
    [cell.contentView addSubview:accessoryView];
	
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    ExerciciosListaCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[ExerciciosListaCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Exercises *exercise = (Exercises *)[arrayExercises objectAtIndex:indexPath.row];
    
    if (indexPath.row == arrayExercises.count-1)
    {
        cell.isLastCell = TRUE;
    }
    else
    {
        cell.isLastCell = NO;
    }
    
    cell.labelExerciseName.text = exercise.name;
    cell.labelExecucaoExercico.text = exercise.instruction;
    [cell.labelExerciseName setHighlightedTextColor:UIColorFromRGB(0xE3E8EA)];
    
    //////////////////////////////////////////////////////////////////////
    /// IMAGEM DO EXERCICIO //////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////
    
    cell.imageExercise.image = [UIImage imageNamed:exercise.icon];
	
	 User *userData = (User *) [coreDataService getDataFromUserTable];
	
	
	 cell.imagePersonPencil.image=[UIImage imageNamed:@"Pencil"];
	
	 if([exercise.instruction isEqualToString:@""])
	{
		if ([userData.level integerValue] == USER_LEVEL_TRAINEE )
			cell.labelExecucaoExercico.text=@" Solicite a execução para seu treinador";
		else
			cell.labelExecucaoExercico.text=@" Indique a execução do exercício";
	}
	else
	  if(exercise.instruction !=nil)
			cell.labelExecucaoExercico.text = [@" " stringByAppendingString: exercise.instruction];
	
	
	cell.imageExercise.image = [UIImage imageNamed:exercise.icon];
	
	

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

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([self.tableview respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableview setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableview respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableview setLayoutMargins:UIEdgeInsetsZero];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - CUSTOM METHODS

- (void)removeDimerView
{
    dimmer.alpha = 1;
    background.transform = CGAffineTransformIdentity;
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        background.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
        dimmer.alpha = 0;
        
    } completion:^(BOOL finished){
        
        // if you want to do something once the animation finishes, put it here
        [dimmer removeFromSuperview];
        self.tableview.scrollEnabled = YES;
        
    }];
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

#pragma mark - ACTION

- (IBAction)btnConcluidoClicado:(id)sender
{
    NSArray *array = [coreDataService getDataFromExercisesTableWithExerciseID:self.circuitoID
                                                                AndTrainingID:self.trainingID];
    
    if(array)
    {
        Exercises *exComb = [array objectAtIndex:0];
        exComb.isDone = [NSNumber numberWithBool:YES];
        
        [coreDataService saveData];
  
        int viewsToPop = 1;
        [self.navigationController popToViewController:[self.navigationController.viewControllers
                                                        objectAtIndex:self.navigationController.viewControllers.count-viewsToPop-1]
                                              animated:YES];
        
        
        [delegate circuitDone:self.selectedPath];
    }
}

- (IBAction)btnVoltar:(id)sender {
		[self dismissViewControllerAnimated:YES completion:nil];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - ACTIONS

- (IBAction)btnIniciarClicado:(id)sender
{
    if(flagInUse == TRUE)
    {
    	flagInUse = FALSE;
		 NSUserDefaults *Defaults = [NSUserDefaults standardUserDefaults];
		 NSInteger timerpadrao = [Defaults integerForKey:@"TimerDescanso"] ;
		 secondsLeft = (int)timerpadrao;
		 minutes = (secondsLeft % 3600) / 60;
		 seconds = (secondsLeft % 3600) % 60;
		 labelClock.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
		 
//		 labelClock.text = @"00:30";
     //   btnIniciar.alpha = 0.5f;
        [descansoTimer invalidate];
		 
		// [iniciarBtnText setTitleColor:UIColorFromRGB(STYLE_MAIN_COLOR) forState:UIControlStateNormal ];
	    [iniciarBtnText setTitle:@"Iniciar" forState:UIControlStateNormal ];
		 
	 }
    else
    {
  //  btnIniciar.enabled = NO;
   // btnIniciar.alpha = 0.5f;
	
		 flagInUse = TRUE;
		// [iniciarBtnText setTitleColor:[UIColor redColor] forState:UIControlStateNormal ];
		 [iniciarBtnText setTitle:@"Reiniciar" forState:UIControlStateNormal ];
		 
		
		 [self countdownTimer];
	 }
}



////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)updateCounter:(NSTimer *)theTimer
{
    if(secondsLeft > 0 )
    {
		
        secondsLeft -- ;
        minutes = (secondsLeft % 3600) / 60;
        seconds = (secondsLeft % 3600) % 60;
        labelClock.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
		 
    }
    else
    {
        // Construct URL to sound file
        NSString *path = [NSString stringWithFormat:@"%@/alarm.mp3", [[NSBundle mainBundle] resourcePath]];
        NSURL *soundUrl = [NSURL fileURLWithPath:path];
        [audioPlayer play];
		 
        // Create audio player object and initialize with URL to sound
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
        [audioPlayer play];
		 
    //    labelClock.text = @"00:30";
			NSUserDefaults *Defaults = [NSUserDefaults standardUserDefaults];
		 NSInteger timerpadrao = [Defaults integerForKey:@"TimerDescanso"] ;
		 secondsLeft = (int)timerpadrao;
		 minutes = (secondsLeft % 3600) / 60;
		 seconds = (secondsLeft % 3600) % 60;
		 labelClock.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    //    btnIniciar.alpha = 0.5f;
        [descansoTimer invalidate];
		 
	//	 [iniciarBtnText setTitleColor:UIColorFromRGB(STYLE_MAIN_COLOR) forState:UIControlStateNormal ];
	    [iniciarBtnText setTitle:@"Iniciar" forState:UIControlStateNormal ];
        flagInUse = FALSE;
		 
//        double delayInSeconds = 1.0f;
//
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//
//        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//
//            [self dismissViewControllerAnimated:YES completion:nil];
//        });
		 
		 
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)countdownTimer
{
	 [descansoTimer invalidate];
	 // Declare the start of a background task
    // If you do not do this then the mainRunLoop will stop
    // firing when the application enters the background
    __block UIBackgroundTaskIdentifier backgroundTaskIdentifier =
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{

        [[UIApplication sharedApplication] endBackgroundTask:backgroundTaskIdentifier];
    }];

    // Make sure you end the background task when you no longer need background execution:
    // [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskIdentifier];

	
    descansoTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                             target:self
                                           selector:@selector(updateCounter:)
                                           userInfo:nil
                                            repeats:YES];
	
	NSRunLoop *runloop = [NSRunLoop currentRunLoop];
	[runloop addTimer:descansoTimer forMode:NSRunLoopCommonModes];
	
}








- (IBAction)btnAlterarTimer:(id)sender {
	self.timerSelector.hidden = NO;
	confirmaNovoTimerOutlet.hidden =NO;
}

- (IBAction)confirmaNovoTimer:(id)sender {
	self.timerSelector.hidden = YES;
	confirmaNovoTimerOutlet.hidden =YES;
	minutes = (secondsLeft % 3600) / 60;
	seconds = (secondsLeft % 3600) % 60;
   labelClock.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
	
	
	
   NSUserDefaults *Defaults = [NSUserDefaults standardUserDefaults];
	 [Defaults setInteger:secondsLeft forKey:@"TimerDescanso"];
    [Defaults synchronize];
	
	
}

- (IBAction)editExecucao:(id)sender
{
	UIButton *button = (UIButton *)sender;
  NSLog(@"editExecucao TAG = %ld e Modulo %ld", [button tag],((button.tag-button.tag%2)/2));

	 BOOL flagInternetStatus = [IMManager sharedManager].hasConnection;
	 if(flagInternetStatus == TRUE)
	 {
		 
			UIAlertController *alertController = [UIAlertController alertControllerWithTitle:kTEXT_ALERT_TITLE
																								 message:@"Instruções de execução."
																								 preferredStyle:UIAlertControllerStyleAlert];
		#ifdef NEW_STYLE
		 alertController.view.tintColor=[UIColor colorNamed:@"myCellTextColor"];
		#endif
		 
		 [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
		  {
				textField.delegate=self;
				textField.placeholder = @"Indique e execução deste exercício...";
				[textField setKeyboardType:UIKeyboardTypeDefault];
				textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
				textField.clearButtonMode = UITextFieldViewModeWhileEditing;
			 
				Exercises *exercise = (Exercises *)[arrayExercises objectAtIndex:((button.tag-button.tag%2)/2)];
	
				textField.text = exercise.instruction;

		  }];
		 
			UIAlertAction *actionYES = [UIAlertAction actionWithTitle:@"OK"
																			  style:UIAlertActionStyleDefault
																			handler:^(UIAlertAction * action){
																				
																				
																				
							Exercises *exercise = (Exercises *)[arrayExercises objectAtIndex:((button.tag-button.tag%2)/2)];

							  // NSLog(exercise.instruction);
							  UITextField *textField = alertController.textFields.firstObject;
							  exercise.instruction = textField.text;
							  
							  [coreDataService saveData];
							  [self syncExerciseToServer];
							  [tableview reloadData];
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
	}
}




- (void)syncExerciseToServer
{
  // VERIFICA SE TEM CONEXÃO COM A INTERNET.
  BOOL flagInternetStatus = [IMManager sharedManager].hasConnection;
	
  if(flagInternetStatus)
  {
		// Mostra o HUD...
		[SVProgressHUD showWithStatus:@"Sincronizando dados..."  maskType: SVProgressHUDMaskTypeGradient];
		
		NSError *error = nil;
		NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Exercises"];
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
		NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
		[fetchRequest setSortDescriptors:sortDescriptors];
		NSMutableArray *mutableFetchResults = [[coreDataService.getManagedContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
		
		User *userData = (User *) [coreDataService getDataFromUserTable];
		
		NSPredicate *predicate;
		
		
		predicate = [NSPredicate predicateWithFormat:@"trainingID==%@ && treineeID==%@ && circuitID==%@",self.trainingID,self.treineeID, @"0"];
		NSArray *arrayFiltered = [mutableFetchResults filteredArrayUsingPredicate:predicate];
		
		
		NSString* lista;
		if ([arrayFiltered count] > 0)
			 lista = [self formatExerciseListString:arrayFiltered];
		else
			lista = @"{}";
	  
	  
			 // Cria um operation manager para realizar a solicitação v POST.
	//		 AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	//       [manager.requestSerializer setTimeoutInterval:AFHHTTP_TIMEOUT];
			 // Parametros validados.
			 NSDictionary *parameters = @{
													@"apikey":   userData.apiKey,
													@"serie_publickey": trainingpublickey,
													@"exercises":lista
													};
	  
			 // Monta a string de acesso a validação do login.
			 NSMutableString *urlString = [[NSMutableString alloc] init];
			 [urlString appendString:kBASE_URL_MOBITRAINER];
			 [urlString appendString:@"api/trainingmanager/saveexercisesinserie"];
	  
			 // Realiza o POST das informações e aguarda o retorno.
					AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
 			[manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
 			NSString *path=[[NSString alloc]initWithFormat:@"%@",urlString];
 			[manager POST:[NSURL URLWithString:path].absoluteString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
				  if (![[responseObject objectForKey:@"response_error"] boolValue])
				  {
						
						[SVProgressHUD showSuccessWithStatus:@"Dados sincronizados \ncom sucesso!"  maskType:SVProgressHUDMaskTypeGradient];
				  }
				  else
				  {
						// Remove o HUD.
						[SVProgressHUD dismiss];
						[utils showAlertWithTitle:kTEXT_ALERT_TITLE
												AndText:[responseObject objectForKey:@"message"]
										  AndTargetVC:self];
				  }
				 
			 } failure:^(NSURLSessionTask *operation, NSError *error){ 
				 
				  NSLog(@"Error: %@", error);
				 
				  [utils showAlertWithTitle:kTEXT_ALERT_TITLE
										  AndText:kTEXT_SERVER_ERROR_DEFAULT
									 AndTargetVC:self];
			 }];
		}
	
  else
  {
  		[utils showAlertWithTitle:kTEXT_ALERT_TITLE
                                      AndText:kTEXT_INTERNET_ERROR_DEFAULT
                                  AndTargetVC:self];
	}
	
}

- (NSString *) formatExerciseListString: (NSArray *) arrayList
 {
	 
	  NSMutableString *thislist = [[NSMutableString alloc] init];
	  int i=0;
	  for (Exercises *e in arrayList)
	  {
			
			// - (NSString*)encodeToPercentEscapeString:(NSString *)string
			
			 if(i==0)
				  [thislist appendString:@"[{\"exe_id\":\""];
			 else
				  [thislist appendString:@"{\"exe_id\":\""];
			 if(e.exerciseID !=nil)
				[thislist appendString:e.exerciseID];
			 [thislist appendString:@"\",\"exe_exec\":\""];
			 if(e.instruction!=nil)
				[thislist appendString:e.instruction];
			 if(i==([arrayList count]-1))
			 {
				 if([e.isCircuit boolValue])
					[thislist appendString:@"\",\"exe_type\":\"C\"}]"];
				 else
					[thislist appendString:@"\",\"exe_type\":\"E\"}]"];
			 }
			 else
			 {
				if([e.isCircuit boolValue])
				  [thislist appendString:@"\",\"exe_type\":\"C\"},"];
				else
				  [thislist appendString:@"\",\"exe_type\":\"E\"},"];
			 }
			
			i++;
			
	  }
	  NSString* final = [NSString stringWithFormat: @"%@", thislist];
	 NSLog(@"%@",final);
	  final =[utils encodeToPercentEscapeString:final];
	 
	  return final;
	 
 }

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
