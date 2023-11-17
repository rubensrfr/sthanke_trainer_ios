//
//  UtilityClass.m
//  mobitrainner
//
//  Created by Reginaldo Lopes on 08/12/14.
//  Copyright (c) 2014 4mobi. All rights reserved.
//

#import "UtilityClass.h"
#import <UIKit/UIKit.h>

@implementation UtilityClass

@synthesize flagHasConnection;

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)StringtoHex:(NSString *)strValue
{
    NSMutableString *tempHex=[[NSMutableString alloc] init];
    
    [tempHex appendString:strValue];
    
    unsigned colorInt = 0;
    
    [[NSScanner scannerWithString:tempHex] scanHexInt:&colorInt];
    
    return colorInt;
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (NSString *)returnLibraryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    
    return cachePath;
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (NSString *)returnDocumentsPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    return documentsPath;
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (NSArray *)pngFilesInFeaturedImagesFolder
{
    // Caminho onde as imagens serão salvas, dentro do Caches/Imagens.
    NSString *filename = @"/Caches/FeaturedImages";
    
    // Configura o path com a url para o caminho.
    NSString *path = [[self returnDocumentsPath] stringByAppendingPathComponent:filename];
    
    NSArray *numberOfFileInFolder = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"self ENDSWITH '.png'"];
    NSArray *pngFiles = [numberOfFileInFolder filteredArrayUsingPredicate:filter];
    
    return pngFiles;
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// VERIFICA QUANTOS ARQUIVOS DO TIPO PNG EXISTEM NA PASTA /DOCUMENTS/IMAGENS DESTAQUE //////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSString *)md5HexDigest:(NSString*)input
{
    if(input==nil)
       return nil;
    const char* str = [input UTF8String];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
	
    CC_MD5(str, (CC_LONG)strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++)
    {
        [ret appendFormat:@"%02x",result[i]];
    }
    
    return ret;
}

////////////////////////////////////////////////////////////////////////////////////////
/// VERIFICA SE A STRING Ë NULA OU ESTA VAZIA //////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (NSString *)checkString:(NSString *)string
{
    if (string == nil || string == (NSString *)[NSNull null])
    {
        return @"";
    }
    else
    {
        return string;
    }
}

////////////////////////////////////////////////////////////////////////////////////////
/// COMPARA DATA1 e DATA2 E RETORNA SE É MAIOR MENOR OU IGUAL //////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)compareDatesServer:(NSDate *)serverDate AndLocal:(NSDate *)localDate
{
    NSInteger status = 0;
    
    if ([serverDate compare:localDate] == NSOrderedDescending)
    {
        status = 1;
        NSLog(@"SERVERDATE É MAIOR QUE LOCALDATE... \n\n");
    }
    else if ([serverDate compare:localDate] == NSOrderedAscending)
    {
        status = 2;
        NSLog(@"SERVERDATE É MENOR QUE LOCALDATE...\n\n");
    }
    else
    {
        status = 0;
        NSLog(@"AS DATAS SÃO IGUAIS...\n\n");
    }
    
    return status;
}

////////////////////////////////////////////////////////////////////////////////////////
/// TRATAMENTO DE ESCAPE PARA AS URL ///////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (NSString*)encodeToPercentEscapeString:(NSString *)string
{
    // Remove os caracteres especiais.
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (CFStringRef) string,NULL,
                                                                                 (CFStringRef) @"!*'();:@&=+$,/?%#[]",
                                                                                 kCFStringEncodingUTF8));
}

////////////////////////////////////////////////////////////////////////////////////////
/// CRIA STRING CONVERTENDO O EMOJI EM CÓDIGO PARA SALVAR NO BD ////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (NSString *)createStringCodeFromEmoji:(NSString *)string
{
    NSString *testedString;
    
    if ([self stringContainsEmoji:string])
    {
        NSString *urlStringEscape = [self encodeToPercentEscapeString:string];
        
        NSData *data = [[NSString stringWithFormat:@"%@",urlStringEscape] dataUsingEncoding:NSNonLossyASCIIStringEncoding];
        testedString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    else
    {
        NSString *urlStringEscape = [self encodeToPercentEscapeString:string];
        
        testedString = urlStringEscape;
    }
    
    return testedString;
}

////////////////////////////////////////////////////////////////////////////////////////
/// CRIA STRING CONVERTENDO O EMOJI EM CÓDIGO PARA SALVAR NO BD ////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (NSString *)createEmojiFromCodeString:(NSString *)string
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *goodValue = [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];
    
    if ([self stringContainsEmoji:goodValue])
    {
        return [goodValue stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    else
    {
        return [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
}

////////////////////////////////////////////////////////////////////////////////////////
/// VERIFICA SE A STRING CONTEM EMOJI //////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff)
         {
             if (substring.length > 1)
             {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 
                 if (0x1d000 <= uc && uc <= 0x1f77f)
                 {
                     returnValue = YES;
                 }
             }
         }
         else if (substring.length > 1)
         {
             const unichar ls = [substring characterAtIndex:1];
             
             if (ls == 0x20e3)
             {
                 returnValue = YES;
             }
         }
         else
         {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff)
             {
                 returnValue = YES;
             }
             else if (0x2B05 <= hs && hs <= 0x2b07)
             {
                 returnValue = YES;
             }
             else if (0x2934 <= hs && hs <= 0x2935)
             {
                 returnValue = YES;
             }
             else if (0x3297 <= hs && hs <= 0x3299)
             {
                 returnValue = YES;
             }
             else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50)
             {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}

////////////////////////////////////////////////////////////////////////////////////////
/// VERIFICA SE O CREF É VALIDO (SIMPLES) //////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)validateCREFWithString:(NSString *)s
{
    if ([s length] && isnumber([s characterAtIndex:0]) && [s length] && isnumber([s characterAtIndex:1]) &&
        [s length] && isnumber([s characterAtIndex:2]) && [s length] && isnumber([s characterAtIndex:3]) &&
        [s length] && isnumber([s characterAtIndex:4]) && [s length] && isnumber([s characterAtIndex:5])) {

        unichar checkPrefix = [s characterAtIndex:7];
        NSCharacterSet *letters = [NSCharacterSet letterCharacterSet];
        if (([letters characterIsMember:checkPrefix] && checkPrefix == 'P') || checkPrefix == 'G')
        {
            unichar checkState1 = [s characterAtIndex:9];
            NSCharacterSet *letters = [NSCharacterSet letterCharacterSet];
            if ([letters characterIsMember:checkState1])
            {
                unichar checkState2 = [s characterAtIndex:10];
                NSCharacterSet *letters = [NSCharacterSet letterCharacterSet];
                if ([letters characterIsMember:checkState2])
                {
                    return TRUE;
                }
                else
                {
                    return FALSE;
                }
            }
            else
            {
                return FALSE;
            }
        }
        else
        {
            return FALSE;
        }
    }
    else
    {
        return FALSE;
    }
    
    return FALSE;
}


////////////////////////////////////////////////////////////////////////////////////////
/// RETORNA O TAMANHO DE UMA STRING ////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////


// Think of this as some utility function that given text, calculates how much
// space would be needed to fit that text.
- (CGSize)frameForText:(NSString *)text sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          font, NSFontAttributeName,
                                          nil];
    CGRect frame = [text boundingRectWithSize:size
                                      options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                   attributes:attributesDictionary
                                      context:nil];
    
    // This contains both height and width, but we really care about height.
    return frame.size;
}

////////////////////////////////////////////////////////////////////////////////////////
/// MOSTRA UM ALERT SIMPLES ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (void)showAlertWithTitle:(NSString *)title AndText:(NSString *)text AndTargetVC:(UIViewController *)targetVC
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:title
                                              message:text
                                              preferredStyle:UIAlertControllerStyleAlert];
#ifdef NEW_STYLE
        alertController.view.tintColor=[UIColor colorNamed:@"myCellTextColor"]; //???
#endif
        UIAlertAction *action = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action){
                                    
                                     [alertController dismissViewControllerAnimated:YES completion:nil];

                                 }];
        
        [alertController addAction:action];
        
        [targetVC presentViewController:alertController animated:YES completion:nil];
    });
}

////////////////////////////////////////////////////////////////////////////////////////
/// RETORNA A DIFERENCA ENTRE DUAS DATAS EM HORAS, DIAS, SEMANAS ///////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (NSString *)dateToStringInterval:(NSDate *)pastDate
{
    // Pega o calendario do sistema
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
	
    // Cria a data atual
    NSDate *currentDate = [[NSDate alloc] init];
	
    // Quebra a data em mes, dia, hora, minuto
    unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit;
	
    NSDateComponents *breakdownInfo = [sysCalendar components:unitFlags
                                                     fromDate:currentDate
                                                       toDate:pastDate
                                                      options:0];
    NSString *intervalString;
	
    if ([breakdownInfo month])
    {
        if (-[breakdownInfo month] > 1) intervalString = [NSString stringWithFormat:@"%ld%@", (long)-[breakdownInfo month],@" meses atrás"];
        else intervalString = @"1 mês atrás";
    }
    else if ([breakdownInfo day])
    {
        if (-[breakdownInfo day] > 1) intervalString = [NSString stringWithFormat:@"%ld%@", (long)-[breakdownInfo day],@" dias atrás"];
        else intervalString = @"1 dia atrás";
    }
    else if ([breakdownInfo hour])
    {
        if (-[breakdownInfo hour] > 1) intervalString = [NSString stringWithFormat:@"%ld%@", (long)-[breakdownInfo hour],@" horas atrás"];
        else intervalString = @"1 hora atrás";
    }
    else
    {
        if (-[breakdownInfo minute] > 1) intervalString = [NSString stringWithFormat:@"%ld%@", (long)-[breakdownInfo minute],@" minutos atrás"];
        else intervalString = @"1 minuto atrás";
    }
	
    return intervalString;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)updateTransactionsToServer
{
	
	// Pega o status do usuário, logado ou não.
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	BOOL login = [defaults boolForKey:@"userStatus"];
	
	if (login != TRUE)
		return;
	coreDataService = [[CoreDataService alloc] init];
	[coreDataService initialize];
	//
	//
	//	dispatch_async(dispatch_get_main_queue(), ^{
	//		[SVProgressHUD showWithStatus:@"Registrando suas compras..." maskType: SVProgressHUDMaskTypeGradient];
	//	});
	//
	// RECUPERA A APIKEY
	User *userData = (User *) [coreDataService getDataFromUserTable];
	
	///////////////////////////////////////////////////////////////////////////////////
	/// VERIFICA SE EXISTEM ITENS DO HISTÓRICO DE TREINO PARA SEREM SINCORNIZAR //////
	///////////////////////////////////////////////////////////////////////////////////
	
	NSArray *arrayFiltered = [coreDataService getDataFromInAppTransactionsTable]; // WithIsSync:NO isonlineadvisor:YES];
	
	if ([arrayFiltered count] > 0)
	{
		for (NSInteger i = 0; i < [arrayFiltered count]; i++)
		{
			InAppTransactions *thisTransaction = [arrayFiltered objectAtIndex:i];
			
			//NSString *training_id=[coreDataService getTrainingIdFromProductsTableWithProductId:thisTransaction.product_id];
		//	if(training_id==nil)
		//		return;
			//			  apikey - do master
			//workout_publickey - do treino que está à venda
			//trainee_email - email do usuário
			//transaction_id - ID da transação da venda
			//os - plataforma ((2=iOs, 3=Android, 4=Windows)
			//datetime - data e hora da venda (formato Y-m-d H:i:s)
			//
			// Parametros validados.
			if(thisTransaction.training_id==nil)
			   continue;
			NSDictionary *parameters = @{
												  @"apikey": API_KEY_TRAINER,
												  @"training_id": thisTransaction.training_id ,
												  @"trainee_email": userData.email ,
												  @"transaction_id": thisTransaction.transaction_id,
												  @"os":@"2",
												  @"datetime":thisTransaction.date
												  
												  };
			
			// Monta a string de acesso a validação do login.
			NSMutableString *urlString = [[NSMutableString alloc] init];
			[urlString appendString:kBASE_URL_MOBITRAINER];
			[urlString appendString:@"api/inapp/setpurchase"];
			
			AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
			[manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
			NSString *path=[[NSString alloc]initWithFormat:@"%@",urlString];
		      [manager POST:[NSURL URLWithString:path].absoluteString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
     	    {
				if (![[responseObject objectForKey:@"response_error"] boolValue])
				{
					thisTransaction.isSync = [NSNumber numberWithBool:YES];
					
					[coreDataService saveData];
					
					
				}
				else
				{
					thisTransaction.isSync = [NSNumber numberWithBool:YES];
					
					[coreDataService saveData];
				}
				
			} failure:^(NSURLSessionTask *operation, NSError *error){
				
				NSLog(@"Error: %@", error);
				//Erro:
				//602 - Apikey inválida
				//614 - Publickey do treino à venda é inválida
				//803 - Endereço de e-mail não encontrado
				//607 - SO inválido
				//666 - Erro inesperado
				
			}];
		}
	}
}



////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)downloadProductsForSale
{
	// VERIFICA SE TEM CONEXÃO COM A INTERNET.
//	BOOL flagInternetStatus = [IMManager sharedManager].hasConnection;
//
//	// SE TEM CONEXÃO
//	if (!flagInternetStatus)
//	{
//		//		[utils showAlertWithTitle:kTEXT_ALERT_TITLE
//		//								AndText:kTEXT_INTERNET_ERROR_DEFAULT
//		//						  AndTargetVC:self];
//		return;
//	}
	
	coreDataService = [[CoreDataService alloc] init];
	[coreDataService initialize];
	
	[SVProgressHUD showWithStatus:@"Atualizando Produtos..." maskType: SVProgressHUDMaskTypeGradient];
	
	// Monta a string de acesso a validação do login.
	NSMutableString *urlString = [[NSMutableString alloc] init];
	[urlString appendString:kBASE_URL_MOBITRAINER];
	[urlString appendString:@"api/inapp/getproducts"];
	
	// Inicializa o manager.
	//AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	//[manager.requestSerializer setTimeoutInterval:AFHHTTP_TIMEOUT];
	NSDictionary *parameters;
	
	parameters = @{@"apikey":API_KEY_TRAINER};
	
	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
			[manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
			NSString *path=[[NSString alloc]initWithFormat:@"%@",urlString];
			[manager POST:[NSURL URLWithString:path].absoluteString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
	
	//[manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		
		if (![[responseObject objectForKey:@"response_error"] boolValue])
		{
			////////////////////////////////////////////////////////////////////////
			/// PEGA OS DADOS DOS TREINOS //////////////////////////////////////////
			////////////////////////////////////////////////////////////////////////
			
			NSArray *arrayInAppProducts = [[NSArray alloc] initWithArray:[responseObject objectForKey:@"workouts"]];
			
			
			[coreDataService dropInAppProductsTable];
			
			if (arrayInAppProducts.count > 0)
			{
				
				
				
				for (NSInteger i = 0; i < [arrayInAppProducts count]; i++)
				{
					InAppProducts *products1 = (InAppProducts *)[NSEntityDescription insertNewObjectForEntityForName:@"InAppProducts"
																													  inManagedObjectContext:coreDataService.getManagedContext];
					products1.training_id = [self checkString:[[arrayInAppProducts objectAtIndex:i] objectForKey:@"response_training_id"]];
					products1.product_id = [self checkString:[[arrayInAppProducts objectAtIndex:i] objectForKey:@"response_inappid"]];
					products1.titulo = [self checkString:[[arrayInAppProducts objectAtIndex:i] objectForKey:@"response_name"]];
					products1.descricao = [self checkString:[[arrayInAppProducts objectAtIndex:i] objectForKey:@"response_description"]];
					products1.preco = [self checkString:[[arrayInAppProducts objectAtIndex:i] objectForKey:@"response_price_brl"]];
					//		products1.preco_usd = [utils checkString:[[arrayInAppProducts objectAtIndex:i] objectForKey:@"response_price_usd"]];
					products1.video = [self checkString:[[arrayInAppProducts objectAtIndex:i] objectForKey:@"response_video"]];
					products1.isonlineadvisor =  [NSNumber numberWithBool: [[[arrayInAppProducts objectAtIndex:i] objectForKey:@"response_isonlineadvisor"] boolValue]];
					products1.status = [NSNumber numberWithBool: [[[arrayInAppProducts objectAtIndex:i] objectForKey:@"response_status"] boolValue]];
					products1.response_days = [NSNumber numberWithInteger:[[self checkString:[[arrayInAppProducts objectAtIndex:i] objectForKey:@"response_days"]]integerValue]];
					
					if(products1.status==0)
						products1.image_store=nil;
					else
					{
						products1.image_store = [self checkString:[[arrayInAppProducts objectAtIndex:i] objectForKey:@"response_image"]];
						products1.image_product = [self checkString:[[arrayInAppProducts objectAtIndex:i] objectForKey:@"response_image2"]];
					}
					[coreDataService saveData];
					
					
				}
				
				[SVProgressHUD showSuccessWithStatus:@"Produtos atualizados \ncom sucesso!"];
				
				LastUpdates *lastUpdate = (LastUpdates *) [coreDataService getDataFromLastUpdatesTable];
				
				// CONFIGURA A DATA ATUAL.
				NSDateFormatter *format = [[NSDateFormatter alloc] init];
				[format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
				NSDate *now = [[NSDate alloc] init];
				NSString *dateString = [format stringFromDate:now];
				
				lastUpdate.training = dateString;
				
				[coreDataService saveData];
				
				
				
			}
			else
			{
				[SVProgressHUD showSuccessWithStatus:@"Não existem produtos a venda!"];
			}
			
			
		
		}
		
	} failure:^(NSURLSessionTask *operation, NSError *error)
         {	
		[SVProgressHUD dismiss];
		NSLog(@"Error: %@", error);
		
	}];
}




@end

////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
