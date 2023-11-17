//
//  MeusTreinosCell.h
//  treino
//
//  Created by Reginaldo Lopes on 25/11/14.
//  Copyright (c) 2014 4mobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataService.h"
#import "UtilityClass.h"
#import "Global.h"

@class CoreDataService;
@class UtilityClass;

@interface MeusTreinosCell : UITableViewCell
{
    CoreDataService *coreDataService;
    UtilityClass *utils;
}

@property (weak, nonatomic) IBOutlet UILabel *labelSeriesName;
@property (weak, nonatomic) IBOutlet UIButton *buttonMore;
@property (weak, nonatomic) IBOutlet UIImageView *imageDifficulty;
@property (weak, nonatomic) IBOutlet UILabel *labelShortDesc;
@property (weak, nonatomic) IBOutlet UILabel *labelShelfLife;
@property (weak, nonatomic) IBOutlet UIImageView *imageCalendar;
@property (weak, nonatomic) IBOutlet UIView *viewBackground;

- (void)configureCell:(Training *)training isHistory:(BOOL)ishistory;

- (IBAction)descricaoClicado:(id)sender;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
