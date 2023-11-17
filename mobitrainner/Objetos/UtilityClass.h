//
//  UtilityClass.h
//  mobitrainner
//
//  Created by Reginaldo Lopes on 08/12/14.
//  Copyright (c) 2014 4mobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"    
#import "Global.h"
#import "User.h"
#import <CommonCrypto/CommonDigest.h>
#import "newsthanke2-Swift.h"
#import "CoreDataService.h"

@class CoreDataService;

@interface UtilityClass : NSObject
{
    dispatch_group_t group;
    dispatch_queue_t queue;
     CoreDataService *coreDataService;
}

@property (nonatomic) __block BOOL flagHasConnection;

- (NSInteger)StringtoHex:(NSString *)strValue;
- (BOOL)validateEmailWithString:(NSString*)email;
- (NSString *)returnLibraryPath;
- (NSString *)returnDocumentsPath;
- (NSArray *)pngFilesInFeaturedImagesFolder;
- (NSString *)md5HexDigest:(NSString*)input;
- (NSString *)checkString:(NSString *)string;
- (NSInteger)compareDatesServer:(NSDate *)serverDate AndLocal:(NSDate *)localDate;
- (NSString*)encodeToPercentEscapeString:(NSString *)string;
- (NSString *)createStringCodeFromEmoji:(NSString *)string;
- (NSString *)createEmojiFromCodeString:(NSString *)string;
- (BOOL)stringContainsEmoji:(NSString *)string;
- (BOOL)validateCREFWithString:(NSString *)s;
- (CGSize)frameForText:(NSString *)text sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
- (void)showAlertWithTitle:(NSString *)title AndText:(NSString *)text AndTargetVC:(UIViewController *)targetVC;
- (NSString *)dateToStringInterval:(NSDate *)pastDate;
- (void)updateTransactionsToServer;
- (void)downloadProductsForSale;

@end

////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
