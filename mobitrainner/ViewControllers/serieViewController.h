//
//  serieViewController.h
//  mobitrainer
//
//  Created by Rubens Rosa on 10/11/2017.
//  Copyright © 2017 4mobi. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "ExerciciosListaCell.h"
#import "CircuitoCell.h"
#import "MGSwipeButton.h"
#import <QuartzCore/QuartzCore.h>
#import "Global.h"
#import "SVProgressHUD.h"
#import "UtilityClass.h"
#import "CircuitoDetalheVC.h"
#import "ExerciciosDetalhesVC.h"
#import "CoreDataService.h"
#import "ExerciseList.h"
#import <AVFoundation/AVFoundation.h>

@class IMManager;
@class UtilityClass;
@class CoreDataService;

@interface serieViewController : UIViewController <UITextFieldDelegate,MGSwipeTableCellDelegate, UITableViewDataSource, UITableViewDelegate, ExerciseDoneDelegate, CircuitDoneDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
    UtilityClass *utils;
    CoreDataService *coreDataService;
    UILabel *lblMessage;

    NSArray *pickerData;
    NSArray *pickerDataSeconds;
    AVAudioPlayer *audioPlayer;
    NSArray *arrayTimer;
    NSTimer *descansoTimer;
    int minutes, seconds;
    int secondsLeft;
    BOOL flagInUse;
    float concluir_pos;
}

@property (weak, nonatomic) IBOutlet UIButton *btnIniciar;
@property (weak, nonatomic) IBOutlet UIButton *btnCancelar;
@property (weak, nonatomic) IBOutlet UILabel *labelClock;
@property (weak, nonatomic) IBOutlet UIView *viewCounterBG;

-(void)updateCounter:(NSTimer *)theTimer;
-(void)countdownTimer;

- (IBAction)btnIniciarClicado:(id)sender;

- (IBAction)btnVoltar:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *iniciarBtnText;
- (IBAction)btnAlterarTimer:(id)sender;
- (IBAction)confirmaNovoTimer:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *confirmaNovoTimerOutlet;


@property (strong, nonatomic) UIView *viewDone;
@property (strong, nonatomic) UIView *dimmer;
@property (strong, nonatomic) UIView *background;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) NSMutableArray *arrayExercises;
@property (strong, nonatomic) NSMutableArray *arrayExercisesDone;
@property (weak, nonatomic) IBOutlet UIPickerView *timerSelector;

@property (strong, nonatomic) NSString *trainingID;
@property (strong, nonatomic) NSString *digitalproduct_id;
@property (strong, nonatomic) NSString *treineeID;
@property (strong, nonatomic) NSString *trainingName;
@property (strong, nonatomic) NSString *trainingDescription;
@property (strong, nonatomic) NSNumber *trainingDifficulty;
@property (weak, nonatomic) NSString*  trainingpublickey;
@property (weak, nonatomic) NSString*  serieOnOffStatus;
@property (nonatomic) BOOL isHistory;
@property (strong, nonatomic) IBOutlet UITableView *tableViewExercicioLista;
@property (nonatomic) BOOL isMeusTreinosCalling;
- (IBAction)buttonBarExercisePressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *nomeSerieLabel;

@property (weak, nonatomic) IBOutlet UIImageView *nivelSerieImage;
@property (weak, nonatomic) IBOutlet UILabel *decricaoSerieLabel;

@property (strong, nonatomic) NSMutableArray *intervalData;
- (void)showDoneMessage;
- (void)hideDoneMessage;
- (void)historyDataEntry;
@property (weak, nonatomic) IBOutlet UIView *viewCellExercise;
@property (weak, nonatomic) IBOutlet UIView *viewCellCircuit;
@property (weak, nonatomic) IBOutlet UITextView *nomeSerieText;
@property (weak, nonatomic) IBOutlet UITextView *descricaoText;

@end

