//
//  BioController.m
//  mobitrainner
//
//  Created by Reginaldo Lopes on 03/12/14.
//  Copyright (c) 2014 4mobi. All rights reserved.
//

#import "BioVC.h"

@interface BioVC()

@end

@implementation BioVC

@synthesize imageTrainer;
@synthesize labelTrainerName;
@synthesize labelTrainerEmail;
@synthesize labelDocument;
@synthesize textViewSobre;

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - VIEW LIFECYCLE

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    utils = [[UtilityClass alloc] init];
    
    // Inicializa o helper do Banco de dados.
    coreDataService = [[CoreDataService alloc] init];
    [coreDataService initialize];
    
    imageTrainer.layer.cornerRadius = imageTrainer.frame.size.width / 2;
	 imageTrainer.layer.borderColor = UIColorFromRGB(kPRIMARY_COLOR).CGColor;
    imageTrainer.layer.borderWidth = 3.0f;
    
    imageTrainer.clipsToBounds = YES;
    
//    // Configura o background da tableview.
//    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    [backgroundView setBackgroundColor:UIColorFromRGB(0xDFDFDF)];
//    [self.tableView setBackgroundView:backgroundView];
//    
    TrainerInfo *trainer = [coreDataService getDataFromTrainerInfoTable];
    
    NSMutableString *fullName = [[NSMutableString alloc] init];
    
 
    labelTrainerName.text = NOME_COMPLETO;
    labelTrainerEmail.text = BIO_EMAIL_RECIPIENT;
    
    //////////////////////////////////////////////////////////////////////
    /// DOCUMENTO ////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////
    
    if (trainer.cnpj.length > 0)
    {
        labelDocument.text = [NSString stringWithFormat:@"CNPJ: %@",trainer.cnpj];
    }
    else if(trainer.cref.length > 0)
    {
        labelDocument.text = [NSString stringWithFormat:@"CREF: %@",trainer.cref];
    }
    else if(trainer.cref.length == 0 && trainer.cnpj.length  == 0)
    {
        
        labelDocument.text = @"";
    }
    
    //////////////////////////////////////////////////////////////////////
    /// TEXTVIEW SOBRE ///////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////
    
    textViewSobre.text = trainer.biography;
    
    //////////////////////////////////////////////////////////////////////
    /// IMAGEM ///////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////
 
     if(trainer.image.length > 0)
     {
         NSMutableString *filenameImage = [[NSMutableString alloc] init];
         [filenameImage appendString:@"/Caches/ProfileImages/"];
         [filenameImage appendString:[NSString stringWithFormat:@"%@",[utils md5HexDigest:trainer.image]]];
         [filenameImage appendString:@".png"];

         NSString* pathImage = [[utils returnDocumentsPath] stringByAppendingPathComponent:filenameImage];
         BOOL imageExists = [[NSFileManager defaultManager] fileExistsAtPath:pathImage];
         
         spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
         
         spinner.frame = CGRectMake(((self.tableView.frame.size.width / 2) - 10),
                                     (imageTrainer.frame.size.height / 2),
                                     20, 20);
         
         [spinner hidesWhenStopped];
         [spinner startAnimating];
         [self.tableView addSubview:spinner];
         
         group = dispatch_group_create();
         queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
         
         if (!imageExists)
         {
             dispatch_group_enter(group);
             dispatch_async(queue, ^{

                 // Faz o download
                 [self getExercisesImagesWithURL:trainer.image];
                 
             });
         }
         
         dispatch_group_notify(group, queue, ^{
             
             dispatch_sync(dispatch_get_main_queue(), ^{

                 [spinner stopAnimating];
                 
                 NSMutableString *filenameImage = [[NSMutableString alloc] init];
                 [filenameImage appendString:@"/Caches/ProfileImages/"];
                 [filenameImage appendString:[utils md5HexDigest:trainer.image]];
                 [filenameImage appendString:@".png"];
                 
                 NSString *imagePath = [[utils returnDocumentsPath] stringByAppendingPathComponent:filenameImage];
                 UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
                 
                 imageTrainer.image = image;
                 
                 CATransition *transition = [CATransition animation];
                 transition.type = kCATransitionFade;
                 transition.duration = 0.3f;
                 [imageTrainer.layer addAnimation:transition forKey:nil];
             });
         });
     }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
#ifdef OLD_STYLE
    Design *appDesign = (Design *) [coreDataService getDataFromDesignTable];

    BOOL flagBlackStatusBar = appDesign.blackStatusBar.boolValue;

    // COR DO TEXTO NA STATUSBAR.
    if (flagBlackStatusBar)
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    else
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
#endif
	
}


#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGRect screen = [[UIScreen mainScreen] bounds];
	CGFloat width = CGRectGetWidth(screen);
	switch(indexPath.row)
	{
		case 0:
     		return width/2.215;
   	case 1:
   		return 100;
	  case 2:
   		return 390;
     default:
     		return 0;
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - CUSTOM METHODS

- (void)getExercisesImagesWithURL:(NSString *)url
{
    if(url.length > 0)
    {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        NSURL *URL = [NSURL URLWithString:url];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request
                                                                         progress:nil
                                                                      destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            
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

- (IBAction)facebookBtn:(id)sender {
	NSURL *url = [NSURL URLWithString:FACEBOOK_URL_LINK];
	if ([[UIApplication sharedApplication] canOpenURL:url]){
		[[UIApplication sharedApplication] openURL:url];
	}
	else {
	
		NSString *facebookUrlString = FACEBOOK_URL_LINK;

		if ([[facebookUrlString pathComponents] count] > 0) {
    		if ([[facebookUrlString pathComponents][1] isEqualToString:@"www.facebook.com"]) {
				  NSMutableArray *pathComponents = [[facebookUrlString pathComponents] mutableCopy];
				  [pathComponents replaceObjectAtIndex:1 withObject:@"facebook.com"];
				  facebookUrlString = [NSString pathWithComponents:pathComponents];
    		}
		}
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:facebookUrlString]];
	
	}
}

- (IBAction)instagramBtn:(id)sender {
	NSURL *instagramURL = [NSURL URLWithString:INSTAGRAM_URL_LINK];
	if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
		 [[UIApplication sharedApplication] openURL:instagramURL];
}

}

- (IBAction)phonrBtn:(id)sender {
    NSString *phoneCallNum = [NSString stringWithFormat:@"tel://%@",PHONE_NUMBER ];

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneCallNum]];

        NSLog(@"phone btn touch %@", phoneCallNum);
}

- (IBAction)emailBtn:(id)sender {
	[self sendEmail];
}

//- (IBAction)webBtn:(id)sender {
//    [[UIApplication sharedApplication]
//        openURL:[NSURL URLWithString: @"http://www.xxx.com.br"]];
//}



- (void)sendEmail {
    // Email Subject
    NSString *emailTitle = @"Contato pelo aplicativo iOS ";
    // Email Content
    NSString *messageBody = @"Olá Paulo Meyra,";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:BIO_EMAIL_RECIPIENT];

    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];

    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];

}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }

    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end

////////////////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
