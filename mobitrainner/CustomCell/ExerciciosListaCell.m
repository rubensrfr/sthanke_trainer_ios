//
//  TreinoDetalhesCell.m
//  treino
//
//  Created by Reginaldo Lopes on 25/11/14.
//  Copyright (c) 2014 4mobi. All rights reserved.
//

#import "ExerciciosListaCell.h"

@implementation ExerciciosListaCell

@synthesize labelExerciseName;
@synthesize imageExercise;
@synthesize labelExecucaoExercico;
@synthesize labelAnotacaoExercicio;
@synthesize isLastCell;
@synthesize iconPlus;
@synthesize imagePersonPencil;

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
	
    utils = [[UtilityClass alloc] init];
    coreDataService = [[CoreDataService alloc] init];
    [coreDataService initialize];
	
	
	
    UIView* container = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                                 self.contentView.frame.size.width,
                                                                 self.contentView.frame.size.height)];
	
    container.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
	
	
    UIView *selectedViewColor;
	
    if(self.isLastCell)
    {
        selectedViewColor = [[UIView alloc] initWithFrame:CGRectMake(7, 7,
                                                                     self.contentView.frame.size.width - 14,
                                                                     self.contentView.frame.size.height - 14)];
    }
    else
    {
        selectedViewColor = [[UIView alloc] initWithFrame:CGRectMake(7, 7,
                                                                     self.contentView.frame.size.width - 14,
                                                                     self.contentView.frame.size.height - 7)];
    }

#ifdef OLD_STYLE
    Design *appDesign = (Design *) [coreDataService getDataFromDesignTable];
    [selectedViewColor setBackgroundColor:UIColorFromRGB(kPRIMARY_COLOR)];
#endif
#ifdef NEW_STYLE
    [selectedViewColor setBackgroundColor:UIColorFromRGB( MENU_CLICK_COLOR )];
#endif
	
 //   [container addSubview:selectedViewColor];
    self.selectedBackgroundView = container;
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

