//
//  serieViewController.m
//  mobitrainer
//
//  Created by Rubens Rosa on 10/11/2017.
//  Copyright © 2017 4mobi. All rights reserved.
//


#import "serieViewController.h"
//#import <FBSDKLoginKit/FBSDKLoginKit.h>
//#import <FBSDKSharekit/FBSDKSharekit.h>

@interface serieViewController()

@end

@implementation serieViewController

@synthesize viewDone;
@synthesize arrayExercises;
@synthesize trainingID;
@synthesize treineeID;
@synthesize trainingDifficulty;
@synthesize trainingName;
@synthesize dimmer;
@synthesize background;
@synthesize isHistory;
@synthesize trainingpublickey;
@synthesize tableViewExercicioLista;
@synthesize serieOnOffStatus;
@synthesize isMeusTreinosCalling;
@synthesize nivelSerieImage;
@synthesize nomeSerieLabel;
@synthesize decricaoSerieLabel;
@synthesize trainingDescription;
@synthesize btnIniciar;
@synthesize btnCancelar;
@synthesize labelClock;
@synthesize viewCounterBG;
@synthesize iniciarBtnText;
@synthesize arrayExercisesDone;
@synthesize intervalData;
@synthesize timerSelector;
@synthesize confirmaNovoTimerOutlet;
@synthesize viewCellCircuit;
@synthesize viewCellExercise;
@synthesize nomeSerieText;
@synthesize descricaoText;
@synthesize digitalproduct_id;

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - SEGUE

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableViewExercicioLista indexPathForSelectedRow];
	

	
    if([[segue identifier] isEqualToString:@"segueCircuitosDetalhes"])
    {
        CircuitoDetalheVC *cdvc = [segue destinationViewController];
		 
        Exercises *exercise = (Exercises *)[arrayExercises objectAtIndex:indexPath.row];
        cdvc.title = @"Exercícios";
        cdvc.circuitoID = exercise.exerciseID;
        cdvc.trainingID = self.trainingID;
        cdvc.treineeID = self.treineeID;
        cdvc.trainingName = self.trainingName;
        cdvc.delegate = self;
        cdvc.isDone = NO;
        cdvc.selectedPath = indexPath;
        cdvc.isHistory = self.isHistory;
        cdvc.trainingpublickey = self.trainingpublickey;
    }
	
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////
	
    if ([[segue identifier] isEqualToString:@"segueExerciciosDetalhes"])
    {
        ExerciciosDetalhesVC *edvc = [segue destinationViewController];
		 
        edvc.exercise = (Exercises *) [arrayExercises objectAtIndex:indexPath.row];
        edvc.trainingID = self.trainingID;
        edvc.isDone = NO;
        edvc.delegate = self;
    }
	
	
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - VIEW LIFECYCLE

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	  CGRect screen = [[UIScreen mainScreen] bounds];
	  CGFloat width = CGRectGetWidth(screen);
	  concluir_pos = width - 100;
	  //NSLog(@">>>>>>>>>>>>>> %f <<<<<<<<<<<<<<<<",width);
	
    self.tableViewExercicioLista.delegate = self;
  //  self.tableViewExercicioLista.contentInset = UIEdgeInsetsMake(-34, 0, 0, 0);
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
	
	
    utils = [[UtilityClass alloc] init];
	
    coreDataService = [[CoreDataService alloc] init];
    [coreDataService initialize];
	
//     [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardDidShow:)
//                                                 name:UIKeyboardDidShowNotification
//                                               object:nil];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
//
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:nil
                                                                  action:nil];
    self.navigationItem.backBarButtonItem = backButton;
 //RFR
    // Configura o background da tableview.
  //  UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
 //   [backgroundView setBackgroundColor:UIColorFromRGB(0xDFDFDF)];
 //   [self.tableViewExercicioLista setBackgroundView:backgroundView];
	
    self.tableViewExercicioLista.delegate = self;
	 self.tableViewExercicioLista.contentInset = UIEdgeInsetsMake(-34, 0, 0, 0);
	
    // PEGA OS DADOS DO USUARIO
    User *userData = (User *) [coreDataService getDataFromUserTable];

    if ([userData.level integerValue] == USER_LEVEL_TRAINER || [userData.level integerValue] == USER_LEVEL_MASTERTRAINER || [userData.level integerValue] == USER_LEVEL_ADMINISTRATOR || self.isHistory)
    {
        // self.navigationItem.rightBarButtonItem.enabled = NO;
        // self.navigationItem.rightBarButtonItem.tintColor = [UIColor clearColor];
        UIButton *button = [[UIButton alloc] init];
        button.frame=CGRectMake(0,0,10,10);
    //    [button setBackgroundImage:[UIImage imageNamed: @"ICO_Execucao"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonBarExercisePressed:) forControlEvents:UIControlEventTouchUpInside];
		 
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    }

	
	
    tableViewExercicioLista.dataSource = self;
    tableViewExercicioLista.delegate = self;

	
	
	[self displayHeader];
     // Tweak para linhas extra na tabela.
  //  [self.tableViewExercicioLista setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0,0, 320,70)]];

//		AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//		NSError *error = nil;
//		NSLog(@"Activating audio session");
//		if (![audioSession setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionDuckOthers error:&error]) {
//			 NSLog(@"Unable to set audio session category: %@", error);
//		}
//		BOOL result = [audioSession setActive:YES error:&error];
//		if (!result) {
//			 NSLog(@"Error activating audio session: %@", error);
//		}
	[[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
	[[UIApplication sharedApplication] beginReceivingRemoteControlEvents];


}



-(void) didSelectMenuOptionAtIndex:(NSInteger)row
{
    NSLog(@"Floating action tapped index %tu",row);
	
   BOOL flagInternetStatus = [IMManager sharedManager].hasConnection;
	
	if(flagInternetStatus == TRUE)
    {
    	[self hideNoDataMessage];
    	if(row==0)
    	{
    	  isMeusTreinosCalling=FALSE;
	
        	[self performSegueWithIdentifier:@"segueListaCompletaExercicios" sender:self];
		 }
		 if(row==1)
    	{
    	  isMeusTreinosCalling=FALSE;
	
        	[self performSegueWithIdentifier:@"segueListaCompletaSuperSeries" sender:self];
		 }
	}
	else
		[utils showAlertWithTitle:kTEXT_ALERT_TITLE
                                      AndText:kTEXT_INTERNET_ERROR_DEFAULT
                                  AndTargetVC:self];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];

    if(IS_OS_9_OR_LATER)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appNeedUpdateExerciseListHandler:)
                                                     name:@"appNeedUpdateExerciseList"
                                                   object:nil];
    }
	
    [self loadExercicesToDo];
	
	 self.timerSelector.delegate =self;
	 [self.timerSelector selectRow:0 inComponent:0 animated:YES];
	
	
	
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
	  [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];

    if(IS_OS_9_OR_LATER)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:@"appNeedUpdateExerciseList"
                                                      object:nil];
    }
	
//    // REMOVE OS OBSERVADORES.
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:UIKeyboardDidShowNotification
//                                                  object:nil];
//
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:UIKeyboardWillHideNotification
//                                                  object:nil];
//
    // Remove o HUD.
    [SVProgressHUD dismiss];
}


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

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - TABLE VIEW DATA SOURCE & DELEGATE

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{


		User *userData = (User *) [coreDataService getDataFromUserTable];
	
		if ([userData.level integerValue] != USER_LEVEL_TRAINEE)
		  return 1;
		else
		  return 2;
	
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

	 UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
	 v.backgroundColor = [UIColor clearColor];
	
	 UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 65, 320, 30)];
	 label.textAlignment = NSTextAlignmentCenter;
	
	 label.font = [UIFont systemFontOfSize:12];
	 label.textColor = [UIColor redColor];
	
	if(section==1)
	{
		if([arrayExercises count]==0)
		{
			[self showDoneMessage];
			v=nil;
		}
		else if([arrayExercisesDone count]>0)
			{
				label.textAlignment = NSTextAlignmentLeft;
				label.textColor = UIColorFromRGB(0x666666);
			 //  label.backgroundColor = UIColorFromRGB(0x666666);
				label.text = @"    EXERCÍCIOS CONCLUÍDOS";
				//    label.textAlignment = UITextAlignmentRight;
				[v addSubview:label];
			}
			else
			{
				v=nil;
			}
		}
		return v;
	
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

	if (section==1 && [arrayExercises count]>0)
		return 100.0f;
	else
		return 0.0f;

}

- (void) displayHeader
{
	decricaoSerieLabel.numberOfLines	= 0 ;
	nomeSerieText.text=trainingName;
	descricaoText.text = trainingDescription;
	//decricaoSerieLabel.text =@"decricaoSerieLabel.textdecricaoSerieLabel.textdecricaoSerieLabel.textdecricaoSerieLabel.textdecricaoSerieLabel.textdecricaoSerieLabel.textdecricaoSerieLabel.textdecricaoSerieLabel.textdecricaoSerieLabel.textdecricaoSerieLabel.textdecricaoSerieLabel.textdecricaoSerieLabel.textdecricaoSerieLabel.textdecricaoSerieLabel.textdecricaoSerieLabel.textdecricaoSerieLabel.textdecricaoSerieLabel.text";
	
    if ([trainingDifficulty integerValue] == 1)
    {
		if([serieOnOffStatus isEqualToString:@"1"] || [serieOnOffStatus isEqualToString:@""])
        nivelSerieImage.image = [UIImage imageNamed:@"Label_Iniciante_Hor"];
		else
		  nivelSerieImage.image = [UIImage imageNamed:@"Label_Iniciante_Hor_Disable"];
    }
	
    else if ([trainingDifficulty integerValue] == 2)
    {
    	if([serieOnOffStatus isEqualToString:@"1"] || [serieOnOffStatus isEqualToString:@""])
        nivelSerieImage.image = [UIImage imageNamed:@"Label_Intermediario_Hor"];
		else
		  nivelSerieImage.image = [UIImage imageNamed:@"Label_Intermediario_Hor_Disable"];
		
    }
	
    else if ([trainingDifficulty integerValue] == 3)
    {
		 if([serieOnOffStatus isEqualToString:@"1"] || [serieOnOffStatus isEqualToString:@""])
          nivelSerieImage.image = [UIImage imageNamed:@"Label_Avancado_Hor"];
		else
	   	nivelSerieImage.image = [UIImage imageNamed:@"Label_Avancado_Hor_Disable"];
		
    }
	
}



////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	
		User *userData = (User *) [coreDataService getDataFromUserTable];
	
		if ([userData.level integerValue] != USER_LEVEL_TRAINEE)
		  return [arrayExercises count];
		else
		{
			if(section==0)
				return [arrayExercises count];
			else
				return [arrayExercisesDone count];
		}
	
	
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	 if(indexPath.row == arrayExercises.count-1)
	 {
		  return 92;
	 }
	 else
	 {
		  return 92;
	 }
	
}



////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(tableView==self.tableViewExercicioLista)
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
			  accessoryView.frame = CGRectMake((self.view.frame.size.width - 26), ((cell.frame.size.height / 2) - 19), 14, 14);
		 }
		 else
		 {
			  accessoryView.frame = CGRectMake((self.view.frame.size.width - 26), ((cell.frame.size.height / 2) - 19), 14, 14);
		 }
		
		 accessoryView.tag = 123;
		 [cell.contentView addSubview:accessoryView];
		
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
	//	 if(indexPath.section==1)
		 	// = [UIColor redColor];
		 //cell.contentView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.6f];
		
		
		
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
		Exercises *exercise;
		 if(indexPath.section==0)
			 exercise = (Exercises *)[arrayExercises objectAtIndex:indexPath.row];
		 else
			 exercise = (Exercises *)[arrayExercisesDone objectAtIndex:indexPath.row];
	
		 if (![exercise.isCircuit boolValue])
		 {
			  static NSString *CellIdentifier = @"Cell";
			 
			  ExerciciosListaCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			 
			  if (!cell)
			  {
					cell = [[ExerciciosListaCell alloc] initWithStyle:UITableViewCellStyleSubtitle
																 reuseIdentifier:CellIdentifier];
			  }
			 
			  if (indexPath.row == arrayExercises.count-1)
			  {
					cell.isLastCell = TRUE;
			  }
			  else
			  {
					cell.isLastCell = NO;
			  }
			 
			 
			 if(indexPath.section==0)
			 {
			 		cell.viewCellExercise.backgroundColor=UIColorFromRGB(0xFFFFFF);
			 		cell.labelAnotacaoExercicio.backgroundColor=UIColorFromRGB(0xFFFFFF);
			 		cell.labelExecucaoExercico.backgroundColor=UIColorFromRGB(0xFFFFFF);
			 }
			 else if(indexPath.section==1)
			 {
			 	   cell.viewCellExercise.backgroundColor=UIColorFromRGB(0xF9F9F9);
			 	   cell.labelAnotacaoExercicio.backgroundColor=UIColorFromRGB(0xF9F9F9);
			 		cell.labelExecucaoExercico.backgroundColor=UIColorFromRGB(0xF9F9F9);
				 
	
			 }
			 
			  cell.imagePersonPencil.image=[UIImage imageNamed:@"Pencil"];
			  cell.labelExerciseName.text = exercise.name;
			  [cell.labelExerciseName setHighlightedTextColor:UIColorFromRGB(0xE3E8EA)];
			 
			  User *userData = (User *) [coreDataService getDataFromUserTable];
			  Notes *note = (Notes *) [coreDataService getDataFromNotesTableByUserID:userData.userID
                                                                TrainingID:trainingID
                                                                ExerciseID:exercise.exerciseID];
			 if(note.textNote==nil)
			    cell.labelAnotacaoExercicio.text = @"Espaço para Anotações";
			  if([note.textNote isEqualToString:@""])
			  {
				  if ([userData.level integerValue] == USER_LEVEL_TRAINEE )
				     cell.labelAnotacaoExercicio.text=@" Anotações do treino";
				  else
				     cell.labelAnotacaoExercicio.text=@" Sem anotações do aluno";
			  }
			  else
			    if(note.textNote!=nil)
				  cell.labelAnotacaoExercicio.text = [@" " stringByAppendingString: note.textNote];
			 
			 
			 
			 
			
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
			 
			 
			 
//			  //TREINADOR
//			  if (!([userData.level integerValue] == USER_LEVEL_TRAINEE ) && (flagInternetStatus == TRUE))
//			  {
//
//				  // add friend button
//				  UIButton *addPencilButton = [UIButton buttonWithType:UIButtonTypeCustom];
//				  addPencilButton.frame = CGRectMake(0.0f, 26.0f, 239.0f, 21.0f);
//
//		  		  addPencilButton.tag=indexPath.row*2;
//				  [cell.contentView addSubview:addPencilButton];
//				  [addPencilButton addTarget:self
//											 action:@selector(editExecucao:)
//								forControlEvents:UIControlEventTouchUpInside];
//
//			 }
//			 else
			 
				for(UIView *subview in cell.contentView.subviews)
				  {
					 if([subview isKindOfClass: [UIButton class]])
					 {
						[subview removeFromSuperview];
					 }
				  }
				 if(indexPath.section==0)
				 {
				 	  BOOL iPhoneX = NO;
					  if (@available(iOS 11.0, *)) {
						  UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
						  if (mainWindow.safeAreaInsets.top > 0.0) {
								iPhoneX = YES;
						  }
					  }
					 
					 
				 	 // add friend button
					  UIButton *addPencilButton = [UIButton buttonWithType:UIButtonTypeCustom];
					 
					  addPencilButton.frame = CGRectMake(concluir_pos, 60.0f, 100.0f, 25.0f);
					 
					  [addPencilButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
					  [addPencilButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
					  [addPencilButton setTitleColor:UIColorFromRGB(STYLE_MAIN_COLOR) forState:UIControlStateNormal];
					  [addPencilButton setTitle:@"CONCLUIR" forState:UIControlStateNormal];
					  addPencilButton.tag=indexPath.row*2;
					  [cell.contentView addSubview:addPencilButton];
					  [addPencilButton addTarget:self
												 action:@selector(execucaoIsDone:)
									forControlEvents:UIControlEventTouchUpInside];
					 
						UIButton *editAnotacaoButton = [UIButton buttonWithType:UIButtonTypeCustom];
					  editAnotacaoButton.frame = CGRectMake(11.0f, 62.0f, 205.0f, 21.0f);
			
					  editAnotacaoButton.tag=indexPath.row*2+1;
					  [cell.contentView addSubview:editAnotacaoButton];
					  [editAnotacaoButton addTarget:self
												 action:@selector(editAnotacao:)
									forControlEvents:UIControlEventTouchUpInside];
					 
					 
				  }
				  else
				  {
					 NSLog(@">>>>SESSAO 0 TAG REFAZER = %ld", indexPath.row*2);
					
					  BOOL iPhoneX = NO;
					  if (@available(iOS 11.0, *)) {
						  UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
						  if (mainWindow.safeAreaInsets.top > 0.0) {
								iPhoneX = YES;
						  }
					  }
					 
					 
				 	 // add friend button
					  UIButton *addPencilButton = [UIButton buttonWithType:UIButtonTypeCustom];
					 
					  addPencilButton.frame = CGRectMake(concluir_pos, 60.0f, 100.0f, 25.0f);
					  	// add friend button
					 
					  
					  [addPencilButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
					   [addPencilButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
					  [addPencilButton setTitleColor:UIColorFromRGB(STYLE_MAIN_COLOR) forState:UIControlStateNormal];
				  	  [addPencilButton setTitle:@"REFAZER" forState:UIControlStateNormal];
					  addPencilButton.tag=indexPath.row;
					  [cell.contentView addSubview:addPencilButton];
					  [addPencilButton addTarget:self
												 action:@selector(execucaoReDo:)
									forControlEvents:UIControlEventTouchUpInside];
					  addPencilButton.tag=indexPath.row;
				  }
			 
			 
			 

			 
				return cell;
	  }
	  else
	  {
			
			static NSString *CellIdentifier = @"Cell2";
			
			CircuitoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			
			if (!cell)
			{
				 cell = [[CircuitoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
			}
			
			if (indexPath.row == arrayExercises.count-1)
			{
				 cell.isLastCell = TRUE;
			}
			else
			{
				 cell.isLastCell = NO;
			}
			
			//////////////////////////////////////////////////////////////////////
			/// IMAGEM CIRCUITO / COMBINADO / PLACEHOLDER ////////////////////////
			//////////////////////////////////////////////////////////////////////
			
			if(indexPath.section==0)
			 {
			 		cell.viewCircuitCell.backgroundColor=UIColorFromRGB(0xFFFFFF);
			 		cell.labelAnotacaoCircuito.backgroundColor=UIColorFromRGB(0xFFFFFF);
			 		cell.labelExecucaoCircuito.backgroundColor=UIColorFromRGB(0xFFFFFF);
			 }
			 else if(indexPath.section==1)
			 {
			 	   cell.viewCircuitCell.backgroundColor=UIColorFromRGB(0xF9F9F9);
			 	   cell.labelAnotacaoCircuito.backgroundColor=UIColorFromRGB(0xF9F9F9);
			 	   cell.labelExecucaoCircuito.backgroundColor=UIColorFromRGB(0xF9F9F9);
	
			 }
		  
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
				 predicate = [NSPredicate predicateWithFormat:@"trainingID==%@ && circuitID==%@",self.trainingID, exercise.exerciseID];
			}
			else
			{
				 predicate = [NSPredicate predicateWithFormat:@"trainingID==%@ && circuitID==%@ && treineeID==%@",self.trainingID,exercise.exerciseID, self.treineeID];
			}
			
			NSArray *arrayFiltered = [mutableFetchResults filteredArrayUsingPredicate:predicate];
			
			if (arrayFiltered.count == 2)
			{
				 cell.imageCircuito.image = [UIImage imageNamed:@"combinado"];
			}
			else if(arrayFiltered.count > 2)
			{
				 cell.imageCircuito.image = [UIImage imageNamed:@"circuito"];
			}
			else
			{
				 cell.imageCircuito.image = [UIImage imageNamed:@"placeholder"];
			}
			
			
			
			//////////////////////////////////////////////////////////////////////
			/// NOME DO CIRCUITO OU COMBINADO ////////////////////////////////////
			//////////////////////////////////////////////////////////////////////
			
			cell.labelCircuitoName.text = exercise.name;
			[cell.labelCircuitoName setHighlightedTextColor:UIColorFromRGB(0xE3E8EA)];
			cell.imagePersonPencil.image=[UIImage imageNamed:@"Pencil"];
			
			
			  Notes *note = (Notes *) [coreDataService getDataFromNotesTableByUserID:userData.userID
                                                                TrainingID:trainingID
                                                                ExerciseID:exercise.exerciseID];
		  
			  if([note.textNote isEqualToString:@""])
			  {
				  if ([userData.level integerValue] == USER_LEVEL_TRAINEE )
				     cell.labelAnotacaoCircuito.text=@" Anotações do treino";
				  else
				     cell.labelAnotacaoCircuito.text=@" Sem anotações do aluno";
			  }
			  else
			    if(note.textNote!=nil)
				  cell.labelAnotacaoCircuito.text = [@" " stringByAppendingString: note.textNote];
		  
		  
		  
		  
		  
			  if([exercise.instruction isEqualToString:@""])
			   {
			   	if ([userData.level integerValue] == USER_LEVEL_TRAINEE )
				  		cell.labelExecucaoCircuito.text=@" Solicite a execução para seu treinador";
				  	else
						cell.labelExecucaoCircuito.text=@" Indique a execução do exercício";
			   }
				else
					if(exercise.instruction !=nil)
				  		cell.labelExecucaoCircuito.text = [@" " stringByAppendingString: exercise.instruction];
		  
			
//			if (!([userData.level integerValue] == USER_LEVEL_TRAINEE ) && (flagInternetStatus == TRUE))
//			  {
//				  // add friend button
//				  UIButton *addPencilButton = [UIButton buttonWithType:UIButtonTypeCustom];
//				  addPencilButton.frame = CGRectMake(0.0f, 26.0f, 239.0f, 21.0f);
////				  [addPencilButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
////				  [addPencilButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
////				  [addPencilButton setTitle:@"EditarCircuito" forState:UIControlStateNormal];
////
//
//				  addPencilButton.tag=indexPath.row*2;
//				  [cell.contentView addSubview:addPencilButton];
//				  [addPencilButton addTarget:self
//											 action:@selector(editExecucao:)
//								forControlEvents:UIControlEventTouchUpInside];
//
//			 }
//			 else
//			 {
				  for(UIView *subview in cell.contentView.subviews)
				  {
					 if([subview isKindOfClass: [UIButton class]])
					 {
						[subview removeFromSuperview];
					 }
				  }
		  
				 if(indexPath.section==0)
				 {
				//	  [[cell.contentView viewWithTag:indexPath.row] removefrom];
					 // add friend button
					 
					  BOOL iPhoneX = NO;
					  if (@available(iOS 11.0, *)) {
						  UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
						  if (mainWindow.safeAreaInsets.top > 0.0) {
								iPhoneX = YES;
						  }
					  }
					 
					 
				 	 // add friend button
					  UIButton *addPencilButton = [UIButton buttonWithType:UIButtonTypeCustom];
					 
					  addPencilButton.frame = CGRectMake(concluir_pos, 60.0f, 100.0f, 25.0f);
					 
					 
					//	[addPencilButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
					[addPencilButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
			 		[addPencilButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
					  [addPencilButton setTitleColor:UIColorFromRGB(STYLE_MAIN_COLOR) forState:UIControlStateNormal];
					  [addPencilButton setTitle:@"CONCLUIR" forState:UIControlStateNormal];
					  addPencilButton.tag=indexPath.row*2;
					  [cell.contentView addSubview:addPencilButton];
					  [addPencilButton addTarget:self
												 action:@selector(execucaoIsDone:)
									forControlEvents:UIControlEventTouchUpInside];
					 
					  UIButton *editAnotacaoButton = [UIButton buttonWithType:UIButtonTypeCustom];
					  editAnotacaoButton.frame = CGRectMake(11.0f, 62.0f, 205.0f, 21.0f);
			
					  editAnotacaoButton.tag=indexPath.row*2+1;
					  [cell.contentView addSubview:editAnotacaoButton];
					  [editAnotacaoButton addTarget:self
												 action:@selector(editAnotacao:)
									forControlEvents:UIControlEventTouchUpInside];
					 
				  }
				  else
				  {
			//	   [[cell.contentView viewWithTag:indexPath.row] removeFromSuperview];
						// add friend button
						
						
					   BOOL iPhoneX = NO;
					  if (@available(iOS 11.0, *)) {
						  UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
						  if (mainWindow.safeAreaInsets.top > 0.0) {
								iPhoneX = YES;
						  }
					  }
					 
					
					 
				 	 // add friend button
					  UIButton *addPencilButton = [UIButton buttonWithType:UIButtonTypeCustom];
					 
					  addPencilButton.frame = CGRectMake(concluir_pos, 60.0f, 100.0f, 25.0f);
					 
					  
					  [addPencilButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
					  [addPencilButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
					  [addPencilButton setTitleColor:UIColorFromRGB(STYLE_MAIN_COLOR) forState:UIControlStateNormal];
					  [addPencilButton setTitle:@"REFAZER" forState:UIControlStateNormal];
					  addPencilButton.tag=indexPath.row;
					  [cell.contentView addSubview:addPencilButton];
					  [addPencilButton addTarget:self
												 action:@selector(execucaoReDo:)
									forControlEvents:UIControlEventTouchUpInside];
					  addPencilButton.tag=indexPath.row;
				  }
//			 }

		  
	
		  
				return cell;
			}
	
	}



                                                                        ////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                        ////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                        ////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 if(tableView==self.tableViewExercicioLista)
	{
	  [tableView deselectRowAtIndexPath:indexPath animated:YES];
 	}
}

                                                                        ////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                        ////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                        ////////////////////////////////////////////////////////////////////////////////////////////////////

	- (void)viewDidLayoutSubviews
	{
	  [super viewDidLayoutSubviews];

	  if ([self.tableViewExercicioLista respondsToSelector:@selector(setSeparatorInset:)])
	  {
			[self.tableViewExercicioLista setSeparatorInset:UIEdgeInsetsZero];
	  }

	  if ([self.tableViewExercicioLista respondsToSelector:@selector(setLayoutMargins:)])
	  {
			[self.tableViewExercicioLista setLayoutMargins:UIEdgeInsetsZero];
	  }
	}


- (IBAction)execucaoIsDone:(id)sender
{
	UIButton *button = (UIButton *)sender;
//   NSLog(@"execucaoIsDone TAG = %ld e Modulo %ld", [button tag],((button.tag-button.tag%2)/2));
	
//	 BOOL flagInternetStatus = [IMManager sharedManager].hasConnection;
//	 User *userData = (User *) [coreDataService getDataFromUserTable];
	
	
	  Exercises *exercise = (Exercises *)[arrayExercises objectAtIndex:((button.tag-button.tag%2)/2)];

		exercise.isDone = [NSNumber numberWithBool:YES];
	
			[coreDataService saveData];
	
			// Remove a linha
		//	NSIndexPath * path = [tableView indexPathForCell:cell];
			[arrayExercises removeObjectAtIndex:((button.tag-button.tag%2)/2)];
	
			//[tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
	
			if ([arrayExercises count] == 0)
			{
				 [self historyDataEntry];
				 [self showDoneMessage];
			}
	
			[self loadExercicesToDo];
	
	
}


- (IBAction)execucaoReDo:(id)sender
{
	UIButton *button = (UIButton *)sender;
  //  NSLog(@"execucaoReDo TAG = %ld e Modulo %ld", [button tag],((button.tag-button.tag%2)/2));
	
	 User *userData = (User *) [coreDataService getDataFromUserTable];
	
	 if ([userData.level integerValue] == USER_LEVEL_TRAINEE && [arrayExercises count]>0)
	 {
		  Exercises *exercise = (Exercises *)[arrayExercisesDone objectAtIndex:[button tag]]; //((button.tag-button.tag%2)/2)];
	 
			exercise.isDone = [NSNumber numberWithBool:NO];
		 
				[coreDataService saveData];
		 
		 
		 
				[self loadExercicesToDo];
	 }
	
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
  {
      NSUInteger newLength = [textField.text length] + [string length] - range.length;
      BOOL flagInternetStatus = [IMManager sharedManager].hasConnection;
		if(flagInternetStatus == TRUE)
		{
			  User *userData = (User *) [coreDataService getDataFromUserTable];
			
		  int maxlenght=30;
		  if ([userData.level integerValue] == USER_LEVEL_TRAINEE)
				maxlenght=45;
      	if(newLength > maxlenght)
          	return NO;
      	else
      		return YES;
		}
		return NO;
  }


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)buttonRestartPressed:(id)sender
 {
	  NSError *error = nil;
	  NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Exercises"];
	  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"order" ascending:YES];
	  NSArray *sortDescriptors = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
	  [fetchRequest setSortDescriptors:sortDescriptors];
	  NSMutableArray *mutableFetchResults = [[coreDataService.getManagedContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
	  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"trainingID==%@ && isDone==%d && circuitID==%@",self.trainingID,YES,@"0"];
	  NSArray *filtered = [mutableFetchResults filteredArrayUsingPredicate:predicate];
	 
	  if ([filtered count] > 0)
	  {
			arrayExercises = [[NSMutableArray alloc] initWithArray:filtered];
			
			for (NSInteger i = 0; i < [filtered count]; i++)
			{
				 Exercises *exercise = [filtered objectAtIndex:i];
				
				 exercise.isDone = [NSNumber numberWithBool:NO];
				
				 [coreDataService saveData];
			}
			
			[self loadExercicesToDo];
	  }
//	  FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
//content.contentURL = [NSURL URLWithString:@"http://www.mobitrainer.com.br"];
//content.quote = @"Acabo de finalizar mais um treino usando o App Mobitrainer!";
//[FBSDKShareDialog showFromViewController:self
//                              withContent:content
//                                 delegate:nil];
	 
//			 FBSDKSharePhoto *sharePhoto = [[FBSDKSharePhoto alloc] init];
//			sharePhoto.caption = @"Test Caption";
//		sharePhoto.image = [UIImage imageNamed:@"BGI.jpg"];
//
//		FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
//		content.photos = @[sharePhoto];
//
//		[FBSDKShareAPI shareWithContent:content delegate:self];
	 
 }

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - CUSTOM METHODS

- (void)loadExercicesToDo
 {
	  NSError *error = nil;
	  NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Exercises"];
	  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
	  NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	  [fetchRequest setSortDescriptors:sortDescriptors];
	  NSMutableArray *mutableFetchResults = [[coreDataService.getManagedContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
	 
	 [self hideDoneMessage];
	  NSPredicate *predicate;
	 
	  predicate = [NSPredicate predicateWithFormat:@"trainingID==%@ && circuitID==%@ && isDone==%d",self.trainingID,@"0", NO];
	 
	 
	  NSArray *arrayFiltered = [mutableFetchResults filteredArrayUsingPredicate:predicate];
	 
	  [arrayExercises removeAllObjects];
	 
	  if ([arrayFiltered count] > 0)
	  {
			arrayExercises = [[NSMutableArray alloc] initWithArray:arrayFiltered];
			[self.tableViewExercicioLista reloadData];
	  }
	 
	  // Verifica se precisa mostrar a mensagem de todos os exercícios finalizados.
	  if ([arrayExercises count]  == 0)
	  {
		  
		  
			[self.tableViewExercicioLista reloadData];
			if ([arrayExercisesDone count]  > 0)
				 [self showDoneMessage];
	//		else
	//			 [self showNoDataMessage];
			
			if(IS_OS_9_OR_LATER)
			{
				 NSDictionary *userInfo = @{@"showAlert" : @TRUE};
				 [[WatchSessionManager sharedManager] transferUserInfo:userInfo];
			}
	  }
	  else
	  {
			[self.tableViewExercicioLista reloadData];
			
			[self hideDoneMessage];
			[self hideNoDataMessage];
	  }
	 
	  if(IS_OS_9_OR_LATER)
	  {
			[NSKeyedArchiver setClassName:@"ExerciseList" forClass: ExerciseList.self];
			
			NSMutableArray *arrayData = [[NSMutableArray alloc] init];
			NSMutableArray *arrayCircuitoData = [[NSMutableArray alloc] init];
			
			for (Exercises *e in arrayExercises)
			{
				 if(e.isCircuit.boolValue)
				 {
					  // Busca os dados no db.
					  NSError *error = nil;
					  NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Exercises"];
					  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
					  NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
					  [fetchRequest setSortDescriptors:sortDescriptors];
					  NSMutableArray *mutableFetchResults = [[coreDataService.getManagedContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
					  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"trainingID==%@ && circuitID==%@",e.trainingID, e.exerciseID];
					  NSArray *arrayFiltered = [mutableFetchResults filteredArrayUsingPredicate:predicate];
					 
					  if (arrayFiltered.count > 0)
					  {
							for (Exercises *ec in arrayFiltered)
							{
								 ExerciseList *elistC = [[ExerciseList alloc] init];
								 elistC.circuitID = ec.circuitID;
								 elistC.exerciseID = ec.exerciseID;
								 elistC.fullDescription = ec.fullDescription;
								 elistC.fullExecution = ec.fullExecution;
								 elistC.icon = ec.icon;
								 elistC.image1 = ec.image1;
								 elistC.image2 = ec.image2;
								 elistC.instruction = ec.instruction;
								 elistC.isCircuit = ec.isCircuit;
								 elistC.isDone = ec.isDone;
								 elistC.muscle = ec.muscle;
								 elistC.name = ec.name;
								 elistC.order = ec.order;
								 elistC.trainingID = ec.trainingID;
								 elistC.treineeID = ec.treineeID;
								 elistC.type = ec.type;
								 elistC.video = ec.video;
								
								 [arrayCircuitoData addObject:elistC];
							}
					  }
				 }
				
				 ExerciseList *elist = [[ExerciseList alloc] init];
				 elist.circuitID = e.circuitID;
				 elist.exerciseID = e.exerciseID;
				 elist.fullDescription = e.fullDescription;
				 elist.fullExecution = e.fullExecution;
				 elist.icon = e.icon;
				 elist.image1 = e.image1;
				 elist.image2 = e.image2;
				 elist.instruction = e.instruction;
				 elist.isCircuit = e.isCircuit;
				 elist.isDone = e.isDone;
				 elist.muscle = e.muscle;
				 elist.name = e.name;
				 elist.order = e.order;
				 elist.trainingID = e.trainingID;
				 elist.treineeID = e.treineeID;
				 elist.type = e.type;
				 elist.video = e.video;
				
				 [arrayData addObject:(ExerciseList *) elist];
			}
			
			NSData *pack = [NSKeyedArchiver archivedDataWithRootObject:arrayData];
			NSData *packC = [NSKeyedArchiver archivedDataWithRootObject:arrayCircuitoData];
			
			NSDictionary *contextData = @{@"data": pack, @"dataC":packC};
			
			[[WatchSessionManager sharedManager] updateApplicationContext:contextData error:&error];
			
			if (error != nil)
			{
				 NSLog(@"WSERROR: %@",error.debugDescription);
			}
	  }
	  [self loadExercicesDone];
 }

 - (void)loadExercicesDone
 {
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
			predicate = [NSPredicate predicateWithFormat:@"trainingID==%@ && isDone==%d && circuitID==%@ && isHistory==%d",self.trainingID,YES,@"0",isHistory];
	  }
	  else if([userData.level integerValue] == USER_LEVEL_TRAINEE && !self.isHistory)
	  {
			predicate = [NSPredicate predicateWithFormat:@"trainingID==%@ && isDone==%d && circuitID==%@",self.trainingID,YES,@"0"];
	  }
	  else
	  {
			predicate = [NSPredicate predicateWithFormat:@"trainingID==%@ && isDone==%d && circuitID==%@ && treineeID==%@ ",self.trainingID,YES,@"0",self.treineeID];
	  }
	 
	  NSArray *arrayFiltered = [mutableFetchResults filteredArrayUsingPredicate:predicate];
	 
	  [arrayExercisesDone removeAllObjects];
	 
	  if ([arrayFiltered count] > 0)
	  {
			arrayExercisesDone = [[NSMutableArray alloc] initWithArray:arrayFiltered];
			[self.tableViewExercicioLista reloadData];
	  }
	 
	 
	 if([userData.level integerValue] ==USER_LEVEL_TRAINEE)
	 	[self.tableViewExercicioLista reloadData];
	 
	 
}


				//                        [{"exe_id":"9a0a5b156d9314f97e1bbe12fb3ab114","exe_exec":"Exec%201%20sem%20char%20especial","exe_type":"E"},{"exe_id":"f023c4857b0a9d4789a77f05bb269bf6","exe_exec":"Execucao%20-%20Execu%E7%E3o","exe_type":"E"}]








				////////////////////////////////////////////////////////////////////////////////////////////////////
				////////////////////////////////////////////////////////////////////////////////////////////////////
				////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showDoneMessage
{
			//////////////////////////////////////////////////////////////////////
			/// CRIA A VIEW CONTAINER ////////////////////////////////////////////
			//////////////////////////////////////////////////////////////////////
			tableViewExercicioLista.allowsSelection=NO;
			viewDone = [[UIView alloc] initWithFrame:CGRectMake(((self.view.frame.size.width/2)-154.0f),
																((self.view.frame.size.height/2)-155.0f), 308.0f, 280.0f)];

			viewDone.backgroundColor = [UIColor colorWithWhite:1.0f alpha:1.0f];

			viewDone.tag = 101;

			//////////////////////////////////////////////////////////////////////
			/// CRIA A LOGO OK ///////////////////////////////////////////////////
			//////////////////////////////////////////////////////////////////////

			UIImageView *imgLogo  = [[UIImageView alloc] initWithFrame:CGRectMake(((viewDone.frame.size.width / 2) - 25.0f),
																						30.0f, 50.0f, 50.0f)];
			imgLogo.image = [UIImage imageNamed:@"Logo_OK"];


			#ifdef OLD_STYLE
			imgLogo.tintColor = UIColorFromRGB(0x459A76);
			#endif
			#ifdef NEW_STYLE
			imgLogo.tintColor = UIColorFromRGB(STYLE_MAIN_COLOR);
			#endif

			[UIView animateWithDuration:1.0f
						delay:0.0f
					 options:UIViewAnimationOptionCurveEaseInOut
				 animations:^{
					  // your animation code here
					  [imgLogo setFrame: CGRectMake(imgLogo.frame.origin.x - 7, imgLogo.frame.origin.y - 7,
															  imgLogo.frame.size.width + 14, imgLogo.frame.size.height + 14)];
				 }
				 completion:^(BOOL finished) {
					 
					 
				 }];

			//////////////////////////////////////////////////////////////////////
			/// CRIA A LABEL TITULO //////////////////////////////////////////////
			//////////////////////////////////////////////////////////////////////

			UILabel *lblTitulo = [[UILabel alloc]initWithFrame:CGRectMake(((viewDone.frame.size.width / 2) - 140.0f), 90.0f, 280.0f, 40.0f)];

			// Configura o label.
			lblTitulo.numberOfLines = 0;
			lblTitulo.textAlignment = NSTextAlignmentCenter;
			lblTitulo.backgroundColor = [UIColor clearColor];
			lblTitulo.textColor = UIColorFromRGB(0x545454);
			lblTitulo.font = [UIFont boldSystemFontOfSize:28.0f];

			// Mensagem do label.
			lblTitulo.text = @"Bom Trabalho!";

			//////////////////////////////////////////////////////////////////////
			/// CRIA A LABEL MENSAGEM ////////////////////////////////////////////
			//////////////////////////////////////////////////////////////////////

			lblMessage = [[UILabel alloc]initWithFrame:CGRectMake(((viewDone.frame.size.width / 2) - 150.0f), 124.0f, 300.0f, 80.0f)];

			// Configura o label.
			lblMessage.numberOfLines = 0;
			lblMessage.textAlignment = NSTextAlignmentCenter;
			lblMessage.backgroundColor = [UIColor clearColor];
			lblMessage.textColor = UIColorFromRGB(0x545454);
			lblMessage.font = [UIFont systemFontOfSize:16.0f];

			// Mensagem do label.
			lblMessage.text = @"Todos os exercícios desta série \nforam concluídos!";

			//////////////////////////////////////////////////////////////////////
			/// CRIA O BOTAO REINICIAR ///////////////////////////////////////////
			//////////////////////////////////////////////////////////////////////

			UIButton *btnReiniciar = [[UIButton alloc] initWithFrame:CGRectMake(((viewDone.frame.size.width / 2) - 70.0f),
																					 215.0f, 140.0f, 35.0f)];

			[btnReiniciar setBackgroundImage:[UIImage imageNamed:@"Btn_Reiniciar"]
						  forState:UIControlStateNormal];



			[btnReiniciar addTarget:self
				 action:@selector(buttonRestartPressed:)
			forControlEvents:UIControlEventTouchUpInside];

			[btnReiniciar setTitle:@"Reiniciar"
			 forState:UIControlStateNormal];

			btnReiniciar.titleLabel.font = [UIFont systemFontOfSize:17.0f];


			#ifdef OLD_STYLE
			btnReiniciar.tintColor = UIColorFromRGB(0x459A76);
			#endif
			#ifdef NEW_STYLE
			btnReiniciar.tintColor = UIColorFromRGB(STYLE_MAIN_COLOR);
			#endif

			btnReiniciar.alpha = 0;
			[UIView animateWithDuration:0.7f
						delay:0.1f
					 options:UIViewAnimationOptionCurveEaseInOut
				 animations:^{
					  // your animation code here
					  btnReiniciar.alpha = 1;
				 }
				 completion:^(BOOL finished) {
					 
					 
				 }];

			//////////////////////////////////////////////////////////////////////
			/// ADICIONA AS SUBVIEWS /////////////////////////////////////////////
			//////////////////////////////////////////////////////////////////////

				[viewDone addSubview:imgLogo];
				[viewDone addSubview:lblTitulo];
				[viewDone addSubview:lblMessage];
				[viewDone addSubview:btnReiniciar];

				viewDone.alpha = 0;

				[UIView beginAnimations:nil context:NULL];
				[UIView setAnimationDuration:0.3f];
				[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];

				viewDone.alpha = 1;
				[self.view addSubview:viewDone];

				[UIView commitAnimations];
}

				////////////////////////////////////////////////////////////////////////////////////////////////////
				////////////////////////////////////////////////////////////////////////////////////////////////////
				////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)hideDoneMessage
{
		tableViewExercicioLista.allowsSelection=YES;
		viewDone.alpha = 1;

		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3f];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];

		viewDone.alpha = 0;

		UIView *v = [self.view viewWithTag:101];
		[v removeFromSuperview];

		[UIView commitAnimations];
}

				////////////////////////////////////////////////////////////////////////////////////////////////////
				////////////////////////////////////////////////////////////////////////////////////////////////////
				////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)showNoDataMessage
{
		lblMessage = [[UILabel alloc]initWithFrame:CGRectMake(((self.view.frame.size.width/2)-140),
																  ((self.view.frame.size.height/2)-40-17.5), 280, 80)];

		// Configura o label.
		lblMessage.numberOfLines = 0;
		lblMessage.textAlignment = NSTextAlignmentCenter;
		lblMessage.backgroundColor = [UIColor clearColor];
		lblMessage.textColor = UIColorFromRGB(0x333333);
		lblMessage.shadowColor = [UIColor colorWithWhite:0.9 alpha:0.5];
		lblMessage.shadowOffset = CGSizeMake(1,1);
		lblMessage.font = [UIFont systemFontOfSize:15];

		// Mensagem do label.
		lblMessage.text = @"Esta série está sem exercícios!";
		lblMessage.tag =17;
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
		UIView *viewToRemove = [self.view viewWithTag:17];
		[viewToRemove removeFromSuperview];

		[UIView commitAnimations];
}

				////////////////////////////////////////////////////////////////////////////////////////////////////
				////////////////////////////////////////////////////////////////////////////////////////////////////
				////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)historyDataEntry
{
				//Adiciona o treino na tabela histórico
				History *historyEntry = (History *)[NSEntityDescription insertNewObjectForEntityForName:@"History"
																					 inManagedObjectContext:coreDataService.getManagedContext];
				historyEntry.trainingID = self.trainingID;
				historyEntry.trainingName = self.trainingName;
				historyEntry.isSync = [NSNumber numberWithBool:NO];
				historyEntry.isClass = [NSNumber numberWithBool:NO];

				NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];

				//RFR: Alterado para sempre mandar o horário local descontados o GMT
				//RFR: NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
				//RFR: [dateFormat setTimeZone:gmt];
				[dateFormat setTimeZone:[NSTimeZone localTimeZone]];
				[dateFormat setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
				historyEntry.endDate = [dateFormat stringFromDate:[NSDate date]];

				[coreDataService saveData];

//				dispatch_async(dispatch_get_main_queue(), ^{
//
//				UIAlertController *alertController = [UIAlertController
//													  alertControllerWithTitle:@"IMPORTANTE:"
//													  message:@"Novos dados estão disponíveis para seu aplicativo. Vamos atualizar sincronizar agora?"
//													  preferredStyle:UIAlertControllerStyleAlert];
//				#ifdef NEW_STYLE
//				alertController.view.tintColor=UIColorFromRGB(kPRIMARY_COLOR);
//				#endif
//				UIAlertAction *actionYES = [UIAlertAction actionWithTitle:@"Sim"
//																		 style:UIAlertActionStyleDefault
//																	  handler:^(UIAlertAction * action){
//
		BOOL flagInternetStatus = [IMManager sharedManager].hasConnection;
	   // Pega o status do usuário, logado ou não.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL login = [defaults boolForKey:@"userStatus"];
	
	
		// Verifica se tem conexão com a Internet.
		if (login == TRUE && flagInternetStatus)
		{
			 // Sincroniza o treino com o servidor.
			 [self syncTraining];
		}
		else
		{
			 [utils showAlertWithTitle:kTEXT_ALERT_TITLE
									 AndText:@"Você deve fazer o login e a Internet disponível para registrar seu treino. O registro será feito localmente!"
								AndTargetVC:self];
		}
	
//		[alertController dismissViewControllerAnimated:YES completion:nil];
//
//  }];
//
//				UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Mais Tarde"
//																				 style:UIAlertActionStyleDefault
//																			  handler:^(UIAlertAction * action){
//
//																					[alertController dismissViewControllerAnimated:YES completion:nil];
//
//																			  }];
//
//				[alertController addAction:actionCancel];
//				[alertController addAction:actionYES];
//
//				[self presentViewController:alertController animated:YES completion:nil];
//				});
}

				////////////////////////////////////////////////////////////////////////////////////////////////////
				////////////////////////////////////////////////////////////////////////////////////////////////////
				////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)syncTraining
 {
	  // Mostra o HUD...
	  [SVProgressHUD showWithStatus:@"Sincronizando dados..."  maskType: SVProgressHUDMaskTypeGradient];
	 
	  User *userData = (User *) [coreDataService getDataFromUserTable];
	 
	  NSArray *arrayFiltered = [coreDataService getDataFromHistoryTableWithIsSync:NO IsClass:NO];
	 
	  if ([arrayFiltered count] > 0)
	  {
			for (NSInteger i = 0; i < [arrayFiltered count]; i++)
			{
				 History *historyEntry = [arrayFiltered objectAtIndex:i];
				
				 ///////////////////////////////////////////////////////////////////////
				 /// INICIA A VALIDAÇÃO DO LOGIN ///////////////////////////////////////
				 ///////////////////////////////////////////////////////////////////////
				
				 // Cria um operation manager para realizar a solicitação via POST.
//				 AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//				 [manager.requestSerializer setTimeoutInterval:AFHHTTP_TIMEOUT];
				 // Parametros validados.
				 NSDictionary *parameters = @{
														@"apikey":   userData.apiKey,
														@"serie":    historyEntry.trainingID,
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
							
							[SVProgressHUD showSuccessWithStatus:@"Dados sincronizados \ncom sucesso!"  maskType:SVProgressHUDMaskTypeGradient];
					  }
					  else
					  {
							[utils showAlertWithTitle:kTEXT_ALERT_TITLE
													AndText:[responseObject objectForKey:@"message"]
											  AndTargetVC:self];
					  }
					 
				 } failure:^(NSURLSessionTask *operation, NSError *error)
				{
					  NSLog(@"Error: %@", error);
					 
					  [utils showAlertWithTitle:kTEXT_ALERT_TITLE
											  AndText:kTEXT_SERVER_ERROR_DEFAULT
										 AndTargetVC:self];
				 }];
			}
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
	 //      [manager.requestSerializer setTimeoutInterval:AFHHTTP_TIMEOUT];
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

//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////

- (IBAction)editAnotacao:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:kTEXT_ALERT_TITLE
                                                                             message:@"Anotações do aluno."
                                                                      preferredStyle:UIAlertControllerStyleAlert];
#ifdef NEW_STYLE
    alertController.view.tintColor=[UIColor colorNamed:@"myCellTextColor"];
#endif
	UIButton *button = (UIButton *)sender;
	NSLog(@"editAnotacao TAG = %ld e Modulo %ld", (long)[button tag],((button.tag-button.tag%2)/2));
		Exercises *exercise;
			exercise = (Exercises *)[arrayExercises objectAtIndex:((button.tag-button.tag%2)/2)];
	
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = @"Adicione sua carga, distância, tempo...";
         [textField setKeyboardType:UIKeyboardTypeDefault];
         textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
         textField.clearButtonMode = UITextFieldViewModeWhileEditing;
		  
         // PEGA OS DADOS DO USUARIO
         User *userData = (User *) [coreDataService getDataFromUserTable];
		  
         Notes *note = (Notes *) [coreDataService getDataFromNotesTableByUserID:userData.userID
                                                                     TrainingID:trainingID
                                                                     ExerciseID:exercise.exerciseID];
         if (note != nil)
         {
             textField.text = note.textNote;
         }
     }];
	
    UIAlertAction *actionYES = [UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action){
																			
                                                          // PEGA OS DADOS DO USUARIO
                                                          User *userData = (User *) [coreDataService getDataFromUserTable];
																			
                                                          UITextField *textField = alertController.textFields.firstObject;
                                                       //   textFieldNota.text = textField.text;
																			
                                                          [coreDataService setNoteWithUserID:userData.userID
                                                                                  TrainingID:trainingID
                                                                                  ExerciseID:exercise.exerciseID
                                                                                        Note:textField.text];
																			 [tableViewExercicioLista reloadData];
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


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)exerciseDone:(NSIndexPath *)indexPath
{
  [arrayExercises removeObjectAtIndex:indexPath.row];
	
  [self.tableViewExercicioLista deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
	
  [self loadExercicesToDo];
	
  if ([arrayExercises count] == 0)
  {
		[self historyDataEntry];
		[self showDoneMessage];
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)circuitDone:(NSIndexPath *)indexPath
 {
	  [arrayExercises removeObjectAtIndex:indexPath.row];
	 
	  [self.tableViewExercicioLista deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
	 
	  [self loadExercicesToDo];
	 
	  if ([arrayExercises count] == 0)
	  {
			[self historyDataEntry];
			[self showDoneMessage];
	  }
 }

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - NOTIFICATION METHODS

- (void)appNeedUpdateExerciseListHandler:(NSNotification *)notification
 {
	  NSDictionary *data = (NSDictionary *)[notification object];
	 
	  NSString *trID = [data objectForKey:@"trainingID"];
	  NSString *exID = [data objectForKey:@"exerciseID"];
	 
	  if (trID.length > 0 && exID.length > 0)
	  {
			// Remove o HUD.
			double delayInSeconds = 0.1;
			dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
			dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
				
				 NSArray *array = [coreDataService getDataFromExercisesTableWithExerciseID:exID AndTrainingID:trID];
				
				 if (array.count > 0)
				 {
					  for (Exercises *e in array)
					  {
							e.isDone = [NSNumber numberWithBool:YES];
						  
							[coreDataService saveData];
						  
							NSInteger row = [arrayExercises indexOfObject:e];
						  
							[arrayExercises removeObjectAtIndex:row];
					  }
					 
					  [self loadExercicesToDo];
				 }
				
			});
	  }
 }



- (IBAction)buttonBarExercisePressed:(id)sender
{
  // PEGA OS DADOS DO USUARIO
  User *userData = (User *) [coreDataService getDataFromUserTable];
  if ([userData.level integerValue] == USER_LEVEL_TRAINER || [userData.level integerValue] == USER_LEVEL_MASTERTRAINER || [userData.level integerValue] == USER_LEVEL_ADMINISTRATOR || self.isHistory)
  {
      //[self performSegueWithIdentifier:@"segueListaCompletaExercicios" sender:self];
  }
  else
      [self performSegueWithIdentifier:@"segueExercicioConcluidos" sender:self];
	
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
        btnIniciar.alpha = 0.5f;
        [descansoTimer invalidate];
		 
	//	 [iniciarBtnText setTitleColor:UIColorFromRGB(STYLE_MAIN_COLOR) forState:UIControlStateNormal ];
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
        btnIniciar.alpha = 0.5f;
        [descansoTimer invalidate];
		 
	//	 [iniciarBtnText setTitleColor:UIColorFromRGB(STYLE_MAIN_COLOR) forState:UIControlStateNormal ];
	    [iniciarBtnText setTitle:@"Iniciar" forState:UIControlStateNormal ];
        flagInUse = FALSE;
//				 AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//		NSError *error = nil;
//		NSLog(@"Deactivating audio session");
//		BOOL result = [audioSession setActive:NO error:&error];
//		if (!result) {
//			 NSLog(@"Error deactivating audio session: %@", error);
//		}
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





- (IBAction)btnVoltar:(id)sender {

		[self dismissViewControllerAnimated:YES completion:nil];
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

@end
