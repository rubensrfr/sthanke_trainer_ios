//
//  CircuitoDetalheController.h
//  mobitrainer
//
//  Created by Reginaldo Lopes on 07/07/15.
//  Copyright (c) 2015 4mobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExerciciosListaCell.h"
#import <QuartzCore/QuartzCore.h>
#import "Global.h"
#import "SVProgressHUD.h"
#import "UtilityClass.h"
#import "CoreDataService.h"
#import "ExerciciosDetalhesVC.h"
#import <AVFoundation/AVFoundation.h>

@protocol CircuitDoneDelegate <NSObject>

-(void)circuitDone:(NSIndexPath *)indexPath;

@end

@class UtilityClass;
@class CoreDataService;

@interface CircuitoDetalheVC : UIViewController <UITableViewDataSource, UITableViewDelegate,UIPickerViewDataSource, UIPickerViewDelegate>
{
    UtilityClass *utils;
    CoreDataService *coreDataService;
	
    NSArray *pickerData;
    NSArray *pickerDataSeconds;
    AVAudioPlayer *audioPlayer;
    NSArray *arrayTimer;
    NSTimer *descansoTimer;
    int minutes, seconds;
    int secondsLeft;
    BOOL flagInUse;
}

@property (weak, nonatomic) IBOutlet UIPickerView *timerSelector;
-(void)updateCounter:(NSTimer *)theTimer;
-(void)countdownTimer;
- (IBAction)btnIniciarClicado:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *iniciarBtnText;
- (IBAction)btnAlterarTimer:(id)sender;
- (IBAction)confirmaNovoTimer:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *confirmaNovoTimerOutlet;
@property (strong, nonatomic) NSMutableArray *intervalData;
@property (weak, nonatomic) IBOutlet UILabel *labelClock;
@property (nonatomic,assign) id delegate;

@property (nonatomic) BOOL isDone;

@property (strong, nonatomic) NSIndexPath *selectedPath;

@property (weak, nonatomic) IBOutlet UILabel *lblSerieName;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UITextView *tvTituloCombinado;

@property (weak, nonatomic) IBOutlet UITextView *tvCombinadoDesc;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnConcluido;
@property (weak, nonatomic) IBOutlet UIView *viewTopFrame;

@property (strong, nonatomic) UIView *viewDone;
@property (strong, nonatomic) UIView *dimmer;
@property (strong, nonatomic) UIView *background;
@property (strong, nonatomic) NSMutableArray *arrayExercises;
@property (strong, nonatomic) NSString *circuitoID;
@property (strong, nonatomic) NSString *trainingID;
@property (strong, nonatomic) NSString *treineeID;
@property (strong, nonatomic) NSString *trainingName;
@property (nonatomic) BOOL isHistory;
@property (weak, nonatomic) NSString*  trainingpublickey;
- (IBAction)btnConcluidoClicado:(id)sender;
- (IBAction)btnVoltar:(id)sender;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
