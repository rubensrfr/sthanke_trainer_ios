    //
//  ExerciciosDetalhesViewController.m
//  mobitrainer
//
//  Created by Reginaldo Lopes on 11/08/15.
//  Copyright (c) 2015 4mobi. All rights reserved.
//

#import "ExerciciosDetalhesVC.h"

@interface ExerciciosDetalhesVC()

@end

@implementation ExerciciosDetalhesVC

@synthesize lblTituloExercicio;
@synthesize lblGrupoMuscular;
@synthesize tvDescricao;
@synthesize lblExecucao;
@synthesize tvInstrucao;
@synthesize exercise;
@synthesize background;
@synthesize dimmer;
@synthesize isDone;
@synthesize delegate;
@synthesize viewInstrucao;
@synthesize viewDescricao;
@synthesize imgVideoThumb;
@synthesize img1Exercise;
@synthesize img2Exercise;
@synthesize viewTituloImagens;
@synthesize imgTituloImagens;
@synthesize viewTituloExecucao;
@synthesize lblTituloExecucao;
@synthesize imgTituloExecucao;
@synthesize viewTituloCargaDescanso;
@synthesize lblTituloCarga;
@synthesize lblTituloDescanso;
@synthesize imgTituloCarga;
@synthesize imgTituloDescanso;
@synthesize viewTituloDescricao;
@synthesize lblTituloDescricao;
@synthesize imgTituloDescricao;
@synthesize viewTituloInstrucao;
@synthesize lblTituloInstrucao;
@synthesize imgTituloInstrucao;
@synthesize aiImage1;
@synthesize aiImage2;
@synthesize lblTituloImagens;
@synthesize lblTituloRepeticao;
@synthesize lblTituloSerie;
@synthesize imgTituloSerie;
@synthesize imgTituloRepeticao;
@synthesize viewTituloSerie;
@synthesize lblSerie;
@synthesize lblRepeticao;
@synthesize lblCarga;
@synthesize lblDescanso;
@synthesize viewTituloNota;
@synthesize lblTituloNota;
@synthesize imgTituloNota;
@synthesize textFieldNota;
@synthesize btnEditarNota;
@synthesize trainingID;


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - VIEW LIFECYCLE

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];

    self.tableView.delegate = self;
    self.playerView.delegate = self;
    
    aiImage1.hidden = YES;
    aiImage2.hidden = YES;

    utils = [[UtilityClass alloc] init];

    if(IS_IPHONE5)
    {
        backgroundWidth = 304.0f;
        backgroundHeight = 488.0f;
    }
    else
    {
        backgroundWidth = 304.0f;
        backgroundHeight = 398.0f;
    }

    coreDataService = [[CoreDataService alloc] init];
    [coreDataService initialize];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"DETALHES"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:nil
                                                                  action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    // Configura o background da tableview.
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                                      self.view.frame.size.width,
                                                                      self.view.frame.size.height)];
    [backgroundView setBackgroundColor:UIColorFromRGB(0xDFDFDF)];
    [self.tableView setBackgroundView:backgroundView];
    
    self.tableView.delegate = self;
    
    // Tweak para linhas extra na tabela.
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
   [self loadVideo];
    
    //lblTituloExercicio.textColor = UIColorFromRGB(kPRIMARY_COLOR);
    /* RFR
    viewTituloImagens.backgroundColor = UIColorFromRGB(kPRIMARY_COLOR);
    imgTituloImagens.tintColor = UIColorFromRGB([utils StringtoHex:appDesign.navTint]);
    lblTituloImagens.textColor = UIColorFromRGB([utils StringtoHex:appDesign.navTint]);
    
    viewTituloExecucao.backgroundColor = UIColorFromRGB(kPRIMARY_COLOR);
    imgTituloExecucao.tintColor = UIColorFromRGB([utils StringtoHex:appDesign.navTint]);
    lblTituloExecucao.textColor = UIColorFromRGB([utils StringtoHex:appDesign.navTint]);
    
    viewTituloCargaDescanso.backgroundColor = UIColorFromRGB(kPRIMARY_COLOR);
    imgTituloDescanso.tintColor = UIColorFromRGB([utils StringtoHex:appDesign.navTint]);
    lblTituloDescanso.textColor = UIColorFromRGB([utils StringtoHex:appDesign.navTint]);
   
    imgTituloCarga.tintColor = UIColorFromRGB([utils StringtoHex:appDesign.navTint]);
    lblTituloCarga.textColor = UIColorFromRGB([utils StringtoHex:appDesign.navTint]);
    
    viewTituloDescricao.backgroundColor = UIColorFromRGB(kPRIMARY_COLOR);
    imgTituloDescricao.tintColor = UIColorFromRGB([utils StringtoHex:appDesign.navTint]);
    lblTituloDescricao.textColor = UIColorFromRGB([utils StringtoHex:appDesign.navTint]);
    
    viewTituloInstrucao.backgroundColor = UIColorFromRGB(kPRIMARY_COLOR);
    imgTituloInstrucao.tintColor = UIColorFromRGB([utils StringtoHex:appDesign.navTint]);
    lblTituloInstrucao.textColor = UIColorFromRGB([utils StringtoHex:appDesign.navTint]);
    
    viewTituloSerie.backgroundColor = UIColorFromRGB(kPRIMARY_COLOR);
    imgTituloSerie.tintColor = UIColorFromRGB([utils StringtoHex:appDesign.navTint]);
    lblTituloSerie.textColor = UIColorFromRGB([utils StringtoHex:appDesign.navTint]);
    imgTituloRepeticao.tintColor = UIColorFromRGB([utils StringtoHex:appDesign.navTint]);
    lblTituloRepeticao.textColor = UIColorFromRGB([utils StringtoHex:appDesign.navTint]);
    
    viewTituloNota.backgroundColor = UIColorFromRGB(kPRIMARY_COLOR);
    imgTituloNota.tintColor = UIColorFromRGB([utils StringtoHex:appDesign.navTint]);
    lblTituloNota.textColor = UIColorFromRGB([utils StringtoHex:appDesign.navTint]);
*/
    lblTituloExercicio.text = exercise.name;
    lblGrupoMuscular.text = exercise.muscle;
    tvDescricao.text = exercise.fullDescription;
    lblExecucao.text = exercise.instruction;
    tvInstrucao.text = [exercise.fullExecution stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    
    lblSerie.text = exercise.serie;
    lblRepeticao.text = exercise.repeat;
    lblDescanso.text = exercise.rest;
    lblCarga.text = exercise.load;
    
    // PEGA OS DADOS DO USUARIO
    User *userData = (User *) [coreDataService getDataFromUserTable];
    
    Notes *note = (Notes *) [coreDataService getDataFromNotesTableByUserID:userData.userID
                                                                TrainingID:trainingID
                                                                ExerciseID:exercise.exerciseID];
    
    if (note != nil)
    {
        textFieldNota.text = note.textNote;
    }
    
    if (isDone || [userData.level integerValue] == USER_LEVEL_TRAINER || [userData.level integerValue] == USER_LEVEL_MASTERTRAINER || [userData.level integerValue] == USER_LEVEL_ADMINISTRATOR)
    {
        self.navigationItem.rightBarButtonItem.enabled = NO;
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor clearColor];
    }
    
    [self downloadImages];
    
    NSURL *youtubeURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://img.youtube.com/vi/%@/0.jpg",exercise.video]];
    [imgVideoThumb setImageWithURL:youtubeURL placeholderImage:nil];
    
    btnEditarNota.enabled = YES;
    textFieldNota.userInteractionEnabled = NO;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillAppear:(BOOL)animated
{
	
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    [self removeDimerView];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)downloadImages
{
    ////////////////////////////////////////////
    // CHECA SE A IMAGE1 EXISTE ////////////////
    ////////////////////////////////////////////
    
    NSMutableString *filenameImage1 = [[NSMutableString alloc] init];
    [filenameImage1 appendString:@"/Caches/ExercisesImages/"];
    
    [filenameImage1 appendString:[NSString stringWithFormat:@"%@",[utils md5HexDigest:exercise.image1]]];
    [filenameImage1 appendString:@".png"];
    
    NSString* pathImage1 = [[utils returnDocumentsPath] stringByAppendingPathComponent:filenameImage1];
    BOOL image1Exists = [[NSFileManager defaultManager] fileExistsAtPath:pathImage1];
    
    ////////////////////////////////////////////
    // CHECA SE A IMAGE2 EXISTE ////////////////
    ////////////////////////////////////////////
    
    NSMutableString *filenameImage2 = [[NSMutableString alloc] init];
    [filenameImage2 appendString:@"/Caches/ExercisesImages/"];
    [filenameImage2 appendString:[NSString stringWithFormat:@"%@",[utils md5HexDigest:exercise.image2]]];
    [filenameImage2 appendString:@".png"];
    
    NSString* pathImage2 = [[utils returnDocumentsPath] stringByAppendingPathComponent:filenameImage2];
    BOOL image2Exists = [[NSFileManager defaultManager] fileExistsAtPath:pathImage2];
    
    group = dispatch_group_create();
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    if (!image1Exists)
    {
        aiImage1.hidden = NO;
        [aiImage1 startAnimating];
        dispatch_group_enter(group);
        dispatch_async(queue, ^{
            
            NSLog(@"IMAGE 1 TASK");
            // Faz o download
            [self getExercisesImagesWithURL:exercise.image1];
            
        });
    }
    
    if (!image2Exists)
    {
        aiImage2.hidden = NO;
        [aiImage2 startAnimating];
        dispatch_group_enter(group);
        dispatch_async(queue, ^{
            
            NSLog(@"IMAGE 2 TASK");
            // Faz o download
            [self getExercisesImagesWithURL:exercise.image2];
        });
    }
    
    dispatch_group_notify(group, queue, ^{
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            NSLog(@"NOTIFY END");
            [spinner stopAnimating];
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.2];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            
            imgStatus.alpha = 0;
  
            [UIView commitAnimations];

            NSMutableString *filenameImage1 = [[NSMutableString alloc] init];
            [filenameImage1 appendString:@"/Caches/ExercisesImages/"];
            [filenameImage1 appendString:[NSString stringWithFormat:@"%@",[utils md5HexDigest:exercise.image1]]];
            [filenameImage1 appendString:@".png"];
            
            NSString* pathImage1 = [[utils returnDocumentsPath] stringByAppendingPathComponent:filenameImage1];
            BOOL image1Exists = [[NSFileManager defaultManager] fileExistsAtPath:pathImage1];
            
            ////////////////////////////////////////////
            // CHECA SE A IMAGE2 EXISTE ////////////////
            ////////////////////////////////////////////
            
            NSMutableString *filenameImage2 = [[NSMutableString alloc] init];
            [filenameImage2 appendString:@"/Caches/ExercisesImages/"];
            [filenameImage2 appendString:[NSString stringWithFormat:@"%@",[utils md5HexDigest:exercise.image2]]];
            [filenameImage2 appendString:@".png"];
            
            NSString* pathImage2 = [[utils returnDocumentsPath] stringByAppendingPathComponent:filenameImage2];
            BOOL image2Exists = [[NSFileManager defaultManager] fileExistsAtPath:pathImage2];
            
            if(image1Exists && image2Exists)
            {
                aiImage1.hidden = YES;
                [aiImage1 stopAnimating];
                
                aiImage2.hidden = YES;
                [aiImage2 stopAnimating];
                
                NSMutableString *filenameImage1 = [[NSMutableString alloc] init];
                [filenameImage1 appendString:@"/Caches/ExercisesImages/"];
                [filenameImage1 appendString:[utils md5HexDigest:exercise.image1]];
                [filenameImage1 appendString:@".png"];
                
                NSString *image1Path = [[utils returnDocumentsPath] stringByAppendingPathComponent:filenameImage1];
                UIImage *image1 = [UIImage imageWithContentsOfFile:image1Path];
                
                NSMutableString *filenameImage2 = [[NSMutableString alloc] init];
                [filenameImage2 appendString:@"/Caches/ExercisesImages/"];
                [filenameImage2 appendString:[utils md5HexDigest:exercise.image2]];
                [filenameImage2 appendString:@".png"];
                
                NSString *image2Path = [[utils returnDocumentsPath] stringByAppendingPathComponent:filenameImage2];
                UIImage *image2 = [UIImage imageWithContentsOfFile:image2Path];

                img1Exercise.image = image1;
                img2Exercise.image = image2;
            }
            
            else if (image1Exists && !image2Exists)
            {
                aiImage1.hidden = YES;
                [aiImage1 stopAnimating];
                
                aiImage2.hidden = YES;
                [aiImage2 stopAnimating];
                
                NSMutableString *filenameImage = [[NSMutableString alloc] init];
                [filenameImage appendString:@"/Caches/ExercisesImages/"];
                [filenameImage appendString:[utils md5HexDigest:exercise.image1]];
                [filenameImage appendString:@".png"];
                
                NSString *imagePath = [[utils returnDocumentsPath] stringByAppendingPathComponent:filenameImage];
                UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
                
                img1Exercise.image = image;
                img2Exercise.image = [UIImage imageNamed:@"Placeholder_Exercises"];
            }
            
            else if (!image1Exists && image2Exists)
            {
                aiImage1.hidden = YES;
                [aiImage1 stopAnimating];
                
                aiImage2.hidden = YES;
                [aiImage2 stopAnimating];
                
                NSMutableString *filenameImage = [[NSMutableString alloc] init];
                [filenameImage appendString:@"/Caches/ExercisesImages/"];
                [filenameImage appendString:[utils md5HexDigest:exercise.image2]];
                [filenameImage appendString:@".png"];
                
                NSString *imagePath = [[utils returnDocumentsPath] stringByAppendingPathComponent:filenameImage];
                UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
                
                img1Exercise.image = [UIImage imageNamed:@"Placeholder_Exercises"];
                img2Exercise.image = image;
            }
        });
    });
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - ACTIONS

//- (IBAction)btnVideoClicado:(id)sender
//{
//    if (exercise.video.length > 0)
//    {
//    //    XCDYouTubeVideoPlayerViewController *videoPlayerVC = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:exercise.video];
//     //   [self presentMoviePlayerViewControllerAnimated:videoPlayerVC];
//
//
//		 // Instancia o AVPlayerController.
//    AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc] init];
//    [self presentViewController:playerViewController animated:YES completion:nil];
//
//    // Extrai a URL do video e passa para o player iniciar a repordução.
//    [[XCDYouTubeClient defaultClient]getVideoWithIdentifier:exercise.video completionHandler:^(XCDYouTubeVideo * _Nullable video, NSError * _Nullable error) {
//
//        NSDictionary *dict = video.streamURLs;
//        NSURL *url = dict[@(XCDYouTubeVideoQualityHD720)] ?: dict[@(XCDYouTubeVideoQualityMedium360)] ?: dict[@(XCDYouTubeVideoQualitySmall240)];
//
//        playerViewController.player = [[AVPlayer alloc]initWithURL:url];
//        [playerViewController.player play];
//
//
////        NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"Movie" ofType:@"m4v"];
////		  MPMoviePlayerViewController *playerController = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:moviePath]];
////			[self presentMoviePlayerViewControllerAnimated:playerController];
////			[playerController.moviePlayer play];
//    }];
//
//
//
//    }
//    else
//    {
//        [SVProgressHUD showImage:[UIImage imageNamed:@"Video_Alert"]
//                          status:@"Vídeo Indisponível!"
//                        maskType:SVProgressHUDMaskTypeGradient];
//    }
//}

//- (IBAction)btnVideoClicado:(id)sender
- (void)loadVideo
{


    if (exercise.video.length > 0)
    {
   //  [self.playerView loadWithVideoId:exercise.video];
		 
		NSDictionary *playerVars = @{
		@"showinfo": @0,
		@"playsinline" : @0,
		@"rel": @0,
		@"ecver:": @2,
		@"modestbranding": @1
		};


		[self.playerView loadWithVideoId:exercise.video playerVars:playerVars];
		 
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

- (IBAction)editLoadValue:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:kTEXT_ALERT_TITLE
                                                                             message:@"Editar a carga:"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
#ifdef NEW_STYLE
    alertController.view.tintColor=[UIColor colorNamed:@"myCellTextColor"];
#endif
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = @"Ex. 45Kg ou 10min.";
         [textField setKeyboardType:UIKeyboardTypeDefault];
         textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
         textField.clearButtonMode = UITextFieldViewModeWhileEditing;
         
         if (lblCarga.text.length > 0)
         {
             textField.text = lblCarga.text;
         }
     }];
    
    UIAlertAction *actionYES = [UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action){
                                                          
                                                          UITextField *textField = alertController.textFields.firstObject;
                                                          
                                                          lblCarga.text = textField.text;
                                                          exercise.load = textField.text;
                                                          
                                                          [coreDataService saveData];
                                                          
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

//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////

- (IBAction)editNote:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:kTEXT_ALERT_TITLE
                                                                             message:@"Anotações do aluno."
                                                                      preferredStyle:UIAlertControllerStyleAlert];
#ifdef NEW_STYLE
    alertController.view.tintColor=[UIColor colorNamed:@"myCellTextColor"];
#endif
    
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
                                                          textFieldNota.text = textField.text;
                                                          
                                                          [coreDataService setNoteWithUserID:userData.userID
                                                                                  TrainingID:trainingID
                                                                                  ExerciseID:exercise.exerciseID
                                                                                        Note:textField.text];
                                                          
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

- (IBAction)btnClose:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
	
}

//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - UITEXTFIELD DELEGATE

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    return newLength <= 35;
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - TABLEVIEW DELEGATE

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:  // TITULO
        {
            return 126;
            break;
        }

        case 1: // VIDEO
        {
            if(exercise.video.length == 0)
            {
                return 0;
            }
            else
            {
                return 190;
            }
            
            break;
        }
            
        case 2: // IMAGENS
        {
            if (exercise.image1.length == 0 && exercise.image2.length == 0)
            {
                return 0;
            }
            else
            {
                return 183;
            }
            
            break;
        }
            
        case 3: // DESCRICAO
        {
            if (exercise.fullDescription.length == 0)
            {
                return 0;
            }
            else
            {
//                CGSize size = [utils frameForText:exercise.fullDescription
//                                     sizeWithFont:tvDescricao.font
//                                constrainedToSize:CGSizeMake(290.f, CGFLOAT_MAX)];
//
//                tvDescricao.frame = CGRectMake(8.0f, 34.0f, size.width, size.height + 60.0f);
//                viewDescricao.frame = (CGRectMake(6.0f, 7.0f, 308.0f, size.height + 64.0f));
					
                return 149; //size.height + 72.0f;
            }
            
            break;
        }
			 
            
        case 4: // INSTRUÇÃO
        {
            if (exercise.fullExecution.length == 0)
            {
                return 0;
            }
            else
            {
//                NSString *text = [exercise.fullExecution stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
//
//                CGSize size = [utils frameForText:text
//                                     sizeWithFont:tvInstrucao.font
//                                constrainedToSize:CGSizeMake(290.f, CGFLOAT_MAX)];
//
//                tvInstrucao.frame = CGRectMake(8.0f, 34.0f, size.width, size.height + 82.0f);
//                viewInstrucao.frame = CGRectMake(6.0f, 7.0f, 308.0f, size.height + 85.0f);
					
                return 164; //size.height + 98.0f;
            }
            
            break;
        }
 
        default:
        {
            return 0;
            break;
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 1: // VIDEO
        {
            if(exercise.video.length == 0)
            {
                cell.hidden = YES;
            }
            else
            {
                cell.hidden = NO;
            }
            
            break;
        }
            
        case 2: // IMAGENS
        {
            if (exercise.image1.length == 0 && exercise.image2.length == 0)
            {
                cell.hidden = YES;
            }
            else
            {
                cell.hidden = NO;
            }
            
            break;
        }
            
        case 3: // DESCRICAO
        {
            if (exercise.fullDescription.length == 0)
            {
                cell.hidden = YES;
            }
            else
            {
                cell.hidden = NO;
            }
            
            break;
        }
            
			 
            
        case 4: // INSTRUÇÃO
        {
            if (exercise.fullExecution.length == 0)
            {
                cell.hidden = YES;
            }
            else
            {
                cell.hidden = NO;
            }
            
            break;
        }
            
        default:
        {
            cell.hidden = NO;
            break;
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - CUSTOM METHODS

- (void)removeDimerView
{
    dimmer.alpha = 1;
    background.transform = CGAffineTransformIdentity;
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        background.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
        dimmer.alpha = 0;
        
    } completion:^(BOOL finished){
        
        // if you want to do something once the animation finishes, put it here
        [dimmer removeFromSuperview];
        self.tableView.scrollEnabled = YES;
        
    }];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

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
            
            NSString *imagesCachePath = [[utils returnDocumentsPath] stringByAppendingPathComponent:@"/Caches/ExercisesImages/"];
            NSURL *path = [NSURL fileURLWithPath:imagesCachePath];
            
            NSMutableString *filename = [[NSMutableString alloc] init];
            [filename appendString:[utils md5HexDigest:url]];
            [filename appendString:@".png"];
            
            return [path URLByAppendingPathComponent:filename];
            
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            
            NSLog(@"DOWNLOAD END");
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
