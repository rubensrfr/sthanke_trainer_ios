//
//  assesoriaTableViewController.h
//  
//
//  Created by Rubens Rosa on 17/03/2018.
//  Copyright © 2018 4mobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "Global.h"
#import "UtilityClass.h"
#import "SVProgressHUD.h"
#import "CoreDataService.h"
#import "UIImageView+AFNetworking.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "YTPlayerView.h"

#define NAO_INICIADO 0
#define EM_APROVACAO_APPLE 1
#define AUTORIZADO_APPLE 2
#define PROCESSANDO_APPLE 3
#define APROVADO_APPLE 4
#define REGISTRO_LOCAL_4MOBI 5
#define REGISTRO_PAINEL_4MOBI 6
#define FINALIZADO_4MOBI 7


#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"
// add a couple notifications sent out when the transaction completes
#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification"
@class UtilityClass;
@class CoreDataService;

@interface AssesoriaTableViewController : UITableViewController<SKRequestDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver,YTPlayerViewDelegate>
{
	 UtilityClass *utils;
    CoreDataService *coreDataService;
	 SKProduct *proUpgradeProduct;
    SKProductsRequest *productsRequest;
    SKReceiptRefreshRequest *request;
    NSArray *products;
    int EstagioCompra;
    long int num_products;
	
}
- (IBAction)comprarBrn:(id)sender;
@property (nonatomic, strong)     NSTimer *cancelaTimer;
@property (nonatomic, strong) NSString *productId;
@property (nonatomic) BOOL  show_details_only;
- (IBAction)btnVideoClicado:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imgVideoThumb;
@property (weak, nonatomic) IBOutlet UITextView *tableProductDescription;
@property (weak, nonatomic) IBOutlet UILabel *tableProductPrice;
@property (nonatomic, strong) NSString *productPrice;
@property (nonatomic, strong) NSString *productDeliverDays;
@property (nonatomic, strong) NSString *productDescription;
@property (nonatomic, strong) NSString *productVideo;
@property (nonatomic, strong) NSString *productImage;
@property (weak, nonatomic) IBOutlet UIButton *comprarBtnOL;
@property (weak, nonatomic) IBOutlet UILabel *priceLabelOL;
@property (weak, nonatomic) IBOutlet UIButton *videoBtnOL;
@property(nonatomic, strong) IBOutlet YTPlayerView *playerView;
- (IBAction)btnTerms:(id)sender;

@end
