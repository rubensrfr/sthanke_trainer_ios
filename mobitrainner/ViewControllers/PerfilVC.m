//
//  PerfilViewController.m
//  mobitrainner
//
//  Created by Reginaldo Lopes on 03/12/14.
//  Copyright (c) 2014 4mobi. All rights reserved.
//

#import "PerfilVC.h"

@interface PerfilVC()

@end

@implementation PerfilVC

@synthesize imageUser;
@synthesize textFieldFistName;
@synthesize textFieldLastName;
@synthesize textFieldEmail;
@synthesize textFieldBirthDate;
@synthesize textFieldHeight;
@synthesize textFieldWeight;
@synthesize buttonSave;
@synthesize buttonChangePicture;
@synthesize datePicker;
@synthesize datePickerIsShowing;
@synthesize dateBirth;

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - VIEW LIFECYCLE

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    utils = [[UtilityClass alloc] init];
    
    // Flag que controla a  necessidade de upload da imagem do usuário.
    flagNeedsUploadPicture = FALSE;
    
    if (IS_IPHONE5)
    {
        self.tableView.scrollEnabled = NO;
    }
    else
    {
        self.tableView.scrollEnabled = YES;
    }
    
    
//    // Configura o background da tableview.
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [backgroundView setBackgroundColor:UIColorFromRGB(0xFFFFFF)];
    [self.tableView setBackgroundView:backgroundView];
    
    // add Padding no textfield Email.
    UIView *tfFirtNamelPad = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    textFieldFistName.leftView = tfFirtNamelPad;
    textFieldFistName.leftViewMode = UITextFieldViewModeAlways;
    textFieldFistName.delegate = self;
    
    // add Padding no textfield Email.
    UIView *tfLastNamePad = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    textFieldLastName.leftView = tfLastNamePad;
    textFieldLastName.leftViewMode = UITextFieldViewModeAlways;
    textFieldLastName.delegate = self;
    
    // add Padding no textfield Email.
    UIView *tfEmailPad = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    textFieldEmail.leftView = tfEmailPad;
    textFieldEmail.leftViewMode = UITextFieldViewModeAlways;
    textFieldEmail.delegate = self;
    
    // add Padding no textfield Email.
    UIView *tfBirthDatePad = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    textFieldBirthDate.leftView = tfBirthDatePad;
    textFieldBirthDate.leftViewMode = UITextFieldViewModeAlways;
    textFieldBirthDate.delegate = self;
    
    // add Padding no textfield Email.
    UIView *tfHeightPad = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    textFieldHeight.leftView = tfHeightPad;
    textFieldHeight.leftViewMode = UITextFieldViewModeAlways;
    textFieldHeight.delegate = self;
    
    // add Padding no textfield Email.
    UIView *tfWeightPad = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    textFieldWeight.leftView = tfWeightPad;
    textFieldWeight.leftViewMode = UITextFieldViewModeAlways;
    textFieldWeight.delegate = self;
    
    /////////////////////////////////////////////////////////////////////
    /// CONFIGURA TOOLBAR NUMPAD NEXT ///////////////////////////////////
    /////////////////////////////////////////////////////////////////////
    
    UIToolbar *keyboardToolbarNext = [[UIToolbar alloc] init];
    [keyboardToolbarNext sizeToFit];
    
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:nil
                                                                                  action:nil];
    
    UIBarButtonItem *nextBarButton = [[UIBarButtonItem alloc]initWithTitle:@"Seguinte"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(btnNextClicado:)];
    
    keyboardToolbarNext.items = @[flexBarButton, nextBarButton];
    
    self.textFieldHeight.inputAccessoryView = keyboardToolbarNext;
    
    /////////////////////////////////////////////////////////////////////
    /// CONFIGURA TOOLBAR NUMPAD DONE ///////////////////////////////////
    /////////////////////////////////////////////////////////////////////
    
    UIToolbar *keyboardToolbarDone = [[UIToolbar alloc] init];
    [keyboardToolbarDone sizeToFit];
    
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Concluído"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(btnDoneClicado:)];
    
    keyboardToolbarDone.items = @[flexBarButton, doneBarButton];
    
    self.textFieldWeight.inputAccessoryView = keyboardToolbarDone;
    
    utils = [[UtilityClass alloc] init];
    
    // Configura um gesture recognizer para esconder o teclado quando clicar na tableView.
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:gestureRecognizer];
    
    // Inicializa o helper do Banco de dados.
    coreDataService = [[CoreDataService alloc] init];
    [coreDataService initialize];
    
    User *userData = [coreDataService getDataFromUserTable];
    
    // RECUPERA AS CONFIGURACÃO DO APP DESGIN DO BANCOD E DADOS.
    Design *appDesign = (Design *) [coreDataService getDataFromDesignTable];
    
    buttonSave.backgroundColor = UIColorFromRGB(kPRIMARY_COLOR);
    
    NSString *strDescription = buttonSave.titleLabel.text;
    
    NSMutableAttributedString *btSave = [[NSMutableAttributedString alloc] initWithString:strDescription];
    [btSave addAttribute:NSForegroundColorAttributeName
                   value:UIColorFromRGB([utils StringtoHex:appDesign.navTint])
                   range:NSMakeRange(0, [strDescription length])];
    [buttonSave setAttributedTitle:btSave forState:UIControlStateNormal];
    
    
    NSString *strDescription2 = buttonChangePicture.titleLabel.text;
    
    NSMutableAttributedString *btChange = [[NSMutableAttributedString alloc] initWithString:strDescription2];
    [btChange addAttribute:NSForegroundColorAttributeName
                     value:UIColorFromRGB(kPRIMARY_COLOR)
                     range:NSMakeRange(0, [strDescription2 length])];
    [buttonChangePicture setAttributedTitle:btChange forState:UIControlStateNormal];

    textFieldFistName.text = userData.firstName;
    textFieldLastName.text = userData.lastName;

    textFieldEmail.text = userData.email;
    textFieldEmail.userInteractionEnabled = NO;
    
    // Formata a data para ser apresentada.
    NSDateFormatter *df1 = [[NSDateFormatter alloc] init];
    [df1 setDateFormat: @"yyyy-MM-dd"];
    NSDate *date = [df1 dateFromString:userData.birthday];
    
    NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
    [df2 setDateFormat: @"dd/MM/yyyy"];
    NSString *stringDate = [df2 stringFromDate:date];
    
    textFieldBirthDate.text = stringDate;
    textFieldHeight.text = [[NSString stringWithFormat:@"%.02f",[userData.height floatValue]]stringByReplacingOccurrencesOfString:@"." withString:@","];
    textFieldWeight.text = [[NSString stringWithFormat:@"%.01f",[userData.weight floatValue]]stringByReplacingOccurrencesOfString:@"." withString:@","];
    
    imageUser.layer.cornerRadius = imageUser.frame.size.width / 2;
    imageUser.clipsToBounds = YES;
    imageUser.layer.borderColor = UIColorFromRGB(kPRIMARY_COLOR).CGColor;
    imageUser.layer.borderWidth = 3.0f;
    
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

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - TABLEVIEW DELEGATE & Data Source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = self.tableView.rowHeight;
	
	
    if (indexPath.row == kDatePickerIndex)
    {
        height = self.datePickerIsShowing ? kDatePickerCellHeight : 0.0f;
    }
	
    if (indexPath.row == 0)
    {
        height = 140.0f;
    }
	
    if (indexPath.row == 8)
    {
        height = 90.0f;
    }
    
    return height;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - TEXTFIELD DELEGATE

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.datePickerIsShowing)
    {
        [textFieldBirthDate resignFirstResponder];
        [self hideDatePickerCell];
    }
    
    if (textFieldBirthDate.editing)
    {
        if (textFieldBirthDate.text.length > 0)
        {
            // Formata a data para ser apresentada.
            NSDateFormatter *df1 = [[NSDateFormatter alloc] init];
            [df1 setDateFormat: @"dd/MM/yyyy"];
            NSDate *date = [df1 dateFromString:textFieldBirthDate.text];
            
            datePicker.date = date;
        }
        
        if (self.datePickerIsShowing)
        {
            [self hideDatePickerCell];
        }
        else
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [textFieldFistName resignFirstResponder];
                    [textFieldLastName resignFirstResponder];
                    [textFieldBirthDate resignFirstResponder];
                    [textFieldEmail resignFirstResponder];
                    [textFieldHeight resignFirstResponder];
                    [textFieldWeight resignFirstResponder];
                    
                    [self showDatePickerCell];
                    
                });
            });
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    if (textField == textFieldFistName)
    {
        [textFieldLastName becomeFirstResponder];
    }
    
    if (textField == textFieldLastName)
    {
        [textFieldBirthDate becomeFirstResponder];
    }
    
    if (textField == textFieldBirthDate)
    {
        [textFieldHeight becomeFirstResponder];
    }
    
    if (textField == textFieldHeight)
    {
        [textFieldWeight becomeFirstResponder];
    }
    
    return YES;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)textField:(UITextField *)textField_ shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textFieldFistName.editing)
    {
        return YES;
    }
    
    if (textFieldLastName.editing)
    {
        return YES;
    }
    
    if (textFieldEmail.editing)
    {
        return YES;
    }
    
    if (textFieldBirthDate.editing)
    {
        return YES;
    }
    
    if (textFieldHeight.editing)
    {
        if ([string isEqualToString:@""])
        {
            //backspace button pressed
            return YES;
        }
        
        if (textFieldHeight.text.length < 4)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    if (textFieldWeight.editing)
    {
        if ([string isEqualToString:@""])
        {
            //backspace button pressed
            return YES;
        }
        
        if (textFieldWeight.text.length < 5)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    return NO;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (IBAction)pickerDateChanged:(UIDatePicker *)sender
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat: @"dd/MM/yyyy"];
    self.textFieldBirthDate.text = [df stringFromDate:sender.date];
    self.dateBirth = sender.date;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - IMAGE PICKER DELEGATE

- (void) imagePickerController:(UIImagePickerController *)thePicker didFinishPickingMediaWithInfo:(NSDictionary *)imageInfo
{
    // Pega os dados do usuário.
    User *userData = [coreDataService getDataFromUserTable];
    
    // remove a tela de seleção da imagem.
    [thePicker dismissViewControllerAnimated:YES completion:nil];
    
    // Recupera a iamgem escolhida ou tirada pelo usuario.
    UIImage *image = [imageInfo objectForKey:@"UIImagePickerControllerEditedImage"];
    
    // Transforma em NSDATA sem compressão.
    NSData *pngData = UIImagePNGRepresentation(image);
    
    // Cria o nome que a imagem será salva, fazendo hash.
    NSMutableString *imageName = [[NSMutableString alloc] init];
    [imageName appendString:[utils md5HexDigest:userData.image]];//RFR
    [imageName appendString:@".png"];
    
    // Salva a imagem na pasta correspondente.
    NSMutableString *pathImage = [[NSMutableString alloc] init];
    [pathImage appendString:[utils returnDocumentsPath]];
    [pathImage appendString:@"/Caches/ProfileImages/"];
    [pathImage appendString:imageName];
    [pngData writeToFile:pathImage atomically:YES]; //Write the file
    
    // Coloca a imagem no imageView para mostrar na tela do usuario.
    self.imageUser.image = image;
    
    // Libera o upload.
    flagNeedsUploadPicture = YES;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - ACTIONS

- (IBAction)buttonSaveClicked:(id)sender
{
    // VERIFICA SE TEM CONEXÃO COM A INTERNET.
    BOOL flagInternetStatus = [IMManager sharedManager].hasConnection;
    
    // SE TEM CONEXÃO
    if (flagInternetStatus) {
        
        [self SaveProfileChanges];
    }
    else {
        
        [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                          AndText:kTEXT_INTERNET_ERROR_DEFAULT
                      AndTargetVC:self];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (IBAction)buttonChangePictureClicked:(id)sender
{
    UIAlertController *view = [UIAlertController alertControllerWithTitle:@""
                                                                  message:@"Escolha uma opção:"
                                                           preferredStyle:UIAlertControllerStyleActionSheet];
#ifdef NEW_STYLE
    view.view.tintColor=UIColorFromRGB(STYLE_MAIN_COLOR);
#endif
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"Câmera"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action) {
                                                       
                                                       [self getImageFromCamera];
                                                       [view dismissViewControllerAnimated:YES completion:nil];
                                                       
                                                   }];
                                                   
   UIAlertAction *cameraRoll = [UIAlertAction actionWithTitle:@"Rolo de Câmera"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          
                                                          [self getImageFromCameraRoll];
                                                          [view dismissViewControllerAnimated:YES completion:nil];
                             
                                                      }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action) {
                                                       
                                                        [view dismissViewControllerAnimated:YES completion:nil];
                                 
                                                  }];
	 
    [view addAction:camera];
    [view addAction:cameraRoll];
    [view addAction:cancel];
	 view.popoverPresentationController.sourceView = self.view;
	 view.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width, self.view.bounds.size.height, 1.0, 1.0);

	// self.presentViewController(view, animated: true, completion: nil)
   // [view setModalPresentationStyle:UIModalPresentationPopover];
    [self presentViewController:view animated:YES completion:nil];
}

- (IBAction)buttonCloseClicked:(id)sender {

   [self dismissViewControllerAnimated:YES completion:nil];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - CUSTOM METHODS

- (void)hideKeyboard
{
    [self hideDatePickerCell];
    [textFieldFistName resignFirstResponder];
    [textFieldLastName resignFirstResponder];
    [textFieldBirthDate resignFirstResponder];
    [textFieldEmail resignFirstResponder];
    [textFieldHeight resignFirstResponder];
    [textFieldWeight resignFirstResponder];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)showDatePickerCell
{
    self.datePickerIsShowing = YES;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    self.datePicker.hidden = NO;
    self.datePicker.alpha = 0.0f;
    
    [UIView animateWithDuration:0.3f animations:^{
        
        self.datePicker.alpha = 1.0f;
        
    }];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)hideDatePickerCell
{
    self.datePickerIsShowing = NO;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    [UIView animateWithDuration:0.3f animations:^{
        
        self.datePicker.alpha = 0.0f;
        
    }
    completion:^(BOOL finished) {
                         
        self.datePicker.hidden = YES;
                         
    }];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)SaveProfileChanges
{
    [SVProgressHUD showWithStatus:@"Atualizando Perfil..." maskType:SVProgressHUDMaskTypeGradient];
    
    // Cria um operation manager para realizar a solicitação via POST.
 //   AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  //  [manager.requestSerializer setTimeoutInterval:AFHHTTP_TIMEOUT];
    // Monta a string de acesso a validação do login.
    NSMutableString *urlString = [[NSMutableString alloc] init];
    [urlString appendString:kBASE_URL_MOBITRAINER];
    [urlString appendString:@"api/sync/profile"];
    
    NSString *stringDate;
    
    // Se a data existe...
    if(textFieldBirthDate.text.length > 0)
    {
        NSDateFormatter *df0 = [[NSDateFormatter alloc] init];
        [df0 setDateFormat: @"dd-MM-yyyy"];
        
        // Formata a data para enviar ao servidor.
        NSDate *date = [df0 dateFromString:textFieldBirthDate.text];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat: @"yyyy-MM-dd"];
        stringDate = [df stringFromDate:date];
    }
    else
    {
        stringDate = @"";
    }
    
    User *userData = [coreDataService getDataFromUserTable];
    
    float fHeight = [[textFieldHeight.text stringByReplacingOccurrencesOfString:@"," withString:@"."] floatValue];
    float fWeight = [[textFieldWeight.text stringByReplacingOccurrencesOfString:@"," withString:@"."] floatValue];
    
    NSString *strHeight;
    
    if(fHeight == 0)
    {
       strHeight = @"";
    }
    else
    {
       strHeight = [[NSString alloc] initWithFormat:@"%.02f", fHeight];
    }
    
    NSString *strWeight;
    
    if(fWeight == 0)
    {
        strWeight = @"";
    }
    else
    {
       strWeight = [[NSString alloc] initWithFormat:@"%.1f", fWeight];
    }

    // Parametros validados.
    NSDictionary *parameters = @{
                                    @"apikey":userData.apiKey,
                                    @"name":textFieldFistName.text,
                                    @"lastname":textFieldLastName.text,
                                    @"birthday":stringDate,
                                    @"height":strHeight,
                                    @"weight":strWeight
                                };
    
	
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
			[manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
			NSString *path=[[NSString alloc]initWithFormat:@"%@",urlString];
			[manager POST:[NSURL URLWithString:path].absoluteString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
	
    // Realiza o POST das informações e aguarda o retorno.
   // [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (![[responseObject objectForKey:@"response_error"] boolValue])
        {
            userData.firstName = textFieldFistName.text;
            userData.lastName = textFieldLastName.text;
            userData.birthday = stringDate;
            userData.height = [NSNumber numberWithFloat:fHeight];
            userData.weight = [NSNumber numberWithFloat:fWeight];
            
            [coreDataService saveData];
            
            if (flagNeedsUploadPicture)
            {
                NSMutableString *imageName = [[NSMutableString alloc] init];
                [imageName appendString:[utils md5HexDigest:userData.image]];
                [imageName appendString:@".png"];
                
                NSMutableString *pathImage = [[NSMutableString alloc] init];
                [pathImage appendString:[utils returnDocumentsPath]];
                [pathImage appendString:@"/Caches/ProfileImages/"];
                [pathImage appendString:imageName];
                
                UIImage *image = [UIImage imageWithContentsOfFile:pathImage];
                
                [self uploadImage:image];
            }
            else
            {
                [SVProgressHUD showSuccessWithStatus:@"Perfil atualizado com sucesso!" maskType:SVProgressHUDMaskTypeGradient];
            }
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error)
	{
		 NSLog(@"Error: %@", error);
        
        [SVProgressHUD dismiss];
        
        [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                          AndText:kTEXT_SERVER_ERROR_DEFAULT
                          AndTargetVC:self];

	}];
        
   
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)getImageFromCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        // Inicializa o objeto UIImagePicker.
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        // Configura o image picker.
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing = YES;
        
        // Apresenta o view controller do picker.
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else
    {
        [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                          AndText:@"Seu dispositivo não possui suporte a este recurso."
                          AndTargetVC:self];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)getImageFromCameraRoll
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        // Inicializa o objeto UIImagePicker.
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        // Configura o image picker.
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.allowsEditing = YES;
        
        // Apresenta o view controller do picker.
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else
    {
        [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                          AndText:@"Seu dispositivo não possui suporte a este recurso."
                          AndTargetVC:self];
    }
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (void)uploadImage:(UIImage *)image
{
    // Pega os dados do usuário...
    User *userData = (User *) [coreDataService getDataFromUserTable];

    // Monta a string de acesso a validação do login.
    NSMutableString *urlString = [[NSMutableString alloc] init];
    [urlString appendString:kBASE_URL_MOBITRAINER];
    [urlString appendString:@"api/sync/upload_image_profile"];

   
 NSDictionary *parameters = @{@"apikey": userData.apiKey};
 NSData *imageData = UIImageJPEGRepresentation(image, 0.9);
 NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFileData:imageData name:@"image" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
} error:nil];

AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

NSURLSessionUploadTask *uploadTask;
uploadTask = [manager
          uploadTaskWithStreamedRequest:request
          progress:^(NSProgress * _Nonnull uploadProgress) {
              // This is not called back on the main queue.
              // You are responsible for dispatching to the main queue for UI updates
              dispatch_async(dispatch_get_main_queue(), ^{
                  //Update the progress view
					 // [UIProgressView setProgress:uploadProgress.fractionCompleted];
              });
          }
          completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
              if (error) {
                  NSLog(@"Error: %@", error);
              } else {
                  NSLog(@"%@ %@", response, responseObject);
                  if (flagNeedsUploadPicture)
						{
							flagNeedsUploadPicture = FALSE;
							[SVProgressHUD showSuccessWithStatus:@"Perfil atualizado com sucesso!" maskType:SVProgressHUDMaskTypeGradient];
						}
              }
          }];

[uploadTask resume];














#if 0



    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    [manager.requestSerializer setTimeoutInterval:AFHHTTP_TIMEOUT];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.9);

    NSDictionary *parameters = @{@"apikey": userData.apiKey};

    AFHTTPRequestOperation *op = [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {

        [formData appendPartWithFileData:imageData name:@"image" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);

        if (![[responseObject objectForKey:@"response_error"] boolValue])
        {
            if (flagNeedsUploadPicture)
            {
                flagNeedsUploadPicture = FALSE;
                [SVProgressHUD showSuccessWithStatus:@"Perfil atualizado com sucesso!" maskType:SVProgressHUDMaskTypeGradient];
            }
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        [SVProgressHUD dismiss];
        NSLog(@"Error: %@ ***** %@", operation.responseString, error);

    }];

    // A cada progresso configura o HUD para mostrar o progresso.
    [op setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite){

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

            dispatch_async(dispatch_get_main_queue(), ^{

                // Converte para o formato 0.0 ~ 1.0.
                float progress = totalBytesWritten / (float)totalBytesExpectedToWrite;

                // Mostra o HUD.
                [SVProgressHUD showProgress:(CGFloat)progress status:@"Upload da imagem..."];

            });
        });
    }];

    [op start];
#endif
    
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - NUMPAD KYEBOARD ACTIONS

- (void)btnNextClicado:(id)sender
{
    if ([textFieldHeight isEditing])
    {
        [textFieldWeight becomeFirstResponder];
        return;
    }
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (void)btnDoneClicado:(id)sender
{
    [self.view endEditing:YES];
    
    [self.tableView scrollRectToVisible:CGRectMake(0, self.tableView.contentSize.height - self.tableView.bounds.size.height,
                                                   self.tableView.bounds.size.width, self.tableView.bounds.size.height) animated:NO];
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

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
