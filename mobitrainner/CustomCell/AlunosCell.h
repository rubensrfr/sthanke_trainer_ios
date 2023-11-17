//
//  alunosCell.h
//  mobitrainer
//
//  Created by Reginaldo Lopes on 23/06/15.
//  Copyright (c) 2015 4mobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDBadgedCell.h"


@interface AlunosCell : TDBadgedCell

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *labelNome;
@property (weak, nonatomic) IBOutlet UILabel *labelEmail;
@property (weak, nonatomic) IBOutlet UILabel *labelTrainer;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
