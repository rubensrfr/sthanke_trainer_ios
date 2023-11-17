//
//  assessoriaViewController.m
//
//
//  Created by Rubens Rosa on 11/04/2018.
//  Copyright © 2018 4mobi. All rights reserved.
//

#import "welcomeViewController.h"


@interface welcomeViewController ()

@end

@implementation welcomeViewController

@synthesize tableview;
@synthesize imgVideoThumb;
@synthesize product_id;
@synthesize training_id;
@synthesize welcome_video;
@synthesize productImage;
@synthesize videoBtnOL;
@synthesize productText;
@synthesize response_days;


//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//	 if ([[segue identifier] isEqualToString:@"segueQuestionsD"])
//    {
//        dadosPessoaisViewController *dpvc = [segue destinationViewController];
//        dpvc.training_id=training_id;
//		 
//    }
//    if ([[segue identifier] isEqualToString:@"segueQuestionsP"])
//    {
//        parQViewController *pqvc = [segue destinationViewController];
//        pqvc.training_id=training_id;
//		 
//    }
//    if ([[segue identifier] isEqualToString:@"segueQuestionsE"])
//    {
//        preferenciasViewController *pvc = [segue destinationViewController];
//   //     pvc.training_id=training_id;
//		 
//    }
//    if ([[segue identifier] isEqualToString:@"segueQuestionsQ"])
//    {
//        questionaryViewController *qvc = [segue destinationViewController];
//        qvc.training_id=training_id;
//		 
//    }
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=NOME_APLICATIVO;
	self.playerView.delegate = self;
	 NSUserDefaults *Defaults = [NSUserDefaults standardUserDefaults];
	 [Defaults setObject:training_id forKey:@"training_id"];
	 [Defaults synchronize];
	
	
    // Do any additional setup after loading the view.
	
	 productText.text=[[@"A entrega do seu treino personalizado será feita em até " stringByAppendingString:response_days] stringByAppendingString:@" dias a partir do recebimento dos questionários."];

    utils = [[UtilityClass alloc] init];
	
	if([welcome_video isEqualToString:@""] && productImage!=nil)
	{
		//imgVideoThumb.image= [UIImage imageNamed:productImage];
		videoBtnOL.hidden=YES;
		
			   // CAMINHO PARA RECUPERAR A IMAGEM DO TREINADOR.
//		 NSLog(@"1. Call md5 with input: %@",Product.image_store);
		 NSMutableString *pathImage = [[NSMutableString alloc] init];
		 [pathImage appendString:[utils returnDocumentsPath]];
		 [pathImage appendString:@"/Caches/StoreImages/"];
		 [pathImage appendString:[utils md5HexDigest:productImage]];
		 [pathImage appendString:@".png"];
		
		 // VERIFICA SE A IMAGEM EXISTE NO CAMINHO ESPECIFICADO.
		 BOOL imageExists = [[NSFileManager defaultManager] fileExistsAtPath:pathImage];
		
		 // SE EXISTE CARREGA, SENÃO CARREGA A IMAGEM PADRÃO.
			 if (imageExists)
			 {
				  UIImage *image = [UIImage imageWithContentsOfFile:pathImage];
				  imgVideoThumb.image = image;
			 }
			 else
			 {
					if([UIImage imageNamed:[utils md5HexDigest:productImage]])
						imgVideoThumb.image = [UIImage imageNamed:[utils md5HexDigest:productImage]];
			 }
	}
	else
	{
	   videoBtnOL.hidden=NO;
    	NSURL *youtubeURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://img.youtube.com/vi/%@/0.jpg",welcome_video]];
    	[imgVideoThumb setImageWithURL:youtubeURL placeholderImage:nil];
    	[self loadVideo];
	}
	
	
	  // Tweak para linhas extra na tabela.
     [self.tableview setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0,0, 320,50)]];
	 coreDataService = [[CoreDataService alloc] init];
    [coreDataService initialize];
	
    QuestionsE *questionsE = (QuestionsE *) [coreDataService getDataFromQuestionsETable:training_id];
	
    if(questionsE==nil)
    {
		 QuestionsE *questionsE = (QuestionsE *)[NSEntityDescription insertNewObjectForEntityForName:@"QuestionsE"
                                                                           inManagedObjectContext:coreDataService.getManagedContext];
       questionsE.estatus=STR_PENDENTE;
       questionsE.training_id=training_id;
       [self receberAnswersE:questionsE];
		 
	 }
	
	 QuestionsD *questionsD = (QuestionsD *) [coreDataService getDataFromQuestionsDTable:training_id];
	
    if(questionsD==nil)
    {
		 QuestionsD *questionsD = (QuestionsD *)[NSEntityDescription insertNewObjectForEntityForName:@"QuestionsD"
                                                                           inManagedObjectContext:coreDataService.getManagedContext];
       questionsD.dstatus=STR_PENDENTE;
       questionsD.training_id=training_id;
       [self receberAnswersD:questionsD];
		 
	 }
	
	 QuestionsP *questionsP = (QuestionsP *) [coreDataService getDataFromQuestionsPTable:training_id];
	
    if(questionsP==nil)
    {
		 QuestionsP *questionsP = (QuestionsP *)[NSEntityDescription insertNewObjectForEntityForName:@"QuestionsP"
                                                                           inManagedObjectContext:coreDataService.getManagedContext];
       questionsP.pstatus=STR_PENDENTE;
       questionsP.training_id=training_id;
       [self receberAnswersP:questionsP];
		 
	 }
	
	 QuestionsQ *questionsQ = (QuestionsQ *) [coreDataService getDataFromQuestionsQTable:training_id];
	
    if(questionsQ==nil)
    {
		 QuestionsQ *questionsQ = (QuestionsQ *)[NSEntityDescription insertNewObjectForEntityForName:@"QuestionsQ"
                                                                           inManagedObjectContext:coreDataService.getManagedContext];
       questionsQ.qstatus=STR_PENDENTE;
       questionsQ.training_id=training_id;
       [self receberAnswersQ:questionsQ];
		 
	 }
	
	[coreDataService saveData];
	
	[tableview reloadData];
	
	 
	
	
	
	
//	NSArray *arrayEnabledTraining = [NSArray alloc];
//	arrayEnabledTraining = [coreDataService getDataFromTrainingTableWithProductId:product_id];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [tableview reloadData];
	
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    UIImageView *accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Table_Seta"]];
    accessoryView.frame = CGRectMake((self.view.frame.size.width - 20), ((cell.frame.size.height / 2) - 7), 14, 14);
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
  //  cell.contentView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.6f];
}




////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//	
//	return 100.0f;
//
//}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	
   return 4;
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
	return 70;
}



////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
		 static NSString *CellIdentifier = @"questionsCell";
	
		 questionsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
	
		 if (!cell)
		 {
			  cell = [[questionsCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		 }
	
	
		if(indexPath.row==0)
		 {
		 	cell.questionsTitle.text=@"Dados Pessoais";
		// 	cell.questionsDescription.text=@"Responda ao questionário atentamente";
		
			QuestionsD *questionsD = (QuestionsD *) [coreDataService getDataFromQuestionsDTable:training_id];
	
    		if(questionsD!=nil)
    		{
		 		if([questionsD.dstatus isEqualToString: STR_PENDENTE])
				{
						cell.questionsStatus.textColor=UIColorFromRGB(0xD22E2E);
					   cell.questionsStatus.text = @"PENDENTE";
				}
				if([questionsD.dstatus isEqualToString: STR_ANDAMENTO])
				{
						cell.questionsStatus.textColor=UIColorFromRGB(0x868686);
					   cell.questionsStatus.text = @"EM ANDAMENTO";
				}
				if([questionsD.dstatus isEqualToString:STR_CONCLUIDO])
				{
						cell.questionsStatus.textColor=UIColorFromRGB(0x038A57);
					   cell.questionsStatus.text = @"CONCLUIDO";
				}
				
			 }
	
		
		 }
	
		 if(indexPath.row==1)
		 {
		 	cell.questionsTitle.text=@"PAR-Q";
		// 	cell.questionsDescription.text=@"Responda ao questionário atentamente";
		
			QuestionsP *questionsP = (QuestionsP *) [coreDataService getDataFromQuestionsPTable:training_id];
	
    		if(questionsP!=nil)
    		{
		 		if([questionsP.pstatus isEqualToString: STR_PENDENTE])
				{
						cell.questionsStatus.textColor=UIColorFromRGB(0xD22E2E);
					   cell.questionsStatus.text = @"PENDENTE";
				}
				if([questionsP.pstatus isEqualToString: STR_ANDAMENTO])
				{
						cell.questionsStatus.textColor=UIColorFromRGB(0x868686);
					   cell.questionsStatus.text = @"EM ANDAMENTO";
				}
				if([questionsP.pstatus isEqualToString:STR_CONCLUIDO])
				{
						cell.questionsStatus.textColor=UIColorFromRGB(0x038A57);
					   cell.questionsStatus.text = @"CONCLUIDO";
				}
				
			 }
	
		
		 }
	
		 if(indexPath.row==2)
		 {
		 	cell.questionsTitle.text=@"Preferências";
		// 	cell.questionsDescription.text=@"Responda ao questionário atentamente";
		
			 QuestionsE *questionsE = (QuestionsE *) [coreDataService getDataFromQuestionsETable:training_id];
	
    		if(questionsE!=nil)
    		{
		 		if([questionsE.estatus isEqualToString: STR_PENDENTE])
				{
						cell.questionsStatus.textColor=UIColorFromRGB(0xD22E2E);
					   cell.questionsStatus.text = @"PENDENTE";
				}
				if([questionsE.estatus isEqualToString: STR_ANDAMENTO])
				{
						cell.questionsStatus.textColor=UIColorFromRGB(0x868686);
					   cell.questionsStatus.text = @"EM ANDAMENTO";
				}
				if([questionsE.estatus isEqualToString:STR_CONCLUIDO])
				{
						cell.questionsStatus.textColor=UIColorFromRGB(0x038A57);
					   cell.questionsStatus.text = @"CONCLUIDO";
				}
				
			 }
	
		
		 }
	
	
		 if(indexPath.row==3)
		 {
		 	cell.questionsTitle.text=@"Medidas";
		// 	cell.questionsDescription.text=@"Responda ao questionário atentamente";
		
			 QuestionsQ *questionsQ = (QuestionsQ *) [coreDataService getDataFromQuestionsQTable:training_id];
		
    		if(questionsQ!=nil)
    		{
		 		if([questionsQ.qstatus isEqualToString: STR_PENDENTE])
				{
						cell.questionsStatus.textColor=UIColorFromRGB(0xD22E2E);
					   cell.questionsStatus.text = @"PENDENTE";
				}
				if([questionsQ.qstatus isEqualToString: STR_ANDAMENTO])
				{
						cell.questionsStatus.textColor=UIColorFromRGB(0x868686);
					   cell.questionsStatus.text = @"EM ANDAMENTO";
				}
				if([questionsQ.qstatus isEqualToString:STR_CONCLUIDO])
				{
						cell.questionsStatus.textColor=UIColorFromRGB(0x038A57);
					   cell.questionsStatus.text = @"CONCLUIDO";
				}
				
			 }
	
		
		 }
		 return cell;
	
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	
    	if(indexPath.row==0)
			[self performSegueWithIdentifier:@"segueQuestionsD" sender:self];
    	if(indexPath.row==1)
			[self performSegueWithIdentifier:@"segueQuestionsP" sender:self];
		if(indexPath.row==2)
			[self performSegueWithIdentifier:@"segueQuestionsE" sender:self];
		if(indexPath.row==3)
			[self performSegueWithIdentifier:@"segueQuestionsQ" sender:self];
	
	
}





////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - ACTIONS

- (void)loadVideo
{


    if (welcome_video.length > 0)
    {
   //  [self.playerView loadWithVideoId:exercise.video];
		 
		NSDictionary *playerVars = @{
		@"showinfo": @0,
		@"playsinline" : @0,
		@"rel": @0,
		@"ecver:": @2,
		@"modestbranding": @1
		};


		[self.playerView loadWithVideoId:welcome_video playerVars:playerVars];
		 
   //     XCDYouTubeVideoPlayerViewController *videoPlayerVC = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:exercise.video];
   //     [self presentMoviePlayerViewControllerAnimated:videoPlayerVC];
    }
    else
    {
        [SVProgressHUD showImage:[UIImage imageNamed:@"Video_Alert"]
                          status:@"Vídeo Indisponível!"
                        maskType:SVProgressHUDMaskTypeGradient];
    }
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state {
  switch (state) {
    case kYTPlayerStatePlaying:
      NSLog(@"Started playback");
      break;
      case kYTPlayerStateEnded:
      {
      NSLog(@"Finished playback");
      [self dismissViewControllerAnimated:YES completion:nil];
         }
      break;
    case kYTPlayerStatePaused:
      NSLog(@"Paused playback");
      break;
    default:
      break;
  }
}

- (IBAction)playVideo:(id)sender {
  [self.playerView playVideo];
}

- (IBAction)stopVideo:(id)sender {
  [self.playerView stopVideo];
}




- (void)receberAnswersD:(QuestionsD *) questionsd
{
 // Cria um operation manager para realizar a solicitação via POST.
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//	 [manager.requestSerializer setTimeoutInterval:AFHHTTP_TIMEOUT];
	
    // Monta a string de acesso a validação do login.
    NSMutableString *urlString = [[NSMutableString alloc] init];
    [urlString appendString:kBASE_URL_MOBITRAINER];
    [urlString appendString:@"api/anamnese/getanswers"];
	User *userData = (User *) [coreDataService getDataFromUserTable];
	
	
     // Parametros validados.
    NSDictionary *parameters = @{
                                 @"apikey":API_KEY_TRAINER,
                                 @"trainee_email":userData.email,
                                 @"inapptraining_id":training_id
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
			  
			  
			  NSArray *dictAnswers = [[NSArray alloc] initWithArray:[responseObject objectForKey:@"answers"]];
 
				questionsd.qd01=@"Nome";
				questionsd.qd02=@"Sobrenome";
				questionsd.qd03=@"E-mail";
				questionsd.qd04=@"Data de nascimento";
				questionsd.qd05=@"Sexo";
				questionsd.qd06=@"Estado civil";
				questionsd.qd07=@"Profissão";
				questionsd.qd08=@"Peso atual";
				questionsd.qd09=@"Altura";
				questionsd.qd10=@"Percentual de gordura";
				questionsd.qd11=@"Percentual de massa muscular";
				questionsd.qd12=@"Frequencia cardiaca em repouso (BPM)";
				questionsd.qd13=@"";
				questionsd.qd14=@"";
				questionsd.qd15=@"";
				questionsd.qd16=@"";
				questionsd.qd17=@"";
				questionsd.qd18=@"";
				questionsd.qd19=@"";
				questionsd.qd20=@"";
			   questionsd.d01=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ad01"]];
				questionsd.d02=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ad02"]];
				questionsd.d03=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ad03"]];
				questionsd.d04=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ad04"]];
			   questionsd.d05=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ad05"]];
				questionsd.d06=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ad06"]];
				questionsd.d07=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ad07"]];
				questionsd.d08=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ad08"]];
			   questionsd.d09=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ad09"]];
				questionsd.d10=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ad10"]];
				questionsd.d11=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ad11"]];
				questionsd.d12=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ad12"]];
				questionsd.d13=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ad13"]];
				questionsd.d14=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ad14"]];
				questionsd.d15=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ad15"]];
				questionsd.d16=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ad16"]];
				questionsd.d17=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ad17"]];
				questionsd.d18=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ad18"]];
				questionsd.d19=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ad19"]];
				questionsd.d20=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ad20"]];
				questionsd.dstatus=STR_CONCLUIDO;
            [tableview reloadData];
				
        }
        else
        {
            [SVProgressHUD dismiss];

		      questionsd.dstatus=STR_PENDENTE;
			   [tableview reloadData];
			  
            }
   } failure:^(NSURLSessionTask *operation, NSError *error) {
		
        NSLog(@"Error: %@", error);
		
        [SVProgressHUD dismiss];
		
        [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                          AndText:kTEXT_SERVER_ERROR_DEFAULT
                      AndTargetVC:self];
    }];

}


- (void)receberAnswersE:(QuestionsE *) questionse
{
	 // Cria um operation manager para realizar a solicitação via POST.
 //   AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//	 [manager.requestSerializer setTimeoutInterval:AFHHTTP_TIMEOUT];
	
    // Monta a string de acesso a validação do login.
    NSMutableString *urlString = [[NSMutableString alloc] init];
    [urlString appendString:kBASE_URL_MOBITRAINER];
    [urlString appendString:@"api/anamnese/getanswers"];
	User *userData = (User *) [coreDataService getDataFromUserTable];
	
	
     // Parametros validados.
    NSDictionary *parameters = @{
                                 @"apikey":API_KEY_TRAINER,
                                 @"trainee_email":userData.email,
                                 @"inapptraining_id":training_id
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
			  
  			  NSArray *dictAnswers = [[NSArray alloc] initWithArray:[responseObject objectForKey:@"answers"]];
	
				questionse.qe01=@"Com qual freqüência semanal pretende treinar?";
				questionse.qe02=@"Quais os dias disponíveis da semana para treinos?";
				questionse.qe03=@"Quantos minutos por dia você tem disponível para treinar?";
				questionse.qe04=@"Quais os períodos de horário de sua preferência?";
				questionse.qe05=@"Caso faça exercícios atualmente, descreva seu treino, por favor.";
				questionse.qe06=@"Tem algum exercício que goste muito e que, se possível, seja incluído no seu treino?";
				questionse.qe07=@"Existe algum exercício específico ou abordagem que não goste de fazer em rotinas de treino, ou que cause algum tipo de desconforto?";
				questionse.qe08=@"Gosta de exercícios aeróbicos?";
				questionse.qe09=@"Descreva o ambiente onde pretende treinar com o treino elaborado pela assessoria";
				questionse.qe10=@"Faça um breve resumo sobre você";
				questionse.qe11=@"Quais são os seus objetivos e expectativas em relação a assessoria?";
				questionse.qe12=@"Se deseja emagrecer, qual a sua meta (Kg)";
				questionse.qe13=@"Mais Detalhes (Use esse espaço para suas considerações e ou observações adicionais)";
				questionse.qe14=@"";
				questionse.qe15=@"";
				questionse.qe16=@"";
				questionse.qe17=@"";
				questionse.qe18=@"";
				questionse.qe19=@"";
				questionse.qe20=@"";
			   questionse.e01=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ae01"]];
				questionse.e02=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ae02"]];
				questionse.e03=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ae03"]];
				questionse.e04=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ae04"]];
			   questionse.e05=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ae05"]];
				questionse.e06=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ae06"]];
				questionse.e07=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ae07"]];
				questionse.e08=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ae08"]];
			   questionse.e09=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ae09"]];
				questionse.e10=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ae10"]];
				questionse.e11=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ae11"]];
				questionse.e12=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ae12"]];
				questionse.e13=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ae13"]];
				questionse.e14=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ae14"]];
				questionse.e15=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ae15"]];
				questionse.e16=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ae16"]];
				questionse.e17=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ae17"]];
				questionse.e18=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ae18"]];
				questionse.e19=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ae19"]];
				questionse.e20=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ae20"]];
				questionse.estatus=STR_CONCLUIDO;
            [tableview reloadData];
				
        }
        else
        {
            [SVProgressHUD dismiss];

		      questionse.estatus=STR_PENDENTE;
			   [tableview reloadData];
			  
            }
   } failure:^(NSURLSessionTask *operation, NSError *error) {
		
        NSLog(@"Error: %@", error);
		
        [SVProgressHUD dismiss];
		
        [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                          AndText:kTEXT_SERVER_ERROR_DEFAULT
                      AndTargetVC:self];
    }];
}


- (void)receberAnswersP:(QuestionsP *) questionsp
{
	 // Cria um operation manager para realizar a solicitação via POST.
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//	 [manager.requestSerializer setTimeoutInterval:AFHHTTP_TIMEOUT];
	
    // Monta a string de acesso a validação do login.
    NSMutableString *urlString = [[NSMutableString alloc] init];
    [urlString appendString:kBASE_URL_MOBITRAINER];
    [urlString appendString:@"api/anamnese/getanswers"];
	User *userData = (User *) [coreDataService getDataFromUserTable];
	
	
     // Parametros validados.
    NSDictionary *parameters = @{
                                 @"apikey":API_KEY_TRAINER,
                                 @"trainee_email":userData.email,
                                 @"inapptraining_id":training_id
                                 };
	
	
	
	
     // Realiza o POST das informações e aguarda o retorno.
 //   [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
	 AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
 			[manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
 			NSString *path=[[NSString alloc]initWithFormat:@"%@",urlString];
 			[manager POST:[NSURL URLWithString:path].absoluteString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
  	 {    if (![[responseObject objectForKey:@"response_error"] boolValue])
        {
			  
			  NSArray *dictAnswers = [[NSArray alloc] initWithArray:[responseObject objectForKey:@"answers"]];
	
				questionsp.qp01=@"Alguma vez um médico lhe disse que você possui um problema do coração e lhe recomendou que só fizesse atividade física sob supervisão médica?";
				questionsp.qp02=@"Você sente dor no peito, causada pela prática de atividade física?";
				questionsp.qp03=@"Você sentiu dor no peito no último mês?";
				questionsp.qp04=@"Você tende a perder a consciência ou cair, como resultado de tonteira ou desmaio?";
				questionsp.qp05=@"Você tem algum problema ósseo ou muscular que poderia ser agravado com a prática de atividade física?";
				questionsp.qp06=@"Algum médico já lhe recomendou o uso de medicamentos para a sua pressão arterial, para circulação ou coração?";
				questionsp.qp07=@"Você tem consciência, através da sua própria experiência ou aconselhamento médico, de alguma outra razão física que impeça sua prática de atividade física sem supervisão médica?";
				questionsp.qp08=@"";
				questionsp.qp09=@"";
				questionsp.qp10=@"";
				questionsp.qp11=@"";
				questionsp.qp12=@"";
				questionsp.qp13=@"";
				questionsp.qp14=@"";
				questionsp.qp15=@"";
				questionsp.qp16=@"";
				questionsp.qp17=@"";
				questionsp.qp18=@"";
				questionsp.qp19=@"";
				questionsp.qp20=@"";
			   questionsp.p01=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ap01"]];
				questionsp.p02=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ap02"]];
				questionsp.p03=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ap03"]];
				questionsp.p04=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ap04"]];
			   questionsp.p05=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ap05"]];
				questionsp.p06=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ap06"]];
				questionsp.p07=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ap07"]];
				questionsp.p08=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ap08"]];
			   questionsp.p09=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ap09"]];
				questionsp.p10=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ap10"]];
				questionsp.p11=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ap11"]];
				questionsp.p12=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ap12"]];
				questionsp.p13=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ap13"]];
				questionsp.p14=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ap14"]];
				questionsp.p15=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ap15"]];
				questionsp.p16=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ap16"]];
				questionsp.p17=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ap17"]];
				questionsp.p18=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ap18"]];
				questionsp.p19=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ap19"]];
				questionsp.p20=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ap20"]];
				questionsp.pstatus=STR_CONCLUIDO;
	         [tableview reloadData];
				
        }
        else
        {
            [SVProgressHUD dismiss];

		      questionsp.pstatus=STR_PENDENTE;
			   [tableview reloadData];
			  
            }
   } failure:^(NSURLSessionTask *operation, NSError *error) {
		
        NSLog(@"Error: %@", error);
		
        [SVProgressHUD dismiss];
		
        [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                          AndText:kTEXT_SERVER_ERROR_DEFAULT
                      AndTargetVC:self];
    }];
}


- (void)receberAnswersQ:(QuestionsQ *) questionsq
{
	 // Cria um operation manager para realizar a solicitação via POST.
 //   AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//	 [manager.requestSerializer setTimeoutInterval:AFHHTTP_TIMEOUT];
	
    // Monta a string de acesso a validação do login.
    NSMutableString *urlString = [[NSMutableString alloc] init];
    [urlString appendString:kBASE_URL_MOBITRAINER];
    [urlString appendString:@"api/anamnese/getanswers"];
	User *userData = (User *) [coreDataService getDataFromUserTable];
	
	
     // Parametros validados.
    NSDictionary *parameters = @{
                                 @"apikey":API_KEY_TRAINER,
                                 @"trainee_email":userData.email,
                                 @"inapptraining_id":training_id
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
			  
 		  NSArray *dictAnswers = [[NSArray alloc] initWithArray:[responseObject objectForKey:@"answers"]];
	
				questionsq.qq01=@"Quantas horas trabalha por dia?";
				questionsq.qq02=@"Como você trabalha?";
				questionsq.qq03=@"Quais seus objetivos principais e secundários com a prática do exercício físico?";
				questionsq.qq04=@"Realizou consulta médica nos últimos 3 meses para iniciar ou manter um programa de exercícios físicos?";
				questionsq.qq05=@"Você pratica alguma atividade física? ";
				questionsq.qq06=@"Você pratica algum esporte específico?";
				questionsq.qq07=@"Tem algum parente cardiopata, com diabetes ou doença crônica?";
				questionsq.qq08=@"Você sofre de alguma doença?";
				questionsq.qq09=@"Você já fez alguma cirurgia?";
				questionsq.qq10=@"Sofreu algum acidente ou lesão osteoarticular?";
				questionsq.qq11=@"Faz uso de algum medicamento?";
				questionsq.qq12=@"Qual o seu nível de Estresse?";
				questionsq.qq13=@"Você possui algum tipo de alergia?";
				questionsq.qq14=@"Sente dores na coluna?";
				questionsq.qq15=@"Você possui algum histórico de lesão?";
				questionsq.qq16=@"Sente algum incômodo ou desconforto, que deva ser relatado?";
				questionsq.qq17=@"É fumante ou ex fumante?";
				questionsq.qq18=@"Ingere bebidas alcoólicas?";
				questionsq.qq19=@"Atualmente você está tendo acompanhamento nutricional?";
				questionsq.qq20=@"Comente sobre seus hábitos alimentares";
			   questionsq.q01=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"aq01"]];
			   questionsq.q01=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"aq01"]];
				questionsq.q02=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"aq02"]];
				questionsq.q03=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"aq03"]];
				questionsq.q04=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"aq04"]];
			   questionsq.q05=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"aq05"]];
				questionsq.q06=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"aq06"]];
				questionsq.q07=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"aq07"]];
				questionsq.q08=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"aq08"]];
			   questionsq.q09=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"aq09"]];
				questionsq.q10=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"aq10"]];
				questionsq.q11=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"aq11"]];
				questionsq.q12=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"aq12"]];
				questionsq.q13=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"aq13"]];
				questionsq.q14=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"aq14"]];
				questionsq.q15=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"aq15"]];
				questionsq.q16=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"aq16"]];
				questionsq.q17=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"aq17"]];
				questionsq.q18=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"aq18"]];
				questionsq.q19=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"aq19"]];
				questionsq.q20=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"aq20"]];
				questionsq.qstatus=STR_CONCLUIDO;
            [tableview reloadData];
				
        }
        else
        {
            [SVProgressHUD dismiss];

		      questionsq.qstatus=STR_PENDENTE;
			   [tableview reloadData];
			  
            }
   } failure:^(NSURLSessionTask *operation, NSError *error) {
		
        NSLog(@"Error: %@", error);
		
        [SVProgressHUD dismiss];
		
        [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                          AndText:kTEXT_SERVER_ERROR_DEFAULT
                      AndTargetVC:self];
    }];
}



//- (void)receberAnamineseCompleta
//{
//
//
//    // Cria um operation manager para realizar a solicitação via POST.
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//	 [manager.requestSerializer setTimeoutInterval:AFHHTTP_TIMEOUT];
//
//    // Monta a string de acesso a validação do login.
//    NSMutableString *urlString = [[NSMutableString alloc] init];
//    [urlString appendString:kBASE_URL_MOBITRAINER];
//    [urlString appendString:@"api/anamnese/getanswers"];
//	User *userData = (User *) [coreDataService getDataFromUserTable];
//
//
//     // Parametros validados.
//    NSDictionary *parameters = @{
//                                 @"apikey":API_KEY_TRAINER,
//                                 @"trainee_email":userData.email,
//                                 @"inapptraining_id":training_id
//                                 };
//
//
//
//
//    // Realiza o POST das informações e aguarda o retorno.
//    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//
//        if (![[responseObject objectForKey:@"response_error"] boolValue])
//        {
//
//        		/// PEGA OS DADOS DOS TREINOS //////////////////////////////////////////
//            ////////////////////////////////////////////////////////////////////////
//			  NSArray *dictAnswers = [[NSArray alloc] initWithArray:[responseObject objectForKey:@"answers"]];
//          //  NSDictionary *dictAnswers = [responseObject objectForKey:@"answers"];
//            [coreDataService dropQuestionsQTable];
//				QuestionsQ *questionsq = (QuestionsQ *)[NSEntityDescription insertNewObjectForEntityForName:@"QuestionsQ"
//                                                                           inManagedObjectContext:coreDataService.getManagedContext];
//
//			   questionsq.qq01=@"Quantas horas trabalha por dia?";
//				questionsq.qq02=@"Como você trabalha?";
//				questionsq.qq03=@"Quais seus objetivos principais e secundários com a prática do exercício físico?";
//				questionsq.qq04=@"Realizou consulta médica nos últimos 3 meses para iniciar ou manter um programa de exercícios físicos?";
//				questionsq.qq05=@"Você pratica alguma atividade física? ";
//				questionsq.qq06=@"Você pratica algum esporte específico?";
//				questionsq.qq07=@"Tem algum parente cardiopata, com diabetes ou doença crônica?";
//				questionsq.qq08=@"Você sofre de alguma doença?";
//				questionsq.qq09=@"Você já fez alguma cirurgia?";
//				questionsq.qq10=@"Sofreu algum acidente ou lesão osteoarticular?";
//				questionsq.qq11=@"Faz uso de algum medicamento?";
//				questionsq.qq12=@"Qual o seu nível de Estresse?";
//				questionsq.qq13=@"Você possui algum tipo de alergia?";
//				questionsq.qq14=@"Sente dores na coluna?";
//				questionsq.qq15=@"Você possui algum histórico de lesão?";
//				questionsq.qq16=@"Sente algum incômodo ou desconforto, que deva ser relatado?";
//				questionsq.qq17=@"É fumante ou ex fumante?";
//				questionsq.qq18=@"Ingere bebidas alcoólicas?";
//				questionsq.qq19=@"Atualmente você está tendo acompanhamento nutricional?";
//				questionsq.qq20=@"Comente sobre seus hábitos alimentares";
//			   questionsq.q01=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"aq01"]];
//			   questionsq.q01=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"aq01"]];
//				questionsq.q02=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"aq02"]];
//				questionsq.q03=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"aq03"]];
//				questionsq.q04=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"aq04"]];
//			   questionsq.q05=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"aq05"]];
//				questionsq.q06=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"aq06"]];
//				questionsq.q07=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"aq07"]];
//				questionsq.q08=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"aq08"]];
//			   questionsq.q09=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"aq09"]];
//				questionsq.q10=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"aq10"]];
//				questionsq.q11=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"aq11"]];
//				questionsq.q12=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"aq12"]];
//				questionsq.q13=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"aq13"]];
//				questionsq.q14=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"aq14"]];
//				questionsq.q15=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"aq15"]];
//				questionsq.q16=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"aq16"]];
//				questionsq.q17=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"aq17"]];
//				questionsq.q18=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"aq18"]];
//				questionsq.q19=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"aq19"]];
//				questionsq.q20=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"aq20"]];
//				questionsq.qstatus=STR_CONCLUIDO;
//
//				 [coreDataService dropQuestionsDTable];
//				QuestionsD *questionsd = (QuestionsD *)[NSEntityDescription insertNewObjectForEntityForName:@"QuestionsD"
//                                                                           inManagedObjectContext:coreDataService.getManagedContext];
//
//				questionsd.qd01=@"Nome";
//				questionsd.qd02=@"Sobrenome";
//				questionsd.qd03=@"E-mail";
//				questionsd.qd04=@"Data de nascimento";
//				questionsd.qd05=@"Sexo";
//				questionsd.qd06=@"Estado civil";
//				questionsd.qd07=@"Profissão";
//				questionsd.qd08=@"Peso atual";
//				questionsd.qd09=@"Altura";
//				questionsd.qd10=@"Percentual de gordura";
//				questionsd.qd11=@"Percentual de massa muscular";
//				questionsd.qd12=@"Frequencia cardiaca em repouso (BPM)";
//				questionsd.qd13=@"";
//				questionsd.qd14=@"";
//				questionsd.qd15=@"";
//				questionsd.qd16=@"";
//				questionsd.qd17=@"";
//				questionsd.qd18=@"";
//				questionsd.qd19=@"";
//				questionsd.qd20=@"";
//			   questionsd.d01=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ad01"]];
//				questionsd.d02=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ad02"]];
//				questionsd.d03=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ad03"]];
//				questionsd.d04=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ad04"]];
//			   questionsd.d05=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ad05"]];
//				questionsd.d06=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ad06"]];
//				questionsd.d07=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ad07"]];
//				questionsd.d08=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ad08"]];
//			   questionsd.d09=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ad09"]];
//				questionsd.d10=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ad10"]];
//				questionsd.d11=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ad11"]];
//				questionsd.d12=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ad12"]];
//				questionsd.d13=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ad13"]];
//				questionsd.d14=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ad14"]];
//				questionsd.d15=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ad15"]];
//				questionsd.d16=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ad16"]];
//				questionsd.d17=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ad17"]];
//				questionsd.d18=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ad18"]];
//				questionsd.d19=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ad19"]];
//				questionsd.d20=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ad20"]];
//			   questionsd.dstatus=STR_CONCLUIDO;
//
//			[coreDataService dropQuestionsETable];
//				QuestionsE *questionse = (QuestionsE *)[NSEntityDescription insertNewObjectForEntityForName:@"QuestionsE"
//                                                                           inManagedObjectContext:coreDataService.getManagedContext];
//
//				questionse.qe01=@"Com qual freqüência semanal pretende treinar?";
//				questionse.qe02=@"Quais os dias disponíveis da semana para treinos?";
//				questionse.qe03=@"Quantos minutos por dia você tem disponível para treinar?";
//				questionse.qe04=@"Quais os períodos de horário de sua preferência?";
//				questionse.qe05=@"Caso faça exercícios atualmente, descreva seu treino, por favor.";
//				questionse.qe06=@"Tem algum exercício que goste muito e que, se possível, seja incluído no seu treino?";
//				questionse.qe07=@"Existe algum exercício específico ou abordagem que não goste de fazer em rotinas de treino, ou que cause algum tipo de desconforto?";
//				questionse.qe08=@"Gosta de exercícios aeróbicos?";
//				questionse.qe09=@"Descreva o ambiente onde pretende treinar com a o treino elaborado pela assessoria";
//				questionse.qe10=@"Faça um breve resumo sobre você";
//				questionse.qe11=@"Quais são os seus objetivos e expectativas em relação a assessoria?";
//				questionse.qe12=@"Se deseja emagrecer, qual a sua meta (Kg)";
//				questionse.qe13=@"Mais Detalhes (Use esse espaço para suas considerações e ou observações adicionais)";
//				questionse.qe14=@"";
//				questionse.qe15=@"";
//				questionse.qe16=@"";
//				questionse.qe17=@"";
//				questionse.qe18=@"";
//				questionse.qe19=@"";
//				questionse.qe20=@"";
//			   questionse.e01=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ae01"]];
//				questionse.e02=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ae02"]];
//				questionse.e03=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ae03"]];
//				questionse.e04=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ae04"]];
//			   questionse.e05=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ae05"]];
//				questionse.e06=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ae06"]];
//				questionse.e07=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ae07"]];
//				questionse.e08=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ae08"]];
//			   questionse.e09=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ae09"]];
//				questionse.e10=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ae10"]];
//				questionse.e11=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ae11"]];
//				questionse.e12=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ae12"]];
//				questionse.e13=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ae13"]];
//				questionse.e14=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ae14"]];
//				questionse.e15=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ae15"]];
//				questionse.e16=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ae16"]];
//				questionse.e17=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ae17"]];
//				questionse.e18=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ae18"]];
//				questionse.e19=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ae19"]];
//				questionse.e20=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ae20"]];
//				questionse.estatus=STR_CONCLUIDO;
//
//				[coreDataService dropQuestionsPTable];
//				QuestionsP *questionsp = (QuestionsP *)[NSEntityDescription insertNewObjectForEntityForName:@"QuestionsP"
//                                                                           inManagedObjectContext:coreDataService.getManagedContext];
//
//				questionsp.qp01=@"Alguma vez um médico lhe disse que você possui um problema do coração e lhe recomendou que só fizesse atividade física sob supervisão médica?";
//				questionsp.qp02=@"Você sente dor no peito, causada pela prática de atividade física?";
//				questionsp.qp03=@"Você sentiu dor no peito no último mês?";
//				questionsp.qp04=@"Você tende a perder a consciência ou cair, como resultado de tonteira ou desmaio?";
//				questionsp.qp05=@"Você tem algum problema ósseo ou muscular que poderia ser agravado com a prática de atividade física?";
//				questionsp.qp06=@"Algum médico já lhe recomendou o uso de medicamentos para a sua pressão arterial, para circulação ou coração?";
//				questionsp.qp07=@"Você tem consciência, através da sua própria experiência ou aconselhamento médico, de alguma outra razão física que impeça sua prática de atividade física sem supervisão médica?";
//				questionsp.qp08=@"";
//				questionsp.qp09=@"";
//				questionsp.qp10=@"";
//				questionsp.qp11=@"";
//				questionsp.qp12=@"";
//				questionsp.qp13=@"";
//				questionsp.qp14=@"";
//				questionsp.qp15=@"";
//				questionsp.qp16=@"";
//				questionsp.qp17=@"";
//				questionsp.qp18=@"";
//				questionsp.qp19=@"";
//				questionsp.qp20=@"";
//			   questionsp.p01=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ap01"]];
//				questionsp.p02=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ap02"]];
//				questionsp.p03=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ap03"]];
//				questionsp.p04=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ap04"]];
//			   questionsp.p05=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ap05"]];
//				questionsp.p06=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ap06"]];
//				questionsp.p07=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ap07"]];
//				questionsp.p08=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ap08"]];
//			   questionsp.p09=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ap09"]];
//				questionsp.p10=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ap10"]];
//				questionsp.p11=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ap11"]];
//				questionsp.p12=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ap12"]];
//				questionsp.p13=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ap13"]];
//				questionsp.p14=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ap14"]];
//				questionsp.p15=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ap15"]];
//				questionsp.p16=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ap16"]];
//				questionsp.p17=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ap17"]];
//				questionsp.p18=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ap18"]];
//				questionsp.p19=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ap19"]];
//				questionsp.p20=[utils checkString:[[dictAnswers objectAtIndex:0] objectForKey:@"ap20"]];
//				questionsp.pstatus=STR_CONCLUIDO;
//				[coreDataService saveData];
//
//        }
//        else
//        {
//            [SVProgressHUD dismiss];
////			   questionsd.dstatus=STR_PENDENTE;
////			   questionse.estatus=STR_PENDENTE;
////			   questionsq.qstatus=STR_PENDENTE;
////			   questionsp.pstatus=STR_PENDENTE;
//                    [utils showAlertWithTitle:kTEXT_ALERT_TITLE
//                                      AndText: @"Em seguida responda aos questionários"
//                                  AndTargetVC:self];
//
//            }
//   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//
//        NSLog(@"Error: %@", error);
//
//        [SVProgressHUD dismiss];
//
//        [utils showAlertWithTitle:kTEXT_ALERT_TITLE
//                          AndText:kTEXT_SERVER_ERROR_DEFAULT
//                      AndTargetVC:self];
//    }];
//}



@end
