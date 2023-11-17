//
//  questionaryViewController.m
//
//
//  Created by Rubens Rosa on 29/03/2018.
//  Copyright © 2018 4mobi. All rights reserved.
//

#import "preferenciasViewController.h"
#import "XLFormWeekDaysCell.h"

@interface preferenciasViewController ()

@end

@implementation preferenciasViewController

//@synthesize training_id;

//NSString *const kDateInline = @"dateInline";
//NSString *const kTimeInline = @"timeInline";
//NSString *const kDateTimeInline = @"dateTimeInline";
//NSString *const kCountDownTimerInline = @"countDownTimerInline";
//NSString *const kDatePicker = @"datePicker";
//NSString *const kDate = @"date";
//NSString *const kTime = @"time";
//NSString *const kDateTime = @"dateTime";
//NSString *const kCountDownTimer = @"countDownTimer";
//NSString *const kSelectorActionSheet = @"selectorActionSheet";



static NSString * const kCustomRowWeekdays = @"CustomRowWeekdays";

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        [self initializeForm];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self){
        [self initializeForm];
    }
    return self;
}


- (void)initializeForm {
    coreDataService = [[CoreDataService alloc] init];
    [coreDataService initialize];
	 XLFormDescriptor * form;
	 XLFormSectionDescriptor * section;
	 XLFormRowDescriptor * row;
	 NSString *sep = @"#";
	 NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:sep];
	 NSArray *temp=[NSArray alloc] ;
	// Configuration section
	
 //   section.footerTitle = @"Changing the Settings values you will navigate differently";
	
	  NSUserDefaults *Defaults = [NSUserDefaults standardUserDefaults];
	training_id = [Defaults objectForKey:@"training_id"] ;
	QuestionsE *questions = (QuestionsE *) [coreDataService getDataFromQuestionsETable:training_id];
	
  form = [XLFormDescriptor formDescriptorWithTitle:@"QUESTIONÁRIO"];
	
	
	////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////e01//////////////////////////////////////////////////
  // First section
 section = [XLFormSectionDescriptor formSectionWithTitle:@"1) Você pratica alguma atividade física?"];
			[form addFormSection:section];
			XLFormRowDescriptor* atividadeRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"e01"
																										 rowType:XLFormRowDescriptorTypeSelectorActionSheet
																											title:@"Selecione"];
	
			atividadeRow.selectorOptions = @[@"Não", @"Sim"];
	
	
	      if(questions.e01!=nil)
	      	temp=[questions.e01 componentsSeparatedByCharactersInSet:set];
			if(questions.e01!=nil)
				atividadeRow.value = temp[0];
			else
				atividadeRow.value = @"Não";
	
	
			[section addFormRow:atividadeRow];

	
			row = [XLFormRowDescriptor formRowDescriptorWithTag:@"e01.1"
																	  rowType:XLFormRowDescriptorTypeText
																		 title:@"Qual?"];
			row.hidden = [NSString stringWithFormat:@"NOT $%@.value contains 'Sim'", atividadeRow];
			if(questions.e01!=nil)
			{
				if([temp count]>=2)
					row.value = temp[1];
			}
			else
				row.value = @"";
	
			[section addFormRow:row];
	
			row = [XLFormRowDescriptor formRowDescriptorWithTag:@"e01.2"
																	  rowType:XLFormRowDescriptorTypeText
																		 title:@"Há quanto tempo?"];
			row.hidden = [NSString stringWithFormat:@"NOT $%@.value contains 'Sim'", atividadeRow];
			if(questions.e01!=nil)
			{
				if([temp count]>=3)
					row.value = temp[2];
			}
			else
				row.value = @"";
	
			[section addFormRow:row];
	
	
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////e02//////////////////////////////////////////////////
  // First section
  section = [XLFormSectionDescriptor formSectionWithTitle:@"2) Qual sua disponibilidade semanal para treinos?"];
  [form addFormSection:section];
  // Title
  row = [XLFormRowDescriptor formRowDescriptorWithTag:@"e02" rowType:XLFormRowDescriptorTypeName];
  [row.cellConfigAtConfigure setObject:@"Sua resposta" forKey:@"textField.placeholder"];
  if(questions.e02!=nil)
		row.value = questions.e02;
	else
		row.value = @"";
	
  [section addFormRow:row];

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////e03//////////////////////////////////////////////////
// Section Weekdays
    section = [XLFormSectionDescriptor formSectionWithTitle:@"3) Quais os dias disponíveis da semana para treinos?"];
    [form addFormSection:section];
	
    // WeekDays
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"e03" rowType:XLFormRowDescriptorTypeWeekDays];
    row.value =  @{
                   kSunday: @([questions.e03 containsString:@"Domingo"]),
                   kMonday: @([questions.e03 containsString:@"Segunda"]),
                   kTuesday: @([questions.e03 containsString:@"Terca"]),
                   kWednesday: @([questions.e03 containsString:@"Quarta"]),
                   kThursday: @([questions.e03 containsString:@"Quinta"]),
                   kFriday: @([questions.e03 containsString:@"Sexta"]),
                   kSaturday: @([questions.e03 containsString:@"Sabado"])
                   };
    [section addFormRow:row];
	



////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////e04//////////////////////////////////////////////////
    // 3 section
  section = [XLFormSectionDescriptor formSectionWithTitle:@"4) Quais os horários de sua preferência?"];
  [form addFormSection:section];
	
   // Selector Action Sheet
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"e04" rowType:XLFormRowDescriptorTypeSelectorActionSheet title:@"Sua Escolha:"];
    row.selectorOptions = @[[XLFormOptionsObject formOptionsObjectWithValue:@"Manhã" displayText:@"Manhã"],
    								 [XLFormOptionsObject formOptionsObjectWithValue:@"Tarde" displayText:@"Tarde"],
                            [XLFormOptionsObject formOptionsObjectWithValue:@"Noite" displayText:@"Noite"],
									 
                            ];
	
	    if(questions.e04!=nil)
				row.value = [XLFormOptionsObject formOptionsObjectWithValue:questions.e04 displayText:questions.e04];
			else
				row.value = [XLFormOptionsObject formOptionsObjectWithValue:@"Manhã" displayText:@"Manhã"];
	
		 [section addFormRow:row];
	
	
	
	////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////e09//////////////////////////////////////////////////
  // First section
  section = [XLFormSectionDescriptor formSectionWithTitle:@"5) Que tipo de lugares pretende realizar seu treino?	Academia, em casa, parque, praia..."];
  [form addFormSection:section];
  // Title
  row = [XLFormRowDescriptor formRowDescriptorWithTag:@"e05"
																	  rowType:XLFormRowDescriptorTypeTextView
																		 ];
	 [row.cellConfigAtConfigure setObject:@"Sua resposta" forKey:@"textView.placeholder"];
  if(questions.e05!=nil)
		row.value = questions.e05;
	else
		row.value = @"";
	
  [section addFormRow:row];
	
	
  ////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////e06//////////////////////////////////////////////////
			section = [XLFormSectionDescriptor formSectionWithTitle:@"6) Você pratica algum esporte específico?"];
			[form addFormSection:section];
			XLFormRowDescriptor* esporteRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"e06"
																										 rowType:XLFormRowDescriptorTypeSelectorActionSheet
																											title:@"Selecione"];
	
	
			esporteRow.selectorOptions = @[@"Não", @"Sim"];
	
	      if(questions.e06!=nil)
	      	temp=[questions.e06 componentsSeparatedByCharactersInSet:set];
	
			if(questions.e06!=nil)
				esporteRow.value = temp[0];
			else
				esporteRow.value = @"Não";
	
			[section addFormRow:esporteRow];

	
			row = [XLFormRowDescriptor formRowDescriptorWithTag:@"e06.1"
																	  rowType:XLFormRowDescriptorTypeText
																		 title:@"Qual Esporte?"];
			row.hidden = [NSString stringWithFormat:@"NOT $%@.value contains 'Sim'", esporteRow];
	
			if(questions.e06!=nil)
			{
				if([temp count]>=2)
					row.value=temp[1];
			}
			else
				row.value=@"";
			[section addFormRow:row];
	
			row = [XLFormRowDescriptor formRowDescriptorWithTag:@"e06.2"
																	  rowType:XLFormRowDescriptorTypeText
																		 title:@"Há quanto tempo?"];
			row.hidden = [NSString stringWithFormat:@"NOT $%@.value contains 'Sim'", esporteRow];
			if(questions.e06!=nil)
			{
	      	if([temp count]>=3)
					row.value=temp[2];
			}
			else
				row.value=@"";
	
			[section addFormRow:row];


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////e07//////////////////////////////////////////////////
			section = [XLFormSectionDescriptor formSectionWithTitle:@"7) Existe histórico de doenças na família?"];
			[form addFormSection:section];
			XLFormRowDescriptor* doencaRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"e07"
																										 rowType:XLFormRowDescriptorTypeSelectorActionSheet
																											title:@"Selecione"];
			doencaRow.selectorOptions = @[@"Não", @"Sim"];
	
			if(questions.e07!=nil)
	      	temp=[questions.e07 componentsSeparatedByCharactersInSet:set];
	
			if(questions.e07!=nil)
				doencaRow.value = temp[0];
			else
				doencaRow.value = @"Não";
	
	
			[section addFormRow:doencaRow];

	
			row = [XLFormRowDescriptor formRowDescriptorWithTag:@"e07.1"
																	  rowType:XLFormRowDescriptorTypeText
																		 title:@"Qual doença?"];
			row.hidden = [NSString stringWithFormat:@"NOT $%@.value contains 'Sim'", doencaRow];
	
	
	
	      if(questions.e07!=nil)
	      {
				if([temp count]>=2)
					row.value=temp[1];
			}
			else
				row.value=@"";
	
	
			[section addFormRow:row];
	
			row = [XLFormRowDescriptor formRowDescriptorWithTag:@"e07.2"
																	  rowType:XLFormRowDescriptorTypeText
																		 title:@"Qual parentesco?"];
			row.hidden = [NSString stringWithFormat:@"NOT $%@.value contains 'Sim'", doencaRow];
	
	
	
	      if(questions.e07!=nil)
	      {
				if([temp count]>=2)
					row.value=temp[1];
			}
			else
				row.value=@"";
	
	
			[section addFormRow:row];
	
	
	////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////e08//////////////////////////////////////////////////
			section = [XLFormSectionDescriptor formSectionWithTitle:@"8) Você sofre de alguma doença? Exemplos: Diabetes, Hipertensão, Doenças Coronarianas, Derrame, Câncer, Obesidade."];
			[form addFormSection:section];
			XLFormRowDescriptor* doenca2Row = [XLFormRowDescriptor formRowDescriptorWithTag:@"e08"
																										 rowType:XLFormRowDescriptorTypeSelectorActionSheet
																											title:@"Selecione"];
			doenca2Row.selectorOptions = @[@"Não", @"Sim"];
	
	      if(questions.e08!=nil)
	      	temp=[questions.e08 componentsSeparatedByCharactersInSet:set];
	
			if(questions.e08!=nil)
				doenca2Row.value = temp[0];
			else
				doenca2Row.value = @"Não";
	
	
			[section addFormRow:doenca2Row];

	
			row = [XLFormRowDescriptor formRowDescriptorWithTag:@"e08.1"
																	  rowType:XLFormRowDescriptorTypeText
																		 title:@"Qual?"];
			row.hidden = [NSString stringWithFormat:@"NOT $%@.value contains 'Sim'", doenca2Row];
			if(questions.e08!=nil)
			{
				if([temp count]>=2)
					row.value=temp[1];
			}
			else
				row.value=@"";
	
			[section addFormRow:row];
	
	
			/////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////e09//////////////////////////////////////////////////
			section = [XLFormSectionDescriptor formSectionWithTitle:@"9) Sofreu algum acidente ou lesão?"];
			[form addFormSection:section];
			XLFormRowDescriptor* lesaoRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"e09"
																										 rowType:XLFormRowDescriptorTypeSelectorActionSheet
																											title:@"Selecione"];
			lesaoRow.selectorOptions = @[@"Não", @"Sim"];
	
			if(questions.e09!=nil)
	      	temp=[questions.e09 componentsSeparatedByCharactersInSet:set];
	
			if(questions.e09!=nil)
				lesaoRow.value = temp[0];
			else
				lesaoRow.value = @"Não";
			[section addFormRow:lesaoRow];

			row = [XLFormRowDescriptor formRowDescriptorWithTag:@"e09.1"
																	  rowType:XLFormRowDescriptorTypeText
																		 title:@"Há quanto tempo?"];
			row.hidden = [NSString stringWithFormat:@"NOT $%@.value contains 'Sim'", lesaoRow];
			if(questions.e09!=nil)
			{
				if([temp count]>=2)
					row.value = temp[1];
			}
			else
				row.value = @"";

	
			[section addFormRow:row];
	
			 row = [XLFormRowDescriptor formRowDescriptorWithTag:@"e09.2"
																	  rowType:XLFormRowDescriptorTypeTextView
																		 ];
	 [row.cellConfigAtConfigure setObject:@"Sua resposta" forKey:@"textView.placeholder"];
			row.hidden = [NSString stringWithFormat:@"NOT $%@.value contains 'Sim'", lesaoRow];
			if(questions.e09!=nil)
			{
				if([temp count]>=3)
					row.value = temp[2];
			}
			else
				row.value = @"";

	
			[section addFormRow:row];


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////e10//////////////////////////////////////////////////
  // First section
  section = [XLFormSectionDescriptor formSectionWithTitle:@"10) O que levou você a procurar o nosso Programa?"];
  [form addFormSection:section];
  // Title
  row = [XLFormRowDescriptor formRowDescriptorWithTag:@"e10"
																	  rowType:XLFormRowDescriptorTypeTextView
																		 ];
	 [row.cellConfigAtConfigure setObject:@"Sua resposta" forKey:@"textView.placeholder"];
  if(questions.e10!=nil)
		row.value = questions.e10;
	else
		row.value = @"";
	
  [section addFormRow:row];
	
  ////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////e11//////////////////////////////////////////////////
  // First section
  section = [XLFormSectionDescriptor formSectionWithTitle:@"11) De 0 a 10 como você classificaria a sua determinação? Comente.."];
  [form addFormSection:section];
  // Title
  row = [XLFormRowDescriptor formRowDescriptorWithTag:@"e11"
																	  rowType:XLFormRowDescriptorTypeTextView
																		 ];
	 [row.cellConfigAtConfigure setObject:@"Sua resposta" forKey:@"textView.placeholder"];
  if(questions.e11!=nil)
		row.value = questions.e11;
	else
		row.value = @"";
	
  [section addFormRow:row];
	
  ////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////e12//////////////////////////////////////////////////
  // First section
  section = [XLFormSectionDescriptor formSectionWithTitle:@"12) Insira aqui o seu treino (caso não esteja treinando atualmente, favor inserir seu ultimo treino)."];
  [form addFormSection:section];
  // Title
 // row = [XLFormRowDescriptor formRowDescriptorWithTag:@"q43" rowType:XLFormRowDescriptorTypeTextView];
	
	row = [XLFormRowDescriptor formRowDescriptorWithTag:@"e12"
																	  rowType:XLFormRowDescriptorTypeTextView
																		 ];
	 [row.cellConfigAtConfigure setObject:@"Sua resposta" forKey:@"textView.placeholder"];
  if(questions.e12!=nil)
		row.value = questions.e12;
	else
		row.value = @"";
	
  [section addFormRow:row];
	
	
	////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////e13//////////////////////////////////////////////////
  // First section
  section = [XLFormSectionDescriptor formSectionWithTitle:@"13) Use esse espaço para suas considerações e ou observações adicionais."];
  [form addFormSection:section];
  // Title
 // row = [XLFormRowDescriptor formRowDescriptorWithTag:@"q43" rowType:XLFormRowDescriptorTypeTextView];
	
	row = [XLFormRowDescriptor formRowDescriptorWithTag:@"e13"
																	  rowType:XLFormRowDescriptorTypeTextView
																		 ];
	 [row.cellConfigAtConfigure setObject:@"Sua resposta" forKey:@"textView.placeholder"];
  if(questions.e13!=nil)
		row.value = questions.e13;
	else
		row.value = @"";
	
  [section addFormRow:row];
	
	
	
	
	

  self.form = form;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)savePressed:(UIBarButtonItem * __unused)button
{
    NSArray * validationErrors = [self formValidationErrors];
    if (validationErrors.count > 0){
        [self showFormValidationError:[validationErrors firstObject]];
        return;
    }
    [self.tableView endEditing:YES];
	
     NSMutableDictionary * result = [NSMutableDictionary dictionary];
 for (XLFormSectionDescriptor * section in self.form.formSections) {
     if (!section.isMultivaluedSection){
         for (XLFormRowDescriptor * row in section.formRows) {
             if (row.tag && ![row.tag isEqualToString:@""]){
                 [result setObject:(row.value ?: [NSNull null]) forKey:row.tag];
             }
         }
     }
     else{
         NSMutableArray * multiValuedValuesArray = [NSMutableArray new];
         for (XLFormRowDescriptor * row in section.formRows) {
             if (row.value){
                 [multiValuedValuesArray addObject:row.value];
             }
         }
         [result setObject:multiValuedValuesArray forKey:section.multivaluedTag];
     }
 }
	

	
    NSDictionary *dict = [self formValues];
     NSDictionary *dict2 = [self httpParameters];
	
	NSDictionary *weekdays=[dict objectForKey:@"e03"];
	
	NSString *Segunda, *Terca, *Quarta, *Quinta, *Sexta, *Sabado, *Domingo;
	if([[weekdays objectForKey:@"monday"]integerValue]==1) Segunda=@"Segunda"; else Segunda=@"";
	if([[weekdays objectForKey:@"tuesday"]integerValue]==1) Terca=@"Terca"; else Terca=@"";
	if([[weekdays objectForKey:@"wednesday"]integerValue]==1) Quarta=@"Quarta"; else Quarta=@"";
	if([[weekdays objectForKey:@"thursday"]integerValue]==1) Quinta=@"Quinta"; else Quinta=@"";
	if([[weekdays objectForKey:@"friday"]integerValue]==1) Sexta=@"Sexta"; else Sexta=@"";
	if([[weekdays objectForKey:@"saturday"]integerValue]==1) Sabado=@"Sabado"; else Sabado=@"";
	if([[weekdays objectForKey:@"sunday"]integerValue]==1) Domingo=@"Domingo"; else Domingo=@"";
	
	
	
//	if([monday boolValue])
//		NSString *segunda=@"Segunda";
//	else
//		NSString *segunda=@"";
	
	
	
	
	
	QuestionsE *questions = (QuestionsE *) [coreDataService getDataFromQuestionsETable:training_id];
	
	questions.qe01=@"Você pratica alguma atividade física? ";
	questions.qe02=@"Qual sua disponibilidade semanal para treinos?";
	questions.qe03=@"Quais os dias disponíveis da semana para treinos?";
	questions.qe04=@"Quais os horários de sua preferência?";
	questions.qe05=@"Que tipo de lugares pretende realizar seu treino?";
	questions.qe06=@"Você pratica algum esporte específico?";
	questions.qe07=@"Existe histórico de doenças na família?";
	questions.qe08=@"Você sofre de alguma doença?";
	questions.qe09=@"já sofreu algum tipo de acidente?";
	questions.qe10=@"O que levou você a procurar o nosso Programa?";
	questions.qe11=@"De 0 a 10 como você classificaria a sua determinação? Comente..";
	questions.qe12=@"Insira aqui o seu treino (caso não esteja treinando atualmente, favor inserir seu ultimo treino).";
   questions.qe13=@"Use esse espaço para suas considerações e ou observações adicionais.";
	questions.qe14=@"";
	questions.qe15=@"";
	questions.qe16=@"";
	questions.qe17=@"";
	questions.qe18=@"";
	questions.qe19=@"";
	questions.qe20=@"";
	
	
	if( [[dict2 objectForKey:@"e01"] isEqualToString:@"Sim"])
	{
		questions.e01 = [@[[dict2 objectForKey:@"e01"] , [dict2 objectForKey:@"e01.1"] , [dict2 objectForKey:@"e01.2"] ] componentsJoinedByString:@"#"];
	}
	else
	{
	   questions.e01 = [@[[dict2 objectForKey:@"e01"], @"", @"" ] componentsJoinedByString:@"#"];
	}
	
	
	questions.e02=[dict2 objectForKey:@"e02"];
	questions.e03 = [@[Segunda, Terca, Quarta, Quinta, Sexta, Sabado, Domingo  ] componentsJoinedByString:@" "];
	questions.e04=[dict2 objectForKey:@"e04"];
	questions.e05 =[dict2 objectForKey:@"e05"];
	
	
	if( [[dict2 objectForKey:@"e06"] isEqualToString:@"Sim"])
	{
		questions.e06 = [@[[dict2 objectForKey:@"e06"] , [dict2 objectForKey:@"e06.1"] , [dict2 objectForKey:@"e06.2"] ] componentsJoinedByString:@"#"];
	}
	else
	{
	   questions.e06 = [@[[dict2 objectForKey:@"e06"], @"", @"" ] componentsJoinedByString:@"#"];
	}
	
	if( [[dict2 objectForKey:@"e07"] isEqualToString:@"Sim"])
	{
		questions.e07 = [@[[dict2 objectForKey:@"e07"] , [dict2 objectForKey:@"e07.1"], [dict2 objectForKey:@"e07.2"]] componentsJoinedByString:@"#"];
	}
	else
	{
	   questions.e07 = [@[[dict2 objectForKey:@"e07"], @"", @"" ] componentsJoinedByString:@"#"];
	}
	
	if( [[dict2 objectForKey:@"e08"] isEqualToString:@"Sim"])
	{
		questions.e08 = [@[[dict2 objectForKey:@"e08"] , [dict2 objectForKey:@"e08.1"] ] componentsJoinedByString:@"#"];
	}
	else
	{
	   questions.e08 = [@[[dict2 objectForKey:@"e08"], @"", @"" ] componentsJoinedByString:@"#"];
	}
	
	if( [[dict2 objectForKey:@"e09"] isEqualToString:@"Sim"])
	{
		questions.e09 = [@[[dict2 objectForKey:@"e09"] , [dict2 objectForKey:@"e09.1"] , [dict2 objectForKey:@"e09.2"] ] componentsJoinedByString:@"#"];
	}
	else
	{
	   questions.e09 = [@[[dict2 objectForKey:@"e09"], @"", @"" ] componentsJoinedByString:@"#"];
	}
	questions.e10 =[dict2 objectForKey:@"e10"];
	questions.e11 =[dict2 objectForKey:@"e11"];
	questions.e12 =[dict2 objectForKey:@"e12"];
	questions.e13 =[dict2 objectForKey:@"e13"];
	questions.e14=@"";
	questions.e15=@"";
	questions.e16=@"";
	questions.e17=@"";
	questions.e18=@"";
	questions.e19=@"";
	questions.e20=@"";
	questions.estatus=STR_ANDAMENTO;
	

	
	[coreDataService saveData];
	
	dispatch_async(dispatch_get_main_queue(), ^{
		
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:kTEXT_ALERT_TITLE
                                                  message:@"Deseja concluir e enviar suas respostas agora?"
                                                  preferredStyle:UIAlertControllerStyleAlert];
#ifdef NEW_STYLE
            alertController.view.tintColor=UIColorFromRGB(kPRIMARY_COLOR);
#endif
            UIAlertAction *actionYES = [UIAlertAction actionWithTitle:@"Sim, enviar agora"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action){
																					  
                                                                 [self enviarPreferencias];
																					  [alertController dismissViewControllerAnimated:YES completion:nil];
																					  
                                                              }];
		
            UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Enviar depois"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * action){
                     
                                                                     [alertController dismissViewControllerAnimated:YES completion:nil];
																						  
                                                                 }];
		
				[alertController addAction:actionYES];
            [alertController addAction:actionCancel];
		
		
            [self presentViewController:alertController animated:YES completion:nil];
        });
	
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)enviarPreferencias
{
	 QuestionsE *questions = (QuestionsE *) [coreDataService getDataFromQuestionsETable:training_id];

    [SVProgressHUD showWithStatus:@"Enviando suas respostas" maskType:SVProgressHUDMaskTypeGradient];
	
     // Cria um operation manager para realizar a solicitação via POST.
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//	 [manager.requestSerializer setTimeoutInterval:AFHHTTP_TIMEOUT];
 //   NSUserDefaults *Defaults = [NSUserDefaults standardUserDefaults];
	
    // Monta a string de acesso a validação do login.
    NSMutableString *urlString = [[NSMutableString alloc] init];
    [urlString appendString:kBASE_URL_MOBITRAINER];
    [urlString appendString:@"api/anamnese/setanswers"];
	User *userData = (User *) [coreDataService getDataFromUserTable];
	
    
	
	
     // Parametros validados.
    NSDictionary *parameters = @{
                                 @"apikey":API_KEY_TRAINER,
                                 @"trainee_email":userData.email,
                                 @"inapptraining_id":training_id,
											@"qe01":questions.qe01 ,
											@"qe02":questions.qe02 ,
											@"qe03":questions.qe03,
											@"qe04":questions.qe04 ,
											@"qe05":questions.qe05 ,
											@"qe06":questions.qe06 ,
											@"qe07":questions.qe07 ,
											@"qe08":questions.qe08 ,
											@"qe09":questions.qe09 ,
											@"qe10":questions.qe10 ,
											@"qe11":questions.qe11 ,
											@"qe12":questions.qe12 ,
											@"qe13":questions.qe13 ,
											@"qe14":questions.qe14 ,
											@"qe15":questions.qe15 ,
											@"qe16":questions.qe16 ,
											@"qe17":questions.qe17 ,
											@"qe18":questions.qe18 ,
											@"qe19":questions.qe19 ,
											@"qe20":questions.qe20 ,
											@"ae01":questions.e01 ,
											@"ae02":questions.e02 ,
											@"ae03":questions.e03 ,
											@"ae04":questions.e04 ,
											@"ae05":questions.e05 ,
											@"ae06":questions.e06 ,
											@"ae07":questions.e07 ,
											@"ae08":questions.e08 ,
											@"ae09":questions.e09 ,
											@"ae10":questions.e10 ,
											@"ae11":questions.e11 ,
											@"ae12":questions.e12 ,
											@"ae13":questions.e13 ,
											@"ae14":questions.e14 ,
											@"ae15":questions.e15 ,
											@"ae16":questions.e16 ,
											@"ae17":questions.e17 ,
											@"ae18":questions.e18 ,
											@"ae19":questions.e19 ,
											@"ae20":questions.e20
											
											
                                 };
	
	
    // Realiza o POST das informações e aguarda o retorno.
     AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
			[manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
			NSString *path=[[NSString alloc]initWithFormat:@"%@",urlString];
			[manager POST:[NSURL URLWithString:path].absoluteString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
         if (![[responseObject objectForKey:@"response_error"] boolValue])
        {
			  
            questions.estatus=STR_CONCLUIDO;
			  
            [coreDataService saveData];
			  
			  
            [SVProgressHUD showSuccessWithStatus:@"Respostas registradas com sucesso!" maskType:SVProgressHUDMaskTypeGradient];
			   [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [SVProgressHUD dismiss];
			  
                    [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                                      AndText:kTEXT_SERVER_ERROR_DEFAULT
                                  AndTargetVC:self];
			  
			}
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		
        NSLog(@"Error: %@", error);
		
        [SVProgressHUD dismiss];
		
        [utils showAlertWithTitle:kTEXT_ALERT_TITLE
                          AndText:kTEXT_SERVER_ERROR_DEFAULT
                      AndTargetVC:self];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=NOME_APLICATIVO;
    // Do any additional setup after loading the view.
	
	utils = [[UtilityClass alloc] init];
	
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePressed:)];
	
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

