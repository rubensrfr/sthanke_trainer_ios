//
//  AulasViewController.m
//  mobitrainer
//
//  Created by Reginaldo Lopes on 28/07/16.
//  Copyright © 2016 4mobi. All rights reserved.
//

#import "AulasVC.h"

@interface AulasVC()
{
    NSInteger selectedWeekday;
}

@end

@implementation AulasVC

@synthesize btnWeekBarBack;
@synthesize btnWeekBarForward;

enum daysofweek {sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday};

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - VIEW LIFECYCLE

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    arrayClassScheduleItens = [[NSMutableArray alloc] init];
    utils = [[UtilityClass alloc] init];
    
    self.tableView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(unlockClassScheduleTableview:)
                                                 name:@"unlockClassScheduleTableview"
                                               object:nil];
	
	 BOOL iPhoneX = NO;
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.top > 0.0) {
            iPhoneX = YES;
        }
    }
	
	
	
    	lblWeekDay = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-75, 7, 150, 20)];
   		 
    // Configura o background da tableview.
//    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    [backgroundView setBackgroundColor:UIColorFromRGB(0xEFCD29)];
//    [self.tableView setBackgroundView:backgroundView];
    
    // Tweak para linhas extra na tabela.
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    NSInteger currentweekday = [comps weekday];
    
    selectedWeekday = currentweekday;
    coreDataService = [[CoreDataService alloc] init];
    [coreDataService initialize];
    
    [self updateWeekDayTitle:selectedWeekday];
    
    arrayClassScheduleItens = (NSMutableArray *)[coreDataService getDataFromClassScheduleItemTableByWeekDay:selectedWeekday];
    
	
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"unlockClassScheduleTableview"
                                                  object:nil];
}


- (void)viewWillAppear:(BOOL)animated
{

// VERIFICA SE TEM CONEXÃO COM A INTERNET.
    BOOL flagInternetStatus = [IMManager sharedManager].hasConnection;

    // SE TEM CONEXÃO
    if (flagInternetStatus)
    {
        [self getClassScheduleData];
    }
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
    // Verifica se o array tem dados, senão retorna 0.
    if ((arrayClassScheduleItens == (id)[NSNull null] || arrayClassScheduleItens.count == 0))
    {
        return 0;
    }
    else
    {
        return arrayClassScheduleItens.count;
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

	 
    UIView *v;
    CGRect screen = [[UIScreen mainScreen] bounds];
	  CGFloat width = CGRectGetWidth(screen);
	
	 v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 35)];
    v.backgroundColor = UIColorFromRGB(kNAVIGATION_TINT_COLOR);
    
    UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(0, v.frame.size.height/2-15, 30, 30)];
    [back setImage:[UIImage imageNamed:@"left_arrow"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(btnWeekBarBackClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *foward = [[UIButton alloc] initWithFrame:CGRectMake(v.frame.size.width-30, v.frame.size.height/2-15, 30, 30)];
    [foward setImage:[UIImage imageNamed:@"right_arrow"] forState:UIControlStateNormal];
    [foward addTarget:self action:@selector(btnWeekBarForwardClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    lblWeekDay.textAlignment = NSTextAlignmentCenter;
    lblWeekDay.backgroundColor = [UIColor clearColor];
    lblWeekDay.font = [UIFont boldSystemFontOfSize:16];
    lblWeekDay.textColor = UIColorFromRGB(kPRIMARY_COLOR);
    
    [v addSubview:back];
    [v addSubview:lblWeekDay];
    [v addSubview:foward];
    
    return v;
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
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    ClassScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (!cell)
    {
        cell = [[ClassScheduleCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    ClassScheduleItem *item = (ClassScheduleItem *) [arrayClassScheduleItens objectAtIndex:indexPath.row];
    
    [cell configureCell:item];
    
    //////////////////////////////////////////////////////////////////////
    /// CONFIGURA MGSWIPE BUTTON /////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////
    
    User *userData = (User *) [coreDataService getDataFromUserTable];
    
    if ([userData.level integerValue] == USER_LEVEL_TRAINEE)
    {
        UIImage *icon = [UIImage imageNamed:@"Btn_Check"];
        UIImage *scaledImage = [UIImage imageWithCGImage:[icon CGImage]
                                                   scale:(icon.scale * 1.4f)
                                             orientation:(icon.imageOrientation)];
        
        // Cria um botão MGSwipeButton;
        MGSwipeButton * button = [MGSwipeButton buttonWithTitle:@" Presente" icon:scaledImage
                                                backgroundColor:UIColorFromRGB(0x3E8A61) padding:15
                                                       callback:^BOOL(MGSwipeTableCell * sender){
                                                           
                                                           [self validateClassDate:item];

                                                           return YES;
                                                       }];
        
        button.adjustsImageWhenHighlighted = NO;
        
        [button setBounds:CGRectMake(0, -7, button.frame.size.width, button.frame.size.height)];
        
        // Array de botões... pode conter vários.
        cell.rightButtons = @[button];
        cell.rightSwipeSettings.transition = MGSwipeTransitionClipCenter;
    }
    
    return cell;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"ClassScheduleDetails"
                                                  owner:self
                                                options:nil];
    
    ClassScheduleItem *csi = (ClassScheduleItem *) [arrayClassScheduleItens objectAtIndex:indexPath.row];
    
    ClassScheduleDetails *csd = [[nibs objectAtIndex:0]initWithParameter:csi];
    
    self.tableView.scrollEnabled = FALSE;
	
    BOOL iPhoneX = NO;
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.top > 0.0) {
            iPhoneX = YES;
        }
    }
    if(iPhoneX)
    	csd.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+122, self.view.frame.size.width, self.view.frame.size.height-100);
    else
    	csd.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+98, self.view.frame.size.width, self.view.frame.size.height-100);
    
    
    [self.tableView.superview addSubview:csd];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)viewDidLayoutSubviews
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

#pragma mark - BUTTONS CALLBACKS

- (void)btnWeekBarBackClicked:(id)sender
{
    if (selectedWeekday == sunday)
    {
        selectedWeekday = saturday + 1;
    }
    
    selectedWeekday --;
    
    [self updateWeekDayTitle:selectedWeekday];
    
    arrayClassScheduleItens = (NSMutableArray *)[coreDataService getDataFromClassScheduleItemTableByWeekDay:selectedWeekday];
    
//    if(arrayClassScheduleItens.count == 0) [self showNoDataMessage];
//    else [self hideNoDataMessage];
	
    [self.tableView reloadData];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)btnWeekBarForwardClicked:(id)sender
{
    selectedWeekday ++;
    
    if(selectedWeekday >= monday)
    {
        btnWeekBarBack.enabled = TRUE;
        btnWeekBarBack.alpha = 1.0f;
    }
    else
    {
        btnWeekBarBack.enabled = FALSE;
        btnWeekBarBack.alpha = 0.5f;
    }
    
    if(selectedWeekday > saturday) selectedWeekday = sunday;
    
    [self updateWeekDayTitle:selectedWeekday];
    
    arrayClassScheduleItens = (NSMutableArray *)[coreDataService getDataFromClassScheduleItemTableByWeekDay:selectedWeekday];
    
//    if(arrayClassScheduleItens.count == 0) [self showNoDataMessage];
//    else [self hideNoDataMessage];
    
    [self.tableView reloadData];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - CUSTOM METHODS

- (void)syncClassSchedule
{
    // Mostra o HUD...
    [SVProgressHUD showWithStatus:@"Sincronizando dados..."  maskType: SVProgressHUDMaskTypeGradient];
 
 
    NSArray *arrayFiltered = [coreDataService getDataFromHistoryTableWithIsSync:NO IsClass:YES];
    
    if ([arrayFiltered count] > 0)
    {
        for (NSInteger i = 0; i < [arrayFiltered count]; i++)
        {
            History *historyEntry = [arrayFiltered objectAtIndex:i];
            
            ///////////////////////////////////////////////////////////////////////
            /// INICIA A VALIDAÇÃO DO LOGIN ///////////////////////////////////////
            ///////////////////////////////////////////////////////////////////////
            
            // Cria um operation manager para realizar a solicitação via POST.
//            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//            [manager.requestSerializer setTimeoutInterval:AFHHTTP_TIMEOUT];
            // Parametros validados.
            NSDictionary *parameters = @{
                                          @"apikey":   API_KEY_TRAINER,
                                          @"classid":  historyEntry.trainingID,
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
                    
                    [SVProgressHUD showSuccessWithStatus:@"Dados sincronizadas \ncom sucesso!"  maskType:SVProgressHUDMaskTypeGradient];
                }
                else
                {
                    [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                                      AndText:[responseObject objectForKey:@"message"]
                                  AndTargetVC:self];
                }
                
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                
                NSLog(@"Error: %@", error);
                
                [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                                  AndText:kTEXT_SERVER_ERROR_DEFAULT
                              AndTargetVC:self];
            }];
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)validateClassDate:(ClassScheduleItem *) item
{
    NSDate *now = [NSDate date];
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
    NSDate *today = [now dateByAddingTimeInterval:timeZoneSeconds];
    
    BOOL checkDuplicatedDate = NO;
    
    NSArray *arrayFiltered = [coreDataService getDataFromHistoryTableWithID:[item.classScheduleID stringValue]];

    if (arrayFiltered.count > 0)
    {
        NSDateFormatter *longFormatter = [[NSDateFormatter alloc] init];
        [longFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
        
        History *history = (History *)[arrayFiltered objectAtIndex:0];
        
        NSDate *historyDateUTC = [longFormatter dateFromString:history.endDate];
        
        NSDate *historyDate = [historyDateUTC dateByAddingTimeInterval:timeZoneSeconds];
        
        NSDateFormatter *shortFormatter = [[NSDateFormatter alloc] init];
        [shortFormatter setDateFormat: @"yyyy-MM-dd"];
        
        NSDate *shortHistoryDate = [shortFormatter dateFromString:[shortFormatter stringFromDate:historyDate]];
        NSDate *shortTodayDate = [shortFormatter dateFromString:[shortFormatter stringFromDate:today]];
        
        if ([shortHistoryDate isEqualToDate:shortTodayDate]) checkDuplicatedDate = NO; // JA TEM UM ITEM COM A DATA DE HJ
        else checkDuplicatedDate = YES;
    }
    else
    {
        checkDuplicatedDate = YES;
    }
    
    if(checkDuplicatedDate)
    {
        NSDateComponents *comp = [theCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:today];
        NSInteger currentYear = (NSInteger)[comp year];
        NSInteger currentMonth = (NSInteger)[comp month];
        NSInteger currentDay = (NSInteger)[comp day];
        
        NSDateComponents *c = [[NSDateComponents alloc] init];
        [c setDay:currentDay];
        [c setMonth:currentMonth];
        [c setYear:currentYear];
        
        NSArray *split = [item.startAt componentsSeparatedByString: @":"];
        
        [c setHour:[[split objectAtIndex:0]integerValue]];
        [c setMinute:[[split objectAtIndex:1]integerValue]];
        
        NSDate *checkDate = [[NSCalendar currentCalendar] dateFromComponents:c];
        NSDate *startDate = [[NSDate alloc] init];
        
        NSDateComponents *comps = [theCalendar components:NSCalendarUnitWeekday fromDate:today];
        NSInteger currentweekday = [comps weekday];
        
        if(currentweekday - 1 == 0) currentweekday = 7; // SUNDAY FIX
        
        if([item.weekday integerValue] == currentweekday - 1)
        {
            NSDateComponents *offset = [[NSDateComponents alloc] init];
            [offset setDay:-1];
            startDate = [theCalendar dateByAddingComponents:offset toDate:checkDate options:0];
        }
        else
        {
            startDate = checkDate;
        }
        
        startDate = [startDate dateByAddingTimeInterval:timeZoneSeconds];
        
        NSInteger duration = [item.duration integerValue];
        NSTimeInterval oneHour = 60 * 60;
        
        NSDate *endDate = [startDate dateByAddingTimeInterval:((duration * 60) + oneHour)]; // end = start + duration + 1hour
        
        NSLog(@"TODAY DATE:%@",today);
        NSLog(@"START DATE:%@",startDate);
        NSLog(@"END DATE:%@",endDate);
        NSLog(@"");
        
        if(currentweekday == [item.weekday integerValue])
        {
            if ([self isDate:today inRangeFirstDate:startDate lastDate:endDate]) {
                
                [SVProgressHUD showSuccessWithStatus:@"Presença Registrada com sucesso!"];
                
                [self historyDataEntry:item];
                
            }
            else
            {
                [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                                  AndText:KTEXT_ERROR_CLASS_CHECKIN
                              AndTargetVC:self];
            }
        }
        else
        {
            if([self dateComparision:startDate : endDate])
            {
                if ([self isDate:today inRangeFirstDate:startDate lastDate:endDate])
                {
                    [SVProgressHUD showSuccessWithStatus:@"Presença Registrada com sucesso!"];
                    
                    [self historyDataEntry:item];
                }
                else
                {
                    [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                                      AndText:KTEXT_ERROR_CLASS_CHECKIN
                                  AndTargetVC:self];
                }
            }
            else
            {
                [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                                  AndText:KTEXT_ERROR_CLASS_TODAY
                              AndTargetVC:self];
            }
        }
    }
    else
    {
        [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                          AndText:@"Você já registrou presença neste evento hoje!"
                      AndTargetVC:self];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

-(BOOL)dateComparision:(NSDate*)d1 :(NSDate*)d2
{
    BOOL isTokonValid;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setLocale:[NSLocale currentLocale]];
    [dateFormat setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormat setDateFormat: @"yyyy-MM-dd"];
    
    NSDate *data1 = [dateFormat dateFromString:[dateFormat stringFromDate:d1]];
    NSDate *data2 = [dateFormat dateFromString:[dateFormat stringFromDate:d2]];
    
    if ([data2 compare:data1] == NSOrderedDescending)
    {
        isTokonValid = YES;
    }
    else
    {
        isTokonValid = NO;
    }
    
    return isTokonValid;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)isDate:(NSDate *)date inRangeFirstDate:(NSDate *)firstDate lastDate:(NSDate *)lastDate
{
    return [date compare:firstDate] == NSOrderedDescending && [date compare:lastDate]  == NSOrderedAscending;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)historyDataEntry:(ClassScheduleItem *) item
{
    //Adiciona o treino na tabela histórico
    History *historyEntry = (History *)[NSEntityDescription insertNewObjectForEntityForName:@"History"
                                                                     inManagedObjectContext:coreDataService.getManagedContext];
    
    historyEntry.trainingID = [NSString stringWithFormat:@"%@",[item.classScheduleID stringValue]];
    historyEntry.trainingName = item.name;
    historyEntry.isSync = [NSNumber numberWithBool:NO];
    historyEntry.isClass = [NSNumber numberWithBool:TRUE];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    //RFR: Alterado para sempre mandar o horário local descontados o GMT
    //RFR: NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    //RFR: [dateFormat setTimeZone:gmt];
    [dateFormat setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormat setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    historyEntry.endDate = [dateFormat stringFromDate:[NSDate date]];
    
    [coreDataService saveData];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"IMPORTANTE:"
                                              message:@"Novos dados estão disponíveis para seu aplicativo. Vamos atualizar sincronizar agora?"
                                              preferredStyle:UIAlertControllerStyleAlert];
#ifdef NEW_STYLE
        alertController.view.tintColor=[UIColor colorNamed:@"myCellTextColor"];
#endif
        UIAlertAction *actionYES = [UIAlertAction actionWithTitle:@"Sim"
                                                         style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action){
                                                              
                                                              BOOL flagInternetStatus = [IMManager sharedManager].hasConnection;
                                                              
                                                              // Verifica se tem conexão com a Internet.
                                                              if (flagInternetStatus)
                                                              {
                                                                  // Sincroniza o treino com o servidor.
                                                                  [self syncClassSchedule];
                                                              }
                                                              else
                                                              {
                                                                  [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                                                                                    AndText:kTEXT_INTERNET_ERROR_DEFAULT
                                                                                AndTargetVC:self];
                                                              }
                                                
                                                              [alertController dismissViewControllerAnimated:YES completion:nil];
                                                              
                                                          }];
        
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Mais Tarde"
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

- (void)updateWeekDayTitle:(NSInteger)weekDay
{
    switch (weekDay)
    {
        case 1:
            lblWeekDay.text = @"DOMINGO";
            break;
        case 2:
            lblWeekDay.text = @"SEGUNDA-FEIRA";
            break;
        case 3:
            lblWeekDay.text = @"TERÇA-FEIRA";
            break;
        case 4:
            lblWeekDay.text = @"QUARTA-FEIRA";
            break;
        case 5:
            lblWeekDay.text = @"QUINTA-FEIRA";
            break;
        case 6:
            lblWeekDay.text = @"SEXTA-FEIRA";
            break;
        case 7:
            lblWeekDay.text = @"SÁBADO";
            break;
            
        default:
            break;
    }
    
    [self.tableView reloadData];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)getClassScheduleData
{
    
    [SVProgressHUD showWithStatus:@"Atualizando programação..."];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    User *userData = (User *) [coreDataService getDataFromUserTable];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager.requestSerializer setTimeoutInterval:AFHHTTP_TIMEOUT];
    NSDictionary *parameters = @{@"apikey": API_KEY_TRAINER};
    
    NSMutableString *urlString = [[NSMutableString alloc] init];
    [urlString appendString:kBASE_URL_MOBITRAINER];
    [urlString appendString:@"api/classschedule"];
    
   // [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
     AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
 			[manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
 			NSString *path=[[NSString alloc]initWithFormat:@"%@",urlString];
 			[manager POST:[NSURL URLWithString:path].absoluteString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
		{
        if ([[responseObject objectForKey:@"response_error"] boolValue]== 0)
        {
            NSDictionary *data = [responseObject objectForKey:@"classschedule"];
            
            if(data.count > 0)
            {
                [coreDataService dropClassScheduleItemTable];
                
                /////////////////////////////////////////////////
                /// SUNDAY //////////////////////////////////////
                /////////////////////////////////////////////////
                
                if([data objectForKey:@"sunday"])
                {
                    NSArray *sunday = [data objectForKey:@"sunday"];
                    
                    for (NSInteger i = 0; i < sunday.count; i++)
                    {
                        ClassScheduleItem *item = (ClassScheduleItem *)[NSEntityDescription insertNewObjectForEntityForName:@"ClassScheduleItem"
                                                                                                     inManagedObjectContext:coreDataService.getManagedContext];
                        
                        item.classScheduleID = [NSNumber numberWithInteger:[[[sunday objectAtIndex:i] objectForKey:@"id_classschedule"]integerValue]];
                        item.amount = [NSNumber numberWithInteger:[[[sunday objectAtIndex:i] objectForKey:@"classschedule_amount"]integerValue]];
                        item.duration = [NSNumber numberWithInteger:[[[sunday objectAtIndex:i] objectForKey:@"classschedule_duration"]integerValue]];
                        item.name = [[sunday objectAtIndex:i] objectForKey:@"classschedule_name"];
                        item.objective = [[sunday objectAtIndex:i] objectForKey:@"classschedule_objective"];
                        item.room = [[sunday objectAtIndex:i] objectForKey:@"classschedule_room"];
                        item.startAt = [[sunday objectAtIndex:i] objectForKey:@"classschedule_init"];
                        item.teacher = [[sunday objectAtIndex:i] objectForKey:@"classschedule_teacher"];
                        item.weekday = [NSNumber numberWithInteger:[[[sunday objectAtIndex:i] objectForKey:@"classschedule_weekday"]integerValue]];
                        
                        [coreDataService saveData];
                    }
                }
                
                /////////////////////////////////////////////////
                /// MONDAY //////////////////////////////////////
                /////////////////////////////////////////////////
                
                if([data objectForKey:@"monday"])
                {
                    NSArray *monday = [data objectForKey:@"monday"];
                    
                    for (NSInteger i = 0; i < monday.count; i++)
                    {
                        ClassScheduleItem *item = (ClassScheduleItem *)[NSEntityDescription insertNewObjectForEntityForName:@"ClassScheduleItem"
                                                                                                     inManagedObjectContext:coreDataService.getManagedContext];
                        
                        item.classScheduleID = [NSNumber numberWithInteger:[[[monday objectAtIndex:i] objectForKey:@"id_classschedule"]integerValue]];
                        item.amount = [NSNumber numberWithInteger:[[[monday objectAtIndex:i] objectForKey:@"classschedule_amount"]integerValue]];
                        item.duration = [NSNumber numberWithInteger:[[[monday objectAtIndex:i] objectForKey:@"classschedule_duration"]integerValue]];
                        item.name = [[monday objectAtIndex:i] objectForKey:@"classschedule_name"];
                        item.objective = [[monday objectAtIndex:i] objectForKey:@"classschedule_objective"];
                        item.room = [[monday objectAtIndex:i] objectForKey:@"classschedule_room"];
                        item.startAt = [[monday objectAtIndex:i] objectForKey:@"classschedule_init"];
                        item.teacher = [[monday objectAtIndex:i] objectForKey:@"classschedule_teacher"];
                        item.weekday = [NSNumber numberWithInteger:[[[monday objectAtIndex:i] objectForKey:@"classschedule_weekday"]integerValue]];
                        
                        [coreDataService saveData];
                    }
                }
                
                /////////////////////////////////////////////////
                /// TUESDAY /////////////////////////////////////
                /////////////////////////////////////////////////
                
                if([data objectForKey:@"tuesday"])
                {
                    NSArray *tuesday = [data objectForKey:@"tuesday"];
                    
                    for (NSInteger i = 0; i < tuesday.count; i++)
                    {
                        ClassScheduleItem *item = (ClassScheduleItem *)[NSEntityDescription insertNewObjectForEntityForName:@"ClassScheduleItem"
                                                                                                     inManagedObjectContext:coreDataService.getManagedContext];
                        
                        item.classScheduleID = [NSNumber numberWithInteger:[[[tuesday objectAtIndex:i] objectForKey:@"id_classschedule"]integerValue]];
                        item.amount = [NSNumber numberWithInteger:[[[tuesday objectAtIndex:i] objectForKey:@"classschedule_amount"]integerValue]];
                        item.duration = [NSNumber numberWithInteger:[[[tuesday objectAtIndex:i] objectForKey:@"classschedule_duration"]integerValue]];
                        item.name = [[tuesday objectAtIndex:i] objectForKey:@"classschedule_name"];
                        item.objective = [[tuesday objectAtIndex:i] objectForKey:@"classschedule_objective"];
                        item.room = [[tuesday objectAtIndex:i] objectForKey:@"classschedule_room"];
                        item.startAt = [[tuesday objectAtIndex:i] objectForKey:@"classschedule_init"];
                        item.teacher = [[tuesday objectAtIndex:i] objectForKey:@"classschedule_teacher"];
                        item.weekday = [NSNumber numberWithInteger:[[[tuesday objectAtIndex:i] objectForKey:@"classschedule_weekday"]integerValue]];
                        
                        [coreDataService saveData];
                    }
                }
                
                /////////////////////////////////////////////////
                /// WEDNESDAY ///////////////////////////////////
                /////////////////////////////////////////////////
                
                if([data objectForKey:@"wednesday"])
                {
                    NSArray *wednesday = [data objectForKey:@"wednesday"];
                    
                    for (NSInteger i = 0; i < wednesday.count; i++)
                    {
                        ClassScheduleItem *item = (ClassScheduleItem *)[NSEntityDescription insertNewObjectForEntityForName:@"ClassScheduleItem"
                                                                                                     inManagedObjectContext:coreDataService.getManagedContext];
                        
                        item.classScheduleID = [NSNumber numberWithInteger:[[[wednesday objectAtIndex:i] objectForKey:@"id_classschedule"]integerValue]];
                        item.amount = [NSNumber numberWithInteger:[[[wednesday objectAtIndex:i] objectForKey:@"classschedule_amount"]integerValue]];
                        item.duration = [NSNumber numberWithInteger:[[[wednesday objectAtIndex:i] objectForKey:@"classschedule_duration"]integerValue]];
                        item.name = [[wednesday objectAtIndex:i] objectForKey:@"classschedule_name"];
                        item.objective = [[wednesday objectAtIndex:i] objectForKey:@"classschedule_objective"];
                        item.room = [[wednesday objectAtIndex:i] objectForKey:@"classschedule_room"];
                        item.startAt = [[wednesday objectAtIndex:i] objectForKey:@"classschedule_init"];
                        item.teacher = [[wednesday objectAtIndex:i] objectForKey:@"classschedule_teacher"];
                        item.weekday = [NSNumber numberWithInteger:[[[wednesday objectAtIndex:i] objectForKey:@"classschedule_weekday"]integerValue]];
                        
                        [coreDataService saveData];
                    }
                    
                    /////////////////////////////////////////////////
                    /// THURSDAY ////////////////////////////////////
                    /////////////////////////////////////////////////
                    
                    if([data objectForKey:@"thursday"])
                    {
                        NSArray *thursday = [data objectForKey:@"thursday"];
                        
                        for (NSInteger i = 0; i < thursday.count; i++)
                        {
                            ClassScheduleItem *item = (ClassScheduleItem *)[NSEntityDescription insertNewObjectForEntityForName:@"ClassScheduleItem"
                                                                                                         inManagedObjectContext:coreDataService.getManagedContext];
                            
                            item.classScheduleID = [NSNumber numberWithInteger:[[[thursday objectAtIndex:i] objectForKey:@"id_classschedule"]integerValue]];
                            item.amount = [NSNumber numberWithInteger:[[[thursday objectAtIndex:i] objectForKey:@"classschedule_amount"]integerValue]];
                            item.duration = [NSNumber numberWithInteger:[[[thursday objectAtIndex:i] objectForKey:@"classschedule_duration"]integerValue]];
                            item.name = [[thursday objectAtIndex:i] objectForKey:@"classschedule_name"];
                            item.objective = [[thursday objectAtIndex:i] objectForKey:@"classschedule_objective"];
                            item.room = [[thursday objectAtIndex:i] objectForKey:@"classschedule_room"];
                            item.startAt = [[thursday objectAtIndex:i] objectForKey:@"classschedule_init"];
                            item.teacher = [[thursday objectAtIndex:i] objectForKey:@"classschedule_teacher"];
                            item.weekday = [NSNumber numberWithInteger:[[[thursday objectAtIndex:i] objectForKey:@"classschedule_weekday"]integerValue]];
                            
                            [coreDataService saveData];
                        }
                    }
                    
                    /////////////////////////////////////////////////
                    /// FRIDAY //////////////////////////////////////
                    /////////////////////////////////////////////////
                    
                    if([data objectForKey:@"friday"])
                    {
                        NSArray *friday = [data objectForKey:@"friday"];
                        
                        for (NSInteger i = 0; i < friday.count; i++)
                        {
                            ClassScheduleItem *item = (ClassScheduleItem *)[NSEntityDescription insertNewObjectForEntityForName:@"ClassScheduleItem"
                                                                                                         inManagedObjectContext:coreDataService.getManagedContext];
                            
                            item.classScheduleID = [NSNumber numberWithInteger:[[[friday objectAtIndex:i] objectForKey:@"id_classschedule"]integerValue]];
                            item.amount = [NSNumber numberWithInteger:[[[friday objectAtIndex:i] objectForKey:@"classschedule_amount"]integerValue]];
                            item.duration = [NSNumber numberWithInteger:[[[friday objectAtIndex:i] objectForKey:@"classschedule_duration"]integerValue]];
                            item.name = [[friday objectAtIndex:i] objectForKey:@"classschedule_name"];
                            item.objective = [[friday objectAtIndex:i] objectForKey:@"classschedule_objective"];
                            item.room = [[friday objectAtIndex:i] objectForKey:@"classschedule_room"];
                            item.startAt = [[friday objectAtIndex:i] objectForKey:@"classschedule_init"];
                            item.teacher = [[friday objectAtIndex:i] objectForKey:@"classschedule_teacher"];
                            item.weekday = [NSNumber numberWithInteger:[[[friday objectAtIndex:i] objectForKey:@"classschedule_weekday"]integerValue]];
                            
                            [coreDataService saveData];
                        }
                    }
                    
                    /////////////////////////////////////////////////
                    /// SATURDAY ////////////////////////////////////
                    /////////////////////////////////////////////////
                    
                    if([data objectForKey:@"saturday"])
                    {
                        NSArray *saturday = [data objectForKey:@"saturday"];
                        
                        for (NSInteger i = 0; i < saturday.count; i++)
                        {
                            ClassScheduleItem *item = (ClassScheduleItem *)[NSEntityDescription insertNewObjectForEntityForName:@"ClassScheduleItem"
                                                                                                         inManagedObjectContext:coreDataService.getManagedContext];
                            
                            item.classScheduleID = [NSNumber numberWithInteger:[[[saturday objectAtIndex:i] objectForKey:@"id_classschedule"]integerValue]];
                            item.amount = [NSNumber numberWithInteger:[[[saturday objectAtIndex:i] objectForKey:@"classschedule_amount"]integerValue]];
                            item.duration = [NSNumber numberWithInteger:[[[saturday objectAtIndex:i] objectForKey:@"classschedule_duration"]integerValue]];
                            item.name = [[saturday objectAtIndex:i] objectForKey:@"classschedule_name"];
                            item.objective = [[saturday objectAtIndex:i] objectForKey:@"classschedule_objective"];
                            item.room = [[saturday objectAtIndex:i] objectForKey:@"classschedule_room"];
                            item.startAt = [[saturday objectAtIndex:i] objectForKey:@"classschedule_init"];
                            item.teacher = [[saturday objectAtIndex:i] objectForKey:@"classschedule_teacher"];
                            item.weekday = [NSNumber numberWithInteger:[[[saturday objectAtIndex:i] objectForKey:@"classschedule_weekday"]integerValue]];
                            
                            [coreDataService saveData];
                        }
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
                
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                arrayClassScheduleItens = (NSMutableArray *)[coreDataService getDataFromClassScheduleItemTableByWeekDay:selectedWeekday];
                [self.tableView reloadData];
            }
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                          AndText:kTEXT_SERVER_ERROR_DEFAULT
                      AndTargetVC:self];
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
    lblMessage.textColor = UIColorFromRGB(kPRIMARY_COLOR);
    lblMessage.shadowColor = [UIColor colorWithWhite:0.9 alpha:0.5];
    lblMessage.shadowOffset = CGSizeMake(1,1);
    lblMessage.font = [UIFont systemFontOfSize:15];
    
    // Mensagem do label.
    lblMessage.text = @"Não há programação neste dia.";
    
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

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - NOTIFICATION METHODS

- (void)unlockClassScheduleTableview:(NSNotification *)notification
{
    self.tableView.scrollEnabled = TRUE;
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

