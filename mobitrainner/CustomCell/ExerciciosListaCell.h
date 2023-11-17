//
//  TreinoDetalhesCell.h
//  treino
//
//  Created by Reginaldo Lopes on 25/11/14.
//  Copyright (c) 2014 4mobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"
#import "CoreDataService.h"
#import "UtilityClass.h"
#import "Global.h"

@class CoreDataService;
@class UtilityClass;

@interface ExerciciosListaCell : MGSwipeTableCell
{
    CoreDataService *coreDataService;
    UtilityClass *utils;
}
@property (weak, nonatomic) IBOutlet UIView *viewCellExercise;

@property (weak, nonatomic) IBOutlet UILabel *labelExerciseName;
@property (weak, nonatomic) IBOutlet UIImageView *imageExercise;
@property (weak, nonatomic) IBOutlet UILabel *labelExecucaoExercico;
@property (weak, nonatomic) IBOutlet UILabel *labelAnotacaoExercicio;
@property (nonatomic) BOOL isLastCell;
@property (weak, nonatomic) IBOutlet UIImageView *iconPlus;
@property (weak, nonatomic) IBOutlet UIImageView *imagePersonPencil;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

