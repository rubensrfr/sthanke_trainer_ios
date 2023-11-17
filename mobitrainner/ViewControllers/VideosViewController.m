//
//  VideosViewController.m
//  Scheeeins
//
//  Created by Naldo Lopes flagVideoViewon 29/08/14.
//  Copyright (c) 2014 4Mobi. All rights reserved.
//

#import "VideosViewController.h"

@interface VideosViewController()

@end

@implementation VideosViewController

@synthesize ivTop;
@synthesize uiTableView;
//@synthesize extractor;
//@synthesize playerView;
@synthesize uiLabelMesage;
@synthesize uiImageViewBackground;

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - VIEW LIFECYCLE

- (void)viewDidLoad
{
	[super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.playerView.delegate = self;
    didLoadList = FALSE;
    
    totalResults = 0;
    
    // CONFIGURA O BACKGROUND DA TABLEVIEW.
//    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    [backgroundView setBackgroundColor:UIColorFromRGB(kDEFAULT_VIEW_BG_COLOR)];
//    [uiTableView setBackgroundView:backgroundView];
//	
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:kTEXT_BACK_BUTTON_DEFAULT
																   style:UIBarButtonItemStyleBordered
																  target:nil
																  action:nil];
    self.navigationItem.backBarButtonItem = backButton;
	
	self.uiTableView.delegate = self;
	
	utils = [[UtilityClass alloc] init];
	
	loadMoreData = YES;
    
    
	
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	// Carrega o logo na navigation bar.
//    UIImage *img = [UIImage imageNamed:@"logo_nav_img.png"];
//    ivTop = [[UIImageView alloc] initWithImage:img];
//	
//	// Calcula o posicionamento em relacao a navigation bar.
//    ivTop.frame = CGRectMake(((self.navigationController.navigationBar.frame.size.width / 2) - (kNAV_IMAGE_WIDTH / 2)),
//							  (self.navigationController.navigationBar.frame.size.height / 2) - (kNAV_IMAGE_HEIGHT / 2) - 2,
//							  kNAV_IMAGE_WIDTH,
//							  kNAV_IMAGE_HEIGHT);
//    
//    // Coloca a imagem na view da Navigation.
//    [self.navigationController.navigationBar addSubview:ivTop];
//    
    self.navigationController.navigationBar.translucent = NO;
//    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(becomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    flagVideoView=NO;
    // VERIFICA SE TEM CONEXÃO COM A INTERNET.
    BOOL flagInternetStatus = [IMManager sharedManager].hasConnection;
	
    if (flagInternetStatus)
    {
     //   [self hideOfflineMessage];
		 
        if (!didLoadList)
        {
            didLoadList = TRUE;
            [self getVideoList];
        }
    }
    else
    {
        if ([arrayData count] == 0)
        {
           // [self showOfflineMessage];
            [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                          AndText:kTEXT_INTERNET_ERROR_DEFAULT
                      AndTargetVC:self];
        }
		 
        didLoadList = FALSE;
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Remove o logo da navigation, para evitar problemas nos outros viewcontroller.
    [ivTop removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
    
    [SVProgressHUD dismiss];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - TABLEVIEW DELEGATE & DATA SOURCE

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [arrayData count];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 88;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Cell custom highlight color.
    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:UIColorFromRGB(kPRIMARY_COLOR)];
    [bgColorView setClipsToBounds:YES];
    [cell setSelectedBackgroundView:bgColorView];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    VideosTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil)
    {
        cell = [[VideosTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
	
	/*******************************************************************/
	/*** VIDEO COVER ***************************************************/
	/*******************************************************************/
	
	NSString *strImagemURL = [utils checkString:[[arrayData objectAtIndex:indexPath.row] objectForKey:@"url"]];
	
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: strImagemURL]];
	
	[cell.uiImageViewVideoCover setImageWithURLRequest:request
								      placeholderImage:[UIImage imageNamed:@"video_img.png"]
										       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
					
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.2];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
											   
                cell.uiImageViewVideoCover.alpha = 1;
											   
                [cell.uiImageViewVideoCover setImage:image];
											   
            [UIView commitAnimations];
											   
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
											   
            [cell.uiImageViewVideoCover setImage:[UIImage imageNamed:@"video_img.png"]];
    }];
	
	/*******************************************************************/
	/*** VIDEO TITULO **************************************************/
	/*******************************************************************/

	cell.uiLabelVideoTitulo.text = [utils checkString:[[arrayData objectAtIndex:indexPath.row]
                                                                   objectForKey:@"title"]];

	/*******************************************************************/
	/*** VIDEO DATA ****************************************************/
	/*******************************************************************/
	
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"pt"]];
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"];
    
    NSDate *dateFromString = [dateFormatter dateFromString:[utils checkString:[[arrayData objectAtIndex:indexPath.row]
                                                                                           objectForKey:@"publishedAt"]]];
	NSMutableString *videoData = [[NSMutableString alloc] init];
	
	[videoData appendString:@"• "];
	[videoData appendString:[utils dateToStringInterval:dateFromString]];

	cell.uiLabelVideoData.text = videoData;
	
	/*******************************************************************/
	/*** VIDEO OWNER ***************************************************/
	/*******************************************************************/
	
	NSMutableString *videoOwer = [[NSMutableString alloc] init];
	
	[videoOwer appendString:@"por "];
	[videoOwer appendString:[utils checkString:[[arrayData objectAtIndex:indexPath.row]
                                                            objectForKey:@"channelTitle"]]];

	cell.uiLabelVideoOwner.text = videoOwer;
	
	/*******************************************************************/
	/*** VIDEO VISUALIZAÇÕES *******************************************/
	/*******************************************************************/
	
	NSMutableString *stats = [[NSMutableString alloc] init];

	[stats appendString:[NSString stringWithFormat:@"%@",[utils checkString:[[arrayData objectAtIndex:indexPath.row]
                                                               objectForKey:@"viewCount"]]]];
	[stats appendString:@" visualizações"];
	
	cell.uiLabelVideoVisualizacoes.text = stats;
	
	/*******************************************************************/
	/*** VIDEO DURAÇÃO *************************************************/
	/*******************************************************************/
    
	NSString *duration = [utils checkString:[[arrayData objectAtIndex:indexPath.row] objectForKey:@"duration"]];
    
    int i = 0, days = 0, hours = 0, minutes = 0, seconds = 0;
    
    while(i < duration.length)
    {
        NSString *str = [duration substringWithRange:NSMakeRange(i, duration.length-i)];
        
        i++;
        
        if([str hasPrefix:@"P"] || [str hasPrefix:@"T"])
            continue;
        
        NSScanner *sc = [NSScanner scannerWithString:str];
        int value = 0;
        
        if ([sc scanInt:&value])
        {
            i += [sc scanLocation]-1;
            
            str = [duration substringWithRange:NSMakeRange(i, duration.length-i)];
            
            i++;
            
            if([str hasPrefix:@"D"])
                days = value;
            else if([str hasPrefix:@"H"])
                hours = value;
            else if([str hasPrefix:@"M"])
                minutes = value;
            else if([str hasPrefix:@"S"])
                seconds = value;
        }
    }

	NSString *time = [NSString stringWithFormat:@"%ld:%02ld", (long)minutes, (long)seconds];
	
	cell.uiLabelDuration.text = [utils checkString:time];
	
    return cell;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{


    // Recupera o ID do Video.
//	NSString *videoID = [utils checkString:[[arrayData objectAtIndex:indexPath.row]
//                                                        objectForKey:@"videoId"]];

//    // Instancia o AVPlayerController.
//    AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc] init];
//    [self presentViewController:playerViewController animated:YES completion:nil];
//
//    // Extrai a URL do video e passa para o player iniciar a repordução.
//    [[XCDYouTubeClient defaultClient]getVideoWithIdentifier:videoID completionHandler:^(XCDYouTubeVideo * _Nullable video, NSError * _Nullable error) {
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
		if(flagVideoView==YES)// Se o view do video está ativa
		{
			flagVideoView=NO;
		
			UIView *viewToRemove = [self.view viewWithTag:31];
			[viewToRemove removeFromSuperview];
		}
		else
		{
			flagVideoView=YES;
			NSString *videoID = [utils checkString:[[arrayData objectAtIndex:indexPath.row]
                                                        objectForKey:@"videoId"]];

			if (videoID.length > 0)
			{
   //  [self.playerView loadWithVideoId:exercise.video];
		 
				NSDictionary *playerVars = @{
				@"showinfo": @0,
				@"playsinline" : @0,
				@"rel": @0,
				@"ecver:": @2,
				@"modestbranding": @1,
				@"disablekb": @1
				};

				YTPlayerView *videoView = [[YTPlayerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height- self.view.frame.size.width*6/9,self.view.frame.size.width,self.view.frame.size.width*6/9)];
				[videoView loadWithVideoId:videoID playerVars:playerVars];
				videoView.tag=31;
		 
				[self.view addSubview:videoView];
				videoView.delegate=self;
			}
		
		
	
   //     XCDYouTubeVideoPlayerViewController *videoPlayerVC = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:exercise.video];
   //     [self presentMoviePlayerViewControllerAnimated:videoPlayerVC];
    
			else
			{
				[SVProgressHUD showImage:[UIImage imageNamed:@"Video_Alert"]
                          status:@"Vídeo Indisponível!"
                        maskType:SVProgressHUDMaskTypeGradient];
			}
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
    //  [self dismissViewControllerAnimated:YES completion:nil];
      UIView *viewToRemove = [self.view viewWithTag:31];
		[viewToRemove removeFromSuperview];
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

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - SCROLLVIEW DELEGATE

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSInteger currentOffset = scrollView.contentOffset.y;
    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    // Hit Bottom?
    if ((currentOffset > 0) && (maximumOffset - currentOffset) <= 10)
    {
        // Se ainda tem dados para ser carregado.
        if (loadMoreData && nextPageToken.length > 0)
        {
			[self getVideoListMergeBottom];
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - CUSTOM METHODS

- (void)getVideoList
{
    // VERIFICA SE TEM CONEXÃO COM A INTERNET.
    BOOL flagInternetStatus = [IMManager sharedManager].hasConnection;
    
    if (flagInternetStatus)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [SVProgressHUD showWithStatus:kTEXT_LOADING_DEFAULT];
            });
        });
        
 //       AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  //      [manager.requestSerializer setTimeoutInterval:AFHHTTP_TIMEOUT];
        NSMutableString *baseURL = [[NSMutableString alloc]init];
        
        // Monta a URL base conforme solicita a API V3 do Youtube.
        [baseURL appendString:kYOUTUBE_BASE_URL];
        [baseURL appendString:@"playlistItems?"];
        [baseURL appendString:@"part=snippet&"];
        [baseURL appendString:[NSString stringWithFormat:@"maxResults=%@&", KYOUTUBE_MAX_RESULT]];
        [baseURL appendString:[NSString stringWithFormat:@"playlistId=%@&", kYOUTUBE_PLAYLIST_ID]];
        [baseURL appendString:[NSString stringWithFormat:@"key=%@&", kYOUTUBE_API_KEY]];
        
       AFHTTPSessionManager *manager2 = [AFHTTPSessionManager manager];
		  [manager2 GET:baseURL parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           
            // Se recebeu OK.
            if(1) //[operation.response statusCode] == 200)
            {
                // Guarda o token da proxima pagina. Para solicitar os proximos resultados precisa enviar esse TOKEN.
                if ([responseObject objectForKey:@"nextPageToken"] != (id)[NSNull null])
                {
                    nextPageToken = [responseObject objectForKey:@"nextPageToken"];
                }
                
                // Pega o total de resultados (Total de Videos).
                if ([responseObject valueForKeyPath:@"pageInfo.totalResults"] != (id)[NSNull null])
                {
                    NSString *temp = [responseObject valueForKeyPath:@"pageInfo.totalResults"];
                    totalResults = [temp intValue];
                }
                
                arrayData = [[NSMutableArray alloc] init];
                NSArray *items = (NSArray *)[responseObject objectForKey:@"items"];
                
                if (items.count > 0)
                {
                    for ( int i = 0; i < items.count; ++i)
                    {
                        NSDictionary *playlistSnippetDict = [[items objectAtIndex:i]objectForKey:@"snippet"];
                        
                        // Initialize a new dictionary and store the data of interest.
                        NSMutableDictionary *desiredPlaylistItemDataDict = [[NSMutableDictionary alloc] init];
                        [desiredPlaylistItemDataDict setObject:[playlistSnippetDict objectForKey:@"title"] forKey:@"title"];
                        [desiredPlaylistItemDataDict setObject:[playlistSnippetDict valueForKeyPath:@"thumbnails.high.url"] forKey:@"url"];
                        [desiredPlaylistItemDataDict setObject:[playlistSnippetDict valueForKeyPath:@"resourceId.videoId"] forKey:@"videoId"];
                        [desiredPlaylistItemDataDict setObject:[playlistSnippetDict objectForKey:@"channelTitle"] forKey:@"channelTitle"];
                        [desiredPlaylistItemDataDict setObject:[playlistSnippetDict objectForKey:@"publishedAt"] forKey:@"publishedAt"];
                        
                        [arrayData addObject:desiredPlaylistItemDataDict];
                        
                        NSString *videoID = [playlistSnippetDict valueForKeyPath:@"resourceId.videoId"];
                        [self getVideoDuration:videoID];
                    }
                }
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"LOG: %@", error);
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:kTEXT_TITLE_ALERT_ERROR_DEFAULT
                                                           message:@"Não foi possível acessar os videos neste momento. \nPor favor tente novamente mais tarde!"
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil, nil];
            
            [alert show];
            
            [SVProgressHUD dismiss];
        }];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kTEXT_TITLE_ALERT_ERROR_DEFAULT
                                                        message:kTEXT_NEED_ONLINE_DEFAULT
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        
        [alert show];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)getVideoDuration:(NSString*)videoID
{
 //   AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  //  [manager.requestSerializer setTimeoutInterval:AFHHTTP_TIMEOUT];
    NSMutableString *baseURL = [[NSMutableString alloc] init];
    
    [baseURL appendString:kYOUTUBE_BASE_URL];
    [baseURL appendString:@"videos?"];
    [baseURL appendString:[NSString stringWithFormat:@"id=%@&", videoID]];
    [baseURL appendString:@"part=contentDetails&"];
    [baseURL appendString:[NSString stringWithFormat:@"key=%@&", kYOUTUBE_API_KEY]];

     AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
		[manager GET:baseURL parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
   {
         if(1) //[operation.response statusCode] == 200)
        {
            NSArray *items = (NSArray *)[responseObject objectForKey:@"items"];
            
            NSDictionary *contentDetailsDict = [[items objectAtIndex:0]objectForKey:@"contentDetails"];

            for (NSMutableDictionary *dict in arrayData)
            {
                if ([[dict objectForKey:@"videoId"] isEqualToString:videoID])
                {
                    [dict setObject:[contentDetailsDict objectForKey:@"duration"] forKey:@"duration"];
                    break;
                }
            }

            [self getVideoViews:videoID];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"LOG: %@", error);
        
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:kTEXT_TITLE_ALERT_ERROR_DEFAULT
//                                                       message:@"1" //kTEXT_INTERNET_ERROR_DEFAULT
//                                                      delegate:self
//                                             cancelButtonTitle:@"OK"
//                                             otherButtonTitles:nil, nil];
//
//        [alert show];
		 
        [SVProgressHUD dismiss];
    }];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)getVideoViews:(NSString*)videoID
{
 //   AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  //  [manager.requestSerializer setTimeoutInterval:AFHHTTP_TIMEOUT];
    NSMutableString *baseURL = [[NSMutableString alloc] init];
    
    [baseURL appendString:kYOUTUBE_BASE_URL];
    [baseURL appendString:@"videos?"];
    [baseURL appendString:[NSString stringWithFormat:@"id=%@&", videoID]];
    [baseURL appendString:@"part=statistics&"];
    [baseURL appendString:[NSString stringWithFormat:@"key=%@&", kYOUTUBE_API_KEY]];
    
  AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
 		  [manager GET:baseURL parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(1)//[operation.response statusCode] == 200)
           {
            NSArray *items = (NSArray *)[responseObject objectForKey:@"items"];
            
            NSDictionary *contentDetailsDict = [[items objectAtIndex:0]objectForKey:@"statistics"];
            
            for (NSMutableDictionary *dict in arrayData)
            {
                if ([[dict objectForKey:@"videoId"] isEqualToString:videoID])
                {
                    [dict setObject:[contentDetailsDict objectForKey:@"viewCount"] forKey:@"viewCount"];
                    break;
                }
            }
            
            uiTableView.tableFooterView = nil;
            
            if (!(arrayData == (id)[NSNull null] || [arrayData count] == 0))
            {
                [SVProgressHUD dismiss];
                
                [self hideNoDataMessage];
                [self.uiTableView reloadData];
            }
            else
            {
                didLoadList = FALSE;
                [self showNoDataMessage];
                [SVProgressHUD dismiss];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
//        NSLog(@"LOG: %@", error);
//
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:kTEXT_TITLE_ALERT_ERROR_DEFAULT
//                                                       message:@"2" //kTEXT_INTERNET_ERROR_DEFAULT
//                                                      delegate:self
//                                             cancelButtonTitle:@"OK"
//                                             otherButtonTitles:nil, nil];
//
//        [alert show];
		 
        [SVProgressHUD dismiss];
    }];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)getVideoListMergeBottom
{
    // VERIFICA SE TEM CONEXÃO COM A INTERNET.
    BOOL flagInternetStatus = [IMManager sharedManager].hasConnection;
    
    if (flagInternetStatus)
    {
        // Cria um Loader no bottom da tela.
        UIView *loaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 26)];
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityIndicator.frame = CGRectMake(110, 1, 18, 18);
        [activityIndicator startAnimating];
        [activityIndicator setColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0]];
        
        [loaderView addSubview:activityIndicator];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(120, 1, 100, 18)];
        
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        label.shadowOffset = CGSizeMake(0,1);
        label.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
        label.font = [UIFont fontWithName:@"AlrightSans-Regular" size:12];
        label.text = kTEXT_LOADING_DEFAULT;
        
        [loaderView addSubview:label];
        
        uiTableView.tableFooterView = loaderView;
        
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
 //       [manager.requestSerializer setTimeoutInterval:AFHHTTP_TIMEOUT];
        NSMutableString *baseURL = [[NSMutableString alloc]init];
        
        [baseURL appendString:kYOUTUBE_BASE_URL];
        [baseURL appendString:@"playlistItems?"];
        [baseURL appendString:[NSString stringWithFormat:@"pageToken=%@&", nextPageToken]];
        [baseURL appendString:@"part=snippet&"];
        [baseURL appendString:[NSString stringWithFormat:@"maxResults=%@&", KYOUTUBE_MAX_RESULT]];
        [baseURL appendString:[NSString stringWithFormat:@"playlistId=%@&", kYOUTUBE_PLAYLIST_ID]];
        [baseURL appendString:[NSString stringWithFormat:@"key=%@&", kYOUTUBE_API_KEY]];
        
         AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
 		  [manager GET:baseURL parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          
            if (!(arrayData == (id)[NSNull null] || [arrayData count] == 0))
            {
                if(1) //[operation.response statusCode] == 200)
                {
                    if ([responseObject objectForKey:@"nextPageToken"] != (id)[NSNull null])
                    {
                        nextPageToken = [responseObject objectForKey:@"nextPageToken"];
                    }
                    
                    NSArray *items = (NSArray *)[responseObject objectForKey:@"items"];
                    
                    if (items.count > 0)
                    {
                        for ( int i = 0; i < items.count; ++i)
                        {
                            NSDictionary *playlistSnippetDict = [[items objectAtIndex:i]objectForKey:@"snippet"];
                            
                            // Initialize a new dictionary and store the data of interest.
                            NSMutableDictionary *desiredPlaylistItemDataDict = [[NSMutableDictionary alloc] init];
                            [desiredPlaylistItemDataDict setObject:[playlistSnippetDict objectForKey:@"title"] forKey:@"title"];
                            [desiredPlaylistItemDataDict setObject:[playlistSnippetDict valueForKeyPath:@"thumbnails.high.url"] forKey:@"url"];
                            [desiredPlaylistItemDataDict setObject:[playlistSnippetDict valueForKeyPath:@"resourceId.videoId"] forKey:@"videoId"];
                            [desiredPlaylistItemDataDict setObject:[playlistSnippetDict objectForKey:@"channelTitle"] forKey:@"channelTitle"];
                            [desiredPlaylistItemDataDict setObject:[playlistSnippetDict objectForKey:@"publishedAt"] forKey:@"publishedAt"];
                            
                            if (arrayData.count < totalResults)
                            {
                                loadMoreData = YES;
                                [arrayData insertObject:desiredPlaylistItemDataDict atIndex:arrayData.count];
                                
                                NSString *videoID = [playlistSnippetDict valueForKeyPath:@"resourceId.videoId"];
                                [self getVideoDuration:videoID];
                            }
                            else
                            {
                                uiTableView.tableFooterView = nil;
                                loadMoreData = NO;
                            }
                        }
                    }
                }
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
            
            NSLog(@"LOG: %@", error);
            
            [SVProgressHUD dismiss];
            
            [loaderView removeFromSuperview];
            
            uiTableView.tableFooterView = nil;
            
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:kTEXT_TITLE_ALERT_ERROR_DEFAULT
//                                                           message:@"3" //kTEXT_INTERNET_ERROR_DEFAULT
//                                                          delegate:self
//                                                 cancelButtonTitle:@"OK"
//                                                 otherButtonTitles:nil, nil];
//            
//            [alert show];
        }];

    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kTEXT_TITLE_ALERT_ERROR_DEFAULT
                                                        message:kTEXT_NEED_ONLINE_DEFAULT
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        
        [alert show];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)showOfflineMessage
{
	self.uiTableView.hidden = YES;
	
    // Remove o label da view.
    [uiLabelMesage removeFromSuperview];
    
    // incializa o label.
    uiLabelMesage = [[UILabel alloc]initWithFrame:CGRectMake(((self.view.frame.size.width / 2) - 150), 130, 300, 80)];
    
    // Configura o label.
    uiLabelMesage.numberOfLines = 0;
    uiLabelMesage.textAlignment = NSTextAlignmentCenter;
    uiLabelMesage.backgroundColor = [UIColor clearColor];
    uiLabelMesage.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
    uiLabelMesage.shadowColor = [UIColor colorWithWhite:0.8 alpha:0.7];
    uiLabelMesage.shadowOffset = CGSizeMake(1,1);
    uiLabelMesage.font = [UIFont fontWithName:@"AlrightSans-Regular" size:14];
    
    // Mensagem do label.
    uiLabelMesage.text = @"Verifique a conexão com a internet!";
    
    // Animação para mostrar o label com fade in.
    uiLabelMesage.alpha = 0;
    
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	
        uiLabelMesage.alpha = 1;
    
    [UIView commitAnimations];
    
    // Adiciona o label na view.
    [self.view addSubview:uiLabelMesage];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)hideOfflineMessage
{
	self.uiTableView.hidden = NO;
	
    // Animação para remover o label com fade out.
    uiLabelMesage.alpha = 1;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
	 
        uiLabelMesage.alpha = 0;
    
    [UIView commitAnimations];
    
    // Remove o label da view.
    [uiLabelMesage removeFromSuperview];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)showNoDataMessage
{
    [uiLabelMesage removeFromSuperview];
    
    uiLabelMesage = [[UILabel alloc]initWithFrame:CGRectMake(((self.view.frame.size.width/2)-140),
                                                          ((self.view.frame.size.height/2)-40-17.5),
                                                          280,
                                                          80)];
    
    // Configura o label.
    uiLabelMesage.numberOfLines = 0;
    uiLabelMesage.textAlignment = NSTextAlignmentCenter;
    uiLabelMesage.backgroundColor = [UIColor clearColor];
    uiLabelMesage.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
    uiLabelMesage.shadowColor = [UIColor colorWithWhite:0.8 alpha:0.7];
    uiLabelMesage.shadowOffset = CGSizeMake(1,1);
    uiLabelMesage.font = [UIFont fontWithName:@"AlrightSans-Regular" size:14];
    
    // Mensagem do label.
    uiLabelMesage.text = @"Nenhum video encontrado. \nTente novamente mais tarde!";
    
    uiLabelMesage.alpha = 0;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    uiLabelMesage.alpha = 1;
    
    // Adiciona o label na view.
    [self.view addSubview:uiLabelMesage];
    
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
    
    uiLabelMesage.alpha = 0;
    [uiLabelMesage removeFromSuperview];
    
    [UIView commitAnimations];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - NOTIFICATION METHODS

- (void)becomeActive:(NSNotification *)notification
{
    didLoadList = FALSE;
    
    [self viewWillAppear:YES];
}

@end

////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
