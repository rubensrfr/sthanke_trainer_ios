//
//  assesoriaTableViewController.m
//  
//
//  Created by Rubens Rosa on 17/03/2018.
//  Copyright © 2018 4mobi. All rights reserved.
//

#import "AssesoriaTableViewController.h"

@interface AssesoriaTableViewController ()

@end

@implementation AssesoriaTableViewController
@synthesize cancelaTimer;
@synthesize productId;
@synthesize imgVideoThumb;
@synthesize productDescription;
@synthesize productPrice;
@synthesize tableProductDescription;
@synthesize tableProductPrice;
@synthesize productVideo;
@synthesize show_details_only;
@synthesize comprarBtnOL;
@synthesize priceLabelOL;
@synthesize productImage;
@synthesize productDeliverDays;
@synthesize videoBtnOL;

- (void)viewDidLoad {
    [super viewDidLoad];
	
    utils = [[UtilityClass alloc] init];
    self.playerView.delegate = self;
  
	
	if(productVideo!=nil || productImage!=nil)
	{
		if([productVideo isEqualToString:@""] && productImage!=nil)
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
			NSURL *youtubeURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://img.youtube.com/vi/%@/0.jpg",productVideo]];
			[imgVideoThumb setImageWithURL:youtubeURL placeholderImage:nil];
			[self loadVideo];
		}
	}
	else
		videoBtnOL.hidden=YES;
	
    coreDataService = [[CoreDataService alloc] init];
    [coreDataService initialize];
	
}

- (void)viewWillAppear:(BOOL)animated
{
	 [super viewWillAppear:animated];
	
	 
	 
	 if(productPrice!=nil)
	 {
	 	if([productPrice isEqualToString:@"0,00"])
	 	{
	 		tableProductPrice.text=@"GRÁTIS";
		//	[comprarBtnOL setTitle: orState:<#(UIControlState)#>=@"BAIXE AGORA";
			[comprarBtnOL setTitle:@"BAIXE AGORA" forState:UIControlStateNormal];
		}
	 	else
	 		tableProductPrice.text=[@"R$ " stringByAppendingString:productPrice];
	 }
	 if(show_details_only==TRUE)
	 {
	 		comprarBtnOL.hidden=YES;
	 		tableProductPrice.hidden=YES;
	 		tableProductDescription.text=productDescription;
	 }
	 else
	 {
	 	if([productDeliverDays isEqualToString:@"0"])
	 	{
			 NSString *finalText=[productDescription stringByAppendingString:@"\n\nSeu treino será baixado imediatamente."];
			
			 tableProductDescription.text=finalText;
	    }
	    else
	    {
			  NSString *finalText=[productDescription stringByAppendingString:@"\n\nEntrega do seu treino personalizado será feito em até "];
			 finalText=[finalText stringByAppendingString:productDeliverDays];
			 finalText=[finalText stringByAppendingString:@" dias a partir do preenchimento dos questionários por você.\n"];
			 tableProductDescription.text=finalText;
		 }
	 }
}

- (void)viewWillDisappear:(BOOL)animated
{
  [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
  [SVProgressHUD dismiss];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGRect screen = [[UIScreen mainScreen] bounds];
	CGFloat width = CGRectGetWidth(screen);
	switch(indexPath.row)
	{
		case 0:
     		return width/1.785+15;
   	case 1:
   		return 93;
	  case 2:
   		return 300;
			
     default:
     		return 0;
	}
}


- (IBAction)comprarBrn:(id)sender {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  	  BOOL login = [defaults boolForKey:@"userStatus"];
	
    // Verifica se o usuário esta logado.
    if (login == TRUE)
    {
		 
		 
    
	 
	
	
	  // VERIFICA SE TEM CONEXÃO COM A INTERNET.
    BOOL flagInternetStatus = [IMManager sharedManager].hasConnection;
	
    if (!flagInternetStatus)
    {
        // Configura um custom AlertView.
        UIAlertView *CustomAlert = [[UIAlertView alloc] initWithTitle:@"Atenção"
                                                                  message:@"Você deve estar conectado a Internet para realizar compras. Verifique sua conexão e tente novamente mais tarde."
                                                                 delegate:self
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil, nil];
        // Configura a cor do AlertView.
        [CustomAlert setBackgroundColor:[UIColor blackColor]];
		 
        [CustomAlert show];
        return;

    }
	
    dispatch_async(dispatch_get_main_queue(), ^{
		
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Confirmar"
                                                  message:@"Deseja iniciar a compra deste item na Apple Store?"
                                                  preferredStyle:UIAlertControllerStyleAlert];
#ifdef NEW_STYLE
            alertController.view.tintColor=[UIColor colorNamed:@"myCellTextColor"];
#endif
            UIAlertAction *actionYES = [UIAlertAction actionWithTitle:@"Sim"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action){
																					  if([coreDataService checkValiditTransactionDateWithProductId:productId]==FALSE)
																					  {
                                                                 		[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
	 																						[SVProgressHUD showWithStatus:@"Aguarde Processo de Compra..." maskType:SVProgressHUDMaskTypeGradient];
        																					[self requestSpecificProductData:productId];
																						}
																						else
																						{
																																												// Configura um custom AlertView.
																								  UIAlertView *CustomAlert = [[UIAlertView alloc] initWithTitle:@"Atenção"
																																												message:@"Uma assessoria já está em andamento. Se não estiver visível, recupere seu produto na tela <Meus Treinos> clicando no botão <Restore Purchases>"
																																											  delegate:self
																																								  cancelButtonTitle:@"OK"
																																								  otherButtonTitles:nil, nil];
																								  // Configura a cor do AlertView.
																								  [CustomAlert setBackgroundColor:[UIColor blackColor]];
																							
																								  [CustomAlert show];
																								  return;
																						}
                                                              }];
		
            UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancelar"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * action){
                     
                                                                     [alertController dismissViewControllerAnimated:YES completion:nil];
																						  
                                                                 }];
		
		 
            [alertController addAction:actionCancel];
            [alertController addAction:actionYES];
		
		
            [self presentViewController:alertController animated:YES completion:nil];
        });
		 
		 
    }
    else
    {
		 
    // Configura um custom AlertView.
			  UIAlertView *CustomAlert = [[UIAlertView alloc] initWithTitle:@"Atenção"
																							message:@"Faça seu login para acessar os conteúdos."
																						  delegate:self
																			  cancelButtonTitle:@"OK"
																			  otherButtonTitles:nil, nil];
			  // Configura a cor do AlertView.
			  [CustomAlert setBackgroundColor:[UIColor blackColor]];
		 
			  [CustomAlert show];
				[self performSegueWithIdentifier:@"segueCompras" sender:self];
		 }
	 }





// InAppPurchaseManager.m
- (void)requestSpecificProductData: (NSString *) prodId
{
	
	
    NSSet *productIdentifiers = [NSSet setWithObjects:
											
                                 prodId,
											
                                 nil
                                 ];
    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
	
    EstagioCompra=EM_APROVACAO_APPLE;
    NSLog(@"Estágio = EM_APROVACAO_APPLE");
    [productsRequest start];
	
    // we will release the request object in the delegate callback
}

#pragma mark -
#pragma mark SKProductsRequestDelegate methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
	//[SVProgressHUD dismiss];
    products = response.products;
    num_products=[products count];
    proUpgradeProduct = [products count] == 1 ? [products firstObject] : nil;
//    if (proUpgradeProduct)
//    {
//        NSLog(@"Product title: %@" , proUpgradeProduct.localizedTitle);
//        NSLog(@"Product description: %@" , proUpgradeProduct.localizedDescription);
//        NSLog(@"Product price: %@" , proUpgradeProduct.price);
//        NSLog(@"Product id: %@" , proUpgradeProduct.productIdentifier);
////    }
	
    for (int i=0; i<num_products; i++)
    {
		 
       proUpgradeProduct=[products objectAtIndex:i];
        NSLog(@"Product title: %@" , proUpgradeProduct.localizedTitle);
        NSLog(@"Product description: %@" , proUpgradeProduct.localizedDescription);
        NSLog(@"Product price: %@" , proUpgradeProduct.price);
        NSLog(@"Product id: %@" , proUpgradeProduct.productIdentifier);
    }
	
    for (NSString *invalidProductId in response.invalidProductIdentifiers)
    {
        NSLog(@"Invalid product id: %@" , invalidProductId);
    }
	
    if([self canMakePurchases]==TRUE)
    {
        EstagioCompra=AUTORIZADO_APPLE;
        NSLog(@"Estágio = AUTORIZADO_APPLE");
		 
		 
         NSLog(@"CAN MAKE PURCHASES TRUE, ID=%@", proUpgradeProduct.productIdentifier);
                EstagioCompra=PROCESSANDO_APPLE;
                NSLog(@"Estágio = PROCESSANDO_APPLE");
                SKPayment *payment = [SKPayment paymentWithProduct:proUpgradeProduct];
                [[SKPaymentQueue defaultQueue] addPayment:payment];
    
    }
	
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
	
	
	
}

//
// call this before making a purchase
//
- (BOOL)canMakePurchases
{
    return [SKPaymentQueue canMakePayments];
}

#pragma -
#pragma Purchase helpers

//
// saves a record of the transaction by storing the receipt to disk
//
- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
 //   if ([transaction.payment.productIdentifier isEqualToString:kInAppPurchaseProUpgradeProductId])
    {
		 
        NSLog(@"Transaction ID=%@",transaction.payment.productIdentifier);
        NSLog(@"Transaction ID=%@",transaction.transactionIdentifier);
        NSLog(@"Transaction ID=%@",transaction.transactionDate );
		 
		 
		 
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.payment.productIdentifier forKey:@"treinoInAppPurchased" ];
		 
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [SVProgressHUD dismiss];
}

//
// enable pro features
//
- (void)provideContent:(SKPaymentTransaction *)transaction
{
	[SVProgressHUD dismiss];
    EstagioCompra=APROVADO_APPLE;
    NSLog(@"Estágio = APROVADO_APPLE");
	
	if(transaction.originalTransaction!=nil)
	{
		NSLog(@"Transacao Repetida");
		return;
	}
		
   InAppTransactions *thistransaction = (InAppTransactions *)[NSEntityDescription insertNewObjectForEntityForName:@"InAppTransactions"
																															inManagedObjectContext:coreDataService.getManagedContext];
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	
    // set locale to something English
    NSLocale *ptLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"pt"];
    [df setLocale:ptLocale];
	
	
  thistransaction.date = [df stringFromDate:transaction.transactionDate];
  thistransaction.isSync =[NSNumber numberWithBool:FALSE];
  thistransaction.product_id = transaction.payment.productIdentifier;
  thistransaction.transaction_id = transaction.transactionIdentifier;
	
  InAppProducts *thisProduct= [coreDataService getInAppProductDataWithProductId:thistransaction.product_id];
	
	if(thisProduct!=nil)
	{
		thistransaction.training_name=thisProduct.titulo;
		thistransaction.training_description=thisProduct.descricao;
		thistransaction.training_id=thisProduct.training_id;
		thistransaction.isonlineadvisor=thisProduct.isonlineadvisor;
	}
	
	
	
  [coreDataService saveData];
	
	// Verifica se o usuário esta logado.
   // Pega o status do usuário, logado ou não.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL login = [defaults boolForKey:@"userStatus"];
	
  NSUserDefaults *Defaults = [NSUserDefaults standardUserDefaults];
  [Defaults setBool:TRUE forKey:@"purchaseNeedUpdate"];
  [defaults synchronize];
	
	 if([thistransaction.isonlineadvisor boolValue]==TRUE)
	 {
		 if (login == TRUE)
		 {
			 // Configura um custom AlertView.
			  UIAlertView *CustomAlert = [[UIAlertView alloc] initWithTitle:@"Parabéns"
																							message:@"Você acaba de adquirir um plano de Assessoria. Acesse sua assessoria na tela <Meus Treinos>"
																						  delegate:self
																			  cancelButtonTitle:@"OK"
																			  otherButtonTitles:nil, nil];
			  // Configura a cor do AlertView.
			  [CustomAlert setBackgroundColor:[UIColor blackColor]];
			 
			  [CustomAlert show];
           
			  [self.navigationController popViewControllerAnimated:YES];
		 }
		 else
		 {
		 
				// Configura um custom AlertView.
			  UIAlertView *CustomAlert = [[UIAlertView alloc] initWithTitle:@"Parabéns"
																							message:@"Você acaba de adquirir um plano de Assessoria. Vamos registrar sua compra em nossos servidores para você ter acesso aos conteúdos e questionários. Acesse esta compra na tela <Meus Treinos> e veja as instruções. Obrigado"
																						  delegate:self
																			  cancelButtonTitle:@"OK"
																			  otherButtonTitles:nil, nil];
			  // Configura a cor do AlertView.
			  [CustomAlert setBackgroundColor:[UIColor blackColor]];
			 
			  [CustomAlert show];
				[self performSegueWithIdentifier:@"segueCompras" sender:self];
		 }
	 }
	 else
	 {
	   // Configura um custom AlertView.
			  UIAlertView *CustomAlert = [[UIAlertView alloc] initWithTitle:@"Parabéns"
																							message:@"Seu treino já está disponível, acesse na tela <Meus Treinos>"
																						  delegate:self
																			  cancelButtonTitle:@"OK"
																			  otherButtonTitles:nil, nil];
			  // Configura a cor do AlertView.
			  [CustomAlert setBackgroundColor:[UIColor blackColor]];
		 
			  [CustomAlert show];
			  [self.navigationController popViewControllerAnimated:YES];
	 
	 	[self.navigationController popViewControllerAnimated:YES];
	 }
	
}

//
// removes the transaction from the queue and posts a notification with the transaction result
//
- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
	 [SVProgressHUD dismiss];
    // remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
	
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
    if (wasSuccessful)
    {
        // send out a notification that we’ve finished the transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:self userInfo:userInfo];
    }
    else
    {
        // send out a notification for the failed transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionFailedNotification object:self userInfo:userInfo];
    }
}

//
// called when the transaction was successful
//
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
	 [SVProgressHUD dismiss];
    [self recordTransaction:transaction];
    [self provideContent:transaction];
    [self finishTransaction:transaction wasSuccessful:YES];
	

}

//
// called when a transaction has been restored and successfully completed
//
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
	 [SVProgressHUD dismiss];
    [self recordTransaction:transaction.originalTransaction];
    [self provideContent:transaction];
    [self finishTransaction:transaction wasSuccessful:YES];
}

//
// called when a transaction has failed
//
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
	 [SVProgressHUD dismiss];
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // error!
        [self finishTransaction:transaction wasSuccessful:NO];
		 
          UIAlertView *CustomAlert = [[UIAlertView alloc] initWithTitle:@"Atenção"
                                                                  message:@"O processo de compra não foi concluído, refaça sua compra em alguns instantes."
                                                                 delegate:self
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil, nil];
        // Configura a cor do AlertView.
        [CustomAlert setBackgroundColor:[UIColor blackColor]];
	
        [CustomAlert show];
    }
    else
    {
        // this is fine, the user just cancelled, so don’t notify
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        NSLog(@"Estágio = NAO_INICIADO ERROR CODE = %ld",transaction.error.code);
     // Configura um custom AlertView.
        UIAlertView *CustomAlert = [[UIAlertView alloc] initWithTitle:@"Atenção"
                                                                  message:@"O processo de compra foi interrompido pelo usuário e não concluído."
                                                                 delegate:self
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil, nil];
        // Configura a cor do AlertView.
        [CustomAlert setBackgroundColor:[UIColor blackColor]];
	
        [CustomAlert show];
    }
	
    EstagioCompra=NAO_INICIADO;
    NSLog(@"Estágio = NAO_INICIADO ERROR CODE = %ld",transaction.error.code);
	
    [SVProgressHUD dismiss];
	
	
}



#pragma mark -
#pragma mark SKPaymentTransactionObserver methods

//
// called when the transaction status is updated
//
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            default:
                break;
        }
    }
}

//hen this delegate Function Will be fired
- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSMutableArray *purchasedItemIDs = [[NSMutableArray alloc] init];
	
    NSLog(@"received restored transactions: %i", queue.transactions.count);
    for (SKPaymentTransaction *transaction in queue.transactions)
    {
        NSString *productID = transaction.payment.productIdentifier;
        [purchasedItemIDs addObject:productID];
    }
    [SVProgressHUD dismiss];
}
-(void) cancelaCompra
{
    //if(EstagioCompra==EM_APROVACAO_APPLE)
    {
        [SVProgressHUD dismiss];
        [SVProgressHUD showWithStatus:@"Esgotou o tempo limite para esta compra..."];
        double delayInSeconds = 2;
		 
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            //code to be executed on the main queue after delay
			  
            // Remove o HUD.
            [SVProgressHUD dismiss];
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
	
}


- (void)loadVideo
{
//    if (1)//exercise.video.length > 0)
//    {
//  //      XCDYouTubeVideoPlayerViewController *videoPlayerVC = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:productVideo];
//  //      [self presentMoviePlayerViewControllerAnimated:videoPlayerVC];
//        AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc] init];
//    [self presentViewController:playerViewController animated:YES completion:nil];
//
//    // Extrai a URL do video e passa para o player iniciar a repordução.
//    [[XCDYouTubeClient defaultClient]getVideoWithIdentifier:productVideo completionHandler:^(XCDYouTubeVideo * _Nullable video, NSError * _Nullable error) {
//  
//        NSDictionary *dict = video.streamURLs;
//        NSURL *url = dict[@(XCDYouTubeVideoQualityHD720)] ?: dict[@(XCDYouTubeVideoQualityMedium360)] ?: dict[@(XCDYouTubeVideoQualitySmall240)];
//		 
//        playerViewController.player = [[AVPlayer alloc]initWithURL:url];
//        [playerViewController.player play];
//		 
//		  }];
//    }
//    else
//    {
//        [SVProgressHUD showImage:[UIImage imageNamed:@"Video_Alert"]
//                          status:@"Vídeo Indisponível!"
//                        maskType:SVProgressHUDMaskTypeGradient];
//    }
    
    
 
    if (productVideo.length > 0)
    {
   //  [self.playerView loadWithVideoId:exercise.video];
		 
		NSDictionary *playerVars = @{
		@"showinfo": @0,
		@"playsinline" : @1,
		@"rel": @0,
		@"ecver:": @2,
		@"modestbranding": @1
		};

		
		[self.playerView loadWithVideoId:productVideo playerVars:playerVars];
		
		[self.playerView playVideo];
		
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
    
		}
      break;
    case kYTPlayerStatePaused: 
    {
      NSLog(@"Paused playback");
      UIView *viewToRemove = [self.view viewWithTag:31];
		[viewToRemove removeFromSuperview];
		}
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


@end
