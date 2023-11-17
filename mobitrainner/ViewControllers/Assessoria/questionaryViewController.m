//
//  questionaryViewController.m
//
//
//  Created by Rubens Rosa on 29/03/2018.
//  Copyright © 2018 4mobi. All rights reserved.
//

#import "questionaryViewController.h"

@interface questionaryViewController ()

@end

@implementation questionaryViewController



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
	  QuestionsQ *questions = (QuestionsQ *) [coreDataService getDataFromQuestionsQTable:training_id];
	
  form = [XLFormDescriptor formDescriptorWithTitle:@"MEDIDAS"];
	
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////q01///////////////////////////////////////////////
	section = [XLFormSectionDescriptor formSectionWithTitle:@"IMPORTANTE: Envie 4(quatro) fotos de corpo inteiro nos seguintes ângulos:De frente, De costas, De perfil direito (lado), De perfil esquerdo (lado) para o email sthankequestionarios@gmail.com"];
	  [form addFormSection:section];
	
		// Selector Action Sheet
		 row = [XLFormRowDescriptor formRowDescriptorWithTag:@"q01" rowType:XLFormRowDescriptorTypeSelectorActionSheet title:@"Confirma o envio?"];
		 row.selectorOptions = @[[XLFormOptionsObject formOptionsObjectWithValue:@"Não" displayText:@"Não"],
										 [XLFormOptionsObject formOptionsObjectWithValue:@"Sim" displayText:@"Sim"],
										 
										 ];
		 row.value = [XLFormOptionsObject formOptionsObjectWithValue:@"Não" displayText:@"Não"];
		 if(questions.q01!=nil)
	      	temp=[questions.q01 componentsSeparatedByCharactersInSet:set];
	
			if(questions.q01!=nil)
				row.value = temp[0];
			else
			   row.value = @"Não";
	
		 [section addFormRow:row];
	
	
	
	////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////q02///////////////////////////////////////////////
	
	  section = [XLFormSectionDescriptor formSectionWithTitle:@"Medida da Cintura:"];
	  [form addFormSection:section];
	
		// Selector Action Sheet
	
		row = [XLFormRowDescriptor formRowDescriptorWithTag:@"q02" rowType:XLFormRowDescriptorTypeNumber title:@"Cintura(cm)"];
  		[row.cellConfigAtConfigure setObject:@"(cm)" forKey:@"textField.placeholder"];
	
	
		 if(questions.q02!=nil)
			row.value = questions.q02;
		else
			row.value = @"";
		 section.footerTitle = @"COMO MEDIR? \n 1.  O tórax e o abdômen precisam estar descobertos. Homens, sem camisa e mulheres de top (roupa de academia) \n 2.  Localize o ponto mais alto do osso do seu quadril e a parte inferior das suas costelas. \n 3.  Expire normalmente. \n 4.  Coloque uma fita métrica em torno de sua cintura, ou seja, no local que fica no meio do caminho entre esses dois pontos citados acima (é a parte mais estreita do seu tronco). \n 5.  Verifique a sua medida. Faça uma marcação na fita métrica com o dedo para ver o resultado.";
		 [section addFormRow:row];
	
	////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////q03///////////////////////////////////////////////
	
	  section = [XLFormSectionDescriptor formSectionWithTitle:@"Medida do Abdômen:"];
	  [form addFormSection:section];
	
		// Selector Action Sheet
	
		row = [XLFormRowDescriptor formRowDescriptorWithTag:@"q03" rowType:XLFormRowDescriptorTypeNumber title:@"Abdômen(cm)"];
  		[row.cellConfigAtConfigure setObject:@"(cm)" forKey:@"textField.placeholder"];
	
	
		 if(questions.q03!=nil)
			row.value = questions.q03;
		else
			row.value = @"";
		 section.footerTitle = @"COMO MEDIR? \n 1.  O tórax e o abdômen precisam estar descobertos. Homens, sem camisa e mulheres de top (roupa de academia) \n 2.  Posicionar uma fita métrica em volta do abdômen, na altura do umbigo, mantendo a barriga relaxada. A fita métrica não pode ficar muito justa, nem muito frouxa. \n 3.  Relaxe o abdômen e expire. \n 4.  A leitura precisa ser feita na parte da frente do seu corpo. Faça uma marcação na fita métrica com o dedo para ver o resultado.";
		 [section addFormRow:row];
	
	////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////q04///////////////////////////////////////////////
	
	  section = [XLFormSectionDescriptor formSectionWithTitle:@"Medida do Quadril:"];
	  [form addFormSection:section];
	
		// Selector Action Sheet
	
		row = [XLFormRowDescriptor formRowDescriptorWithTag:@"q04" rowType:XLFormRowDescriptorTypeNumber title:@"Quadril(cm)"];
  		[row.cellConfigAtConfigure setObject:@"(cm)" forKey:@"textField.placeholder"];
	
	
		 if(questions.q04!=nil)
			row.value = questions.q04;
		else
			row.value = @"";
		 section.footerTitle = @"COMO MEDIR? \n 1.  Junte os pés \n 2.  Passe a fita métrica em volta do seu quadril. \n 3.  A medida do quadril é realizada a partir da parte mais larga do bumbum (ponto de maior circunferência sobre a região glútea). \n 4.  Faça uma marcação na fita métrica com o dedo para ver o resultado.";
	 [section addFormRow:row];

  self.form = form;
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

/*
#pragma mark - Navigation

// In a storyboard-based aqqlication, you will often want to do a little preparation before navigation
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
	

	
	
	NSDictionary *dict2 = [self httpParameters];
	
	
	QuestionsQ *questions = (QuestionsQ *) [coreDataService getDataFromQuestionsQTable:training_id];
	questions.qq01=@"Pedimos a gentileza de que envie para o email sthankequestionarios@gmail.com 4(quatro) fotos de corpo inteiro nos seguintes ângulos:De frente, De costas, De perfil direito (lado), De perfil esquerdo (lado)";
	questions.qq02=@"Cintura(cm)";
	questions.qq03=@"Abdômen(cm)";
	questions.qq04=@"Quadril(cm)";
	questions.qq05=@"";
	questions.qq06=@"";
	questions.qq07=@"";
	questions.qq08=@"";
	questions.qq09=@"";
	questions.qq10=@"";
	questions.qq11=@"";
	questions.qq12=@"";
	questions.qq13=@"";
	questions.qq14=@"";
	questions.qq15=@"";
	questions.qq16=@"";
	questions.qq17=@"";
	questions.qq18=@"";
	questions.qq19=@"";
	questions.qq20=@"";
	
	
	questions.q01=[dict2 objectForKey:@"q01"];
	questions.q02=[[NSString alloc] initWithFormat:@"%@", [dict2 objectForKey:@"q02"]];
	questions.q03=[[NSString alloc] initWithFormat:@"%@", [dict2 objectForKey:@"q03"]];
	questions.q04=[[NSString alloc] initWithFormat:@"%@", [dict2 objectForKey:@"q04"]];
	questions.q05=@"";
	questions.q06=@"";
	questions.q07=@"";
	questions.q08=@"";
	questions.q09=@"";
	questions.q10=@"";
	questions.q11=@"";
	questions.q12=@"";
	questions.q13=@"";
	questions.q14=@"";
	questions.q15=@"";
	questions.q16=@"";
	questions.q17=@"";
	questions.q18=@"";
	questions.q19=@"";
	questions.q20=@"";
	
	questions.qstatus=STR_ANDAMENTO;
	
	
	[coreDataService saveData];
	
	dispatch_async(dispatch_get_main_queue(), ^{
		
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:kTEXT_ALERT_TITLE
                                                  message:@"Deseja concluir e enviar suas respostas agora?"
                                                  preferredStyle:UIAlertControllerStyleAlert];
#ifdef NEW_STYLE
            alertController.view.tintColor=[UIColor colorNamed: @"myAlertTextColor"];
#endif
            UIAlertAction *actionYES = [UIAlertAction actionWithTitle:@"Sim, enviar agora"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action){
																					  
                                                                 [self enviarQuestionario];
																					  
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

- (void)enviarQuestionario
{
	 QuestionsQ *questions = (QuestionsQ *) [coreDataService getDataFromQuestionsQTable:training_id];

    [SVProgressHUD showWithStatus:@"Enviando suas respostas" maskType:SVProgressHUDMaskTypeGradient];
	
    // Cria um operation manager para realizar a solicitação via POST.
  //  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//	 [manager.requestSerializer setTimeoutInterval:AFHHTTP_TIMEOUT];
	
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
											@"qq01":questions.qq01 ,
											@"qq02":questions.qq02 ,
											@"qq03":questions.qq03 ,
											@"qq04":questions.qq04 ,
											@"qq05":questions.qq05 ,
											@"qq06":questions.qq06 ,
											@"qq07":questions.qq07 ,
											@"qq08":questions.qq08 ,
											@"qq09":questions.qq09 ,
											@"qq10":questions.qq10 ,
											@"qq11":questions.qq11 ,
											@"qq12":questions.qq12 ,
											@"qq13":questions.qq13 ,
											@"qq14":questions.qq14 ,
											@"qq15":questions.qq15 ,
											@"qq16":questions.qq16 ,
											@"qq17":questions.qq17 ,
											@"qq18":questions.qq18 ,
											@"qq19":questions.qq19 ,
											@"qq20":questions.qq20 ,
											@"aq01":questions.q01 ,
											@"aq02":questions.q02 ,
											@"aq03":questions.q03 ,
											@"aq04":questions.q04 ,
											@"aq05":questions.q05 ,
											@"aq06":questions.q06 ,
											@"aq07":questions.q07 ,
											@"aq08":questions.q08 ,
											@"aq09":questions.q09 ,
											@"aq10":questions.q10 ,
											@"aq11":questions.q11 ,
											@"aq12":questions.q12 ,
											@"aq13":questions.q13 ,
											@"aq14":questions.q14 ,
											@"aq15":questions.q15 ,
											@"aq16":questions.q16 ,
											@"aq17":questions.q17 ,
											@"aq18":questions.q18 ,
											@"aq19":questions.q19 ,
											@"aq20":questions.q20
											
											
                                 };
	
	
    // Realiza o POST das informações e aguarda o retorno.
     AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
			[manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
			NSString *path=[[NSString alloc]initWithFormat:@"%@",urlString];
			[manager POST:[NSURL URLWithString:path].absoluteString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
         if (![[responseObject objectForKey:@"response_error"] boolValue])
        {
			  
            questions.qstatus=STR_CONCLUIDO;
			  
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

@end
