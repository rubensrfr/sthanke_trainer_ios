//
//  ListAllViewController.m
//
//
//  Created by Rubens Rosa on 15/03/2018.
//  Copyright © 2018 4mobi. All rights reserved.
//


#import "StoreViewController.h"

@interface StoreViewController()

@end

@implementation StoreViewController

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

    if ([[segue identifier] isEqualToString:@"segueCompras"])
    {
        AssesoriaTableViewController *aatvc = [segue destinationViewController];
        InAppProducts *Product = [inAppProdutosMutArray objectAtIndex:[indexPath row]];
        aatvc.title = @"Compra";
        aatvc.productId = Product.product_id;
        aatvc.productPrice = Product.preco;
        aatvc.productDescription = Product.descricao;
        aatvc.productVideo=Product.video;
        aatvc.productImage=Product.image_product;
		  aatvc.productDeliverDays = [Product.response_days stringValue];
		 
    }
    if ([[segue identifier] isEqualToString:@"segueInAppTreinos"])
    {
        MeusInAPPViewController *miavc = [segue destinationViewController];
		 InAppTransactions *Transaction = [inAppTransactionsMutArray objectAtIndex:[indexPath row]];
        miavc.title = @"Treino";
        miavc.training_id = Transaction.training_id;
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
    }
	
    if ([[segue identifier] isEqualToString:@"segueDetalhes"])
    {
       AssesoriaTableViewController *aatvc = [segue destinationViewController];
        InAppProducts *Product = [inAppProdutosMutArray objectAtIndex:[indexPath row]];
        aatvc.title = @"Compra";
        aatvc.productId = Product.product_id;
        aatvc.productPrice = Product.preco;
        aatvc.productDescription = Product.descricao;
        aatvc.productVideo=Product.video;
		  aatvc.productDeliverDays = [Product.response_days stringValue];
    }
	
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
	
	
	
    self.tableViewMeusTreinos.delegate = self;
	
    utils = [[UtilityClass alloc] init];
	
    inAppProdutosMutArray = [[NSMutableArray alloc] init];
    inAppTransactionsMutArray = [[NSMutableArray alloc] init];
	
	
    coreDataService = [[CoreDataService alloc] init];
    [coreDataService initialize];
	
	//tableViewMeusTreinos.estimatedRowHeight = 156;
	//   tableViewMeusTreinos.rowHeight = UITableViewAutomaticDimension;
	
	
	
     // Tweak para linhas extra na tabela.
     [self.tableViewMeusTreinos setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0,0, 320,70)]];

//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"TREINOS"
//                                                                   style:UIBarButtonItemStylePlain
//                                                                  target:nil
//                                                                  action:nil];
//    self.navigationItem.backBarButtonItem = backButton;
	
	
     [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(becomeActive:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
	
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(becomeInactive:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
	
	
	
	 inAppProdutosMutArray = [coreDataService getDataFromInAppProductsTable];
	 [self.tableViewMeusTreinos reloadData];
	
	self.navigationItem.leftBarButtonItem=nil;
	self.navigationItem.hidesBackButton=YES;
	self.navigationController.navigationBar.translucent = NO;

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
	
	// VERIFICA SE TEM CONEXÃO COM A INTERNET.
    BOOL flagInternetStatus = [IMManager sharedManager].hasConnection;
	
    if (!flagInternetStatus)
    {
		 
            [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                          AndText:kTEXT_INTERNET_ERROR_DEFAULT
                      AndTargetVC:self];
    
    }
	
//	[utils downloadProductsForSale];
	inAppProdutosMutArray = [coreDataService getDataFromInAppProductsTable];
	 [self readProductsList];
	
	// Verifica se usuario logou e precisa puxar lista atualizada de compras
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL login = [defaults boolForKey:@"userStatus"];
	
	 if (login == TRUE)
	 {
		 chatIcon.rightBarButtonItem.image=[UIImage imageNamed:@"chat0"];
	
	
//		 [self dowloadImageWithPersonalTreinee];
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
	
	
	
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
	
	 [utils updateTransactionsToServer];
	
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
	
    [SVProgressHUD dismiss];
	  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	  [defaults setBool:TRUE forKey:@"purchaseNeedUpdate"];
	  [defaults synchronize];

	
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
	
	
     InAppProducts *Product = [inAppProdutosMutArray objectAtIndex:[indexPath row]];
	  if([Product.status boolValue]==TRUE)
	  {
		  cell.productTitle.text=Product.titulo;
		  cell.productDescription.text=Product.descricao;
		  
		  if([Product.preco isEqualToString:@"0,00"])
			  cell.productValue.text=@"GRÁTIS";
		  else
			  cell.productValue.text=[@"R$ " stringByAppendingString:Product.preco];
		 // NSURL *youtubeURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://img.youtube.com/vi/%@/0.jpg",Product.video]];
		  
		  NSMutableString *pathImage = [[NSMutableString alloc] init];
			if(Product.image_store!=nil)
			{
						// CAMINHO PARA RECUPERAR A IMAGEM DO TREINADOR.
				 NSLog(@"1. Call md5 with input: %@",Product.image_store);
				
				 [pathImage appendString:[utils returnDocumentsPath]];
				 [pathImage appendString:@"/Caches/StoreImages/"];
				 [pathImage appendString:[utils md5HexDigest:Product.image_store]];
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
				 if([UIImage imageNamed:[utils md5HexDigest:Product.image_store]])
					cell.productIcon.image = [UIImage imageNamed:[utils md5HexDigest:Product.image_store]];
				
			 }

		}
		else
		 	cell.hidden=YES;
	
		  return cell;
}



////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
////		return 30.0f;
//
//}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

     InAppProducts *Product = [inAppProdutosMutArray objectAtIndex:[indexPath row]];
     CGRect screen = [[UIScreen mainScreen] bounds];
	  CGFloat width = CGRectGetWidth(screen);
	  
	  if([Product.status boolValue]==TRUE)
		 return width/2.4333;//156;
	  else
	    return 0;

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
		return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	
	return	[inAppProdutosMutArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
			 [self performSegueWithIdentifier:@"segueCompras" sender:self];
}



-(void) readProductsList
{
	
		inAppProdutosMutArray = [coreDataService getDataFromInAppProductsTable];
		inAppTransactionsMutArray = [coreDataService getDataFromInAppTransactionsTable];
	    BOOL imageExists;
	//int i=0;
			for(int i=0;i<[inAppProdutosMutArray count];i++)
			{
				InAppProducts *Product = [inAppProdutosMutArray objectAtIndex:i];
        		NSMutableString *pathImage = [[NSMutableString alloc] init];
					 [pathImage appendString:[utils returnDocumentsPath]];
					 [pathImage appendString:@"/Caches/StoreImages/"];
					 [pathImage appendString:[utils md5HexDigest:Product.image_store]];
					 [pathImage appendString:@".png"];
				
				
				  if (![UIImage imageNamed: [utils md5HexDigest:Product.image_store]])
				  {
					  imageExists = [[NSFileManager defaultManager] fileExistsAtPath:pathImage];
				
				//	 group = dispatch_group_create();
				//	 queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
				
					 if (!imageExists)
					 {
						 // dispatch_group_enter(group);
						 // dispatch_async(queue, ^{
							  
								// Faz o download
								if(Product.status!=0)
									[self getImageWithURL:Product.image_store andPath:@"/Caches/StoreImages/"];
							  
						  //});
					 }
				}
				if(Product.image_product!=nil)
				{
				
					 NSMutableString *pathImage2 = [[NSMutableString alloc] init];
					 [pathImage2 appendString:[utils returnDocumentsPath]];
					 [pathImage2 appendString:@"/Caches/StoreImages/"];
					 [pathImage2 appendString:[utils md5HexDigest:Product.image_product]];
					 [pathImage2 appendString:@".png"];
					
					 //Imagem está no Asset, então baixa
					 if (![UIImage imageNamed: [utils md5HexDigest:Product.image_product]])
					 {
						  
						 imageExists = [[NSFileManager defaultManager] fileExistsAtPath:pathImage2];
					
					//	 group = dispatch_group_create();
					//	 queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
					
						 if (!imageExists)
						 {
							 // dispatch_group_enter(group);
							 // dispatch_async(queue, ^{
							 
									// Faz o download
									if(Product.status!=0)
										[self getImageWithURL:Product.image_product andPath:@"/Caches/StoreImages/"];
							 
							  //});
						 }
					}
				}
		}
		 [self.tableViewMeusTreinos reloadData];

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
         else
				lblMessage.text = @"Este aluno está sem treinos. \n Use o botão de adição para criar um treino!";
		 
		 
		 
    }
	
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

- (void)getImageWithURL:(NSString *)url  andPath: (NSString *)path
{
	NSLog(@"%@",url);
    if(url.length > 0)
    {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
		 
        NSURL *URL = [NSURL URLWithString:url];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
		 
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
			  
            NSString *imagesCachePath = [[utils returnDocumentsPath] stringByAppendingPathComponent:path];
			  
            NSURL *path = [NSURL fileURLWithPath:imagesCachePath];
			  
            NSMutableString *filename = [[NSMutableString alloc] init];
            [filename appendString:[utils md5HexDigest:url]];
            [filename appendString:@".png"];
			  
            return [path URLByAppendingPathComponent:filename];
			  
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
			  
          //  dispatch_group_leave(group);
        }];
		 
        [downloadTask resume];
    }
    else
    {
//        dispatch_group_leave(group);
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



- (void)paymentQueue:(nonnull SKPaymentQueue *)queue updatedTransactions:(nonnull NSArray<SKPaymentTransaction *> *)transactions {
	
}



- (void)productsRequest:(nonnull SKProductsRequest *)request didReceiveResponse:(nonnull SKProductsResponse *)response {
	
}


@end

////////////////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////


