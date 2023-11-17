//
//  CombinadoCell.h
//  mobitrainner
//
//  Created by Reginaldo Lopes on 29/12/14.
//  Copyright (c) 2014 4mobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"
#import "CoreDataService.h"
#import "UtilityClass.h"
#import "Global.h"

@class CoreDataService;
@class UtilityClass;

@interface CircuitoCell : MGSwipeTableCell
{
    CoreDataService *coreDataService;
    UtilityClass *utils;
}
@property (weak, nonatomic) IBOutlet UIView *viewCircuitCell;

@property (weak, nonatomic) IBOutlet UILabel *labelCircuitoName;
@property (weak, nonatomic) IBOutlet UIImageView *imageCircuito;
@property (weak, nonatomic) IBOutlet UILabel *labelExecucaoCircuito;
@property (nonatomic) BOOL isLastCell;
@property (weak, nonatomic) IBOutlet UITextField *TextCircuitoExecucao;
@property (weak, nonatomic) IBOutlet UILabel *labelAnotacaoCircuito;
@property (weak, nonatomic) IBOutlet UIImageView *imagePersonPencil;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
