//
//  MeusTreinosCell.m
//  treino
//
//  Created by Reginaldo Lopes on 25/11/14.
//  Copyright (c) 2014 4mobi. All rights reserved.
//

#import "MeusTreinosCell.h"

@implementation MeusTreinosCell

@synthesize labelSeriesName;
@synthesize buttonMore;
@synthesize imageDifficulty;
@synthesize labelShortDesc;
@synthesize labelShelfLife;
@synthesize imageCalendar;
@synthesize viewBackground;

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////


- (void)configureCell:(Training *)training isHistory:(BOOL)isHistory
{
    //////////////////////////////////////////////////////////////////////
    /// BARRA LATERAL DE DIFICULDADE /////////////////////////////////////
    //////////////////////////////////////////////////////////////////////
	if([training.serieOnOffStatus isEqualToString: @"2"])
    	viewBackground.backgroundColor = UIColorFromRGB(0xF5F5F5);
    if ([training.difficulty integerValue] == 1)
    {
		  if(([training.serieOnOffStatus isEqualToString: @"1"] || [training.serieOnOffStatus isEqualToString: @""])
		  && isHistory == FALSE )
		  {
        		self.imageDifficulty.image = [UIImage imageNamed:@"Label_Iniciante"];
        	//	self.imageCalendar.image = [UIImage imageNamed:@"Table_Calendario_Off"];
			}
		  else
		  {
			   self.imageDifficulty.image = [UIImage imageNamed:@"Label_Iniciante_Disable"];
			//   self.imageCalendar.image = [UIImage imageNamed:@"Table_Calendario_Off"];
		 }
			
    }
    
    else if ([training.difficulty integerValue] == 2)
    {
 	  if(([training.serieOnOffStatus isEqualToString: @"1"] || [training.serieOnOffStatus isEqualToString: @""])
 	  && isHistory == FALSE )
			{
        self.imageDifficulty.image = [UIImage imageNamed:@"Label_Intermediario"];
      //  	self.imageCalendar.image = [UIImage imageNamed:@"Table_Calendario_Off"];
		 }
		 else
		 {
			self.imageDifficulty.image = [UIImage imageNamed:@"Label_Intermediario_Disable"];
		//   self.imageCalendar.image = [UIImage imageNamed:@"Table_Calendario_Off"];
		 }
    }
    
    else if ([training.difficulty integerValue] == 3)
    {
   	  if(([training.serieOnOffStatus isEqualToString: @"1"] || [training.serieOnOffStatus isEqualToString: @""])
   	  && isHistory == FALSE )
	  	{
        self.imageDifficulty.image = [UIImage imageNamed:@"Label_Avancado"];
      //  	self.imageCalendar.image = [UIImage imageNamed:@"Table_Calendario_Off"];
		}
		else
		{
			self.imageDifficulty.image = [UIImage imageNamed:@"Label_Avancado_Disable"];
		//	self.imageCalendar.image = [UIImage imageNamed:@"Table_Calendario_Off"];
		 }
    }
    
    //////////////////////////////////////////////////////////////////////
    /// NOME DO TREINO ///////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////
    
    self.labelSeriesName.text = training.name;
    [self.labelSeriesName setHighlightedTextColor:UIColorFromRGB(0xE3E8EA)];
    
    //////////////////////////////////////////////////////////////////////
    /// DESCRIÇÃO CURTA //////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////
    
    self.labelShortDesc.text = training.fullDescription;
    [self.labelShortDesc setHighlightedTextColor:UIColorFromRGB(0xE3E8EA)];
    
    //////////////////////////////////////////////////////////////////////
    /// VALIDADE /////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////
    
    NSMutableString *shelfLife = [[NSMutableString alloc] init];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    
    NSString *strDateInit = [dateFormat stringFromDate:training.serieDateInit];
    NSString *strDateEnd = [dateFormat stringFromDate:training.serieDateEnd];
	
    NSDate *today = [NSDate date];
	
	 
	
    if (strDateInit.length > 0 && strDateEnd.length >0)
    {
        self.labelShelfLife.hidden = NO;
        if([training.serieOnOffStatus isEqualToString:@"2"])
				labelShelfLife.textColor = UIColorFromRGB(0xB0B0B0);
		 else if([training.serieOnOffStatus isEqualToString:@"1"])
		 {
		  if( [today timeIntervalSinceDate:training.serieDateInit] > 0 && [today timeIntervalSinceDate:training.serieDateEnd]<0)
			 	labelShelfLife.textColor = UIColorFromRGB(0x00be72);
			else
				labelShelfLife.textColor = UIColorFromRGB(0xBC2341); //Série Vencida
					
		 }
		 
			  
        [shelfLife appendString:strDateInit];
        [shelfLife appendString:@" à "];
        [shelfLife appendString:strDateEnd];
        
        self.labelShelfLife.text = shelfLife;
        
        if (isHistory) self.labelShelfLife.textColor = UIColorFromRGB(0xE66252);
    }
    else
    {
		  User *userData = (User *) [coreDataService getDataFromUserTable];
		 labelShelfLife.textColor = UIColorFromRGB(0xB0B0B0);
        if ([userData.level integerValue] != USER_LEVEL_TRAINER)
        		self.labelShelfLife.text = @"Sem restrição de data.";
		  else
			   self.labelShelfLife.text = @"Sem restrição de data";
    }
}

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
    
    UIView *selectedViewColor = [[UIView alloc] initWithFrame:CGRectMake(7, 7,
                                                                         self.contentView.frame.size.width - 14,
                                                                         self.contentView.frame.size.height - 7)];
    
    
#ifdef OLD_STYLE
    Design *appDesign = (Design *) [coreDataService getDataFromDesignTable];
    [selectedViewColor setBackgroundColor:UIColorFromRGB(kPRIMARY_COLOR)];
#endif
#ifdef NEW_STYLE
    [selectedViewColor setBackgroundColor:UIColorFromRGB( MENU_CLICK_COLOR )];
#endif
    
    [container addSubview:selectedViewColor];
    self.selectedBackgroundView = container;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (IBAction)descricaoClicado:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"btnDescTreinoClicado" object:self];
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

