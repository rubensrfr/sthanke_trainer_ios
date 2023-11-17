//
//  TimerViewController.m
//  mobitrainer
//
//  Created by Reginaldo Lopes on 27/08/15.
//  Copyright (c) 2015 4mobi. All rights reserved.
//

#import "TimerVC.h"

@interface TimerVC()

@end

@implementation TimerVC

@synthesize btnIniciar;
@synthesize btnCancelar;
@synthesize labelClock;
@synthesize viewCounterBG;

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - VIEW LIFECYCLES

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    utils = [[UtilityClass alloc] init];
    
    coreDataService = [[CoreDataService alloc] init];
    [coreDataService initialize];
    
    flagInUse = FALSE;

    // Tweak para linhas extra na tabela.
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:kTEXT_BACK_BUTTON_DEFAULT
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:nil
                                                                  action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    // Configura o background da tableview.
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                      0,
                                                                      self.view.frame.size.width,
                                                                      self.view.frame.size.height)];
    
    [backgroundView setBackgroundColor:UIColorFromRGB(0xDFDFDF)];
    [self.tableView setBackgroundView:backgroundView];
    self.tableView.backgroundView.layer.zPosition -= 1;
    
    arrayTimer = [[NSArray alloc]initWithObjects:@"30s",@"45s",@"1min",@"1min 30s",@"2min",@"3min",@"4min", @"5min", nil];
    
    // RECUPERA AS CONFIGURA"CÃO DO APP DESGIN DO BANCOD E DADOS.
    //Design *appDesign = (Design *) [db getDataFromDesignTable];
    
    viewCounterBG.backgroundColor = UIColorFromRGB(0xEEEEEE);
    
    UIFont *customFont = [UIFont fontWithName:@"Digital" size:100.0f];
    labelClock.font = customFont;
    labelClock.textColor = UIColorFromRGB(0x333333);
 
    btnCancelar.layer.cornerRadius = 16.0f;
    btnIniciar.layer.cornerRadius = 16.0f;

    secondsLeft = 0;
    minutes = 0;
    seconds = 0;
    
    btnIniciar.enabled = NO;
    btnIniciar.alpha = 0.5f;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - TABLE VIEW DATA SOURCE & DELEGATE

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayTimer count];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPHONE5)
    {
        return 47.0f;
    }
    else
    {
        return 36.0f;
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    // Romove qq objeto com a mesma tag para não empilhar na view.
    [[cell.contentView viewWithTag:123] removeFromSuperview];
    
    // Configura a seta
    UIImageView *accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Table_Seta"]];
    accessoryView.frame = CGRectMake((self.view.frame.size.width - 26),
                                     ((cell.frame.size.height / 2) - 7),
                                     14, 14);
    accessoryView.tag = 123;
    [cell.contentView addSubview:accessoryView];
    
    
    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor: UIColorFromRGB(kPRIMARY_COLOR)];
    [bgColorView setClipsToBounds:YES];
    bgColorView.alpha = 0.1f;
    [cell setSelectedBackgroundView:bgColorView];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    if (flagInUse)
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setUserInteractionEnabled:NO];
    }
    
    cell.textLabel.text = [arrayTimer objectAtIndex:indexPath.row];
    [cell.textLabel setHighlightedTextColor:UIColorFromRGB(0xE3E8EA)];
    
    return cell;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    switch (indexPath.row)
    {
        case 0:
        {
            if (!flagInUse)
            {
                labelClock.text = @"00:30";
                labelClock.transform = CGAffineTransformMakeScale(1.0, 1.0);
                
                [UIView animateWithDuration:0.1f
                                      delay:0.0f
                                    options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAutoreverse
                                 animations:^{
                                     
                                     labelClock.transform = CGAffineTransformMakeScale(1.1, 1.1);
                                     
                                 }
                                 completion:^(BOOL finished) {
                                     
                                     labelClock.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                 }];
                
                secondsLeft = 30;
                
                btnIniciar.enabled = YES;
                btnIniciar.alpha = 1.0f;
            }

            break;
        }
            
            
        case 1:
        {
            if (!flagInUse)
            {
                labelClock.text = @"00:45";
                [UIView animateWithDuration:0.1f
                                      delay:0.0f
                                    options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAutoreverse
                                 animations:^{
                                     
                                     labelClock.transform = CGAffineTransformMakeScale(1.1, 1.1);
                                     
                                 }
                                 completion:^(BOOL finished) {
                                     
                                     labelClock.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                 }];
                
                secondsLeft = 45;
                
                btnIniciar.enabled = YES;
                btnIniciar.alpha = 1.0f;
            }
            
            break;
        }
            
        case 2:
        {
            if (!flagInUse)
            {
                labelClock.text = @"01:00";
                [UIView animateWithDuration:0.1f
                                      delay:0.0f
                                    options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAutoreverse
                                 animations:^{
                                     
                                     labelClock.transform = CGAffineTransformMakeScale(1.1, 1.1);
                                     
                                 }
                                 completion:^(BOOL finished) {
                                     
                                     labelClock.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                 }];
                
                secondsLeft = 60;
                
                btnIniciar.enabled = YES;
                btnIniciar.alpha = 1.0f;
            }
            
            break;
        }
            
        case 3:
        {
            if (!flagInUse)
            {
                labelClock.text = @"01:30";
                
                [UIView animateWithDuration:0.1f
                                      delay:0.0f
                                    options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAutoreverse
                                 animations:^{
                                     
                                     labelClock.transform = CGAffineTransformMakeScale(1.1, 1.1);
                                     
                                 }
                                 completion:^(BOOL finished) {
                                     
                                     labelClock.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                 }];
                
                secondsLeft = 90;
                
                btnIniciar.enabled = YES;
                btnIniciar.alpha = 1.0f;
            }
            
            break;
        }
            
        case 4:
        {
            if (!flagInUse)
            {
                labelClock.text = @"02:00";
                
                [UIView animateWithDuration:0.1f
                                      delay:0.0f
                                    options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAutoreverse
                                 animations:^{
                                     
                                     labelClock.transform = CGAffineTransformMakeScale(1.1, 1.1);
                                     
                                 }
                                 completion:^(BOOL finished) {
                                     
                                     labelClock.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                 }];
                secondsLeft = 120;
                
                btnIniciar.enabled = YES;
                btnIniciar.alpha = 1.0f;

            }
            
            break;
        }
            
        case 5:
        {
            if (!flagInUse)
            {
                labelClock.text = @"03:00";
                
                [UIView animateWithDuration:0.1f
                                      delay:0.0f
                                    options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAutoreverse
                                 animations:^{
                                     
                                     labelClock.transform = CGAffineTransformMakeScale(1.1, 1.1);
                                     
                                 }
                                 completion:^(BOOL finished) {
                                     
                                     labelClock.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                 }];
                
                secondsLeft = 180;
                
                btnIniciar.enabled = YES;
                btnIniciar.alpha = 1.0f;
            }
            
            break;
        }
            
        case 6:
        {
            if (!flagInUse)
            {
                labelClock.text = @"04:00";
                
                [UIView animateWithDuration:0.1f
                                      delay:0.0f
                                    options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAutoreverse
                                 animations:^{
                                     
                                     labelClock.transform = CGAffineTransformMakeScale(1.1, 1.1);
                                     
                                 }
                                 completion:^(BOOL finished) {
                                     
                                     labelClock.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                 }];
                
                secondsLeft = 240;
                
                btnIniciar.enabled = YES;
                btnIniciar.alpha = 1.0f;
            }
            
            break;
        }
            
        case 7:
        {
            if (!flagInUse)
            {
                labelClock.text = @"05:00";
                
                [UIView animateWithDuration:0.1f
                                      delay:0.0f
                                    options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAutoreverse
                                 animations:^{
                                     
                                     labelClock.transform = CGAffineTransformMakeScale(1.1, 1.1);
                                     
                                 }
                                 completion:^(BOOL finished) {
                                     
                                     labelClock.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                 }];
                
                secondsLeft = 300;
                
                btnIniciar.enabled = YES;
                btnIniciar.alpha = 1.0f;
            }
            
            break;
        }

        default:
            break;
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - ACTIONS

- (IBAction)btnIniciarClicado:(id)sender
{
    btnIniciar.enabled = NO;
    btnIniciar.alpha = 0.5f;
    
    flagInUse = TRUE;
    
    [self.tableView reloadData];
    
    [self countdownTimer];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (IBAction)btnCancelarClicado:(id)sender
{
    [timer invalidate];
    [self dismissViewControllerAnimated:YES completion:nil];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)updateCounter:(NSTimer *)theTimer
{
    if(secondsLeft > 0 )
    {
        secondsLeft -- ;
        minutes = (secondsLeft % 3600) / 60;
        seconds = (secondsLeft % 3600) % 60;
        labelClock.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    }
    else
    {
        // Construct URL to sound file
        NSString *path = [NSString stringWithFormat:@"%@/alarm.mp3", [[NSBundle mainBundle] resourcePath]];
        NSURL *soundUrl = [NSURL fileURLWithPath:path];
        [audioPlayer play];
        
        // Create audio player object and initialize with URL to sound
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
        [audioPlayer play];
        
        labelClock.text = @"00:00";
        btnIniciar.enabled = NO;
        btnIniciar.alpha = 0.5f;
        [timer invalidate];
        
        flagInUse = FALSE;
        
        double delayInSeconds = 1.0f;
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [self dismissViewControllerAnimated:YES completion:nil];
        });
        
        
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)countdownTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                             target:self
                                           selector:@selector(updateCounter:)
                                           userInfo:nil
                                            repeats:YES];
}


@end

////////////////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
