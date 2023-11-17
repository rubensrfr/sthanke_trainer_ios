//
//  MensagensViewController.m
//  treino
//
//  Created by Reginaldo Lopes on 26/11/14.
//  Copyright (c) 2014 4mobi. All rights reserved.
//

#import "MensagensVC.h"

@interface MensagensVC()

@end

@implementation MensagensVC

@synthesize treineeID;
@synthesize timerCheckUpdate;

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - VIEW LIFECYCLE

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Inicializa o objeto utils.
    utils = [[UtilityClass alloc] init];
    
    // Inicializa o helper do Banco de dados.
    coreDataService = [[CoreDataService alloc] init];
    [coreDataService initialize];
    
    NSUserDefaults *Defaults = [NSUserDefaults standardUserDefaults];
	 [Defaults setInteger:0 forKey:@"UnreadCounter"];
	 [Defaults synchronize];
    
    // PEGA OS DADOS DO USUARIO.
    User *userData = (User *) [coreDataService getDataFromUserTable];
    
    // PEGA OS DADOS DO TREINADOR.
    TrainerInfo *trainer = [coreDataService getDataFromTrainerInfoTable];

    // CONFIGURA QUE Ë O SENDER.
    self.senderId = userData.userID;
    
    NSMutableString *fullName = [[NSMutableString alloc] init];
    [fullName appendString:userData.firstName];
    [fullName appendString:@" "];
    [fullName appendString:userData.lastName];
    
    self.senderDisplayName = fullName;

    // CONFIGURA O TAMANHO DOS AVATARES.
    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeMake(35, 35);
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeMake(35, 35);

    // NÃO DEIXA APARECER O ICONE DO LADO DIREITO DA INPUT BAR QUE APARECE POR PADRÃO.
    self.inputToolbar.contentView.leftBarButtonItem = nil;
    
    // INSERE UM ESPAÇO NO TOPO DA COLLECTION VIEW.
    self.topContentAdditionalInset = 10.0f;

    self.automaticallyScrollsToMostRecentMessage = YES;
    
	
    
    [self.inputToolbar.contentView.rightBarButtonItem setTitleColor:UIColorFromRGB(kPRIMARY_COLOR)
                                                           forState:UIControlStateNormal];

    // OBJETOS QUE IRÃO CONTER AS IMAGENS (AVATARES)
    JSQMessagesAvatarImage *alunoImage;
    JSQMessagesAvatarImage *personalImage;
    
    //////////////////////////////////////////////////////////////////////////////
    /// IMAGEM DO USUARIO LOGADO /////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    
    // CAMINHO PARA RECUPERAR A IMAGEM DO USUARIO.
    NSMutableString *pathImageUser = [[NSMutableString alloc] init];
    [pathImageUser appendString:[utils returnDocumentsPath]];
    [pathImageUser appendString:@"/Caches/ProfileImages/"];
    [pathImageUser appendString:[utils md5HexDigest:userData.image]];
    [pathImageUser appendString:@".png"];
    
    // VERIFICA SE A IMAGEM EXISTE NO CAMINHO ESPECIFICADO.
    BOOL imageUserExists = [[NSFileManager defaultManager] fileExistsAtPath:pathImageUser];
    
    // SE EXISTE CARREGA, SENÃO CARREGA A IMAGEM PADRÃO.
    if (imageUserExists)
    {
        UIImage *imageAluno = [UIImage imageWithContentsOfFile:pathImageUser];
        
        alunoImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:imageAluno
                                                                diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
    }
    else
    {
        // CARREGA O DEFAULT.
        alunoImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"Table_User_Default"]
                                                                diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
        
        // BAIXA A IMAGEM.
        [self dowloadImageWithURL:userData.image];
    }

    // CAMINHO PARA RECUPERAR A IMAGEM DO TREINADOR.
    NSMutableString *pathImagePersonal = [[NSMutableString alloc] init];
    [pathImagePersonal appendString:[utils returnDocumentsPath]];
    [pathImagePersonal appendString:@"/Caches/ProfileImages/"];

    // VERIFICA SE USUARIO OU TREINADOR / ACADEMIA.
    if([userData.level integerValue] == USER_LEVEL_TRAINEE) [pathImagePersonal appendString:[utils md5HexDigest:trainer.image]];
    else [pathImagePersonal appendString:[utils md5HexDigest:treineeID]];

    [pathImagePersonal appendString:@".png"];
    
    // VERIFICA SE A IMAGEM EXISTE NO CAMINHO ESPECIFICADO.
    BOOL imagePersonalExists = [[NSFileManager defaultManager] fileExistsAtPath:pathImagePersonal];
    
    // SE EXISTE CARREGA, SENÃO CARREGA A IMAGEM PADRÃO.
    if (imagePersonalExists)
    {
        UIImage *imagePersonal = [UIImage imageWithContentsOfFile:pathImagePersonal];
        
        personalImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:imagePersonal
                                                                   diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
    }
    else
    {
        personalImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"Table_User_Default"]
                                                                   diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
        
        // VERIFICA SE USUARIO OU TREINADOR / ACADEMIA.
        if([userData.level integerValue] == USER_LEVEL_TRAINEE) [self dowloadImageWithURL:trainer.image];
        else [self dowloadImageWithURL:treineeID];
    }
   
    // CONFIGURA AS IMAGENS QUE APARECEM DO LADO DO BALÃO.
    if ([userData.level integerValue] == USER_LEVEL_TRAINEE)
    {
        self.avatars = @{ userData.userID : alunoImage, userData.trainerID : personalImage };
    }
    else
    {
        self.avatars = @{ userData.userID : alunoImage, treineeID : personalImage };
    }
    
    // CONFIGURA A COR DOS BALÕES COM AS MENSAGENS.
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];

    self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:UIColorFromRGB(kPRIMARY_COLOR)];
    
    // INCIALIZA O ARRAY QUE IRA CONTER AS MENSAGENS.
    self.messages = [[NSMutableArray alloc] init];
    
    if ([userData.level integerValue] == USER_LEVEL_TRAINEE)
    {
        // CARREGA AS MENSAGENS DA BASE DE DADOS.
        [self loadMessagesFromDB:LOAD_BOTTOM];
    }
    else
    {
        // CARREGA AS MENSAGENS DA BASE DE DADOS.
        [self loadMessagesFromDBTrainer:LOAD_BOTTOM];
    }

    // CONFIGURA UM GESTURE RECOGNIZER PARA ESCONDER O TECLADO.
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.collectionView addGestureRecognizer:gestureRecognizer];
    
    // CONFIGURA OS OBSERVADORES.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(becomeActive:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(becomeInactive:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // LIMPA A VARIAVEL OFFSET.
    offset = 0;

    // DESATIVA O EFEITO.
    self.collectionView.collectionViewLayout.springinessEnabled = NO;

    // VERIFICA SE PRECISA MOSTRAR O BOTÃO DE CARREGAR MENSAGENS ANTERIORES.
    if(self.messages.count == 0) self.showLoadEarlierMessagesHeader = NO;
    else self.showLoadEarlierMessagesHeader = YES;
  
    // CONFIGURA O TIMER PARA VERIFICAR O UPDATE.
    self.timerCheckUpdate = [NSTimer scheduledTimerWithTimeInterval:3.0f
                                                             target:self
                                                           selector:@selector(checkUpdateStatus:)
                                                           userInfo:nil
                                                            repeats:YES];
    
    // DISPARA O TIMER, IMEDIATAMENTE.
    [self.timerCheckUpdate fire];
 
    dispatch_async(dispatch_get_main_queue(), ^{

        // VERIFICA SE PRECISA MOSTRAR O BOTÃO DE CARREGAR MENSAGENS ANTERIORES.
        if(self.messages.count == 0) self.showLoadEarlierMessagesHeader = NO;
        else self.showLoadEarlierMessagesHeader = YES;
    });
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // VERIFICA SE PRECISA MOSTRAR A MENSAGEM.
    if (self.messages.count == 0)
    {
        [self showNoDataMessage];
    }
    else
    {
        [self hideNoDataMessage];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];

    // PEGA OS DADOS DO USUARIO.
    User *userData = (User *) [coreDataService getDataFromUserTable];
    
    if ([userData.level integerValue] == USER_LEVEL_TRAINER || [userData.level integerValue] == USER_LEVEL_MASTERTRAINER ||
        [userData.level integerValue] == USER_LEVEL_ADMINISTRATOR)
    {
        // PARA O TIMER.
        [self.timerCheckUpdate invalidate];

        PersonalTreinees *pt = [coreDataService getDataFromPersonalTreineesTableByTreineeID:treineeID];
        pt.unreadMessages = [NSNumber numberWithInt:0];
        [coreDataService saveData];
    }
    [self.timerCheckUpdate invalidate];
	
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)dealloc
{
    // REMOVE OS OBSERVADORES.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
    
 
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

#pragma mark - JSQM VIEWCONTROLLER METHODS OVERRIDES

- (void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date
{
    button.enabled = NO;
    
    // VERIFICA SE TEM CONEXÃO COM A INTERNET.
    BOOL flagInternetStatus = [IMManager sharedManager].hasConnection;
    
    // SE TEM CONEXÃO
    if (flagInternetStatus)
    {
        // PEGA OS DADOS DO USUARIO...
        User *userData = (User *) [coreDataService getDataFromUserTable];
        
        // INICIALIZA O LOADER NA STATUSBAR.
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        // CRIA UM OPERATION MANAGER PARA REALIZAR A SOLICITAÇÃO VIA POST.
     //   AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
     //   [manager.requestSerializer setTimeoutInterval:AFHHTTP_TIMEOUT];
        NSDictionary *parameters;
   
        // VERIFICA SE É USUARIO OU TREINADOR / ACADEMIA.
        if ([userData.level integerValue] == USER_LEVEL_TRAINEE)
        {
            parameters = @{@"apikey":userData.apiKey, @"message":[utils createStringCodeFromEmoji:text], @"method":@"SET"};
        }
        else
        {
            parameters = @{@"apikey":userData.apiKey, @"message":text, @"user_id":treineeID, @"method":@"SET"};
        }
        
        // MONTA A STRING DE ACESSO A VALIDAÇÃO DO LOGIN.
        NSMutableString *urlString = [[NSMutableString alloc] init];
        [urlString appendString:kBASE_URL_MOBITRAINER];
        [urlString appendString:@"api/message"];
        
        // REALIZA O POST DAS INFORMAÇÕES E AGUARDA O RETORNO.
       // [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
			[manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
			NSString *path=[[NSString alloc]initWithFormat:@"%@",urlString];
			[manager POST:[NSURL URLWithString:path].absoluteString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
          {
            // SE NÃO RETORNOU ERRO.
            if (![[responseObject objectForKey:@"response_error"] boolValue])
            {
                // PARA O LOADER NA STATUSBAR.
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
 
                // FORMATA A DATA RECEBIDA PELO SERVIDOR.
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
                [dateFormatter setTimeZone:gmt];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *dateFromString = [[NSDate alloc] init];
                dateFromString = [dateFormatter dateFromString:[responseObject objectForKey:@"date"]];
                
                // CRIA O OBJETO MENSAGEM.
                JSQMessage *message = [[JSQMessage alloc] initWithSenderId:senderId
                                                         senderDisplayName:senderDisplayName
                                                                      date:dateFromString
                                                                      text:text];
                // ADICIONA AO ARRAY.
                [self.messages addObject:message];
                
                // VERIFICA SE PRECISA REMOVER A MENSAGEM.
                if (self.messages.count > 0)
                {
                    [self hideNoDataMessage];
                }
                
                // FINALIZA O ENVIO DA MENSAGEM.
                [self finishSendingMessageAnimated:YES];
                
                // TOCA O SOM PARA INDICAR QUE A MENSAGEM FOI ENVIADA.
                [JSQSystemSoundPlayer jsq_playMessageSentSound];
                
                button.enabled = YES;
                
                // CRIA UM OBJETO PARA ADICIONAR A MENSAGEM NA BASE DE DADOS.
                Messages *m = (Messages *)[NSEntityDescription insertNewObjectForEntityForName:@"Messages"
                                                                        inManagedObjectContext:coreDataService.getManagedContext];
                
                m.name = senderDisplayName;
                m.senderID = userData.userID;
                m.messageID = @"0";
                
                if ([userData.level integerValue] == USER_LEVEL_TRAINEE) m.receiverID = userData.trainerID;
                else m.receiverID = treineeID;
                
                m.message = text;
                m.created = dateFromString;
                m.isSync = [NSNumber numberWithBool:YES];
                
                [coreDataService saveData];
                
                // VERIFICA SE PRECISA MOSTRAR O BOTÃO DE CARREGAR MENSAGENS ANTERIORES.
                if(self.messages.count == 0) self.showLoadEarlierMessagesHeader = NO;
                else self.showLoadEarlierMessagesHeader = YES;
            }
            
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            
            button.enabled = YES;
            
            // PARA O LOADER NA STATUSBAR.
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            NSLog(@"Error: %@", error);
            
            [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                              AndText:@"Não foi possível entregar sua mensagem neste momento. Tente novamente mais tarde!"
                          AndTargetVC:self];
        }];
    }
    else
    {
        [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                          AndText:kTEXT_INTERNET_ERROR_DEFAULT
                      AndTargetVC:self];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - JSQM COLLECTION VIEW DATA SOURCE

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.messages objectAtIndex:indexPath.item];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId])
    {
        return self.outgoingBubbleImageData;
    }
    
    return self.incomingBubbleImageData;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    
    return [self.avatars objectForKey:message.senderId];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item % 3 == 0)
    {
        JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    
    return nil;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    
    /**
     *  iOS7-style sender name labels
     */
    if ([message.senderId isEqualToString:self.senderId])
    {
        return nil;
    }
    
    if (indexPath.item - 1 > 0)
    {
        JSQMessage *previousMessage = [self.messages objectAtIndex:indexPath.item - 1];
        
        if ([[previousMessage senderId] isEqualToString:message.senderId])
        {
            return nil;
        }
    }

    return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - JSQM COLLECTION VIEW FLOW LAYOUT DELEGATE

// Adjusting cell label heights
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item % 3 == 0)
    {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    return 0.0f;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  iOS7-style sender name labels
     */
    JSQMessage *currentMessage = [self.messages objectAtIndex:indexPath.item];
    if ([[currentMessage senderId] isEqualToString:self.senderId])
    {
        return 0.0f;
    }
    
    if (indexPath.item - 1 > 0)
    {
        JSQMessage *previousMessage = [self.messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:[currentMessage senderId]])
        {
            return 0.0f;
        }
    }
    
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.0f;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (UICollectionReusableView *)collectionView:(JSQMessagesCollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    if (self.showLoadEarlierMessagesHeader && [kind isEqualToString:UICollectionElementKindSectionHeader]) {
        JSQMessagesLoadEarlierHeaderView *header = [collectionView dequeueLoadEarlierMessagesViewHeaderForIndexPath:indexPath];
        
       

        // Customize header
        
        [header.loadButton setTitleColor:UIColorFromRGB(kPRIMARY_COLOR)
                                forState:UIControlStateNormal];
        
        [header.loadButton setTitle:@"CARREGAR MENSAGENS ANTERIORES"
                           forState:UIControlStateNormal];
        
        header.loadButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        return header;
    }
    
    return [super collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - UICOLLECTION DATA SOURCE

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.messages count];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Override point for customizing cells
     */
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];

    JSQMessage *msg = [self.messages objectAtIndex:indexPath.item];
    
    if (!msg.isMediaMessage)
    {
        if ([msg.senderId isEqualToString:self.senderId])
        {
            cell.textView.textColor = [UIColor blackColor];
        }
        else
        {
            cell.textView.textColor = [UIColor whiteColor];
        }
        
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    
    return cell;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - COLLECTION VIEW TAP EVENTS

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
    NSLog(@"Load earlier messages!");
    
    // Pega os dados do usuário...
    User *userData = (User *) [coreDataService getDataFromUserTable];
    
    NSArray *arrayAll;
    
    if ([userData.level integerValue] == USER_LEVEL_TRAINEE)
    {
        arrayAll = [coreDataService getDataFromMessageTableWithUserID:userData.userID
                                                            TrainerID:userData.trainerID];
    }
    else
    {
        arrayAll = [coreDataService getDataFromMessageTableWithUserID:userData.userID
                                                            TrainerID:treineeID];
    }
    
    NSInteger totalMensagens = arrayAll.count;
    
    if (offset < totalMensagens)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.showLoadEarlierMessagesHeader = YES;
        });
        
        offset = offset + 10;
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.showLoadEarlierMessagesHeader = NO;
        });
        offset = totalMensagens;
    }
    
    if ([userData.level integerValue] == USER_LEVEL_TRAINEE)
    {
        // CARREGA AS MENSAGENS DA BASE DE DADOS.
        [self loadMessagesFromDB:LOAD_TOP];
    }
    else
    {
        // CARREGA AS MENSAGENS DA BASE DE DADOS.
        [self loadMessagesFromDBTrainer:LOAD_TOP];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped avatar!");
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
{
    [self.inputToolbar.contentView.textView resignFirstResponder];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation
{
    [self.inputToolbar.contentView.textView resignFirstResponder];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - CUSTOM METHODS

- (void)hideKeyboard
{
    [self.view endEditing:YES];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)loadMessagesFromDB:(NSInteger)status
{
    // Pega os dados do usuário...
    User *userData = (User *) [coreDataService getDataFromUserTable];
    
    NSArray *arrayAll = [coreDataService getDataFromMessageTableWithUserID:userData.userID
                                                                 TrainerID:userData.trainerID];
    
    NSInteger totalMensagens = arrayAll.count;

    if (offset < totalMensagens)
    {
        NSArray *copy = [[NSArray alloc]initWithArray:self.messages];
        
        [self.messages removeAllObjects];
        
        for (NSInteger i = 0; i < arrayAll.count; i++)
        {
            Messages *m = (Messages *) [arrayAll objectAtIndex:i];

            [self.messages addObject:[[JSQMessage alloc] initWithSenderId:m.senderID
                                                        senderDisplayName:m.name
                                                                     date:m.created
                                                                     text:[utils createEmojiFromCodeString:m.message]]];
        }
        
        if (copy.count > 0)[self.messages addObjectsFromArray:copy];
        
        [self.messages sortUsingDescriptors:[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"date"
                                                                                                    ascending:YES], nil]];
        
        // Verifica se precisa mostrar a mensagem.
        if (self.messages.count == 0)
        {
            [self showNoDataMessage];
        }
        else
        {
            [self hideNoDataMessage];
        }
    }
    
    // VERIFICA SE PRECISA MOSTRAR O BOTÃO DE CARREGAR MENSAGENS ANTERIORES.
    if(self.messages.count == 0) self.showLoadEarlierMessagesHeader = NO;
    else self.showLoadEarlierMessagesHeader = YES;

    [self.collectionView reloadData];
    
    if(self.messages.count > 0)
    {
        NSInteger section = [self.collectionView numberOfSections] - 1 ;
        NSInteger item = [self.collectionView numberOfItemsInSection:section] - 1 ;
        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:item inSection:section] ;
        [self.collectionView scrollToItemAtIndexPath:lastIndexPath atScrollPosition:(UICollectionViewScrollPositionBottom) animated:YES];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)loadMessagesFromDBTrainer:(NSInteger)status
{
    // Pega os dados do usuário...
    User *userData = (User *) [coreDataService getDataFromUserTable];
    
    NSArray *arrayAll = [coreDataService getDataFromMessageTableWithUserID:userData.userID
                                                                 TrainerID:treineeID];
    
    NSInteger totalMensagens = arrayAll.count;
    
    if (offset < totalMensagens)
    {
        NSArray *copy = [[NSArray alloc] initWithArray:self.messages];
        
        [self.messages removeAllObjects];

        NSInteger limit = 10;
        NSInteger top = limit + offset;
        
        if (top > arrayAll.count)
        {
            top = arrayAll.count;
        }
        
        for (NSInteger i = offset; i < top; i++)
        {
            Messages *m = (Messages *) [arrayAll objectAtIndex:i];
 
            [self.messages addObject:[[JSQMessage alloc] initWithSenderId:m.senderID
                                                        senderDisplayName:m.name
                                                                     date:m.created
                                                                     text:[utils createEmojiFromCodeString:m.message]]];
        }
        
        if (copy.count > 0) [self.messages addObjectsFromArray:copy];
        
        [self.messages sortUsingDescriptors:[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"date"
                                                                                                    ascending:YES], nil]];

        // Verifica se precisa mostrar a mensagem de todos os exercícios finalizados.
        if (self.messages.count == 0)
        {
            [self showNoDataMessage];
        }
        else
        {
            [self hideNoDataMessage];
        }
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.showLoadEarlierMessagesHeader = NO;
        });
    }
    
    [self.collectionView reloadData];
    
    if (status == 0)
    {
        if (self.messages.count > 0)
        {
            NSInteger section = [self.collectionView numberOfSections] - 1 ;
            NSInteger item = [self.collectionView numberOfItemsInSection:section] - 1 ;
            NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:item inSection:section] ;
            [self.collectionView scrollToItemAtIndexPath:lastIndexPath atScrollPosition:(UICollectionViewScrollPositionBottom) animated:YES];
        }
    }
    else if(status == 1)
    {
        if (self.messages.count > 0)
        {
            [self.view layoutIfNeeded];
            NSArray *visibleItems = [self.collectionView indexPathsForVisibleItems];
            NSIndexPath *currentItem = [visibleItems objectAtIndex:0];
            NSIndexPath *nextItem = [NSIndexPath indexPathForItem:10 inSection:currentItem.section];
            [self.collectionView scrollToItemAtIndexPath:nextItem atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
        }
    }
    

}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - TIMER METHODS

-(void)confirmMessage:(NSString *)strID
{
    // Pega os dados do usuário...
    User *userData = (User *) [coreDataService getDataFromUserTable];
    
    // Cria um operation manager para realizar a solicitação via POST.
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//	[manager.requestSerializer setTimeoutInterval:AFHHTTP_TIMEOUT];
    // Parametros validados.
    NSDictionary *parameters = @{@"apikey": userData.apiKey, @"ids": strID};
    
    // Monta a string de acesso a validação do login.
    NSMutableString *urlString = [[NSMutableString alloc] init];
    [urlString appendString:kBASE_URL_MOBITRAINER];
    [urlString appendString:@"api/message/confirm"];
    
    NSArray *arrayID = [strID componentsSeparatedByString:@","];
    
    // Realiza o POST das informações e aguarda o retorno.
//    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
     AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
 			[manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
 			NSString *path=[[NSString alloc]initWithFormat:@"%@",urlString];
 			[manager POST:[NSURL URLWithString:path].absoluteString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
	 {
        if (![[responseObject objectForKey:@"response_error"] boolValue])
        {
            NSInteger confirmed = [[responseObject objectForKey:@"confirmed"] integerValue];
            
            if (confirmed == arrayID.count)
            {
                for (NSInteger i = 0; i < arrayID.count; i++)
                {
                    NSArray *arrayMessage = [coreDataService getDataFromMessageTableWithMessageID:[arrayID objectAtIndex:i]];
                    
                    for ( Messages *m in arrayMessage)
                    {
                        NSLog(@"MENSAGEM COM O ID:%@ CONFIRMADA!",[arrayID objectAtIndex:i]);
                        m.isSync = [NSNumber numberWithBool:YES];
                        
                        [coreDataService saveData];
                    }
                }
            }
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
    }];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)checkUpdateStatus:(NSTimer *)timer
{
    // VERIFICA SE TEM CONEXÃO COM A INTERNET.
    BOOL flagInternetStatus = [IMManager sharedManager].hasConnection;
    
    // SE TEM CONEXÃO
    if (flagInternetStatus)
    {
        // PEGA OS DADOS DO USUARIO...
        User *userData = (User *) [coreDataService getDataFromUserTable];
        
        // CRIA UM OPERATION MANAGER PARA REALIZAR A SOLICITAÇÃO VIA POST.
 //       AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
 //       [manager.requestSerializer setTimeoutInterval:AFHHTTP_TIMEOUT];
        // PARAMETROS.
        NSDictionary *parameters = @{@"apikey": userData.apiKey, @"method": @"GET"};
        
        // MONTA A STRING DE ACESSO A VALIDAÇÃO DO LOGIN.
        NSMutableString *urlString = [[NSMutableString alloc] init];
        [urlString appendString:kBASE_URL_MOBITRAINER];
        [urlString appendString:@"api/message"];
        
        // REALIZA O POST DAS INFORMAÇÕES E AGUARDA O RETORNO.
      AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
 			[manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
 			NSString *path=[[NSString alloc]initWithFormat:@"%@",urlString];
 			[manager POST:[NSURL URLWithString:path].absoluteString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
		{
            if (![[responseObject objectForKey:@"response_error"] boolValue])
            {
                // PEGA OS DADOS DO JSON.
                NSArray *dataMessage = [responseObject objectForKey:@"message"];
                
                if (dataMessage.count > 0)
                {
                    [JSQSystemSoundPlayer jsq_playMessageSentSound];
                    
                    NSMutableString *confStr = [[NSMutableString alloc] init];
                    
                    for (NSInteger i = 0; i < dataMessage.count; i++)
                    {
                        [confStr appendString:[NSString stringWithFormat:@"%@",[[dataMessage objectAtIndex:i]
                                                                                              objectForKey:@"id"]]];
                        
                        if (i < (dataMessage.count - 1))
                        {
                            [confStr appendString:@","];
                        }
                        
                        NSError *error = nil;
                        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Messages"];
                        NSMutableArray *mutableFetchResults = [[coreDataService.getManagedContext executeFetchRequest:fetchRequest
                                                                                                                error:&error] mutableCopy];
                        
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"messageID==%@",[[dataMessage objectAtIndex:i] objectForKey:@"id"]];
                        NSArray *filtered = [mutableFetchResults filteredArrayUsingPredicate:predicate];
                        
                        if (filtered.count > 0)
                        {
                            //Objeto já existe, precisa fazer o "UPDATE"
                            Messages *m = (Messages *) [filtered objectAtIndex:0];

                            if([userData.level integerValue] == USER_LEVEL_TRAINEE)
                            {
                                m.name = @"Personal Trainer"; // GAMBIARRA SOLICITADA PELO ELI...
                            }
                            else
                            {
                                m.name = [[dataMessage objectAtIndex:i] objectForKey:@"sender_name"];
                            }
                            
                            m.senderID = [[dataMessage objectAtIndex:i] objectForKey:@"sender_id"];
                            m.receiverID = userData.userID;
                            m.messageID = [[dataMessage objectAtIndex:i] objectForKey:@"id"];
                            m.message = [[dataMessage objectAtIndex:i] objectForKey:@"text"];
                            
                            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                            
                            NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
                            [dateFormatter setTimeZone:gmt];
                            
                            NSDate *dateFromString = [[NSDate alloc] init];
                            dateFromString = [dateFormatter dateFromString:[[dataMessage objectAtIndex:i] objectForKey:@"created"]];
                            m.created = dateFromString;
                            m.isSync = [NSNumber numberWithBool:NO];
                            
                            [coreDataService saveData];
                        }
                        else
                        {
                            //Objeto não existe, precisa fazer o "INSERT"
                            Messages *m = (Messages *)[NSEntityDescription insertNewObjectForEntityForName:@"Messages"
                                                                                    inManagedObjectContext:coreDataService.getManagedContext];
                            
                            if([userData.level integerValue] == USER_LEVEL_TRAINEE)
                            {
                                m.name = @"Personal Trainer"; // GAMBIARRA SOLICITADA PELO ELI...
                            }
                            else
                            {
                              m.name = [[dataMessage objectAtIndex:i] objectForKey:@"sender_name"];
                            }
        
                            m.senderID = [[dataMessage objectAtIndex:i] objectForKey:@"sender_id"];
                            m.receiverID = userData.userID;
                            m.messageID = [[dataMessage objectAtIndex:i] objectForKey:@"id"];
                            m.message = [[dataMessage objectAtIndex:i] objectForKey:@"text"];
                            
                            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                            
                            NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
                            [dateFormatter setTimeZone:gmt];
                            
                            NSDate *dateFromString = [[NSDate alloc] init];
                            dateFromString = [dateFormatter dateFromString:[[dataMessage objectAtIndex:i] objectForKey:@"created"]];
                            m.created = dateFromString;
                            m.isSync = [NSNumber numberWithBool:NO];
                            
                            [coreDataService saveData];
                        }
                    }
                    
                    // CONFIRMA AS MENSAGENS RECEBIDAS.
                    [self confirmMessage:confStr];
                    
                    // REMOVE OS OBJETOS.
                    [self.messages removeAllObjects];
                    
                    offset = 0;
                    
                    // VERIFICA SE É USUARIO.
                    if ([userData.level integerValue] == USER_LEVEL_TRAINEE)
                    {
                        // CARREGA AS MENSAGENS DA BASE DE DADOS.
                        [self loadMessagesFromDB:LOAD_BOTTOM];
                    }
                    else
                    {
                        // CARREGA AS MENSAGENS DA BASE DE DADOS.
                        [self loadMessagesFromDBTrainer:LOAD_BOTTOM];
                    }
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

- (void)showNoDataMessage
{
    lblMessage = [[UILabel alloc]initWithFrame:CGRectMake(((self.collectionView.frame.size.width/2)-140),
                                                          ((self.collectionView.frame.size.height/2)-40-17.5),
                                                          280,80)];
    
    // Configura o label.
    lblMessage.numberOfLines = 0;
    lblMessage.textAlignment = NSTextAlignmentCenter;
    lblMessage.backgroundColor = [UIColor clearColor];
    lblMessage.textColor = UIColorFromRGB(0xAAAAAA);
    lblMessage.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
    lblMessage.shadowOffset = CGSizeMake(1,1);
    lblMessage.font = [UIFont boldSystemFontOfSize:17.0f];
    
    // Mensagem do label.
    lblMessage.text = @"Sem mensagens!";
    
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
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    lblMessage.alpha = 0;
    [lblMessage removeFromSuperview];
    
    [UIView commitAnimations];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)dowloadImageWithURL:(NSString *)url
{
    // VERIFICA SE TEM CONEXÃO COM A INTERNET.
    BOOL flagInternetStatus = [IMManager sharedManager].hasConnection;
    
    // SE TEM CONEXÃO
    if (flagInternetStatus)
    {
        if(url.length > 0 && flagInternetStatus == TRUE)
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
                
                // Pega os dados do usuário...
                User *userData = (User *) [coreDataService getDataFromUserTable];
                TrainerInfo *trainer = [coreDataService getDataFromTrainerInfoTable];
                
                // OBJETOS QUE IRÃO CONTER AS IMAGENS (AVATARES)
                JSQMessagesAvatarImage *alunoImage;
                JSQMessagesAvatarImage *personalImage;
  
                //////////////////////////////////////////////////////////////////////////////
                /// IMAGEM DO USUARIO LOGADO /////////////////////////////////////////////////
                //////////////////////////////////////////////////////////////////////////////
                
                // CAMINHO PARA RECUPERAR A IMAGEM DO USUARIO.
                NSMutableString *pathImageUser = [[NSMutableString alloc] init];
                [pathImageUser appendString:[utils returnDocumentsPath]];
                [pathImageUser appendString:@"/Caches/ProfileImages/"];
                [pathImageUser appendString:[utils md5HexDigest:userData.image]];
                [pathImageUser appendString:@".png"];
                
                // VERIFICA SE A IMAGEM EXISTE NO CAMINHO ESPECIFICADO.
                BOOL imageUserExists = [[NSFileManager defaultManager] fileExistsAtPath:pathImageUser];
                
                // SE EXISTE CARREGA, SENÃO CARREGA A IMAGEM PADRÃO.
                if (imageUserExists)
                {
                    UIImage *imageAluno = [UIImage imageWithContentsOfFile:pathImageUser];
                    
                    alunoImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:imageAluno
                                                                            diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
                }
                else
                {
                    alunoImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"Table_User_Default"]
                                                                            diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
                }
                
                // CAMINHO PARA RECUPERAR A IMAGEM DO TREINADOR.
                NSMutableString *pathImagePersonal = [[NSMutableString alloc] init];
                [pathImagePersonal appendString:[utils returnDocumentsPath]];
                [pathImagePersonal appendString:@"/Caches/ProfileImages/"];
                
                if([userData.level integerValue] == USER_LEVEL_TRAINEE) [pathImagePersonal appendString:[utils md5HexDigest:trainer.image]];
                else [pathImagePersonal appendString:[utils md5HexDigest:treineeID]];
                
                [pathImagePersonal appendString:@".png"];
                
                // VERIFICA SE A IMAGEM EXISTE NO CAMINHO ESPECIFICADO.
                BOOL imagePersonalExists = [[NSFileManager defaultManager] fileExistsAtPath:pathImagePersonal];
                
                // SE EXISTE CARREGA, SENÃO CARREGA A IMAGEM PADRÃO.
                if (imagePersonalExists)
                {
                    UIImage *imagePersonal = [UIImage imageWithContentsOfFile:pathImagePersonal];
                    
                    personalImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:imagePersonal
                                                                               diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
                }
                else
                {
                    personalImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"Table_User_Default"]
                                                                               diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
                }
                
                // CONFIGURA AS IMAGENS QUE APARECEM DO LADO DO BALÃO.
                if ([userData.level integerValue] == USER_LEVEL_TRAINEE)
                {
                    self.avatars = @{ userData.userID : alunoImage, userData.trainerID : personalImage };
                }
                else
                {
                    self.avatars = @{ userData.userID : alunoImage, treineeID : personalImage };
                }
                
                [self.collectionView reloadData];
                
            }];
            
            [downloadTask resume];
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - NOTIFICATION METHODS

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect frame = lblMessage.frame;
    
    frame.origin.x = ((self.view.frame.size.width/2)-140);
    frame.origin.y = ((self.view.frame.size.height/2)-40-143);
    frame.size.width = 280.0f;
    frame.size.height = 80.0f;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    lblMessage.frame = frame;

    [UIView commitAnimations];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)keyboardWillHide:(NSNotification *)notification
{
    CGRect frame = lblMessage.frame;
    
    frame.origin.x = ((self.view.frame.size.width/2)-140);
    frame.origin.y = ((self.view.frame.size.height/2)-40-17.5);
    frame.size.width = 280.0f;
    frame.size.height = 80.0f;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    lblMessage.frame = frame;
    
    [UIView commitAnimations];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - NOTIFICATION METHODS

- (void)becomeActive:(NSNotification *)notification
{
    // Pega o status do usuário, logado ou não.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL login = [defaults boolForKey:@"userStatus"];
    
    // Verifica se o usuário esta logado.
    if (login == TRUE)
    {
        // Pega os dados do usuário...
        Chat *chat = (Chat *) [coreDataService getDataFromChatTable];
        
        if ([chat.hasChat boolValue])
        {
            // Seta o timer para verificar o update.
            self.timerCheckUpdate = [NSTimer scheduledTimerWithTimeInterval:3.0f
                                                                     target:self
                                                                   selector:@selector(checkUpdateStatus:)
                                                                   userInfo:nil
                                                                    repeats:YES];
            
            // Dispare o timer, imediatamente.
            [self.timerCheckUpdate fire];
        }
        
    }
    
    [self.collectionView reloadData];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)becomeInactive:(NSNotification *)notification
{
    [self.timerCheckUpdate invalidate];
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
