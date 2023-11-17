//
//  dadosPessoaisViewController.h
//  
//
//  Created by Rubens Rosa on 10/04/2018.
//  Copyright © 2018 4mobi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>
#import "XLFormViewController.h"
#import "XLForm.h"
#import "UtilityClass.h"
#import "Global.h"
#import "CoreDataService.h"
#import "QuestionsD.h"
#import "SHSPhoneLibrary.h"
@interface dadosPessoaisViewController : XLFormViewController
{
	 CoreDataService *coreDataService;
    UtilityClass *utils;
    NSString *training_id;
}


@end
