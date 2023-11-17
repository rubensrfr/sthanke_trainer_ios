//
//  ListAllViewController.m
//
//
//  Created by Rubens Rosa on 15/03/2018.
//  Copyright © 2018 4mobi. All rights reserved.
//


#import "ListAllViewController.h"
//#import <CCDropDownMenu/CCDropDownMenus.h>

@interface ListAllViewController()

//<CCDropDownMenuDelegate>
//
//@property (nonatomic, strong) ManaDropDownMenu *menu1;
//@property (nonatomic, strong) GaiDropDownMenu *menu2;
//@property (nonatomic, strong) SyuDropDownMenu *menu3;

@end

@implementation ListAllViewController

@synthesize treineeID;
@synthesize btnReload;
@synthesize isHistory;
@synthesize treineeEmail;
@synthesize tableViewMeusTreinos;
@synthesize imageUser;
@synthesize nameUser;
@synthesize emailUser;
@synthesize chatIcon;
@synthesize loginBackgroundImage;
@synthesize iconBackgroungImage;
@synthesize buttonLogin;
@synthesize buttonMais;




////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - SEGUE

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableViewMeusTreinos indexPathForSelectedRow];

//    if ([[segue identifier] isEqualToString:@"segueCompras"])
//    {
//        AssesoriaTableViewController *aatvc = [segue destinationViewController];
//        InAppProducts *Product = [inAppProdutosMutArray objectAtIndex:[indexPath row]];
//        aatvc.title = @"Compra";
//        aatvc.productId = Product.product_id;
//        aatvc.productPrice = Product.preco;
//        aatvc.productDeliverDays = [Product.response_days stringValue];
//        aatvc.productDescription = Product.descricao;
//        aatvc.productVideo=Product.video;
//        aatvc.productImage=Product.image_product;
//    }
    if ([[segue identifier] isEqualToString:@"segueInAppTreinos"])
    {
        MeusInAPPViewController *miavc = [segue destinationViewController];
		 InAppTransactions *Transaction = [inAppTransactionsMutArray objectAtIndex:[indexPath row]];
		 
        miavc.title = @"Treino";
        miavc.training_id = Transaction.training_id;
        miavc.digitalproduct_id = Transaction.digitalproduct_id;
        miavc.product_id = Transaction.product_id;
        miavc.sale_video = Transaction.sale_video;
        miavc.training_description = Transaction.training_description;
        miavc.welcome_video = Transaction.welcome_video;
        miavc.training_name = Transaction.training_name;
        if([Transaction.isonlineadvisor boolValue]==FALSE)
        		miavc.training_is_inapp = TRUE;
        	else
				miavc.training_is_inapp = FALSE;

    }
	
	 if ([[segue identifier] isEqualToString:@"segueMeusTreinos"]) //
    {
        MeusTreinosViewController *mtvc = [segue destinationViewController];
		// InAppTransactions *Transaction = [inAppTransactionsMutArray objectAtIndex:[indexPath row]];
        mtvc.title = @"Treino";
      //  mtvc.trainin = Transaction.product_id;

    }
	
	
    if ([[segue identifier] isEqualToString:@"segueWelcome"])
    {
        welcomeViewController *wtvc = [segue destinationViewController];
		 InAppTransactions *Transaction = [inAppTransactionsMutArray objectAtIndex:[indexPath row]];
     //   mtvc.title = @"Treino";
        wtvc.product_id = Transaction.product_id;
		  wtvc.training_id = Transaction.training_id;
		  wtvc.welcome_video = Transaction.welcome_video;
		  wtvc.response_days=[Transaction.response_days stringValue];;
		 // InAppProducts *thisProduct= [coreDataService getInAppProductDataWithProductId:Transaction.product_id];
		   wtvc.productImage=Transaction.image_product;
		 
    }
	
//    if ([[segue identifier] isEqualToString:@"segueDetalhes"])
//    {
//       AssesoriaTableViewController *aatvc = [segue destinationViewController];
//        InAppProducts *Product = [inAppProdutosMutArray objectAtIndex:[indexPath row]];
//        aatvc.title = @"Compra";
//        aatvc.productId = Product.product_id;
//        aatvc.productPrice = Product.preco;
//        aatvc.productDescription = Product.descricao;
//        aatvc.productVideo=Product.video;
//		  aatvc.productDeliverDays = [Product.response_days stringValue];
//    }
	
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    // Verifica se usuario logou e precisa puxar lista atualizada de compras
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
    // VERIFICA SE EXISTEM EXERCICIOS ASSOCIADOS AO TREINO, SE NÃO GERA ALERT.
    if ([identifier isEqualToString:@"segueMensagens"])
    {
		 BOOL login = [defaults boolForKey:@"userStatus"];
	
	 	if (login != TRUE)
	 		return NO;
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
    coreDataService = [[CoreDataService alloc] init];
    [coreDataService initialize];
	
	 [utils downloadProductsForSale];
	  inAppProdutosMutArray = [coreDataService getDataFromInAppProductsTable];
	 [self.tableViewMeusTreinos reloadData];
	
    self.tableViewMeusTreinos.delegate = self;
	
    utils = [[UtilityClass alloc] init];
	
    inAppProdutosMutArray = [[NSMutableArray alloc] init];
    inAppTransactionsMutArray = [[NSMutableArray alloc] init];
	
	
	// Força iniciar com Chat
    Chat *chat = (Chat *) [NSEntityDescription insertNewObjectForEntityForName:@"Chat"
                                                                    inManagedObjectContext:coreDataService.getManagedContext];
	
	 chat.hasChat = [NSNumber numberWithBool:[[utils checkString:@"1"] boolValue]];
	 [coreDataService saveData];
	
	 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	 [defaults setBool:TRUE forKey:@"purchaseNeedUpdate"];
	 [defaults synchronize];
	
	
	
     // Tweak para linhas extra na tabela.
     [self.tableViewMeusTreinos setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0,0, 320,70)]];

//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"TREINOS"
//                                                                   style:UIBarButtonItemStylePlain
//                                                                  target:nil
//                                                                  action:nil];
//    self.navigationItem.backBarButtonItem = backButton;
	
	
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
	
  //  [self downloadProductsForSale];

	
    [self downloadRegularTraining];
	 [self downloadShelfTraining];
	
	self.navigationItem.leftBarButtonItem=nil;
	self.navigationItem.hidesBackButton=YES;
	self.navigationController.navigationBar.translucent = NO;
	
//	 refreshControl = [[UIRefreshControl alloc] init];
//    refreshControl.backgroundColor = UIColorFromRGB(0xF0F0F0);
//    refreshControl.tintColor = UIColorFromRGB(0xFFFFFF);
//    [refreshControl addTarget:self
//                    action:@selector(refreshTrainings)
//                  forControlEvents:UIControlEventValueChanged];
//	 // [self.tableView addSubview:refreshControl];
//	self.tableViewMeusTreinos.refreshControl=refreshControl;
	
//	[self.tableViewMeusTreinos initWithFrame:self.tableViewMeusTreinos.frame style:UITableViewStyleGrouped];

	

}



////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	 [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
	//if([inAppTransactionsMutArray count]==0 && [inAppProdutosMutArray count]==0)
	//	 [self performSegueWithIdentifier:@"segueLogin" sender:self];
	
	// Verifica se usuario logou e precisa puxar lista atualizada de compras
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	 BOOL login = [defaults boolForKey:@"userStatus"];
    BOOL purchaseUpdate = [defaults boolForKey:@"purchaseNeedUpdate"];
    if(purchaseUpdate==TRUE)
    {
    	if (login == TRUE)
	 	{
   // 		[self retorePurchases:self];
			[self downloadRegularTraining];
			[defaults setBool:FALSE forKey:@"purchaseNeedUpdate"];
		}
	 }
	
	 [self readProductsList];
	 // Verifica se o usuário esta logado.
   // Pega o status do usuário, logado ou não.
	
	
	
	 if (login == TRUE)
	 {
		 chatIcon.rightBarButtonItem.image=[UIImage imageNamed:@"chat0"];
	
	//    [self downloadRegularTraining];
		 [self dowloadImageWithPersonalTreinee];
	     loginBackgroundImage.hidden=YES;
	     iconBackgroungImage.hidden=YES;
	     buttonLogin.hidden = YES;
	     buttonLogin.enabled = NO;
		 
	     buttonMais.hidden=NO;
	     buttonMais.enabled=YES;
	 }
	 else
	 {
		 chatIcon.rightBarButtonItem.image=[UIImage imageNamed:@""];
	
	    loginBackgroundImage.hidden=NO;
	    iconBackgroungImage.hidden=NO;
		 buttonLogin.hidden = NO;
		 buttonLogin.enabled = YES;
		 
		 buttonMais.hidden=YES;
		 buttonMais.enabled=NO;
	 }
	
	
   [self.tableViewMeusTreinos reloadData];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
	

	 // Pega o status do usuário, logado ou não.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL login = [defaults boolForKey:@"userStatus"];
	
	 if (login == TRUE)
	 {
	 	User *userData = (User *) [coreDataService getDataFromUserTable];
	
	
	
			// RECUPERA AS CONFIGURACÃO DO APP DESGIN DO BANCOD E DADOS.
		 //   Design *appDesign = (Design *) [coreDataService getDataFromDesignTable];
			 imageUser.layer.cornerRadius = imageUser.frame.size.width / 2;
			 imageUser.clipsToBounds = YES;
			// imageUser.layer.borderColor = UIColorFromRGB(kPRIMARY_COLOR).CGColor;
			// imageUser.layer.borderWidth = 3.0f;
		 
			 nameUser.text = [[userData.firstName stringByAppendingString: @" "]stringByAppendingString:userData.lastName];
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
		 
    }
	 NSUserDefaults *Defaults = [NSUserDefaults standardUserDefaults];
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

//- (void)refreshTrainings
//{
//	[self downloadShelfTraining];
//	[self downloadRegularTraining];
//	[self.tableViewMeusTreinos.refreshControl endRefreshing];
//}



- (void)dowloadImageWithPersonalTreinee
{
    // VERIFICA SE TEM CONEXÃO COM A INTERNET.
    BOOL flagInternetStatus = [IMManager sharedManager].hasConnection;
	
    User *userData = (User *) [coreDataService getDataFromUserTable];
	
	NSMutableString *pathImage = [[NSMutableString alloc] init];
			if(userData.image!=nil)
			{
						// CAMINHO PARA RECUPERAR A IMAGEM DO TREINADOR.
				 NSLog(@"1. Call md5 with input: %@",userData.image);
				
				 [pathImage appendString:[utils returnDocumentsPath]];
				 [pathImage appendString:@"/Caches/ProfileImages/"];
				 [pathImage appendString:[utils md5HexDigest:userData.image]];
				 [pathImage appendString:@".png"];
			 }
			 // VERIFICA SE A IMAGEM EXISTE NO CAMINHO ESPECIFICADO.
			 BOOL imageExists = [[NSFileManager defaultManager] fileExistsAtPath:pathImage];
	
			 // SE EXISTE CARREGA, SENÃO CARREGA A IMAGEM PADRÃO.
			 if (imageExists)
			 {
				 return;
			 }
			 else
			 {
	
			 if(userData.image.length > 0 && flagInternetStatus == TRUE)
			 {
				  NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
				  AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
				 
				  NSURL *URL = [NSURL URLWithString:userData.image];
				  NSURLRequest *request = [NSURLRequest requestWithURL:URL];
				 
				  NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
					  
						NSString *imagesCachePath = [[utils returnDocumentsPath] stringByAppendingPathComponent:@"/Caches/ProfileImages/"];
						NSURL *path = [NSURL fileURLWithPath:imagesCachePath];
					  
						NSMutableString *filename = [[NSMutableString alloc] init];
						[filename appendString:[utils md5HexDigest:userData.image]];
						[filename appendString:@".png"];
					  
						return [path URLByAppendingPathComponent:filename];
					  
				  } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
					  
						NSLog(@"DOWNLOAD END");
					  
					  
					  
				  }];
				 
				  [downloadTask resume];
			 }
		}
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - TABLE VIEW DATA SOURCE & DELEGATE

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
	
	 productCell *cell = [tableViewMeusTreinos dequeueReusableCellWithIdentifier:@"product_cell" forIndexPath:indexPath];
	
	
    if (cell == nil)
    {
        cell = [[productCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"product_cell"];
    }

        InAppTransactions *Transaction = [inAppTransactionsMutArray objectAtIndex:[indexPath row]];
		  InAppProducts *thisProduct= [coreDataService getInAppProductDataWithProductId:Transaction.product_id];
	
        if([Transaction.isnormaltraining boolValue]==TRUE)
        {
			  cell.productTitle.text= Transaction.training_name;
			  cell.productDescription.text=@"Meu treino pessoal com o Personal Paulo Meyra" ;//Transaction.training_description;
			  
			   NSMutableString *pathImage = [[NSMutableString alloc] init];
			   if(thisProduct.image_product!=nil)
				{
				  // CAMINHO PARA RECUPERAR A IMAGEM DO TREINADOR.
					 NSLog(@"1. Call md5 with input: %@",thisProduct.image_product);
					
					 [pathImage appendString:[utils returnDocumentsPath]];
					 [pathImage appendString:@"/Caches/StoreImages/"];
					 [pathImage appendString:[utils md5HexDigest:thisProduct.image_product]];
					 [pathImage appendString:@".png"];
			  }
				
			  // VERIFICA SE A IMAGEM EXISTE NO CAMINHO ESPECIFICADO.
			 BOOL imageExists = [[NSFileManager defaultManager] fileExistsAtPath:pathImage];
		  
			 // SE EXISTE CARREGA, SENÃO CARREGA A IMAGEM PADRÃO.
			 if (imageExists)
			 {
				  UIImage *image = [UIImage imageWithContentsOfFile:pathImage];
				  cell.productIcon.image= image;
				
			 }
			 else
			 {
				 if([UIImage imageNamed:[utils md5HexDigest:thisProduct.image_product]])
					cell.productIcon.image = [UIImage imageNamed:[utils md5HexDigest:thisProduct.image_product]];
				else
					cell.productIcon.image = [UIImage imageNamed:@"placeholder_Video"];
				
			 }
			    cell.productData.text=@"";
			  
			  
        }
		  else
		  {
		  	  if(thisProduct!=nil)
		  	  {
				  cell.productTitle.text=thisProduct.titulo;
				  cell.productDescription.text=thisProduct.descricao;
				  
				  if([thisProduct.video isEqualToString:@""])
				  {
				  		NSMutableString *pathImage = [[NSMutableString alloc] init];
						if(thisProduct.image_product!=nil)
						{
						  // CAMINHO PARA RECUPERAR A IMAGEM DO TREINADOR.
							 NSLog(@"1. Call md5 with input: %@",thisProduct.image_product);
							
							 [pathImage appendString:[utils returnDocumentsPath]];
							 [pathImage appendString:@"/Caches/StoreImages/"];
							 [pathImage appendString:[utils md5HexDigest:thisProduct.image_product]];
							 [pathImage appendString:@".png"];
					  }
						 // VERIFICA SE A IMAGEM EXISTE NO CAMINHO ESPECIFICADO.
						 BOOL imageExists = [[NSFileManager defaultManager] fileExistsAtPath:pathImage];
					  
						 // SE EXISTE CARREGA, SENÃO CARREGA A IMAGEM PADRÃO.
						 if (imageExists)
						 {
							  UIImage *image = [UIImage imageWithContentsOfFile:pathImage];
							  cell.productIcon.image= image;
						 }
						 else
						 {
						 	if([UIImage imageNamed:[utils md5HexDigest:thisProduct.image_product]])
								cell.productIcon.image = [UIImage imageNamed:[utils md5HexDigest:thisProduct.image_product]];
							else
								cell.productIcon.image = [UIImage imageNamed:@"placeholder_Video"];
						 }
				  }
				  else
				  {
						  NSURL *youtubeURL;
						  if([thisProduct.isonlineadvisor boolValue] ==TRUE)
								youtubeURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://img.youtube.com/vi/%@/0.jpg",Transaction.welcome_video]];
						  else
								youtubeURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://img.youtube.com/vi/%@/0.jpg",Transaction.sale_video]];
							[cell.productIcon setImageWithURL:youtubeURL placeholderImage:nil];
				  }
           }
			  else
			  {
			  		cell.productTitle.text=Transaction.training_name;
				  	cell.productDescription.text=Transaction.training_description;
				  	NSURL *youtubeURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://img.youtube.com/vi/%@/0.jpg",Transaction.welcome_video]];
					[cell.productIcon setImageWithURL:youtubeURL placeholderImage:nil];
			  }
				if(Transaction.expiration!=nil && Transaction.date!=nil && ![Transaction.expiration isEqualToString:@""] )
				{
					NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
					[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	
					// set locale to something English
					NSLocale *ptLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"pt"];
					[dateFormatter setLocale:ptLocale];
					
					
					
					NSMutableString *shelfLife = [[NSMutableString alloc] init];
					
					NSDate *dateInit = [[NSDate alloc] init];
					NSDate *dateEnd = [[NSDate alloc] init];
					dateEnd = [dateFormatter dateFromString:Transaction.expiration];
					dateInit = [dateFormatter dateFromString:Transaction.date];
				
					
					
					NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
					[dateFormatter2 setDateFormat:@"dd/MM/yyyy"];
	 
					NSString *strDateInit = [dateFormatter2 stringFromDate:dateInit];
					NSString *strDateEnd = [dateFormatter2 stringFromDate:dateEnd];



		 			[shelfLife appendString:@"Vencimento: "];
					[shelfLife appendString:strDateEnd];



	//[shelfLife appendString:@" à "];
					//[shelfLife appendString:strDateEnd];
		 
					cell.productData.text=shelfLife.displayText;
			  }
			  else
				  cell.productData.text=@"" ;
			  
		  }
		  cell.productValue.text=@"";
	
        return cell;
	
	
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   return 90;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	  	return 1;
	
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	
	return [inAppTransactionsMutArray count];
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	if(indexPath.section==0)
	{
		 // Pega o status do usuário, logado ou não.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL login = [defaults boolForKey:@"userStatus"];
	
    // Verifica se o usuário esta logado.
		
	   InAppTransactions *Transaction = [inAppTransactionsMutArray objectAtIndex:[indexPath row]];
		
	   if([Transaction.isnormaltraining boolValue]==TRUE && [Transaction.isonlineadvisor boolValue]==FALSE)
	   {
			
			if (login == FALSE)
    			{
					// Mostra o alert.
				  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Atenção!"
																				  message:@"Clique em <Fazer Login> acima para acessar os conteúdos deste treino!"
																				 delegate:self
																	 cancelButtonTitle:@"Ok"
																	 otherButtonTitles:nil];
					
				  [alert show];
				  return;
				}
			 [self performSegueWithIdentifier:@"segueMeusTreinos" sender:self];
			
		}
		
		if([Transaction.isnormaltraining boolValue]==FALSE && [Transaction.isonlineadvisor boolValue]==FALSE)
			 [self performSegueWithIdentifier:@"segueInAppTreinos" sender:self];
		
		if([Transaction.isonlineadvisor boolValue]==TRUE)
		{
			  if (login == FALSE)
    			{
					// Mostra o alert.
				  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Atenção!"
																				  message:@"Clique em <Fazer Login> acima para acessar os conteúdos desta assessoria!"
																				 delegate:self
																	 cancelButtonTitle:@"Ok"
																	 otherButtonTitles:nil];
					
				  [alert show];
				  return;
				}
		
	 QuestionsE *questionsE = (QuestionsE *) [coreDataService getDataFromQuestionsETable:Transaction.training_id];
	
	
	 QuestionsD *questionsD = (QuestionsD *) [coreDataService getDataFromQuestionsDTable:Transaction.training_id];
	
			
	 QuestionsP *questionsP = (QuestionsP *) [coreDataService getDataFromQuestionsPTable:Transaction.training_id];
	
			
	 QuestionsQ *questionsQ = (QuestionsQ *) [coreDataService getDataFromQuestionsQTable:Transaction.training_id];
	
			
		
		
			if(!Transaction.showanamnese || ([questionsE.estatus isEqualToString: STR_CONCLUIDO] && [questionsD.dstatus isEqualToString: STR_CONCLUIDO] && [questionsP.pstatus isEqualToString: STR_CONCLUIDO] && [questionsQ.qstatus isEqualToString: STR_CONCLUIDO]))
			{
				[self performSegueWithIdentifier:@"segueInAppTreinos" sender:self];
			}
			else
			{
				 [self performSegueWithIdentifier:@"segueWelcome" sender:self]; //segueMeusTreinos
			}
		}
	
	}
	
	
}



-(void) readProductsList
{
	
		inAppProdutosMutArray = [coreDataService getDataFromInAppProductsTable];
		inAppTransactionsMutArray = [coreDataService getDataFromInAppTransactionsTable];
	

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
                                                          ((self.view.frame.size.height/2)-150), 280, 300)];
	
    // Configura o label.
    lblMessage.numberOfLines = 0;
    lblMessage.textAlignment = NSTextAlignmentCenter;
    lblMessage.backgroundColor = [UIColor clearColor];
    lblMessage.textColor = UIColorFromRGB(0x333333);
    lblMessage.shadowColor = [UIColor colorWithWhite:0.9 alpha:0.5];
    lblMessage.shadowOffset = CGSizeMake(1,1);
    lblMessage.font = [UIFont systemFontOfSize:17];
	
	 lblMessage.text = @"Você ainda não tem treinos disponíveis.\n\n Se você já é aluno faça seu login,\n ou acesse a loja para obter treinos. ";
	
	
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


- (IBAction)btnReload:(id)sender {
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


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)downloadRegularTraining
{
	// VERIFICA SE TEM CONEXÃO COM A INTERNET.
	BOOL flagInternetStatus = [IMManager sharedManager].hasConnection;
	
	// SE TEM CONEXÃO
	if (!flagInternetStatus)
	{
//		[utils showAlertWithTitle:kTEXT_ALERT_TITLE
//								AndText:kTEXT_INTERNET_ERROR_DEFAULT
//						  AndTargetVC:self];
		return;
	}
	
	// Pega o status do usuário, logado ou não.
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	BOOL login = [defaults boolForKey:@"userStatus"];
	
	if (login != TRUE)
		return;
	
	
	[SVProgressHUD showWithStatus:@"Atualizando seus treinos..." maskType: SVProgressHUDMaskTypeGradient];
	
	// Monta a string de acesso a validação do login.
	NSMutableString *urlString = [[NSMutableString alloc] init];
	[urlString appendString:kBASE_URL_MOBITRAINER];
	[urlString appendString:@"api/inapp/getpurchases"];
	
	// Inicializa o manager.
//	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//	[manager.requestSerializer setTimeoutInterval:AFHHTTP_TIMEOUT];
	NSDictionary *parameters;
	
	User *userData = (User *) [coreDataService getDataFromUserTable];
	parameters = @{@"apikey":API_KEY_TRAINER,@"trainee_email":userData.email};
	
	
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
			
			NSArray *arrayInAppTransactions = [[NSArray alloc] initWithArray:[responseObject objectForKey:@"purchases"]];
			
			
			
			
			if (arrayInAppTransactions.count > 0)
			{
				
				[coreDataService dropInAppTransactionsTable];
				for (NSInteger i = 0; i < [arrayInAppTransactions count]; i++)
				{
					transactionClass *transactions= [[transactionClass alloc] init];
					transactions.product_id = [utils checkString:[[arrayInAppTransactions objectAtIndex:i] objectForKey:@"response_training_inappid"]];
					
//					NSString *productid=transactions.product_id = [utils checkString:[[arrayInAppTransactions objectAtIndex:i] objectForKey:@"response_training_inappid"]];
//					if([productid isEqualToString:@""])
//						transactions.product_id = @"QU31R0_NORMAL";
//					else

					transactions.product_id = [utils checkString:[[arrayInAppTransactions objectAtIndex:i] objectForKey:@"response_productid"]];
					transactions.transaction_id = [utils checkString:[[arrayInAppTransactions objectAtIndex:i] objectForKey:@"response_transactionid"]];
					transactions.training_id = [utils checkString:[[arrayInAppTransactions objectAtIndex:i] objectForKey:@"response_training_id"]];
					transactions.digitalproduct_id = [utils checkString:[[arrayInAppTransactions objectAtIndex:i] objectForKey:@"response_digitalproduct_id"]];
					transactions.date = [utils checkString:[[arrayInAppTransactions objectAtIndex:i] objectForKey:@"response_datetime"]];
					transactions.expiration = [utils checkString:[[arrayInAppTransactions objectAtIndex:i] objectForKey:@"response_training_expiration"]];
					transactions.sale_video = [utils checkString:[[arrayInAppTransactions objectAtIndex:i] objectForKey:@"response_training_video"]];
					transactions.welcome_video = [utils checkString:[[arrayInAppTransactions objectAtIndex:i] objectForKey:@"response_training_welcomevideo"]];
					transactions.training_name = [utils checkString:[[arrayInAppTransactions objectAtIndex:i] objectForKey:@"response_training_name"]];
					transactions.training_description = [utils checkString:[[arrayInAppTransactions objectAtIndex:i] objectForKey:@"response_training_description"]];
					transactions.price = [utils checkString:[[arrayInAppTransactions objectAtIndex:i] objectForKey:@"response_price"]];
					transactions.isonlineadvisor = [NSNumber numberWithBool: [[[arrayInAppTransactions objectAtIndex:i] objectForKey:@"response_training_isonlineadvisor"] boolValue]];
					transactions.isnormaltraining = [NSNumber numberWithBool: [[[arrayInAppTransactions objectAtIndex:i] objectForKey:@"response_training_isnormaltraining"] boolValue]];
					transactions.isSync = [NSNumber numberWithBool:TRUE];
					if([[arrayInAppTransactions objectAtIndex:i] objectForKey:@"response_training_showanamnese"]!=(id)[NSNull null])
						transactions.showanamnese = [NSNumber numberWithBool: [[[arrayInAppTransactions objectAtIndex:i] objectForKey:@"response_training_showanamnese"] boolValue]];
				   else
						transactions.showanamnese = [NSNumber numberWithBool: FALSE];

					if([[arrayInAppTransactions objectAtIndex:i] objectForKey:@"response_training_days"]!=(id)[NSNull null])
						transactions.response_days = [NSNumber numberWithInteger:[[[arrayInAppTransactions objectAtIndex:i] objectForKey:@"response_training_days"]integerValue]];
					else
						transactions.response_days = [NSNumber numberWithInteger:0];
					
						

					transactions.image_store = [utils checkString:[[arrayInAppTransactions objectAtIndex:i] objectForKey:@"response_training_image"]];
					transactions.image_product = [utils checkString:[[arrayInAppTransactions objectAtIndex:i] objectForKey:@"response_training_image2"]];
				
				   [coreDataService insertUpdateDataInAppTransactionsTable:transactions];
				}
				
				[SVProgressHUD showSuccessWithStatus:@"Treinos atualizados \ncom sucesso!"];
				
				LastUpdates *lastUpdate = (LastUpdates *) [coreDataService getDataFromLastUpdatesTable];
				
				// CONFIGURA A DATA ATUAL.
				NSDateFormatter *format = [[NSDateFormatter alloc] init];
				[format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
				NSDate *now = [[NSDate alloc] init];
				NSString *dateString = [format stringFromDate:now];
				
				lastUpdate.training = dateString;
				
				[coreDataService saveData];
				
				inAppTransactionsMutArray = [coreDataService getDataFromInAppTransactionsTable];
				
			}
			else
			{
				//20180919
				 [coreDataService dropInAppTransactionsTable];
				  inAppTransactionsMutArray = [coreDataService getDataFromInAppTransactionsTable];
				 [tableViewMeusTreinos reloadData];
				[SVProgressHUD showSuccessWithStatus:@"Você está sem treinos no momento."];
			}
			
			[SVProgressHUD dismiss];
			
			[self.tableViewMeusTreinos reloadData];
		}
		
	} failure:^(NSURLSessionTask *operation, NSError *error) {
		
		[SVProgressHUD dismiss];
		NSLog(@"Error: %@", error);
		
	}];
}



//                                        response_training_isnormaltraining.     response_training_isonlineadvisor
//
//TREINO PRATELEIRA                                   0                                                       0
//TREINO ASSESSORIA                                   0                                                       1
//TREINO BÁSICO                                       1                                                       0


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)downloadShelfTraining
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
	
    [SVProgressHUD showWithStatus:@"Recuperando seu Treino..." maskType: SVProgressHUDMaskTypeGradient];
	
	inAppTransactionsMutArray = [coreDataService getDataFromInAppTransactionsTable];
	 for(int i=0;i<[inAppTransactionsMutArray count];i++)
	 {
	    InAppTransactions *Transaction = [inAppTransactionsMutArray objectAtIndex:i];
	
	     int producttype= [coreDataService getTypeFromProductsTableWithProductId:Transaction.product_id];
	     if(producttype!=SHELF_TRAINING)
		     continue;
		 
    		// Monta a string de acesso a validação do login.
    		NSMutableString *urlString = [[NSMutableString alloc] init];
			 [urlString appendString:kBASE_URL_MOBITRAINER];
			 [urlString appendString:@"api/inapp/getworkout"];
		 
			  // Inicializa o manager.
//			 AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//			 [manager.requestSerializer setTimeoutInterval:AFHHTTP_TIMEOUT];
          NSString *treino_id=Transaction.training_id;
		 
			 NSDictionary *parameters = @{@"apikey":API_KEY_TRAINER,@"training_id":Transaction.training_id};
		 
		 
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
					  [coreDataService deleteDataFromExerciseTableByTrainingID:treino_id];
					  [coreDataService deleteTrainingWithTrainingID:treino_id];
					 
					  
						if (arrayDataTraining.count > 0)
						{
							
							
							 for (NSInteger i = 0; i < [arrayDataTraining count]; i++)
							 {
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
									training.serieIsLock = [NSNumber numberWithInteger:[[[arrayDataTraining objectAtIndex:i] objectForKey:@"response_serie_islock"]integerValue]];
									training.training_id = treino_id;

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
							
							 [SVProgressHUD showSuccessWithStatus:@"Treinos atualizados \ncom sucesso!"];
							
			//				 if (arrayDataTraining.count > 0)
			//				 {
			//
			//
			//						[arrayEnabledTraining removeAllObjects];
			//						arrayEnabledTraining = [coreDataService getDataFromTrainingTableWithProductId:self.productid];
			//						[self.tableViewMeusTreinos reloadData];
			//
			//				 }
			//				 else
			//				 {
			//						[arrayEnabledTraining removeAllObjects];
			//						[arrayDisabledTraining removeAllObjects];
			//						[self.tableViewMeusTreinos reloadData];
			//			  //      [self showNoDataMessage];
			//				 }
						}
						else
						{
						//	  [arrayEnabledTraining removeAllObjects];
						//	  arrayEnabledTraining = [coreDataService getDataFromTrainingTableWithProductId:self.productid];
							  [self.tableViewMeusTreinos reloadData];
							
							 if (self.isHistory)
							 {
								  [SVProgressHUD showSuccessWithStatus:@"Não existem treinos registrados em seu histórico!"];
							 }
							
							
							
						  //  [self showNoDataMessage];
						}
						[self.tableViewMeusTreinos reloadData];
				  }
				 
		
		 
    		} failure:^(NSURLSessionTask *operation, NSError *error) {
		 
        			[SVProgressHUD dismiss];
        			NSLog(@"Error: %@", error);
		 
    			}];
		 
		}
		[SVProgressHUD dismiss];
}

- (void)productsRequest:(nonnull SKProductsRequest *)request didReceiveResponse:(nonnull SKProductsResponse *)response {
	
}


- (IBAction)retorePurchases:(id)sender {

	// VERIFICA SE TEM CONEXÃO COM A INTERNET.
    BOOL flagInternetStatus = [IMManager sharedManager].hasConnection;
	[self.tableViewMeusTreinos.refreshControl endRefreshing];
	[self downloadRegularTraining];
	 [self downloadShelfTraining];
//	[tableViewMeusTreinos reloadData];
   // SE TEM CONEXÃO
    if (!flagInternetStatus)
    {
        [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                          AndText:kTEXT_INTERNET_ERROR_DEFAULT
                      AndTargetVC:self];
         [self.tableViewMeusTreinos.refreshControl endRefreshing];
			return;
    }
	
 // Mostra Mensagem.
	[SVProgressHUD showWithStatus:@"Restaurando suas compras..." maskType:SVProgressHUDMaskTypeGradient];

	// Solicita o restore das transações ja efetuadas dentro do aplicativo.
	[[SKPaymentQueue defaultQueue] restoreCompletedTransactions];

	[SVProgressHUD dismiss];

}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
	[self.tableViewMeusTreinos.refreshControl endRefreshing];
	 [SVProgressHUD dismiss];
    if ([queue.transactions count] == 0)
    {
        // Remove o HUD.
        [SVProgressHUD dismiss];

        // Remove o spinner do statusbar.
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		 
        // Mostra o alert.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Atenção!"
                                                        message:@"Não existem itens comprados para serem restaurados!"
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
		 
        [alert show];
    }
    else
    {
        // Verifica se o recibo é valido
        NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
        NSData *receipt = [NSData dataWithContentsOfURL:receiptURL];
		 
        // Verifica se o recibo existe.
        if (!receipt)
        {
            NSLog(@"Não foi possível ler o recibo...");
			  
            // Mostra a mensagem.
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Atenção!"
                                                            message:@"Não foi possível concluir esta transação no momento. Tente novamente mais tarde!"
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
			  
            [alert show];
			  
            // Remove o HUD.
            [SVProgressHUD dismiss];
			  
            // Remove o loader da status bar.
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
			  
            return;
        }
		 
        NSError *error;
		 
        NSDictionary *requestContents = @{
                                             @"receipt-data": [receipt base64EncodedStringWithOptions:0],
                                             @"password": APPLE_SHARED_KEY
                                         };
		 
        // Serializa o request como JSON.
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestContents options:0 error:&error];
		 
        // Verifica se criou o request.
        if (!requestData)
        {
            // Mostra o Alert.
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Atenção!"
                                                           message:[error localizedDescription]
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil, nil];
            [alert show];
			  
            return;
        }
		 
        // Cria um POST request com os dados do recibo.
        NSURL *storeURL = [NSURL URLWithString:APPLE_URL_VERIFICATION];
		 
        // Cria o request.
        NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:storeURL];
		 
        // Configura o metodo com POST.
        [storeRequest setHTTPMethod:@"POST"];
		 
        // Monta o corpo da requisição.
        [storeRequest setHTTPBody:requestData];
		 
        // Make a connection to the iTunes Store on a background queue.
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
		 
        // Dispara a requisição Assicrona e aguarda a resposta.
        [NSURLConnection sendAsynchronousRequest:storeRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
			  
            // Verfica se houve algum erro.
            if (connectionError)
            {
                // Mostra a mesnsagem do erro.
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Atenção!"
                                                               message:[connectionError localizedDescription]
                                                              delegate:self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil, nil];
                [alert show];
					
                return;
            }
            else
            {
                NSError *error;
					
                // Serializa a resposta em JSON.
                NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
					
                // Verica se o json foi criado corretamente
                if (!jsonResponse)
                {
                    // Mostra a mesnsagem do erro.
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Atenção!"
                                                                   message:[error localizedDescription]
                                                                  delegate:self
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles:nil, nil];
                    [alert show];
						 
                    return;
                }
					
					
                // Verifica o status da compra, enviado pela apple.
                switch ([[jsonResponse objectForKey:@"status"] integerValue])
                {
                    case 0:
                    {
                         [coreDataService dropInAppTransactionsTable];
                        // Array com todos os recibos recebidos da APPLE STORE.
                        NSArray *arrayReceipts = [jsonResponse valueForKeyPath:@"receipt.in_app"];
							  
                        // Verifica todos os recibos.
                        for (NSInteger i = 0; i < [arrayReceipts count]; i++)
                        {
                            // Cria um recibo para cada interação.
                            NSDictionary *receipt = [arrayReceipts objectAtIndex:i];
									
                            // Identifica se é assinatura ou compra individual.
                            BOOL flag = NO;
									
                            NSString *strKey = [receipt objectForKey:@"web_order_line_item_id"];
									
                            // Verifica se a chave web_order_line_item_id existe dentro do recibo. se existir é uma assinatura
                            // pois em compras individuais essa chave não aparece no recibo.
                            if ((strKey == nil) || (strKey == (NSString *) [NSNull null]) || ([strKey isEqualToString:@""]))
                            {
                                // É uma compra individual.
                                flag = NO;
                            }
                            else
                            {
                                // É uma assinatura.
                                flag = TRUE;
                            }
									
                            // Registra o recibo na base de dados.
                            [self registerTransaction:receipt];
									
                        }
							  
                        // VOlta para a THREAD principal.
                        double delayInSeconds = 1.0;
                        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
									
                            // Para o spinner da statusbar.
                            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
									
                            // Mostra o hud de sucesso.
                            [SVProgressHUD showSuccessWithStatus:@"Suas compras foram recuperadas com sucesso!"];
									
                            // Sincroniza tabela de Transactions com o servidor
                          [utils updateTransactionsToServer];
                          [self downloadRegularTraining];
                          [self downloadShelfTraining];
									
                        });
							  
                        break;
                    }
							 
                    case 21007:
                    {
					// Cria um POST request com os dados do recibo.
							  NSURL *storeURL = [NSURL URLWithString:APPLE_URL_VERIFICATION_SANDBOX];
							 
							  // Cria o request.
							  NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:storeURL];
							 
							  // Configura o metodo com POST.
							  [storeRequest setHTTPMethod:@"POST"];
							 
							  // Monta o corpo da requisição.
							  [storeRequest setHTTPBody:requestData];
							 
							  // Make a connection to the iTunes Store on a background queue.
							  NSOperationQueue *queue = [[NSOperationQueue alloc] init];
							 
							  // Dispara a requisição Assicrona e aguarda a resposta.
							  [NSURLConnection sendAsynchronousRequest:storeRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
								  
									// Verfica se houve algum erro.
									if (connectionError)
									{
										 // Mostra a mesnsagem do erro.
										 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Atenção!"
																										message:[connectionError localizedDescription]
																									  delegate:self
																						  cancelButtonTitle:@"OK"
																						  otherButtonTitles:nil, nil];
										 [alert show];
										
										 return;
									}
									else
									{
										 NSError *error;
										
										 // Serializa a resposta em JSON.
										 NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
										
										 // Verica se o json foi criado corretamente
										 if (!jsonResponse)
										 {
											  // Mostra a mesnsagem do erro.
											  UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Atenção!"
																											 message:[error localizedDescription]
																											delegate:self
																								cancelButtonTitle:@"OK"
																								otherButtonTitles:nil, nil];
											  [alert show];
											 
											  return;
										 }
										
										
										 // Verifica o status da compra, enviado pela apple.
										 switch ([[jsonResponse objectForKey:@"status"] integerValue])
										 {
											  case 0:
											  {
													 [coreDataService dropInAppTransactionsTable];
													// Array com todos os recibos recebidos da APPLE STORE.
													NSArray *arrayReceipts = [jsonResponse valueForKeyPath:@"receipt.in_app"];
												  
													// Verifica todos os recibos.
													for (NSInteger i = 0; i < [arrayReceipts count]; i++)
													{
														 // Cria um recibo para cada interação.
														 NSDictionary *receipt = [arrayReceipts objectAtIndex:i];
														
														 // Identifica se é assinatura ou compra individual.
														 BOOL flag = NO;
														
														 NSString *strKey = [receipt objectForKey:@"web_order_line_item_id"];
														
														 // Verifica se a chave web_order_line_item_id existe dentro do recibo. se existir é uma assinatura
														 // pois em compras individuais essa chave não aparece no recibo.
														 if ((strKey == nil) || (strKey == (NSString *) [NSNull null]) || ([strKey isEqualToString:@""]))
														 {
															  // É uma compra individual.
															  flag = NO;
														 }
														 else
														 {
															  // É uma assinatura.
															  flag = TRUE;
														 }
														
														 // Registra o recibo na base de dados.
														 [self registerTransaction:receipt];
														
													}
												  
													// VOlta para a THREAD principal.
													double delayInSeconds = 1.0;
													dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
													dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
														
														 // Para o spinner da statusbar.
														 [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
														
														 // Mostra o hud de sucesso.
														 [SVProgressHUD showSuccessWithStatus:@"Suas compras foram recuperadas com sucesso!"];
														
														 // Sincroniza tabela de Transactions com o servidor
													  [utils updateTransactionsToServer];
													  [self downloadRegularTraining];
													  [self downloadShelfTraining];
														
													});
												  
													break;
											  }
											  default:
											  {
													// Para o spinner da statusbar.
													[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
												  
													// Remove o HUD.
													[SVProgressHUD dismiss];
												  
													break;
											 }
							  		}
										
                    		}
								  
								  
                    		}];
								break;
						
							}
							 
                    default:
                    {
                        // Para o spinner da statusbar.
                        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
							  
                        // Remove o HUD.
                        [SVProgressHUD dismiss];
							  
                        break;
                    }
                }
            }
        }];
    }
    [tableViewMeusTreinos reloadData];
}

- (void)paymentQueue:(nonnull SKPaymentQueue *)queue updatedTransactions:(nonnull NSArray<SKPaymentTransaction *> *)transactions {
	
}


//- (void)paymentQueue:(nonnull SKPaymentQueue *)queue updatedTransactions:(nonnull NSArray<SKPaymentTransaction *> *)transactions {
//	<#code#>
//}


- (void) registerTransaction:(NSDictionary *)receipt
{
	InAppTransactions *thistransaction = (InAppTransactions *)[NSEntityDescription insertNewObjectForEntityForName:@"InAppTransactions"
																														 inManagedObjectContext:coreDataService.getManagedContext];
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	
	// set locale to something English
	NSLocale *ptLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"pt"];
	[df setLocale:ptLocale];
	
	
	// Data da Compra Original.
	NSString *dateStr_OriginalPurchase = [receipt objectForKey:@"original_purchase_date"];
	dateStr_OriginalPurchase = [dateStr_OriginalPurchase stringByReplacingOccurrencesOfString:@" Etc/GMT" withString:@""];
	
	thistransaction.date = dateStr_OriginalPurchase;
	thistransaction.isSync =FALSE;
	thistransaction.product_id = [receipt objectForKey:@"product_id"];;
	thistransaction.transaction_id = [receipt objectForKey:@"transaction_id"];
	
	InAppProducts *thisProduct= [coreDataService getInAppProductDataWithProductId:[receipt objectForKey:@"product_id"]];
	if(thisProduct !=nil)
	{
		thistransaction.isonlineadvisor = thisProduct.isonlineadvisor;
		thistransaction.training_description = thisProduct.descricao;
		thistransaction.training_name = thisProduct.titulo;
		thistransaction.training_id = thisProduct.training_id;
		thistransaction.price = thisProduct.preco;
		
		
	}
	
	[coreDataService saveData];
	
}




////////////////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////





@end

