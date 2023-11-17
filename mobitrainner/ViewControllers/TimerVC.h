//
//  TimerViewController.h
//  mobitrainer
//
//  Created by Reginaldo Lopes on 27/08/15.
//  Copyright (c) 2015 4mobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UtilityClass.h"
#import "Global.h"
#import "CoreDataService.h"
#import <AVFoundation/AVFoundation.h>


@class UtilityClass;
@class CoreDataService;

@interface TimerVC : UITableViewController
{
    UtilityClass *utils;
    CoreDataService *coreDataService;
    AVAudioPlayer *audioPlayer;
    NSArray *arrayTimer;
    NSTimer *timer;
    int minutes, seconds;
    int secondsLeft;
    BOOL flagInUse;
}

@property (weak, nonatomic) IBOutlet UIButton *btnIniciar;
@property (weak, nonatomic) IBOutlet UIButton *btnCancelar;
@property (weak, nonatomic) IBOutlet UILabel *labelClock;
@property (weak, nonatomic) IBOutlet UIView *viewCounterBG;

-(void)updateCounter:(NSTimer *)theTimer;
-(void)countdownTimer;

- (IBAction)btnIniciarClicado:(id)sender;
- (IBAction)btnCancelarClicado:(id)sender;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

