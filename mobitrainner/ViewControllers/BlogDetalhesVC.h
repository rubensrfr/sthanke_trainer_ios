//
//  BlogDetalhesViewController.h
//  mobitrainner
//
//  Created by Reginaldo Lopes on 28/11/14.
//  Copyright (c) 2014 4mobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "CoreDataService.h"
#import "UtilityClass.h"
#import "Global.h"

@class UtilityClass;
@class CoreDataService;

@interface BlogDetalhesVC : UIViewController
{
    CoreDataService *coreDataService;
    UtilityClass *utils;
}


@property (weak, nonatomic) IBOutlet WKWebView *blogDetalhesWeb;
@property (strong, nonatomic) IBOutlet UILabel *tituloBlog;

@property (weak, nonatomic)NSMutableDictionary *item;
@property (weak, nonatomic)NSString *titulo;


@end

////////////////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
