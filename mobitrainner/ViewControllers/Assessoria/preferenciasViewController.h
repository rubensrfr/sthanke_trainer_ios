//
//  preferenciasViewController.h
//  
//
//  Created by Rubens Rosa on 29/03/2018.
//  Copyright © 2018 4mobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLFormViewController.h"
#import "XLForm.h"
#import "UtilityClass.h"
#import "Global.h"
#import "CoreDataService.h"
#import "QuestionsE.h"





@interface preferenciasViewController : XLFormViewController
{
	 CoreDataService *coreDataService;
    UtilityClass *utils;
    NSString *training_id;
}


@end

//39	q39	Com qual freqüência semanal pretende treinar?
//40	q40	Quais os dias disponíveis da semana para treinos?	Texto, texto, texto...	Dias da semana
//41	q41	Quantos minutos por dia você tem disponível para treinar?	Texto	Definir as opções
//42	q42	Quais os períodos de horário de sua preferência?	Texto	Manhã, tarde, noite
//43	q43	Caso faça exercícios atualmente, descreva seu treino, por favor	Texto
//44	q44	Tem algum exercício que goste muito e que, se possível, seja incluído no seu treino?	Texto
//45	q45	"Existe algum exercício específico ou abordagem que não goste de fazer em rotinas de treino, ou que
//cause algum tipo de desconforto?"	Texto
//46	q46	Gosta de exercícios aeróbicos?	Sim/Não
//47	q47	Descreva o ambiente onde pretende treinar com a o treino elaborado pela assessoria	Texto	Academia, parque...
//Para que a planilha de treinamento tenha o máximo de eficácia possível, precisamos nos conhecer mais ainda.
//48	q48	Faça um breve resumo sobre você	Texto
//49	q49	Quai são os seus objetivos e expectativas em relação a assessoria	Texto
//50	q50	Se deseja emagrecer, qual a sua meta (Kg)	Texto
//51	q51	Mais Detalhes (Use esse espaço para suas considerações e ou observações adicionais)	Texto
