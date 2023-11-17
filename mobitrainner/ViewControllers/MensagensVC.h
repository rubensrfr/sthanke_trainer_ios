//
//  MensagensViewController.h
//  treino
//
//  Created by Reginaldo Lopes on 26/11/14.
//  Copyright (c) 2014 4mobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"
#import "UtilityClass.h"
#import "CoreDataService.h"
#import "JSQMessages.h"
#import "SVProgressHUD.h"

@class UtilityClass;
@class CoreDataService;

@interface MensagensVC : JSQMessagesViewController
{
    UtilityClass *utils;
    CoreDataService *coreDataService;
    NSInteger offset;
    UILabel *lblMessage;
}

@property(nonatomic, strong) NSString *treineeID;
@property (strong, nonatomic) NSTimer *timerCheckUpdate;
@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSDictionary *avatars;
@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
