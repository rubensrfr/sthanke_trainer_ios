//
//  parQViewController.h
//  
//
//  Created by Rubens Rosa on 05/04/2018.
//  Copyright © 2018 4mobi. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "XLFormViewController.h"
#import "XLForm.h"
#import "UtilityClass.h"
#import "Global.h"
#import "CoreDataService.h"
#import "QuestionsP.h"

@interface parQViewController : XLFormViewController
{
	 CoreDataService *coreDataService;
    UtilityClass *utils;
    NSString *training_id;
}

@end


//q28	"Alguma vez um médico lhe disse que você possui um problema do coração e lhe recomendou que
//só fizesse atividade física sob supervisão médica?"
//q29	Você sente dor no peito, causada pela prática de atividade física?

//q30	Você sentiu dor no peito no último mês?

//q31	Você tende a perder a consciência ou cair, como resultado de tonteira ou desmaio?

//q32	Você tem algum problema ósseo ou muscular que poderia ser agravado com a prática de atividade física?

//q33	"Algum médico já lhe recomendou o uso de medicamentos para a sua pressão arterial,
//para circulação ou coração?"

//q34	"Você tem consciência, através da sua própria experiência ou aconselhamento médico, de alguma outra
//razão física que impeça sua prática de atividade física sem supervisão médica?"
