//
//  ExerciciosDetalhesViewController.h
//  mobitrainer
//
//  Created by Reginaldo Lopes on 11/08/15.
//  Copyright (c) 2015 4mobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Global.h"
#import "SVProgressHUD.h"
#import "UtilityClass.h"
#import "CoreDataService.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SVProgressHUD.h"
#import <MediaPlayer/MediaPlayer.h>
#import "YTPlayerView.h"

@class CoreDataService;
@class UtilityClass;

@protocol ExerciseDoneDelegate <NSObject>

-(void)exerciseDone:(NSIndexPath *)indexPath;

@end

@interface ExerciciosDetalhesVC : UITableViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,YTPlayerViewDelegate>
{
    UtilityClass *utils;
    CoreDataService *coreDataService;
    UIActivityIndicatorView *spinner;
    dispatch_group_t group;
    dispatch_queue_t queue;
    float backgroundWidth;
    float backgroundHeight;
    UILabel *imgStatus;
}

@property (nonatomic,assign) id delegate;

@property (weak, nonatomic) IBOutlet UILabel *lblTituloExercicio;
@property (weak, nonatomic) IBOutlet UILabel *lblGrupoMuscular;
@property (weak, nonatomic) IBOutlet UITextView *tvDescricao;
@property (weak, nonatomic) IBOutlet UILabel *lblExecucao;
@property (weak, nonatomic) IBOutlet UITextView *tvInstrucao;
@property (weak, nonatomic) IBOutlet UIView *viewInstrucao;
@property (weak, nonatomic) IBOutlet UIView *viewDescricao;
@property (weak, nonatomic) IBOutlet UIImageView *imgVideoThumb;
@property (weak, nonatomic) IBOutlet UIImageView *img1Exercise;
@property (weak, nonatomic) IBOutlet UIImageView *img2Exercise;

@property (weak, nonatomic) IBOutlet UIView *viewTituloImagens;
@property (weak, nonatomic) IBOutlet UILabel *lblTituloImagens;
@property (weak, nonatomic) IBOutlet UIImageView *imgTituloImagens;

@property (weak, nonatomic) IBOutlet UIView *viewTituloExecucao;
@property (weak, nonatomic) IBOutlet UILabel *lblTituloExecucao;
@property (weak, nonatomic) IBOutlet UIImageView *imgTituloExecucao;

@property (weak, nonatomic) IBOutlet UIView *viewTituloCargaDescanso;
@property (weak, nonatomic) IBOutlet UILabel *lblTituloCarga;
@property (weak, nonatomic) IBOutlet UILabel *lblTituloDescanso;
@property (weak, nonatomic) IBOutlet UILabel *lblTituloRepeticao;
@property (weak, nonatomic) IBOutlet UILabel *lblTituloSerie;

@property (weak, nonatomic) IBOutlet UIView *viewTituloNota;
@property (weak, nonatomic) IBOutlet UILabel *lblTituloNota;
@property (weak, nonatomic) IBOutlet UIImageView *imgTituloNota;
@property (weak, nonatomic) IBOutlet UITextField *textFieldNota;
@property (weak, nonatomic) IBOutlet UIButton *btnEditarNota;

@property (weak, nonatomic) IBOutlet UIView *viewTituloSerie;
@property (weak, nonatomic) IBOutlet UIImageView *imgTituloCarga;
@property (weak, nonatomic) IBOutlet UIImageView *imgTituloDescanso;
@property (weak, nonatomic) IBOutlet UIImageView *imgTituloSerie;
@property (weak, nonatomic) IBOutlet UIImageView *imgTituloRepeticao;

@property (weak, nonatomic) IBOutlet UIView *viewTituloDescricao;
@property (weak, nonatomic) IBOutlet UILabel *lblTituloDescricao;
@property (weak, nonatomic) IBOutlet UIImageView *imgTituloDescricao;

@property (weak, nonatomic) IBOutlet UIView *viewTituloInstrucao;
@property (weak, nonatomic) IBOutlet UILabel *lblTituloInstrucao;
@property (weak, nonatomic) IBOutlet UIImageView *imgTituloInstrucao;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *aiImage1;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *aiImage2;

@property (weak, nonatomic) IBOutlet UILabel *lblSerie;
@property (weak, nonatomic) IBOutlet UILabel *lblRepeticao;
@property (weak, nonatomic) IBOutlet UILabel *lblCarga;
@property (weak, nonatomic) IBOutlet UILabel *lblDescanso;

@property (nonatomic) BOOL isDone;

@property (strong, nonatomic) Exercises *exercise;
@property (strong, nonatomic) NSString *trainingID;

@property (strong, nonatomic) UIView *dimmer;
@property (strong, nonatomic) UIView *background;


@property(nonatomic, strong) IBOutlet YTPlayerView *playerView;

- (IBAction)btnVideoClicado:(id)sender;
- (IBAction)editLoadValue:(id)sender;
- (IBAction)editNote:(id)sender;
- (IBAction)btnClose:(id)sender;
- (IBAction)playVideo:(id)sender;
- (IBAction)stopVideo:(id)sender;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
