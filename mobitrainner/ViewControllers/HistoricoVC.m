//
//  HistoricoViewController.m
//  treino
//
//  Created by Reginaldo Lopes on 27/11/14.
//  Copyright (c) 2014 4mobi. All rights reserved.
//

#import "HistoricoVC.h"

@interface HistoricoVC()

@end

@implementation HistoricoVC

@synthesize tableView;
@synthesize calendar;
@synthesize dateFormatter;
@synthesize minimumDate;
@synthesize disabledDates;
@synthesize treineeID;
@synthesize flagByID;

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - VIEW LIFECYCLE

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.delegate = self;
    
    arrayDates = [[NSMutableArray alloc] init];
    arrayHistory = [[NSMutableArray alloc] init];
    arrayFiltered = [[NSMutableArray alloc] init];

//    // Configura o background da tableview.
//    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    [backgroundView setBackgroundColor:UIColorFromRGB(0xDFDFDF)];
//    [self.tableView setBackgroundView:backgroundView];
 
    // Tweak para linhas extra na tabela.
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    coreDataService = [[CoreDataService alloc] init];
    [coreDataService initialize];
	
   // Inicializa o objeto utils.
    utils = [[UtilityClass alloc] init];
	
    // Configura o formatter da data.
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    self.minimumDate = [self.dateFormatter dateFromString:@"01/01/2012"];
	
    // VERIFICA SE TEM CONEXÃO COM A INTERNET.
    BOOL flagInternetStatus = [IMManager sharedManager].hasConnection;
	// PEGA OS DADOS DO USUARIO
    User *userData = (User *) [coreDataService getDataFromUserTable];
	 if ([userData.level integerValue] != USER_LEVEL_TRAINEE)
	 {
	 	if(flagInternetStatus)
			[self updateTreineeHistory:treineeID];
	 }
	 else
	 {
		[self loadCalendar];
	 }
}

-(void) loadCalendar
{
	
    if (flagByID)
    {
        NSArray *arraytemp = (NSArray *) [coreDataService getDataFromHistoryTableWithUserID:treineeID];
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"endDate" ascending:YES];
        NSArray *descriptors = [NSArray arrayWithObject: descriptor];
        NSArray *array = [arraytemp sortedArrayUsingDescriptors:descriptors];
        
        if ([array count] > 0)
        {
            for(NSInteger i = 0; i < [array count]; i++)
            {
                History *historyEntry = (History *)[array objectAtIndex:i];
                NSDate *date = [self.dateFormatter dateFromString:historyEntry.endDate];
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"dd/MM/yyyy"];
                NSString *stringDate = [df stringFromDate:date];
                NSDate *dateM = [df dateFromString:stringDate];
                [arrayDates addObject:dateM];
                [arrayHistory addObject:historyEntry];
            }
        }
    }
    else
    {
        NSArray *arraytemp = (NSArray *) [coreDataService getDataFromHistoryTable];
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"endDate" ascending:YES];
        NSArray *descriptors = [NSArray arrayWithObject: descriptor];
        NSArray *array = [arraytemp sortedArrayUsingDescriptors:descriptors];
        
        if ([array count] > 0)
        {
            for(NSInteger i = 0; i < [array count]; i++)
            {
                History *historyEntry = (History *)[array objectAtIndex:i];
                NSDate *date = [self.dateFormatter dateFromString:historyEntry.endDate];
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat: @"dd/MM/yyyy"];
                NSString *stringDate = [df stringFromDate:date];
                NSDate *dateM = [df dateFromString:stringDate];
                [arrayDates addObject:dateM];
                [arrayHistory addObject:historyEntry];
            }
        }
    }
	
   // [self dowloadImageWithPersonalTreinee];

    // Inicializa o calendário.
    calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
    
    [calendar setLocale:[NSLocale currentLocale]];
    
    // Configura o delegate.
    calendar.delegate = self;
    
    NSLog(@"%@",[calendar locale].debugDescription);
    
    // Cor dos textos do dia da semana.
    calendar.dayOfWeekTextColor = UIColorFromRGB(0x545454);
    
    // Cor do background dos Dias da semana. Normal é degradê.
    [calendar setDayOfWeekBottomColor:[UIColor lightGrayColor]
                             topColor:[UIColor lightGrayColor]];
    
    // Configura background para tranparente. Mostra a view do fundo.
    calendar.backgroundColor =  [UIColor whiteColor];
    
    // Mostra o mês seguinte.
    calendar.onlyShowCurrentMonth = NO;
    
    // Calendario com tamanho fixo.
    calendar.adaptHeightToNumberOfWeeksInMonth = NO;
    
    // Ajusta o Frame do calendário.
    BOOL iPhoneX = NO;
		 if (@available(iOS 11.0, *)) {
			  UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
			  if (mainWindow.safeAreaInsets.top > 0.0) {
					iPhoneX = YES;
			  }
		 }
	if(iPhoneX)
    calendar.frame = CGRectMake(0, -1, 375, 375);
   else
		calendar.frame = CGRectMake(0, -1, 320, 320);
	
	calendar.titleColor=UIColorFromRGB(STYLE_MAIN_COLOR);
    calendar.tintColor =UIColorFromRGB(0x545454);
   
    // Adiciona o calendario na view.
    [self.view addSubview:calendar];
    
    // Configura o observador para mudança de locale.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(localeDidChange:)
                                                 name:NSCurrentLocaleDidChangeNotification
                                               object:nil];

    // Força a seleção da data do dia...
    NSDate *now = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd/MM/yyyy"];
    NSString *stringDate = [df stringFromDate:now];
    NSDate *dateM = [df dateFromString:stringDate];
    [calendar setTintColor :UIColorFromRGB(STYLE_MAIN_COLOR) ];
    selected = [self.dateFormatter stringFromDate:dateM];
    [self.tableView reloadData];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
/*
    if (IS_IPHONE5)
    {
        CGRect frame = self.tableView.frame;
        
        frame.origin.x = 0.0f;
        frame.origin.y = 335.0f;
        frame.size.width = 320.0f;
        frame.size.height = 170.0f;
        
        self.tableView.frame = frame;
    }
    else
    {
    	  BOOL iPhoneX = NO;
		 if (@available(iOS 11.0, *)) {
			  UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
			  if (mainWindow.safeAreaInsets.top > 0.0) {
					iPhoneX = YES;
			  }
		 }
	
	    CGRect frame = self.tableView.frame;
		 if(iPhoneX)
		 {
         frame.origin.x = 0.0f;
         frame.origin.y = 380.0f;
         frame.size.width = 375.0f;
         frame.size.height = 280.0f;
        }
        else
        {
			 frame.origin.x = 0.0f;
          frame.origin.y = 335.0f;
          frame.size.width = 320.0f;
          frame.size.height = 81.0f;
        }
        self.tableView.frame = frame;
    }
    */
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSCurrentLocaleDidChangeNotification
                                                  object:nil];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - CKCALENDAR DELEGATE

- (void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd/MM/yyyy"];
    NSString *stringDate = [df stringFromDate:date];
    NSDate *dateM = [df dateFromString:stringDate];

    // If the date has been chosen by the user, go ahead and style it differently
    if ([arrayDates containsObject:dateM])
    {
        NSDate *todayTemp = [NSDate date];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat: @"dd/MM/yyyy"];
        NSString *stringDate = [df stringFromDate:todayTemp];
        NSDate *today = [df dateFromString:stringDate];
        
        if ([today compare:dateM] != NSOrderedSame)
        {
            dateItem.backgroundColor = UIColorFromRGB(STYLE_MAIN_COLOR);
            dateItem.textColor = [UIColor whiteColor];
        }
      
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date
{
    flagSelect = TRUE;
    return ![self dateIsDisabled:date];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)calendar:(CKCalendarView *)calendar willDeselectDate:(NSDate *)date
{
    flagSelect = FALSE;
    return YES;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat: @"dd/MM/yyyy"];
    NSString *stringDate = [df stringFromDate:date];
    NSDate *dateM = [df dateFromString:stringDate];
    
    selected = [self.dateFormatter stringFromDate:dateM];
    [self.tableView reloadData];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)calendar:(CKCalendarView *)calendar willChangeToMonth:(NSDate *)date
{
    if ([date laterDate:self.minimumDate] == date)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)dateIsDisabled:(NSDate *)date
{
    for (NSDate *disabledDate in self.disabledDates)
    {
        if ([disabledDate isEqualToDate:date])
        {
            return YES;
        }
    }
    
    return NO;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([arrayHistory count] > 0)
    {
        [arrayFiltered removeAllObjects];
        
        for (NSInteger i = 0; i < [arrayHistory count]; i++)
        {
            History *historyEntry = [arrayHistory objectAtIndex:i];

            NSDate *date = [self.dateFormatter dateFromString:historyEntry.endDate];
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat: @"dd/MM/yyyy"];
            NSString *stringDate = [df stringFromDate:date];
            NSDate *dateM = [df dateFromString:stringDate];
            
            NSString *compareDate = [self.dateFormatter stringFromDate:dateM];
            
            if ([compareDate isEqualToString:selected])
            {
                [arrayFiltered addObject:historyEntry];
            }
        }
        
        if ([arrayFiltered count] == 0)
        {
            [lblMessage removeFromSuperview];
            
            lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(self.tableView.frame.size.width / 2-150,
                                                                   self.tableView.frame.size.height / 2-20, 300.0f, 40.0f)];
            
            // Configura o label.
            lblMessage.numberOfLines = 0;
            lblMessage.textAlignment = NSTextAlignmentCenter;
            lblMessage.backgroundColor = [UIColor clearColor];
            lblMessage.textColor = UIColorFromRGB(STYLE_MAIN_COLOR);
            lblMessage.shadowColor = [UIColor colorWithWhite:0.9 alpha:0.5];
            lblMessage.shadowOffset = CGSizeMake(1,1);
            lblMessage.font = [UIFont systemFontOfSize:16];
            lblMessage.alpha = 0;
            
            if (flagSelect == 0)
            {
                lblMessage.text = @"Não existem registros de atividades para você nesta data.";
            }
            else
            {
               lblMessage.text = @"Não existem registros de atividades para você nesta data.";
            }
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.3f];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            
                lblMessage.alpha = 1;
                [self.tableView addSubview:lblMessage];
            
            [UIView commitAnimations];
        }
        else
        {
            lblMessage.alpha = 1;
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.3f];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            
                lblMessage.alpha = 0;
                [lblMessage removeFromSuperview];
            
            [UIView commitAnimations];
        }
        
        return [arrayFiltered count];
    }
    else
    {
        [lblMessage removeFromSuperview];
        lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(self.tableView.frame.size.width/2-150,
                                                               self.tableView.frame.size.height/2-20, 300.0f, 40.0f)];
        
        // Configura o label.
        lblMessage.numberOfLines = 0;
        lblMessage.textAlignment = NSTextAlignmentCenter;
        lblMessage.backgroundColor = [UIColor clearColor];
        lblMessage.textColor = UIColorFromRGB(STYLE_MAIN_COLOR);
        lblMessage.shadowColor = [UIColor colorWithWhite:0.9 alpha:0.5];
        lblMessage.shadowOffset = CGSizeMake(1,1);
        lblMessage.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        lblMessage.text = @"Nenhuma atividade \n registrada nesta data!";
        lblMessage.alpha = 0;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        
            lblMessage.alpha = 1;
            [self.tableView addSubview:lblMessage];
        
        [UIView commitAnimations];
        
        return 0;
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    //cell.contentView.backgroundColor = UIColorFromRGB(0xFFFFFF);
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    HistoricoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[HistoricoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    History *historyEntry = (History *)[arrayFiltered objectAtIndex:indexPath.row];

    if ([arrayFiltered count] > 0)
    {
        cell.labelNomeSerie.text = historyEntry.trainingName;
        
      //RFR  cell.labelType.layer.cornerRadius = cell.labelType.frame.size.height / 2;
      //  cell.labelType.clipsToBounds = YES;
      //  cell.labelType.backgroundColor = UIColorFromRGB(0x333333);
        
        if([historyEntry.isClass boolValue])
        {
            cell.labelType.text = @"Aula";
        }
        else
        {
            cell.labelType.text = @"Treino";
        }
        
        // Separa a data em dia da semana, dia e mes.
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setLocale:[NSLocale currentLocale]];
        [dateFormat setTimeZone:[NSTimeZone localTimeZone]];
        [dateFormat setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
 
        NSDate *timestamp = [dateFormat dateFromString:historyEntry.endDate];
        
        // Dia da Semana
        NSDateFormatter *weekday = [[NSDateFormatter alloc] init];
        [weekday setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"pt"]];
        [weekday setDateFormat: @"EE"];
        
        // Dia
        NSDateFormatter *day = [[NSDateFormatter alloc] init];
        [day setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"pt"]];
        [day setDateFormat: @"dd"];
        
        // Mês
        NSDateFormatter *month = [[NSDateFormatter alloc] init];
        [month setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"pt"]];
        [month setDateFormat: @"MMM"];
        
        // Hora
        NSDateFormatter *hourFull = [[NSDateFormatter alloc] init];
        [hourFull setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"pt"]];
        [hourFull setDateFormat: @"HH:mm"];
        
        // Forma a string com as partes separadas.
        NSMutableString *strFormattedgDate = [[NSMutableString alloc] init];
  //      [strFormattedgDate appendString:@"Concluído - "];
        [strFormattedgDate appendString:[[weekday stringFromDate:timestamp] capitalizedString]];
        [strFormattedgDate appendString:@" "];
        [strFormattedgDate appendString:[[day stringFromDate:timestamp] capitalizedString]];
        [strFormattedgDate appendString:@"/"];
        [strFormattedgDate appendString:[[month stringFromDate:timestamp] capitalizedString]];
        [strFormattedgDate appendString:@" às "];
        
        NSString *hour = [[hourFull stringFromDate:timestamp] stringByReplacingOccurrencesOfString:@":" withString:@"h"];
        [strFormattedgDate appendString:hour];
        
        cell.labelData.text = strFormattedgDate;
    /* NEW LAYOUT
        if (flagByID)
        {
            UIImageView *check =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CheckBlue"]];
            cell.accessoryView = check;
        }
        else
        {
            if ([historyEntry.isSync boolValue])
            {
                UIImageView *check =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CheckBlue"]];
                cell.accessoryView = check;
            }
            else
            {
                UIImageView *check =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CheckGray"]];
                cell.accessoryView = check;
            }
        }
 
        cell.accessoryType = UITableViewCellAccessoryCheckmark; */
    }

    return cell;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - ACTIONS

- (IBAction)todayDateClicked:(id)sender
{
    [calendar selectDate:[NSDate date] makeVisible:YES];
    [calendar reloadData];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - NOTIFICATION METHODS

- (void)localeDidChange:(NSNotification *)notification
{
    [self.calendar setLocale:[NSLocale currentLocale]];
}

- (void)dowloadImageWithPersonalTreinee
{
    // VERIFICA SE TEM CONEXÃO COM A INTERNET.
    BOOL flagInternetStatus = [IMManager sharedManager].hasConnection;
	 PersonalTreinees *pTreinee = (PersonalTreinees *) [coreDataService getDataFromPersonalTreineesTableByTreineeID:treineeID];
	
    if(pTreinee.image.length > 0 && flagInternetStatus == TRUE)
    {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
		 
        NSURL *URL = [NSURL URLWithString:pTreinee.image];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
		 
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
			  
            NSString *imagesCachePath = [[utils returnDocumentsPath] stringByAppendingPathComponent:@"/Caches/ProfileImages/"];
            NSURL *path = [NSURL fileURLWithPath:imagesCachePath];
			  
            NSMutableString *filename = [[NSMutableString alloc] init];
            [filename appendString:[utils md5HexDigest:pTreinee.treineeID]];
            [filename appendString:@".png"];
			  
            return [path URLByAppendingPathComponent:filename];
			  
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
			  
            NSLog(@"DOWNLOAD END");
			  
			  
			  
        }];
		 
        [downloadTask resume];
    }
}

- (void)updateTreineeHistory:(NSString *)treineeID
{
	
	
    // PEGA OS DADOS DO USUARIO
    User *userData = (User *) [coreDataService getDataFromUserTable];
	 [coreDataService deleteHistoryDatabyTrainee:treineeID];
	
        // Monta a string de acesso a validação do login.
        NSMutableString *urlString = [[NSMutableString alloc] init];
        [urlString appendString:kBASE_URL_MOBITRAINER];
        [urlString appendString:@"api/history/by_user_id"];
		 
        // Inicializa o manager.
    //    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	//	  [manager.requestSerializer setTimeoutInterval:AFHHTTP_TIMEOUT];
        NSDictionary *parameters = @{@"apikey":userData.apiKey, @"user_id":treineeID};
		 
     //   [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		 AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
			[manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
			NSString *path=[[NSString alloc]initWithFormat:@"%@",urlString];
			[manager POST:[NSURL URLWithString:path].absoluteString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
   	  {
            if (![[responseObject objectForKey:@"response_error"] boolValue])
            {
                NSArray *arrayDataHistory = [responseObject objectForKey:@"history"];
					
                if ([arrayDataHistory count] != 0)
                {
						 
                    for (NSInteger i = 0; i < [arrayDataHistory count]; i++)
                    {
                        History *historyEntry = (History *) [NSEntityDescription insertNewObjectForEntityForName:@"History"
                                                                                          inManagedObjectContext:coreDataService.getManagedContext];
							  
                        historyEntry.endDate = [utils checkString:[[arrayDataHistory objectAtIndex:i]objectForKey:@"response_history_datetime"]];
                        historyEntry.trainingID = [utils checkString:[[arrayDataHistory objectAtIndex:i]objectForKey:@"response_history_serie_id"]];
                        historyEntry.trainingName = [utils checkString:[[arrayDataHistory objectAtIndex:i]objectForKey:@"response_history_serie_name"]];
                        historyEntry.treineeID = treineeID;
							  
                    }
						 
                    [coreDataService saveData];
						 
                    dispatch_async(dispatch_get_main_queue(), ^{
							  
                        [SVProgressHUD dismiss];
                    });
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
							  
                        [SVProgressHUD dismiss];
                    });
                }
                [self loadCalendar];
            }
			  
        } failure:^(NSURLSessionTask *operation, NSError *error){
			  
            dispatch_async(dispatch_get_main_queue(), ^{
					
                [SVProgressHUD dismiss];
            });
			  
            NSLog(@"Error: %@", error);
			  
        }];
	
}




@end

////////////////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////



#if 0
//
//  HistoricoViewController.m
//  treino
//
//  Created by ReginalNSDateFormatter *dateFormatterdo Lopes on 27/11/14.
//  Copyright (c) 2014 4mobi. All rights reserved.
//

#import "HistoricoVC.h"

@interface HistoricoVC()

@end

@implementation HistoricoVC

@synthesize tableView;
@synthesize calendar;
//@synthesize dateFormatter;
@synthesize minimumDate;
@synthesize disabledDates;
@synthesize treineeID;
@synthesize flagByID;

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - VIEW LIFECYCLE

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.delegate = self;
    
    arrayDates = [[NSMutableArray alloc] init];
    arrayHistory = [[NSMutableArray alloc] init];
    arrayFiltered = [[NSMutableArray alloc] init];

//    // Configura o background da tableview.
//    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    [backgroundView setBackgroundColor:UIColorFromRGB(0xDFDFDF)];
//    [self.tableView setBackgroundView:backgroundView];
 
    // Tweak para linhas extra na tabela.
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    coreDataService = [[CoreDataService alloc] init];
    [coreDataService initialize];
	
   // Inicializa o objeto utils.
    utils = [[UtilityClass alloc] init];
	
    // Configura o formatter da data.
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    self.minimumDate = [dateFormatter dateFromString:@"01/01/2012"];
	
    // VERIFICA SE TEM CONEXÃO COM A INTERNET.
    BOOL flagInternetStatus = [IMManager sharedManager].hasConnection;
	// PEGA OS DADOS DO USUARIO
    User *userData = (User *) [coreDataService getDataFromUserTable];
	 if ([userData.level integerValue] != USER_LEVEL_TRAINEE)
	 {
	 	if(flagInternetStatus)
			[self updateTreineeHistory:treineeID];
	 }
	 else
	 {
		[self loadCalendar];
	 }
}

-(void) loadCalendar
{
	
    if (flagByID)
    {
        NSArray *arraytemp = (NSArray *) [coreDataService getDataFromHistoryTableWithUserID:treineeID];
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"endDate" ascending:YES];
        NSArray *descriptors = [NSArray arrayWithObject: descriptor];
        NSArray *array = [arraytemp sortedArrayUsingDescriptors:descriptors];
        
        if ([array count] > 0)
        {
            for(NSInteger i = 0; i < [array count]; i++)
            {
					NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
					[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	
					// set locale to something English
					NSLocale *ptLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"pt"];
					[dateFormatter setLocale:ptLocale];
					 
					 
                History *historyEntry = (History *)[array objectAtIndex:i];
                NSDate *date = [dateFormatter dateFromString:historyEntry.endDate];
					
                
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"dd/MM/yyyy"];
                NSString *stringDate = [df stringFromDate:date];
                NSDate *dateM = [df dateFromString:stringDate];
                [arrayDates addObject:dateM];
                [arrayHistory addObject:historyEntry];
            }
        }
    }
    else
    {
        NSArray *arraytemp = (NSArray *) [coreDataService getDataFromHistoryTable];
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"endDate" ascending:YES];
        NSArray *descriptors = [NSArray arrayWithObject: descriptor];
        NSArray *array = [arraytemp sortedArrayUsingDescriptors:descriptors];
        
        if ([array count] > 0)
        {
            for(NSInteger i = 0; i < [array count]; i++)
            {
                History *historyEntry = (History *)[array objectAtIndex:i];
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
					[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
						// set locale to something English
					NSLocale *ptLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"pt"];
					[dateFormatter setLocale:ptLocale];
					
                
                NSDate *date = [dateFormatter dateFromString:historyEntry.endDate];
                
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setLocale:ptLocale];
                [df setDateFormat: @"dd/MM/yyyy"];
                NSString *stringDate = [df stringFromDate:date];
                 [df setDateFormat: @"dd/MM/yyyy"];
                NSDate *dateM = [df dateFromString:stringDate];
                [arrayDates addObject:dateM];
                [arrayHistory addObject:historyEntry];
            }
        }
    }
	
   // [self dowloadImageWithPersonalTreinee];

    // Inicializa o calendário.
    calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
    
    [calendar setLocale:[NSLocale currentLocale]];
    
    // Configura o delegate.
    calendar.delegate = self;
    
    NSLog(@"%@",[calendar locale].debugDescription);
    
    // Cor dos textos do dia da semana.
    calendar.dayOfWeekTextColor = UIColorFromRGB(0x545454);
    
    // Cor do background dos Dias da semana. Normal é degradê.
    [calendar setDayOfWeekBottomColor:[UIColor lightGrayColor]
                             topColor:[UIColor lightGrayColor]];
    
    // Configura background para tranparente. Mostra a view do fundo.
    calendar.backgroundColor =  [UIColor whiteColor];
    
    // Mostra o mês seguinte.
    calendar.onlyShowCurrentMonth = NO;
    
    // Calendario com tamanho fixo.
    calendar.adaptHeightToNumberOfWeeksInMonth = NO;
    
    // Ajusta o Frame do calendário.
    BOOL iPhoneX = NO;
		 if (@available(iOS 11.0, *)) {
			  UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
			  if (mainWindow.safeAreaInsets.top > 0.0) {
					iPhoneX = YES;
			  }
		 }
	if(iPhoneX)
    calendar.frame = CGRectMake(0, -1, 375, 375);
   else
		calendar.frame = CGRectMake(0, -1, 320, 320);
	
	calendar.titleColor=UIColorFromRGB(STYLE_MAIN_COLOR);
    calendar.tintColor =UIColorFromRGB(0x545454);
   
    // Adiciona o calendario na view.
    [self.view addSubview:calendar];
    
    // Configura o observador para mudança de locale.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(localeDidChange:)
                                                 name:NSCurrentLocaleDidChangeNotification
                                               object:nil];

    // Força a seleção da data do dia...
    NSDate *now = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd/MM/yyyy"];
    NSString *stringDate = [df stringFromDate:now];
    NSDate *dateM = [df dateFromString:stringDate];
    [calendar setTintColor :UIColorFromRGB(STYLE_MAIN_COLOR) ];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    
    selected = [dateFormatter stringFromDate:dateM];
    [self.tableView reloadData];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
/*
    if (IS_IPHONE5)
    {
        CGRect frame = self.tableView.frame;
        
        frame.origin.x = 0.0f;
        frame.origin.y = 335.0f;
        frame.size.width = 320.0f;
        frame.size.height = 170.0f;
        
        self.tableView.frame = frame;
    }
    else
    {
    	  BOOL iPhoneX = NO;
		 if (@available(iOS 11.0, *)) {
			  UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
			  if (mainWindow.safeAreaInsets.top > 0.0) {
					iPhoneX = YES;
			  }
		 }
	
	    CGRect frame = self.tableView.frame;
		 if(iPhoneX)
		 {
         frame.origin.x = 0.0f;
         frame.origin.y = 380.0f;
         frame.size.width = 375.0f;
         frame.size.height = 280.0f;
        }
        else
        {
			 frame.origin.x = 0.0f;
          frame.origin.y = 335.0f;
          frame.size.width = 320.0f;
          frame.size.height = 81.0f;
        }
        self.tableView.frame = frame;
    }
    */
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSCurrentLocaleDidChangeNotification
                                                  object:nil];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - CKCALENDAR DELEGATE

- (void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd/MM/yyyy"];
    NSString *stringDate = [df stringFromDate:date];
    NSDate *dateM = [df dateFromString:stringDate];

    // If the date has been chosen by the user, go ahead and style it differently
    if ([arrayDates containsObject:dateM])
    {
        NSDate *todayTemp = [NSDate date];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat: @"dd/MM/yyyy"];
        NSString *stringDate = [df stringFromDate:todayTemp];
        NSDate *today = [df dateFromString:stringDate];
        
        if ([today compare:dateM] != NSOrderedSame)
        {
            dateItem.backgroundColor = UIColorFromRGB(STYLE_MAIN_COLOR);
            dateItem.textColor = [UIColor whiteColor];
        }
      
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date
{
    flagSelect = TRUE;
    return ![self dateIsDisabled:date];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)calendar:(CKCalendarView *)calendar willDeselectDate:(NSDate *)date
{
    flagSelect = FALSE;
    return YES;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat: @"dd/MM/yyyy"];
    NSString *stringDate = [df stringFromDate:date];
    NSDate *dateM = [df dateFromString:stringDate];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	 [dateFormatter setDateFormat: @"dd/MM/yyyy"];
    selected = [dateFormatter stringFromDate:dateM];
    [self.tableView reloadData];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)calendar:(CKCalendarView *)calendar willChangeToMonth:(NSDate *)date
{
    if ([date laterDate:self.minimumDate] == date)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)dateIsDisabled:(NSDate *)date
{
    for (NSDate *disabledDate in self.disabledDates)
    {
        if ([disabledDate isEqualToDate:date])
        {
            return YES;
        }
    }
    
    return NO;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([arrayHistory count] > 0)
    {
        [arrayFiltered removeAllObjects];
        
        for (NSInteger i = 0; i < [arrayHistory count]; i++)
        {
            History *historyEntry = [arrayHistory objectAtIndex:i];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
				//	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	
					// set locale to something English
					NSLocale *ptLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"pt"];
			//		[dateFormatter setLocale:ptLocale];
					
				[dateFormatter setDateFormat: @"dd/MM/yyyy"];
            NSDate *date = [dateFormatter dateFromString:historyEntry.endDate];
            
            
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat: @"dd/MM/yyyy"];
            NSString *stringDate = [df stringFromDate:date];
            NSDate *dateM = [df dateFromString:stringDate];
            
            NSString *compareDate = [dateFormatter stringFromDate:dateM];
            
            if ([compareDate containsString:selected])
            {
                [arrayFiltered addObject:historyEntry];
            }
        }
        
        if ([arrayFiltered count] == 0)
        {
            [lblMessage removeFromSuperview];
            
            lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(self.tableView.frame.size.width / 2-150,
                                                                   self.tableView.frame.size.height / 2-20, 300.0f, 40.0f)];
            
            // Configura o label.
            lblMessage.numberOfLines = 0;
            lblMessage.textAlignment = NSTextAlignmentCenter;
            lblMessage.backgroundColor = [UIColor clearColor];
            lblMessage.textColor = UIColorFromRGB(STYLE_MAIN_COLOR);
            lblMessage.shadowColor = [UIColor colorWithWhite:0.9 alpha:0.5];
            lblMessage.shadowOffset = CGSizeMake(1,1);
            lblMessage.font = [UIFont systemFontOfSize:16];
            lblMessage.alpha = 0;
            
            if (flagSelect == 0)
            {
                lblMessage.text = @"Não existem registros de atividades para você nesta data.";
            }
            else
            {
               lblMessage.text = @"Não existem registros de atividades para você nesta data.";
            }
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.3f];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            
                lblMessage.alpha = 1;
                [self.tableView addSubview:lblMessage];
            
            [UIView commitAnimations];
        }
        else
        {
            lblMessage.alpha = 1;
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.3f];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            
                lblMessage.alpha = 0;
                [lblMessage removeFromSuperview];
            
            [UIView commitAnimations];
        }
        
        return [arrayFiltered count];
    }
    else
    {
        [lblMessage removeFromSuperview];
        lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(self.tableView.frame.size.width/2-150,
                                                               self.tableView.frame.size.height/2-20, 300.0f, 40.0f)];
        
        // Configura o label.
        lblMessage.numberOfLines = 0;
        lblMessage.textAlignment = NSTextAlignmentCenter;
        lblMessage.backgroundColor = [UIColor clearColor];
        lblMessage.textColor = UIColorFromRGB(STYLE_MAIN_COLOR);
        lblMessage.shadowColor = [UIColor colorWithWhite:0.9 alpha:0.5];
        lblMessage.shadowOffset = CGSizeMake(1,1);
        lblMessage.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        lblMessage.text = @"Nenhuma atividade \n registrada nesta data!";
        lblMessage.alpha = 0;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        
            lblMessage.alpha = 1;
            [self.tableView addSubview:lblMessage];
        
        [UIView commitAnimations];
        
        return 0;
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    //cell.contentView.backgroundColor = UIColorFromRGB(0xFFFFFF);
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    HistoricoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[HistoricoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    History *historyEntry = (History *)[arrayFiltered objectAtIndex:indexPath.row];

    if ([arrayFiltered count] > 0)
    {
        cell.labelNomeSerie.text = historyEntry.trainingName;
        
      //RFR  cell.labelType.layer.cornerRadius = cell.labelType.frame.size.height / 2;
      //  cell.labelType.clipsToBounds = YES;
      //  cell.labelType.backgroundColor = UIColorFromRGB(0x333333);
        
        if([historyEntry.isClass boolValue])
        {
            cell.labelType.text = @"Aula";
        }
        else
        {
            cell.labelType.text = @"Treino";
        }
        
        // Separa a data em dia da semana, dia e mes.
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setLocale:[NSLocale currentLocale]];
        [dateFormat setTimeZone:[NSTimeZone localTimeZone]];
        [dateFormat setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
 
        NSDate *timestamp = [dateFormat dateFromString:historyEntry.endDate];
        
        // Dia da Semana
        NSDateFormatter *weekday = [[NSDateFormatter alloc] init];
        [weekday setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"pt"]];
        [weekday setDateFormat: @"EE"];
        
        // Dia
        NSDateFormatter *day = [[NSDateFormatter alloc] init];
        [day setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"pt"]];
        [day setDateFormat: @"dd"];
        
        // Mês
        NSDateFormatter *month = [[NSDateFormatter alloc] init];
        [month setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"pt"]];
        [month setDateFormat: @"MMM"];
        
        // Hora
        NSDateFormatter *hourFull = [[NSDateFormatter alloc] init];
        [hourFull setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"pt"]];
        [hourFull setDateFormat: @"HH:mm"];
        
        // Forma a string com as partes separadas.
        NSMutableString *strFormattedgDate = [[NSMutableString alloc] init];
  //      [strFormattedgDate appendString:@"Concluído - "];
        [strFormattedgDate appendString:[[weekday stringFromDate:timestamp] capitalizedString]];
        [strFormattedgDate appendString:@" "];
        [strFormattedgDate appendString:[[day stringFromDate:timestamp] capitalizedString]];
        [strFormattedgDate appendString:@"/"];
        [strFormattedgDate appendString:[[month stringFromDate:timestamp] capitalizedString]];
        [strFormattedgDate appendString:@" às "];
        
        NSString *hour = [[hourFull stringFromDate:timestamp] stringByReplacingOccurrencesOfString:@":" withString:@"h"];
        [strFormattedgDate appendString:hour];
        
        cell.labelData.text = strFormattedgDate;
    /* NEW LAYOUT
        if (flagByID)
        {
            UIImageView *check =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CheckBlue"]];
            cell.accessoryView = check;
        }
        else
        {
            if ([historyEntry.isSync boolValue])
            {
                UIImageView *check =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CheckBlue"]];
                cell.accessoryView = check;
            }
            else
            {
                UIImageView *check =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CheckGray"]];
                cell.accessoryView = check;
            }
        }
 
        cell.accessoryType = UITableViewCellAccessoryCheckmark; */
    }

    return cell;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - ACTIONS

- (IBAction)todayDateClicked:(id)sender
{
    [calendar selectDate:[NSDate date] makeVisible:YES];
    [calendar reloadData];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - NOTIFICATION METHODS

- (void)localeDidChange:(NSNotification *)notification
{
    [self.calendar setLocale:[NSLocale currentLocale]];
}

- (void)dowloadImageWithPersonalTreinee
{
    // VERIFICA SE TEM CONEXÃO COM A INTERNET.
    BOOL flagInternetStatus = [IMManager sharedManager].hasConnection;
	 PersonalTreinees *pTreinee = (PersonalTreinees *) [coreDataService getDataFromPersonalTreineesTableByTreineeID:treineeID];
	
    if(pTreinee.image.length > 0 && flagInternetStatus == TRUE)
    {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
		 
        NSURL *URL = [NSURL URLWithString:pTreinee.image];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
		 
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
			  
            NSString *imagesCachePath = [[utils returnDocumentsPath] stringByAppendingPathComponent:@"/Caches/ProfileImages/"];
            NSURL *path = [NSURL fileURLWithPath:imagesCachePath];
			  
            NSMutableString *filename = [[NSMutableString alloc] init];
            [filename appendString:[utils md5HexDigest:pTreinee.treineeID]];
            [filename appendString:@".png"];
			  
            return [path URLByAppendingPathComponent:filename];
			  
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
			  
            NSLog(@"DOWNLOAD END");
			  
			  
			  
        }];
		 
        [downloadTask resume];
    }
}

- (void)updateTreineeHistory:(NSString *)treineeID
{
	
	
    // PEGA OS DADOS DO USUARIO
    User *userData = (User *) [coreDataService getDataFromUserTable];
	 [coreDataService deleteHistoryDatabyTrainee:treineeID];
	
        // Monta a string de acesso a validação do login.
        NSMutableString *urlString = [[NSMutableString alloc] init];
        [urlString appendString:kBASE_URL_MOBITRAINER];
        [urlString appendString:@"api/history/by_user_id"];
		 
        // Inicializa o manager.
    //    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	//	  [manager.requestSerializer setTimeoutInterval:AFHHTTP_TIMEOUT];
        NSDictionary *parameters = @{@"apikey":userData.apiKey, @"user_id":treineeID};
		 
     //   [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		 AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
			[manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
			NSString *path=[[NSString alloc]initWithFormat:@"%@",urlString];
			[manager POST:[NSURL URLWithString:path].absoluteString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
   	  {
            if (![[responseObject objectForKey:@"response_error"] boolValue])
            {
                NSArray *arrayDataHistory = [responseObject objectForKey:@"history"];
					
                if ([arrayDataHistory count] != 0)
                {
						 
                    for (NSInteger i = 0; i < [arrayDataHistory count]; i++)
                    {
                        History *historyEntry = (History *) [NSEntityDescription insertNewObjectForEntityForName:@"History"
                                                                                          inManagedObjectContext:coreDataService.getManagedContext];
							  
                        historyEntry.endDate = [utils checkString:[[arrayDataHistory objectAtIndex:i]objectForKey:@"response_history_datetime"]];
                        historyEntry.trainingID = [utils checkString:[[arrayDataHistory objectAtIndex:i]objectForKey:@"response_history_serie_id"]];
                        historyEntry.trainingName = [utils checkString:[[arrayDataHistory objectAtIndex:i]objectForKey:@"response_history_serie_name"]];
                        historyEntry.treineeID = treineeID;
							  
                    }
						 
                    [coreDataService saveData];
						 
                    dispatch_async(dispatch_get_main_queue(), ^{
							  
                        [SVProgressHUD dismiss];
                    });
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
							  
                        [SVProgressHUD dismiss];
                    });
                }
                [self loadCalendar];
            }
			  
        } failure:^(NSURLSessionTask *operation, NSError *error){
			  
            dispatch_async(dispatch_get_main_queue(), ^{
					
                [SVProgressHUD dismiss];
            });
			  
            NSLog(@"Error: %@", error);
			  
        }];
	
}



@end

////////////////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#endif
