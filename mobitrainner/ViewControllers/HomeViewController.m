//
//  UIViewController+HomeViewController.m
//  mobitrainer
//
//  Created by Rubens Rosa on 19/02/2018.
//  Copyright © 2018 4mobi. All rights reserved.
//

//
//  HomeViewController.m
//  treino
//
//  Created by Reginaldo Lopes on 25/11/14.
//  Copyright (c) 2014 4mobi. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController()

@end

@implementation HomeViewController

@synthesize scrollView;
@synthesize pageControl;
@synthesize pageViewManager;
@synthesize arrayImages;
@synthesize viewImage;
//@synthesize timerCheckUpdate;
//@synthesize timerLater;


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - SEGUE


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	
    if ([[segue identifier] isEqualToString:@"segueBlogDetalhes"])
    {
        BlogDetalhesVC *bdvc = [segue destinationViewController];
		 
        bdvc.item = [arrayFeeds objectAtIndex:indexPath.row];
        bdvc.titulo = [[arrayFeeds objectAtIndex:indexPath.row] objectForKey:@"title"];
    }
}




////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - VIEW LIFECYCLE

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	// Inicializa o helper do Banco de dados.
    coreDataService = [[CoreDataService alloc] init];
    [coreDataService initialize];
	 // Inicializa o objeto utils.
    utils = [[UtilityClass alloc] init];
	
	
    arrayLocalFeeds = [[NSMutableArray alloc] init];
	
    arrayImages = [[NSMutableArray alloc] init];
    [self loadImagensFromCacheFolder];
	
	
	
	
	
    self.tableView.delegate = self;
	// self.tableView.refreshControl = refreshControl;
	
   // scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 248)];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(scrollView.frame.size.width/2 - 19, scrollView.frame.size.height-32, 38, 38)];
	 [viewImage addSubview:scrollView];
    [viewImage addSubview:pageControl];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(becomeActive:)
//                                                 name:UIApplicationWillEnterForegroundNotification
//                                               object:nil];
//	
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(becomeInactive:)
//                                                 name:UIApplicationDidEnterBackgroundNotification
//                                               object:nil];
//	
    self.tableView.scrollEnabled = YES;
	
    // Configura o texto do botão de voltar.
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"HOME"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:nil
                                                                  action:nil];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.backBarButtonItem = backButton;
	
//    // Configura o background da tableview.
//    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    [backgroundView setBackgroundColor:UIColorFromRGB(0xDFDFDF)];
//    [self.tableView setBackgroundView:backgroundView];
//    self.tableView.backgroundView.layer.zPosition -= 1;
	
    // Tweak para linhas extra na tabela.
  //   [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0,0, 320,70)]];
  // Initialize the refresh control.
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = UIColorFromRGB(0xF0F0F0);
    refreshControl.tintColor = UIColorFromRGB(0xFFFFFF);
    [refreshControl addTarget:self
                    action:@selector(parseXMLFileAtURL)
                  forControlEvents:UIControlEventValueChanged];
	  [self.tableView addSubview:refreshControl];
	self.tableView.refreshControl=refreshControl;
	 arrayLocalFeeds = [coreDataService getDataFromBlogFeedsTable];
    [self startUpdateProcess];
    [self getBlogURL];
    [self parseXMLFileAtURL];
       [utils downloadProductsForSale];
	
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
 
    [self.tableView setContentOffset:CGPointZero animated:NO];
	
//    // Configura observadores.
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(startTimerUpdateThread:)
//                                                 name:@"startTimerUpdateThread"
//                                               object:nil];
//
//    // Configura observadores.
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(stopTimerUpdateThread:)
//                                                 name:@"stopTimerUpdateThread"
//                                               object:nil];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(updateFeaturedImages:)
//                                                 name:@"updateFeaturedImages"
//                                               object:nil];
//
	  [self checkUpdateStatus];
	  flagUpdate = TRUE;
	  [self loadImagensFromCacheFolder];
	
     [self.tableView reloadData];
}



////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
	
    [SVProgressHUD dismiss];
	
  //  [[NSNotificationCenter defaultCenter] postNotificationName:@"stopTimerUpdateThread" object:self];
	
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"updateFeaturedImages"
                                                  object:nil];
	
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"updateFeaturedImages"
                                                  object:nil];
	
    flagUpdate = FALSE;
	
    dispatch_async(dispatch_get_main_queue(), ^{
		 
        [self.timerMessageCount invalidate];
    //    [self.timerCheckUpdate invalidate];
    //    [self.timerLater invalidate];
		 
        self.timerMessageCount = nil;
     //   self.timerCheckUpdate = nil;
     //   self.timerLater = nil;
		 
    });
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)dealloc
{
    // Configura observadores.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"startTimerUpdateThread"
                                                  object:nil];
	
    // Configura observadores.
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:@"stopTimerUpdateThread"
//                                                  object:nil];
//
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillEnterForegroundNotification
                                                  object:nil];
	
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - TABLE VIEW DATA SOURCE & DELEGATE

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//   // UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 248)];
//    [viewImage addSubview:scrollView];
//    [viewImage addSubview:pageControl];
//	
//    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:viewImage.bounds];
//    viewImage.layer.masksToBounds = NO;
//    viewImage.layer.shadowColor = [UIColor blackColor].CGColor;
//    viewImage.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
//    viewImage.layer.shadowOpacity = 0.3f;
//    viewImage.layer.shadowPath = shadowPath.CGPath;
//	
//    return viewImage;
//}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return scrollView.frame.size.height;
//}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - TABLEVIEW DATA SOURCE & DELEGATE

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if(arrayLocalFeeds !=nil)
    return [arrayLocalFeeds count];
   else
     return 0;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
	
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
	
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        //end of loading
        //for example [activityIndicator stopAnimating];
        [SVProgressHUD dismiss];
    }
	
    UIView *bgColorView = [[UIView alloc] init];
#ifdef OLD_STYLE
    Design *appDesign = (Design *) [coreDataService getDataFromDesignTable];
    [bgColorView setBackgroundColor: UIColorFromRGB(kPRIMARY_COLOR)];
#endif
#ifdef NEW_STYLE
    [bgColorView setBackgroundColor: UIColorFromRGB( MENU_CLICK_COLOR )];
#endif
	
    [bgColorView setClipsToBounds:YES];
    bgColorView.alpha = 0.1f;
    [cell setSelectedBackgroundView:bgColorView];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
	
    BlogCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (!cell)
    {
        cell = [[BlogCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
	 BlogFeeds *feed = (BlogFeeds *) [arrayLocalFeeds objectAtIndex:indexPath.row];
	
    cell.labelTitleBlog.text = feed.titulo;
    cell.labelContentBlog.text = feed.descricao;
    cell.labelData.text = feed.pubDate;
    // RECUPERA AS CONFIGURA"CÃO DO APP DESGIN DO BANCOD E DADOS.
 //   Design *appDesign = (Design *) [coreDataService getDataFromDesignTable];
	
   // cell.labelMore.textColor = UIColorFromRGB(kPRIMARY_COLOR);
	
    return cell;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
 //     [self.tabBar invalidateIntrinsicContentSize];
	
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

#pragma mark - PARSE RSS FEED

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
	
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)parseXMLFileAtURL
{
	
     [self.tableView.refreshControl endRefreshing];
    // SE TEM CONEXÃO

    Blog *blogData = [coreDataService getDataFromBlogTable];
	 if(blogData==nil)
	 	return;
	
	 [coreDataService dropBlogFeedsTable];
    NSString *URL = blogData.blogURL;
	
    arrayFeeds = [[NSMutableArray alloc] init];
	
    NSURL *xmlURL = [NSURL URLWithString:URL];
	
    rssParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
    [rssParser setDelegate:self];
    [rssParser setShouldProcessNamespaces:NO];
    [rssParser setShouldReportNamespacePrefixes:NO];
    [rssParser setShouldResolveExternalEntities:NO];
    [rssParser parse];

    [arrayLocalFeeds removeAllObjects];
	 arrayLocalFeeds = [coreDataService getDataFromBlogFeedsTable];
	 [self.tableView.refreshControl endRefreshing];
    [self.tableView reloadData];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
	[self.tableView.refreshControl endRefreshing];
    [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                      AndText:@"Erro ao carregar o conteúdo!"
                  AndTargetVC:self];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{

    currentElement = [elementName copy];
	
    if ([elementName isEqualToString:@"item"])
    {
        item = [[NSMutableDictionary alloc] init];
        currentTitle = [[NSMutableString alloc] init];
        currentDate = [[NSMutableString alloc] init];
        currentDescription = [[NSMutableString alloc] init];
        currentGUID = [[NSMutableString alloc] init];
        currentContent = [[NSMutableString alloc] init];
        currentLink = [[NSMutableString alloc] init];
		 
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"item"])
    {
        [item setObject:currentTitle forKey:@"title"];
        [item setObject:currentDescription forKey:@"description"];
        [item setObject:currentDate forKey:@"pubDate"];
        [item setObject:currentGUID forKey:@"guid"];
        [item setObject:currentContent forKey:@"content"];
        [item setObject:currentLink forKey:@"link"];
        [arrayFeeds addObject:[item copy]];
		 
		  BlogFeeds *blogfeed = (BlogFeeds *)[NSEntityDescription insertNewObjectForEntityForName:@"BlogFeeds"
                                                                                             inManagedObjectContext:coreDataService.getManagedContext];
	
		  blogfeed.titulo = [item objectForKey:@"title"];
		  blogfeed.descricao = [item objectForKey:@"description"];
		  blogfeed.pubDate = [item objectForKey:@"pubDate"];
		  blogfeed.guid = [item objectForKey:@"guid"];
		  blogfeed.content = [item objectForKey:@"content"];
		  blogfeed.link = [item objectForKey:@"link"];
		 
		  [coreDataService saveData];
		 
    }
	
    else
    {
        //NSLog(@"Elemente Name not Item = %@",elementName);
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"&#8220;" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"&#8211;" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"	" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"<small>" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"</small>" withString:@""];
	
    if ([currentElement isEqualToString:@"title"])
    {
        [currentTitle appendString:string];
    }
    else if ([currentElement isEqualToString:@"description"])
    {
        [currentDescription appendString:string];
    }
    else if ([currentElement isEqualToString:@"pubDate"])
    {
	     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		 [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss ZZ"];
		 NSDate *date = [dateFormatter dateFromString:string];
		 [dateFormatter setDateFormat:@"dd/MM/yyyy"];
		 if(date!=nil)
		 {
		 	NSString *datestr = [dateFormatter stringFromDate:date];
		 	NSLog(@"DateObject : %@", datestr);
			[currentDate appendString:datestr];
		 }
    }
    else if ([currentElement isEqualToString:@"guid"])
    {
        [currentGUID appendString:string];
    }
    else if ([currentElement isEqualToString:@"destaque"])
    {
        [guid appendString:string];
    }
    else if ([currentElement isEqualToString:@"content:encoded"])
    {
        [currentContent appendString:string];
    }
    else if ([currentElement isEqualToString:@"link"])
    {
        [currentLink appendString:string];
    }
	
    //NSLog(@"Elemento: %@=%@", currentLink, string);
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - ACTIONS

- (IBAction) blogReloadBtn:(id)sender
{
	
        [self performSelector:@selector(parseXMLFileAtURL) withObject:nil afterDelay:0.1];
	
	
}



//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
//
//#pragma mark - NOTIFICATION METHODS
//
//- (void)startTimerUpdateThread:(NSNotification *)notification
//{
//    dispatch_async(dispatch_get_main_queue(), ^{
//
//        // Seta o timer para verificar o update.
//        self.timerCheckUpdate = [NSTimer scheduledTimerWithTimeInterval:kCHECK_UPDATE_TIMER
//                                                                 target:self
//                                                               selector:@selector(checkUpdateStatus:)
//                                                               userInfo:nil
//                                                                repeats:YES];
//
//        // Dispare o timer, imediatamente.
//        [self.timerCheckUpdate fire];
//
//        unreadCount = 0;
//    });
//}
//
//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
//
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

- (void)updateFeaturedImages:(NSNotification *)notification
{
    [self loadImagensFromCacheFolder];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

//- (void)becomeActive:(NSNotification *)notification
//{
//    // Pega o status do usuário, logado ou não.
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//
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
//
//    [self.tableView reloadData];
//}
//
//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
//
//- (void)becomeInactive:(NSNotification *)notification
//{
//
//
//    // DESATIVA O TIMER QUE VERIFCA O UPDATE DA BASE DE DADOS.
//    [self.timerCheckUpdate invalidate];
//}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - CUSTOM METHODS

- (void)fixNavBarColor
{
    ////////////////////////////////////////////////
    /// Carrega o tema no aplicativo ///////////////
    ////////////////////////////////////////////////
	
    // Pega os dados da tabela.
    Design *appDesign = (Design *) [coreDataService getDataFromDesignTable];
	
    // COR DA NAVIGATION
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(kPRIMARY_COLOR);
	
    // COR DOS ITENS (TINT) DA NAVBAR.
    self.navigationController.navigationBar.tintColor = UIColorFromRGB([utils StringtoHex:appDesign.navTint]);
	
    // COR DO TITULO DA NAVIGATION.
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:UIColorFromRGB([utils StringtoHex:appDesign.navTitleColor])};
	
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
	
    [self.tableView reloadData];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)loadImagensFromCacheFolder
{
    // Inicializa o arra que ira conter as telas de destaque.
    [arrayImages removeAllObjects];
	
    // Pega todas as imagens de destaque na pasta.
    NSArray *arrayPNG = [utils pngFilesInFeaturedImagesFolder];
	
    // Se o array não estiver vazio.
    if ([arrayPNG count] != 0)
    {
        // Varre o array pegando todos os itens e criando as imagens.
        for (NSUInteger i = 0; i < [arrayPNG count]; i++)
        {
            UIImageView *imageView = [[UIImageView alloc] init];
			  
            NSMutableString *urlFile = [[NSMutableString alloc] init];
			  
            // Pega o caminho do diretório Documents adicionando o nome do diretório que será criado.
            [urlFile appendString:[[utils returnDocumentsPath] stringByAppendingPathComponent:@"/Caches/FeaturedImages"]];
            [urlFile appendString:@"/"];
            [urlFile appendString:[arrayPNG objectAtIndex:i]];
			  
            // Cria uma UIImage com imagem do cache
            UIImage * image = [UIImage imageWithContentsOfFile:urlFile];
			  
            imageView.image = image;
			  
            [imageView sizeToFit];
			  
            // Adiciona a imagem criada no aarray.
            [arrayImages addObject:imageView];
        }
		 
        double delayInSeconds = 0.2f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
			  
            if(pageViewManager==nil) //RFR - Eviar a realocação do PageView
					
                // Inicializa o pageViewManager
                pageViewManager = [[PageViewManager alloc] initWithScrollView:self.scrollView
                                                                  pageControl:self.pageControl
                                                                showAnimation:YES];
			  
            // Faz o PageViewManager mostrar o conteudo do array de UIViews no UIScrollView.
            [pageViewManager loadPages:arrayImages];
			  
        });
    }
    else
    {
        // Se estiver vazio, carrega a imagem default.
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"Default_Placeholder.png"];
		 
        [arrayImages removeAllObjects];
        [arrayImages addObject:imageView];
		 
        double delayInSeconds = 0.2f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
			  
            // Inicializa o pageViewManager
            if(pageViewManager==nil) //RFR - Eviar a realocação do PageView
					
                pageViewManager = [[PageViewManager alloc] initWithScrollView:self.scrollView
                                                                  pageControl:self.pageControl
                                                                showAnimation:YES]; //RFR: Era NO
			  
            // Faz o PageViewManager mostrar o conteudo do array de UIViews no UIScrollView.
            [pageViewManager loadPages:arrayImages];
        });
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - CUSTOM METHODS


- (void)startUpdateProcess
{
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		 
        [SVProgressHUD showWithStatus:@"Atualizando..."
                             maskType:SVProgressHUDMaskTypeGradient];
		 
    });
	
    // Cria um operation manager para realizar a solicitação via POST.
 //   AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//	[manager.requestSerializer setTimeoutInterval:AFHHTTP_TIMEOUT];
	// [manager.requestSerializer setTimeoutInterval:AFHHTTP_TIMEOUT];
	
    // Parametros validados.
    NSDictionary *parameters = @{@"apikey": API_KEY_TRAINER};
	
    // Monta a string de acesso a validação do login.
    NSMutableString *urlString = [[NSMutableString alloc] init];
    [urlString appendString:kBASE_URL_MOBITRAINER];
    [urlString appendString:@"api/update"];
	
    // Realiza o POST das informações e aguarda o retorno.
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
 			[manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
 			NSString *path=[[NSString alloc]initWithFormat:@"%@",urlString];
 			[manager POST:[NSURL URLWithString:path].absoluteString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
        if (![[responseObject objectForKey:@"response_error"] boolValue])
        {
            // Pega os dados do JSON.
            NSDictionary *dataUpdate = [responseObject objectForKey:@"response_update"];
			  
            // Se existirem dados a serem verificados.
            if ([dataUpdate count] > 0)
            {
                UpdateCheck *uCheck = [[UpdateCheck alloc] init];
					
                uCheck.designLastUpdate = [utils checkString:[dataUpdate objectForKey:@"design"]];
                uCheck.blogLastUpdate = [utils checkString:[dataUpdate objectForKey:@"blog"]];
                uCheck.trainerInfoLastUpdate = [utils checkString:[dataUpdate objectForKey:@"trainerinfo"]];
                uCheck.featuredImagesLastUpdate = [utils checkString:[dataUpdate objectForKey:@"promotion"]];
                uCheck.trainingLastUpdate = [utils checkString:[dataUpdate objectForKey:@"training"]];
                uCheck.traineeLastUpdate = [utils checkString:[dataUpdate objectForKey:@"trainee"]];
                uCheck.radioLastUpdate = [utils checkString:[dataUpdate objectForKey:@"radio"]];
                uCheck.chatLastUpdate = [dataUpdate objectForKey:@"chat"];
                uCheck.userProfileLastUpdate = [utils checkString:[dataUpdate objectForKey:@"profile"]];
					
                /// CARREGA O TEMA DO APP
                [self updateDesignWithDatesToCheck:uCheck];
                 [SVProgressHUD dismiss];
            }
        }
		 
        flagUpdate = TRUE;
		 
    } failure:^(NSURLSessionTask *operation, NSError *error) {
		 
        NSLog(@"Error: %@", error);
		 
        dispatch_async(dispatch_get_main_queue(), ^{
			  
            [SVProgressHUD dismiss];
        });
		  [self.tableView.refreshControl endRefreshing];
        [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                          AndText:kTEXT_SERVER_ERROR_DEFAULT
                      AndTargetVC:self];
		 
        flagUpdate = TRUE;
    }];
    	[self getBlogURL];
	
}



////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)updateDesignWithDatesToCheck:(UpdateCheck *)uCheck
{
    LastUpdates *lastUpdate = (LastUpdates *) [coreDataService getDataFromLastUpdatesTable];
	
    if (![lastUpdate.design isEqualToString:uCheck.designLastUpdate])
    {
        // Pega os dados do usuário...
   //     User *userData = (User *) [coreDataService getDataFromUserTable];
		 
		 
        // Cria um operation manager para realizar a solicitação via POST.
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//		  [manager.requestSerializer setTimeoutInterval:AFHHTTP_TIMEOUT];
        // Parametros validados.
        NSDictionary *parameters = @{@"apikey": API_KEY_TRAINER, @"filter": @"design"};
		 
        // Monta a string de acesso a validação do login.
        NSMutableString *urlString = [[NSMutableString alloc] init];
        [urlString appendString:kBASE_URL_MOBITRAINER];
        [urlString appendString:@"api/appconfig"];
		 
        // Realiza o POST das informações e aguarda o retorno.
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
 			[manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
 			NSString *path=[[NSString alloc]initWithFormat:@"%@",urlString];
 			[manager POST:[NSURL URLWithString:path].absoluteString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
            if (![[responseObject objectForKey:@"response_error"] boolValue])
            {
                // Pega os dados do JSON.
                NSDictionary *dataDesing = [responseObject objectForKey:@"appconfig_design"];
					
                // Se existirem dados a serem verificados.
                if (dataDesing.count > 0)
                {
                    LastUpdates *lastUpdate = (LastUpdates *) [coreDataService getDataFromLastUpdatesTable];
						 
                    
						 
                    // Apaga dos dados da tabela.
                    [coreDataService dropDesignTable];
						 
                    Design *appDesign = (Design *) [NSEntityDescription insertNewObjectForEntityForName:@"Design"
                                                                                 inManagedObjectContext:coreDataService.getManagedContext];
						 
                    appDesign.navColor =  [utils checkString:[dataDesing objectForKey:@"design_navcolor"]];
                    appDesign.navTint =  [utils checkString:[dataDesing objectForKey:@"design_navtint"]];
                    appDesign.navTitleColor =  [utils checkString:[dataDesing objectForKey:@"design_navtittlecolor"]];
                    appDesign.blackStatusBar = [NSNumber numberWithBool: [[utils checkString:[dataDesing objectForKey:@"design_blackstatusbar"]] boolValue]];
						 
                    if ([utils checkString:uCheck.designLastUpdate].length == 0)
                    {
                        lastUpdate.design = @"1970-01-01 00:00:00";
                    }
                    else
                    {
                        // Atualiza a data do ultimo update da tabela design...
                        lastUpdate.design = uCheck.designLastUpdate;
                    }
						 
                    [coreDataService saveData];
						 
                    ////////////////////////////////////////////////
                    /// Carrega o tema no aplicativo ///////////////
                    ////////////////////////////////////////////////
						 
                    // COR DA NAVIGATION
						 
                    [[UINavigationBar appearance] setBarTintColor: UIColorFromRGB(kPRIMARY_COLOR)];
						 
						 
                    // COR DOS ITENS (TINT) DA NAVBAR.
                    [[UINavigationBar appearance] setTintColor: UIColorFromRGB([utils StringtoHex:appDesign.navTint])];
                    self.navigationController.navigationBar.tintColor = [UINavigationBar appearance].tintColor;
						 
                    // COR DO TITULO DA NAVIGATION.
                    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB([utils StringtoHex:appDesign.navTitleColor])}];
						 
						 
                    self.navigationController.navigationBar.tintColor = [UINavigationBar appearance].tintColor;
                    self.navigationController.navigationBar.barTintColor = [UINavigationBar appearance].barTintColor;
                    self.navigationController.navigationBar.titleTextAttributes = [UINavigationBar appearance].titleTextAttributes;
						 
                    // COR DO TEXTO NA STATUSBAR.
                    if (appDesign.blackStatusBar.boolValue)
                    {
                        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
                    }
                    else
                    {
                        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
                    }
						 
                    [self updateRadioWithDatesToCheck:uCheck];
                }
                else
                {
                    // ATUALIZA A DATA, PARA EVITAR PROBLEMAS DE GERAÇÃO DE ATUALIZAÇÃO EM LOOP.
                    LastUpdates *lastUpdate = (LastUpdates *) [coreDataService getDataFromLastUpdatesTable];
						 
                    // ATUALIZA A TABELA COM A DATA ATUAL (NOW)
						 
                    NSDate *today = [NSDate date];
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSString *dateString = [dateFormat stringFromDate:today];
						 
                    lastUpdate.design = dateString;
						 
                    [coreDataService saveData];
						 
                    [self updateRadioWithDatesToCheck:uCheck];
                }
            }
			  
        } failure:^(NSURLSessionTask *operation, NSError *error) {
			  
            NSLog(@"Error: %@", error);
			  
            dispatch_async(dispatch_get_main_queue(), ^{
					
                [SVProgressHUD dismiss];
            });
			   [self.tableView.refreshControl endRefreshing];
            [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                              AndText:kTEXT_SERVER_ERROR_DEFAULT
                          AndTargetVC:self];
        }];
    }
    else
    {
        [self updateRadioWithDatesToCheck:uCheck];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)updateRadioWithDatesToCheck:(UpdateCheck *)uCheck
{
	
    // Cria um operation manager para realizar a solicitação via POST.
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//	 [manager.requestSerializer setTimeoutInterval:AFHHTTP_TIMEOUT];
    // Parametros validados.
    NSDictionary *parameters = @{@"apikey": API_KEY_TRAINER, @"filter": @"radio"};
	
    // Monta a string de acesso a validação do login.
    NSMutableString *urlString = [[NSMutableString alloc] init];
    [urlString appendString:kBASE_URL_MOBITRAINER];
    [urlString appendString:@"api/appconfig"];
	
    // Realiza o POST das informações e aguarda o retorno.
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
			[manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
			NSString *path=[[NSString alloc]initWithFormat:@"%@",urlString];
			[manager POST:[NSURL URLWithString:path].absoluteString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
        if (![[responseObject objectForKey:@"response_error"] boolValue])
        {
            // Pega os dados do JSON.
            NSDictionary *dataRadio = [responseObject objectForKey:@"appconfig_radio"];
			  
            // Se existirem dados a serem verificados.
            if ([dataRadio count] > 0)
            {
                LastUpdates *lastUpdate = (LastUpdates *) [coreDataService getDataFromLastUpdatesTable];
					
                // Apaga dos dados da tabela.
                [coreDataService dropRadioTable];
					
                Radio *radio = (Radio *) [NSEntityDescription insertNewObjectForEntityForName:@"Radio"
                                                                       inManagedObjectContext:coreDataService.getManagedContext];
					
                radio.hasRadio = [NSNumber numberWithBool: [[utils checkString:[dataRadio objectForKey:@"radio_has"]] boolValue]];
                radio.key1 =  [utils checkString:[dataRadio objectForKey:@"radio_key1"]];
                radio.key2 =  [utils checkString:[dataRadio objectForKey:@"radio_key2"]];
					
                if ([utils checkString:uCheck.designLastUpdate].length == 0)
                {
                    lastUpdate.radio = @"1970-01-01 00:00:00";
                }
                else
                {
                    // Atualiza a data do ultimo update da tabela design...
                    lastUpdate.radio = uCheck.radioLastUpdate;
                }
					
                [coreDataService saveData];
					
                if (![radio.hasRadio boolValue])
                {
                    self.navigationItem.leftBarButtonItem.enabled = NO;
                    self.navigationItem.leftBarButtonItem.tintColor = [UIColor clearColor];
                }
                else
                {
                    self.navigationItem.leftBarButtonItem.enabled = YES;
                }
            }
            else
            {
                LastUpdates *lastUpdate = (LastUpdates *) [coreDataService getDataFromLastUpdatesTable];
					
                NSDate *today = [NSDate date];
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *dateString = [dateFormat stringFromDate:today];
					
                lastUpdate.radio = dateString;
					
                [coreDataService saveData];
            }
			  
            [self updateBlogWithDatesToCheck:uCheck];
        }
		 
    } failure:^(NSURLSessionTask *operation, NSError *error) {
		 
        NSLog(@"Error: %@", error);
		 
        dispatch_async(dispatch_get_main_queue(), ^{
			  
            [SVProgressHUD dismiss];
        });
		  [self.tableView.refreshControl endRefreshing];
        [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                          AndText:kTEXT_SERVER_ERROR_DEFAULT
                      AndTargetVC:self];
    }];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)updateBlogWithDatesToCheck:(UpdateCheck *)uCheck
{
	
    LastUpdates *lastUpdate = (LastUpdates *) [coreDataService getDataFromLastUpdatesTable];
	
    if (![lastUpdate.blog isEqualToString:uCheck.blogLastUpdate])
    {
		 
        // Cria um operation manager para realizar a solicitação via POST.
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//		  [manager.requestSerializer setTimeoutInterval:AFHHTTP_TIMEOUT];
        // Parametros validados.
        NSDictionary *parameters = @{@"apikey": API_KEY_TRAINER, @"filter": @"blog"};
		 
        // Monta a string de acesso a validação do login.
        NSMutableString *urlString = [[NSMutableString alloc] init];
        [urlString appendString:kBASE_URL_MOBITRAINER];
        [urlString appendString:@"api/appconfig"];
		 
        // Realiza o POST das informações e aguarda o retorno.
       AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
			[manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
			NSString *path=[[NSString alloc]initWithFormat:@"%@",urlString];
			[manager POST:[NSURL URLWithString:path].absoluteString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
            if (![[responseObject objectForKey:@"response_error"] boolValue])
            {
                // Pega os dados do JSON.
                NSDictionary *dataBlog = [responseObject objectForKey:@"appconfig_blog"];
					
                // Se existirem dados a serem verificados.
                if ([dataBlog count] > 0)
                {
                    LastUpdates *lastUpdate = (LastUpdates *) [coreDataService getDataFromLastUpdatesTable];
						 
                    [coreDataService dropBlogTable];
						 
                    Blog *appBlog = (Blog *) [NSEntityDescription insertNewObjectForEntityForName:@"Blog"
                                                                           inManagedObjectContext:coreDataService.getManagedContext];
						 
                    appBlog.blogURL = [utils checkString:[dataBlog objectForKey:@"blog_url"]];
                    appBlog.hasBlog = [NSNumber numberWithBool: [[utils checkString:[dataBlog objectForKey:@"blog_has"]] boolValue]];
						  //appBlog.hasBlog = [dataBlog objectForKey:@"blog_has"];
      
                    if ([utils checkString:uCheck.blogLastUpdate].length == 0)
                    {
                        lastUpdate.blog  = @"1970-01-01 00:00:00";
                    }
                    else
                    {
                        // Atualiza a data do ultimo update da tabela design...
                        lastUpdate.blog  = uCheck.blogLastUpdate;
                    }
						 
                    [coreDataService saveData];
						 
                    [self updateTrainerInfoWithDatesToCheck:uCheck];
                }
                else
                {
                    // ATUALIZA A DATA, PARA EVITAR PROBLEMAS DE GERAÇÃO DE ATUALIZAÇÃO EM LOOP.
                    LastUpdates *lastUpdate = (LastUpdates *) [coreDataService getDataFromLastUpdatesTable];
						 
                    // ATUALIZA A TABELA COM A DATA ATUAL (NOW)
						 
                    NSDate *today = [NSDate date];
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSString *dateString = [dateFormat stringFromDate:today];
						 
                    lastUpdate.blog = dateString;
						 
                    [coreDataService saveData];
						 
                    [self updateTrainerInfoWithDatesToCheck:uCheck];
                }
            }
			  
        } failure:^(NSURLSessionTask *operation, NSError *error) {
			  
            NSLog(@"Error: %@", error);
			  
            dispatch_async(dispatch_get_main_queue(), ^{
					
                [SVProgressHUD dismiss];
            });
			   [self.tableView.refreshControl endRefreshing];
            [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                              AndText:kTEXT_SERVER_ERROR_DEFAULT
                          AndTargetVC:self];
        }];
    }
    else
    {
        [self updateTrainerInfoWithDatesToCheck:uCheck];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)updateTrainerInfoWithDatesToCheck:(UpdateCheck *)uCheck
{
    LastUpdates *lastUpdate = (LastUpdates *) [coreDataService getDataFromLastUpdatesTable];
	
    if (![lastUpdate.trainerInfo isEqualToString:uCheck.trainerInfoLastUpdate])
    {
		 
        // Cria um operation manager para realizar a solicitação via POST.
   //     AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	//	  [manager.requestSerializer setTimeoutInterval:AFHHTTP_TIMEOUT];
        // Parametros validados.
        NSDictionary *parameters = @{@"apikey": API_KEY_TRAINER, @"filter": @"trainerinfo"};
		 
        // Monta a string de acesso a validação do login.
        NSMutableString *urlString = [[NSMutableString alloc] init];
        [urlString appendString:kBASE_URL_MOBITRAINER];
        [urlString appendString:@"api/appconfig"];
		 
        // Realiza o POST das informações e aguarda o retorno.
       AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
			[manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
			NSString *path=[[NSString alloc]initWithFormat:@"%@",urlString];
			[manager POST:[NSURL URLWithString:path].absoluteString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
            if (![[responseObject objectForKey:@"response_error"] boolValue])
            {
                // Pega os dados do JSON.
                NSDictionary *dataTrainerInfo = [responseObject objectForKey:@"appconfig_trainerinfo"];
					
                // Se existirem dados a serem verificados.
                if ([dataTrainerInfo count] > 0)
                {
                    LastUpdates *lastUpdate = (LastUpdates *) [coreDataService getDataFromLastUpdatesTable];
						 
                    // Apaga a tabela.
                    [coreDataService dropTrainerInfoTable];
						 
                    TrainerInfo *appTrainerInfo = (TrainerInfo *) [NSEntityDescription insertNewObjectForEntityForName:@"TrainerInfo"
                                                                                                inManagedObjectContext:coreDataService.getManagedContext];
						 
                    appTrainerInfo.firstName = [utils checkString:[dataTrainerInfo objectForKey:@"trainerinfo_name"]];
                    appTrainerInfo.lastName = [utils checkString:[dataTrainerInfo objectForKey:@"trainerinfo_lastname"]];
                    appTrainerInfo.email = [utils checkString:[dataTrainerInfo objectForKey:@"trainerinfo_email"]];
                    appTrainerInfo.gender = [utils checkString:[dataTrainerInfo objectForKey:@"trainerinfo_gender"]];
                    appTrainerInfo.birthday = [utils checkString:[dataTrainerInfo objectForKey:@"trainerinfo_birthday"]];
                    appTrainerInfo.image = [utils checkString:[dataTrainerInfo objectForKey:@"trainerinfo_image"]];
                    appTrainerInfo.website = [utils checkString:[dataTrainerInfo objectForKey:@"trainerinfo_website"]];
                    appTrainerInfo.facebook = [utils checkString:[dataTrainerInfo objectForKey:@"trainerinfo_facebook"]];
                    appTrainerInfo.twitter = [utils checkString:[dataTrainerInfo objectForKey:@"trainerinfo_twitter"]];
                    appTrainerInfo.phone = [utils checkString:[dataTrainerInfo objectForKey:@"trainerinfo_phone"]];
                    appTrainerInfo.biography = [utils checkString:[dataTrainerInfo objectForKey:@"trainerinfo_biography"]];
                    appTrainerInfo.cnpj = [utils checkString:[dataTrainerInfo objectForKey:@"trainerinfo_cnpj"]];
                    appTrainerInfo.cref = [utils checkString:[dataTrainerInfo objectForKey:@"trainerinfo_cref"]];
						 
                    // Apaga a imagem de perfil do treinador para força a atualização
                    NSMutableString *filenameImage = [[NSMutableString alloc] init];
                    [filenameImage appendString:@"/Caches/ProfileImages/"];
                    [filenameImage appendString:[NSString stringWithFormat:@"%@",[utils md5HexDigest:appTrainerInfo.image]]];
                    [filenameImage appendString:@".png"];
						 
                    NSString* pathImage = [[utils returnDocumentsPath] stringByAppendingPathComponent:filenameImage];
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    [fileManager removeItemAtPath:pathImage error:NULL];
						 
                    if ([utils checkString:uCheck.trainerInfoLastUpdate].length == 0)
                    {
                        lastUpdate.trainerInfo = @"1970-01-01 00:00:00";
                    }
                    else
                    {
                        lastUpdate.trainerInfo = uCheck.trainerInfoLastUpdate;
                    }
						 
                    [coreDataService saveData];
						 
						 
                }
                else
                {
                    // ATUALIZA A DATA, PARA EVITAR PROBLEMAS DE GERAÇÃO DE ATUALIZAÇÃO EM LOOP.
                    LastUpdates *lastUpdate = (LastUpdates *) [coreDataService getDataFromLastUpdatesTable];
						 
                    // ATUALIZA A TABELA COM A DATA ATUAL (NOW)
						 
                    NSDate *today = [NSDate date];
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSString *dateString = [dateFormat stringFromDate:today];
						 
                    lastUpdate.trainerInfo = dateString;
						 
                    [coreDataService saveData];
						 
						 
                }
            }
			  
        } failure:^(NSURLSessionTask *operation, NSError *error) {
			  
            NSLog(@"Error: %@", error);
			  
            dispatch_async(dispatch_get_main_queue(), ^{
					
                [SVProgressHUD dismiss];
            });
			   [self.tableView.refreshControl endRefreshing];
            [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                              AndText:kTEXT_SERVER_ERROR_DEFAULT
                          AndTargetVC:self];
        }];
    }
    
}




////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - TIMER METHODS

- (void)checkUpdateStatus
{
	
    // VERIFICA SE TEM CONEXÃO COM A INTERNET.
    BOOL flagInternetStatus = [IMManager sharedManager].hasConnection;
	
    if (flagInternetStatus)
    {		 
            NSLog(@"HOME VC: Checking update...");

            // Cria um operation manager para realizar a solicitação via POST.
 //           AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//			   [manager.requestSerializer setTimeoutInterval:AFHHTTP_TIMEOUT];
            // Parametros validados.
            NSDictionary *parameters = @{@"apikey": API_KEY_TRAINER};
			  
            // Monta a string de acesso a validação do login.
            NSMutableString *urlString = [[NSMutableString alloc] init];
            [urlString appendString:kBASE_URL_MOBITRAINER];
            [urlString appendString:@"api/update"];
			  
            // Realiza o POST das informações e aguarda o retorno.
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
			[manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
			NSString *path=[[NSString alloc]initWithFormat:@"%@",urlString];
			[manager POST:[NSURL URLWithString:path].absoluteString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
                if (![[responseObject objectForKey:@"response_error"] boolValue])
                {
                    // Pega os dados do JSON.
                    NSDictionary *dataUpdate = [responseObject objectForKey:@"response_update"];
						 
                    // Se existirem dados a serem verificados.
                    if ([dataUpdate count] > 0)
                    {
                        // Salva os dados de update do servidor para comparar.
                        UpdateCheck* uCheck = [[UpdateCheck alloc] init];
                        uCheck.designLastUpdate = [dataUpdate objectForKey:@"design"];
                        uCheck.blogLastUpdate = [dataUpdate objectForKey:@"blog"];
                        uCheck.trainerInfoLastUpdate = [dataUpdate objectForKey:@"trainerinfo"];
                        uCheck.featuredImagesLastUpdate = [dataUpdate objectForKey:@"promotion"];
                        uCheck.trainingLastUpdate = [dataUpdate objectForKey:@"training"];
                        uCheck.traineeLastUpdate = [dataUpdate objectForKey:@"trainee"];
                        uCheck.radioLastUpdate = [dataUpdate objectForKey:@"radio"];
                        uCheck.chatLastUpdate = [dataUpdate objectForKey:@"chat"];
                        uCheck.userProfileLastUpdate = [dataUpdate objectForKey:@"profile"];
							  
                        // Recupera os dados de update salvo na base de dados.
                        LastUpdates *lastUpdate = (LastUpdates *) [coreDataService getDataFromLastUpdatesTable];
							  
                        ///////////////////////////////////////////////////////////////////////
                        /// ATUALIZAÇÃO DE DESTAQUES E FEITA DE FORMA SILENCIOSA //////////////
                        ///////////////////////////////////////////////////////////////////////
							  
                        NSLog(@"IMAGE LOCAL DATE:%@",lastUpdate.featuredImages);
                        NSLog(@"IMAGE SERVER DATE:%@ \n\n",uCheck.featuredImagesLastUpdate);
							  
                        // Verifica se tem atualização das imagens de destaque.
                        if (![lastUpdate.featuredImages isEqualToString:uCheck.featuredImagesLastUpdate] && uCheck.featuredImagesLastUpdate.length > 0)
                        {
                            [self updateFeaturedImagesTableWithDatesToCheck:uCheck];
                        }
							  
                        ///////////////////////////////////////////////////////////////////////
                        /// VERIFICA SE AS TABELAS PRECISAM DE ATUALIZAÇÃO ////////////////////
                        ///////////////////////////////////////////////////////////////////////
							  
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
							  
                        ////////////////////////////////////////
                        /// DESIGN CHECK DATE //////////////////
                        ////////////////////////////////////////
							  
                        NSLog(@"LOCAL DESIGN DATE:%@",lastUpdate.design);
                        NSLog(@"SERVER DESIGN DATE:%@",uCheck.designLastUpdate);
							  
                        NSDate *serverDesignLastUpdate = [dateFormatter dateFromString:uCheck.designLastUpdate];
                        NSDate *localDesignLastUpdate = [dateFormatter dateFromString:lastUpdate.design];
                        NSInteger statusDesign = [utils compareDatesServer:serverDesignLastUpdate AndLocal:localDesignLastUpdate];
							  
                        ////////////////////////////////////////
                        /// BLOG CHECK DATE ////////////////////
                        ////////////////////////////////////////
							  
                        NSLog(@"LOCAL BLOG DATE:%@",lastUpdate.blog);
                        NSLog(@"SERVER BLOG DATE:%@",uCheck.blogLastUpdate);
							  
                        NSDate *serverBlogLastUpdate = [dateFormatter dateFromString:uCheck.blogLastUpdate];
                        NSDate *localBlogLastUpdate = [dateFormatter dateFromString:lastUpdate.blog];
                        NSInteger statusBlog = [utils compareDatesServer:serverBlogLastUpdate AndLocal:localBlogLastUpdate];
							  
                        ////////////////////////////////////////
                        /// TRAINER INFO CHECK DATE ////////////
                        ////////////////////////////////////////
							  
                        NSLog(@"LOCAL TRAINERINFO DATE:%@",lastUpdate.trainerInfo);
                        NSLog(@"SERVER TRAINERINFO DATE:%@",uCheck.trainerInfoLastUpdate);
							  
                        NSDate *serverTrainerInfoLastUpdate = [dateFormatter dateFromString:uCheck.trainerInfoLastUpdate];
                        NSDate *localTrainerInfoLastUpdate = [dateFormatter dateFromString:lastUpdate.trainerInfo];
                        NSInteger statusTrainerInfo = [utils compareDatesServer:serverTrainerInfoLastUpdate AndLocal:localTrainerInfoLastUpdate];
							  
                        ////////////////////////////////////////
                        /// USER PROFILE CHECK DATE ////////////
                        ////////////////////////////////////////
							  
                        NSLog(@"LOCAL USER PROFILE DATE:%@",lastUpdate.userProfile);
                        NSLog(@"SERVER USER PROFILE DATE:%@",uCheck.userProfileLastUpdate);
							  
							  
                        if (statusDesign == NEED_UPDATE || statusBlog == NEED_UPDATE || statusTrainerInfo == NEED_UPDATE)
                        {
                            flagUpdate = FALSE;
									 [self startUpdateProcess];
                            NSLog(@"NECESSITA ATUALIZAR!");
									
                        }
                        else
                        {
                            flagUpdate = TRUE;
									
                            NSLog(@"HOME VC: NÃO NECESSITA ATUALIZAR!");
                        }
                    }
                }
					
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                NSLog(@"Error Servidor Update");
                flagUpdate = TRUE;
					
            }];
		 
    }
   
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)updateFeaturedImagesTableWithDatesToCheck:(UpdateCheck *)uCheck
{

#if 1
	
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	
    // Cria um operation manager para realizar a solicitação via POST.
   // AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	// [manager.requestSerializer setTimeoutInterval:AFHHTTP_TIMEOUT];
    // Parametros validados.
    NSDictionary *parameters = @{@"apikey": API_KEY_TRAINER, @"filter": @"promotion"};
	
    // Monta a string de acesso a validação do login.
    NSMutableString *urlString = [[NSMutableString alloc] init];
    [urlString appendString:kBASE_URL_MOBITRAINER];
    [urlString appendString:@"api/appconfig"];
	
	
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
			[manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
			NSString *path=[[NSString alloc]initWithFormat:@"%@",urlString];
			[manager POST:[NSURL URLWithString:path].absoluteString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
         
    // Realiza o POST das informações e aguarda o retorno.
  //  [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		 
        if (![[responseObject objectForKey:@"response_error"] boolValue])
        {
            // Pega os dados do JSON.
            NSDictionary *dataFeaturedImages = [responseObject objectForKey:@"appconfig_promotion"];
			  
            // Se existirem dados a serem verificados.
            if ([dataFeaturedImages count] > 0)
            {
                // Pega os dados da tabela.
                NSArray *arrayFeaturedImages = [coreDataService getDataFromFeaturedImagesTable];
                FeaturedImages *appFeaturedImages = (FeaturedImages *) [arrayFeaturedImages objectAtIndex:0];
					
                LastUpdates *lastUpdate = (LastUpdates *) [coreDataService getDataFromLastUpdatesTable];
					
                [coreDataService dropFeaturedImagesTable];
					
                ////////////////////////////////////////////////////////////////////
                // Apaga o conteudo da pasta Features Images. //////////////////////
                ////////////////////////////////////////////////////////////////////
					
                NSString *directoryFImages = [[utils returnDocumentsPath] stringByAppendingPathComponent:@"/Caches/FeaturedImages"];
					
                NSFileManager *fm = [NSFileManager defaultManager];
                NSError *error = nil;
					
                for (NSString *file in [fm contentsOfDirectoryAtPath:directoryFImages error:&error])
                {
                    BOOL success = [fm removeItemAtPath:[NSString stringWithFormat:@"%@/%@", directoryFImages, file] error:&error];
						 
                    if (!success || error)
                    {
                        // it failed.
                        NSLog(@"ERRO AO DELETAR A PASTA FEATURED IMAGES");
                    }
                }
					
                NSArray *arrayImagesURL = [dataFeaturedImages objectForKey:@"promotion_images"];
                NSInteger imageCount = [arrayImagesURL count];
					
                appFeaturedImages = nil;
					
                appFeaturedImages = (FeaturedImages *) [NSEntityDescription insertNewObjectForEntityForName:@"FeaturedImages"
                                                                                     inManagedObjectContext:coreDataService.getManagedContext];
					
                appFeaturedImages.imagesCount = [NSNumber numberWithInteger:imageCount];
                appFeaturedImages.isVerified = [NSNumber numberWithBool:NO];
					
                // Atualiza a data do ultimo update da tabela design...
                lastUpdate.featuredImages = uCheck.featuredImagesLastUpdate;
					
                [coreDataService saveData];
					
                __block NSInteger count = 0;
					
                NSFileManager *fileManager = [NSFileManager defaultManager];
					
                //RFR: Apaga todas as imagens
                NSString *directory = [[utils returnDocumentsPath] stringByAppendingPathComponent:@"/Caches/FeaturedImages/"];
					
                for (NSString *file in [fileManager contentsOfDirectoryAtPath:directory error:&error]) {
                    BOOL success = [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@", directory, file] error:&error];
                    if (!success || error) {
                        // it failed.
                    }
                }
					
                //RFR
                if(imageCount == 0)
                {
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    [self loadImagensFromCacheFolder];
                }
					
                // Realiza o download das imagens
                for (NSInteger i = 0; i < imageCount; i++)
                {
                    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[arrayImagesURL objectAtIndex:i]]
                                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                       timeoutInterval:60.0];
						 
              //      AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
              //   requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
						 
               //  [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
							  
							  
	//		AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
 	//		[manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
 	//		NSString *path=[[NSString alloc]initWithFormat:@"%@",urlString];
 	//		[manager POST:[NSURL URLWithString:path].absoluteString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
      
      
   #if 0
			NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
			AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

	//		NSURL *URL = [NSURL URLWithString:urlString];
	//		NSURLRequest *request = [NSURLRequest requestWithURL:URL];

			NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
			NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
			return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
			
			
			
			} completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
			NSLog(@"File downloaded to: %@", filePath);
	#endif
			
			NSString *str = [arrayImagesURL objectAtIndex:i] ;

			NSString* encodedUrl = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
			//NSURL *URL = [NSURL URLWithString:urlString];
			//NSURLRequest *request = [NSURLRequest requestWithURL:URL];
			NSURL *url = [NSURL URLWithString:encodedUrl];
			NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession]
                                          dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
			{
				UIImage *image = [UIImage imageWithData:data];

			
			
			
			
			
			
							  
                        NSMutableString *path = [[NSMutableString alloc]init];
							  
                        NSInteger x = i + 1;
							  
                        NSString *name = [@(x) stringValue];
							  
                        [path appendString:[[utils returnDocumentsPath] stringByAppendingPathComponent:@"/Caches/FeaturedImagesTemp/d"]];
                        [path appendString:[NSString stringWithFormat:@"%@",name]];
                        [path appendString:@".png"];
							  
                        NSFileManager *fileManager = [NSFileManager defaultManager];
                     //   NSError *error;
							  
                        // Se já existir a imagem, apaga para escrever novamente
                        if ([fileManager fileExistsAtPath:path] == YES)
                        {
                            [fileManager removeItemAtPath:path error:&error];
                        }
							  
                        NSData *imageData = UIImagePNGRepresentation(image);
                        [imageData writeToFile:path atomically:YES];
							  
                        count = count + 1;
							  
                        if (count == imageCount)
                        {
									
                            for (NSInteger i = 1; i <= count; i++)
                            {
                                NSMutableString *fileFromPath = [[NSMutableString alloc] init];
                                [fileFromPath appendString:[[utils returnDocumentsPath] stringByAppendingPathComponent:@"/Caches/FeaturedImagesTemp/d"]];
                                [fileFromPath appendString:[NSString stringWithFormat:@"%ld",(long)i]];
                                [fileFromPath appendString:@".png"];
										 
                                NSMutableString *fileToPath = [[NSMutableString alloc] init];
                                [fileToPath appendString:[[utils returnDocumentsPath] stringByAppendingPathComponent:@"/Caches/FeaturedImages/d"]];
                                [fileToPath appendString:[NSString stringWithFormat:@"%ld",(long)i]];
                                [fileToPath appendString:@".png"];
										 
                                [fileManager copyItemAtPath:fileFromPath toPath:fileToPath error:&error];
                            }
									
                            NSArray *array = [utils pngFilesInFeaturedImagesFolder];
									
                            // Faz o check para validar se todas as imagens foram baixadas corretamente.
                            if ([array count] == imageCount)
                            {
                                ////////////////////////////////////////////////////////////////////
                                // Apaga o conteudo da pasta Features Images Temp //////////////////
                                ////////////////////////////////////////////////////////////////////
										 
                                NSString *directoryFImages = [[utils returnDocumentsPath] stringByAppendingPathComponent:@"/Caches/FeaturedImagesTemp"];
										 
                                NSFileManager *fm = [NSFileManager defaultManager];
                                NSError *error = nil;
										 
                                for (NSString *file in [fm contentsOfDirectoryAtPath:directoryFImages error:&error])
                                {
                                    BOOL success = [fm removeItemAtPath:[NSString stringWithFormat:@"%@/%@", directoryFImages, file] error:&error];
											  
                                    if (!success || error)
                                    {
                                        // it failed.
                                        NSLog(@"ERRO AO DELETAR A PASTA FEATURED IMAGES");
                                    }
                                }
										 
                                NSFetchRequest *fetchRequestPromotion = [NSFetchRequest fetchRequestWithEntityName:@"FeaturedImages"];
                                NSMutableArray *mutableFetchResultsPromotion = [[coreDataService.getManagedContext executeFetchRequest:fetchRequestPromotion
                                                                                                                                 error:&error] mutableCopy];
										 
                                if ([mutableFetchResultsPromotion count] > 0)
                                {
                                    FeaturedImages *appFeaturedImages = (FeaturedImages *) [mutableFetchResultsPromotion objectAtIndex:0];
                                    appFeaturedImages.isVerified = [NSNumber numberWithBool:YES];
											  
                                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
											  
                                    [coreDataService saveData];
                                }
                            }
                        }
							  
                        //RFR
                        double delayInSeconds = 0.5;
                        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
									
                            [self loadImagensFromCacheFolder];
									
                        });
							  
							  
                    }];
								[downloadTask resume];
                }
            }
        }
		 
    } failure:^(NSURLSessionTask *operation, NSError *error)
 	{
        NSLog(@"Error: %@", error);
		 
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		  [self.tableView.refreshControl endRefreshing];
        [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                          AndText:kTEXT_SERVER_ERROR_DEFAULT
                      AndTargetVC:self];
    }];
}
#endif


//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
//
//- (void)setFlagUpdate:(NSTimer *)timer
//{
//    flagUpdate = TRUE;
//	
//    // Seta o timer para verificar o update.
//    self.timerCheckUpdate = [NSTimer scheduledTimerWithTimeInterval:kCHECK_UPDATE_TIMER
//                                                             target:self
//                                                           selector:@selector(checkUpdateStatus:)
//                                                           userInfo:nil
//                                                            repeats:YES];
//}


- (void)getBlogURL
{
	
	// Cria um operation manager para realizar a solicitação via POST.
//  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//	[manager.requestSerializer setTimeoutInterval:AFHHTTP_TIMEOUT];
  // Parametros validados.
  NSDictionary *parameters = @{@"apikey": API_KEY_TRAINER, @"filter": @"blog"};
	
  // Monta a string de acesso a validação do login.
  NSMutableString *urlString = [[NSMutableString alloc] init];
  [urlString appendString:kBASE_URL_MOBITRAINER];
  [urlString appendString:@"api/appconfig"];
	
  // Realiza o POST das informações e aguarda o retorno.
   AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
			[manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
			NSString *path=[[NSString alloc]initWithFormat:@"%@",urlString];
			[manager POST:[NSURL URLWithString:path].absoluteString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
    
		if (![[responseObject objectForKey:@"response_error"] boolValue])
		{
			 // Pega os dados do JSON.
			 NSDictionary *dataBlog = [responseObject objectForKey:@"appconfig_blog"];
			
			 // Se existirem dados a serem verificados.
			 if ([dataBlog count] > 0)
			 {
				  LastUpdates *lastUpdate = (LastUpdates *) [coreDataService getDataFromLastUpdatesTable];
				 
				  [coreDataService dropBlogTable];
				 
				  Blog *appBlog = (Blog *) [NSEntityDescription insertNewObjectForEntityForName:@"Blog"
																							inManagedObjectContext:coreDataService.getManagedContext];
				 
				  appBlog.blogURL = [utils checkString:[dataBlog objectForKey:@"blog_url"]];
				  appBlog.hasBlog = [NSNumber numberWithBool: [[utils checkString:[dataBlog objectForKey:@"blog_has"]] boolValue]];
				
				 
				  // ATUALIZA A TABELA COM A DATA ATUAL (NOW)
				 
				  NSDate *today = [NSDate date];
				  NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
				  [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
				  NSString *dateString = [dateFormat stringFromDate:today];
				 
				  lastUpdate.blog = dateString;
				 
				  [coreDataService saveData];
				  if(appBlog.hasBlog && appBlog.blogURL!=nil)
				  {
				  		[self parseXMLFileAtURL];
				  		[arrayLocalFeeds removeAllObjects];
				  		arrayLocalFeeds = [coreDataService getDataFromBlogFeedsTable];
				  }
			}
		}
	  
  } failure:^(NSURLSessionTask *operation, NSError *error) {
	  
		NSLog(@"Error: %@", error);
	  
		dispatch_async(dispatch_get_main_queue(), ^{
			
			 [SVProgressHUD dismiss];
		});
	   [self.tableView.refreshControl endRefreshing];
//		[utils showAlertWithTitle:kTEXT_ALERT_TITLE
//								AndText:kTEXT_SERVER_ERROR_DEFAULT
//						  AndTargetVC:self];
  }];
	
}
@end

////////////////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

