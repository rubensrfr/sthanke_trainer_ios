//
//  parQViewController.m
//
//
//  Created by Rubens Rosa on 05/04/2018.
//  Copyright © 2018 4mobi. All rights reserved.
//


#import "parQViewController.h"

@interface parQViewController ()

@end

@implementation parQViewController



//NSString *const kDateInline = @"dateInline";
//NSString *const kTimeInline = @"timeInline";
//NSString *const kDateTimeInline = @"dateTimeInline";
//NSString *const kCountDownTimerInline = @"countDownTimerInline";
//NSString *const kDatePicker = @"datePicker";
//NSString *const kDate = @"date";
//NSString *const kTime = @"time";
//NSString *const kDateTime = @"dateTime";
//NSString *const kCountDownTimer = @"countDownTimer";
////NSString *const kSelectorActionSheet = @"selectorActionSheet";

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


	  NSUserDefaults *Defaults = [NSUserDefaults standardUserDefaults];
	  training_id = [Defaults objectForKey:@"training_id"] ;
	  QuestionsP *questions = (QuestionsP *) [coreDataService getDataFromQuestionsPTable:training_id];
	
  form = [XLFormDescriptor formDescriptorWithTitle:@"PAR Q"];
	
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////p01//////////////////////////////////////////////////
	
	  section = [XLFormSectionDescriptor formSectionWithTitle:@"1) Alguma vez um médico lhe disse que você possui um problema do coração e lhe recomendou que só fizesse atividade física sob supervisão médica?"];
	  [form addFormSection:section];
	
		// Selector Action Sheet
		 row = [XLFormRowDescriptor formRowDescriptorWithTag:@"p01" rowType:XLFormRowDescriptorTypeSelectorActionSheet title:@"Sua Escolha:"];
		 row.selectorOptions = @[[XLFormOptionsObject formOptionsObjectWithValue:@"Não" displayText:@"Não"],
										 [XLFormOptionsObject formOptionsObjectWithValue:@"Sim" displayText:@"Sim"],
										 
										 ];
		 row.value = [XLFormOptionsObject formOptionsObjectWithValue:@"Não" displayText:@"Não"];
		 if(questions.p01!=nil)
	      	temp=[questions.p01 componentsSeparatedByCharactersInSet:set];
	
			if(questions.p01!=nil)
				row.value = temp[0];
			else
			   row.value = @"Não";
	
		 [section addFormRow:row];
	
	
	
	


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////p02//////////////////////////////////////////////////
	
	  section = [XLFormSectionDescriptor formSectionWithTitle:@"2) Você sente dor no peito, causada pela prática de atividade física?"];
	  [form addFormSection:section];
	
		// Selector Action Sheet
		 row = [XLFormRowDescriptor formRowDescriptorWithTag:@"p02" rowType:XLFormRowDescriptorTypeSelectorActionSheet title:@"Sua Escolha:"];
		 row.selectorOptions = @[[XLFormOptionsObject formOptionsObjectWithValue:@"Não" displayText:@"Não"],
										 [XLFormOptionsObject formOptionsObjectWithValue:@"Sim" displayText:@"Sim"],
										 
										 ];
		 row.value = [XLFormOptionsObject formOptionsObjectWithValue:@"Não" displayText:@"Não"];
		 if(questions.p02!=nil)
	      	temp=[questions.p02 componentsSeparatedByCharactersInSet:set];
	
			if(questions.p02!=nil)
				row.value = temp[0];
			else
			   row.value = @"Não";
		 [section addFormRow:row];
	
	
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////p03//////////////////////////////////////////////////
	
	  section = [XLFormSectionDescriptor formSectionWithTitle:@"3) Você sentiu dor no peito no último mês?"];
	  [form addFormSection:section];
	
		// Selector Action Sheet
		 row = [XLFormRowDescriptor formRowDescriptorWithTag:@"p03" rowType:XLFormRowDescriptorTypeSelectorActionSheet title:@"Sua Escolha:"];
		 row.selectorOptions = @[[XLFormOptionsObject formOptionsObjectWithValue:@"Não" displayText:@"Não"],
										 [XLFormOptionsObject formOptionsObjectWithValue:@"Sim" displayText:@"Sim"],
										 
										 ];
		 row.value = [XLFormOptionsObject formOptionsObjectWithValue:@"Não" displayText:@"Não"];
		 if(questions.p03!=nil)
	      	temp=[questions.p03 componentsSeparatedByCharactersInSet:set];
	
			if(questions.p03!=nil)
				row.value = temp[0];
			else
			   row.value = @"Não";
	
		 [section addFormRow:row];
	
	
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////p04///////////////////////////////////////////////
	
	  section = [XLFormSectionDescriptor formSectionWithTitle:@"4) Você tende a perder a consciência ou cair, como resultado de tonteira ou desmaio?"];
	  [form addFormSection:section];
	
		// Selector Action Sheet
		 row = [XLFormRowDescriptor formRowDescriptorWithTag:@"p04" rowType:XLFormRowDescriptorTypeSelectorActionSheet title:@"Sua Escolha:"];
		 row.selectorOptions = @[[XLFormOptionsObject formOptionsObjectWithValue:@"Não" displayText:@"Não"],
										 [XLFormOptionsObject formOptionsObjectWithValue:@"Sim" displayText:@"Sim"],
										 
										 ];
		 row.value = [XLFormOptionsObject formOptionsObjectWithValue:@"Não" displayText:@"Não"];
		 if(questions.p04!=nil)
	      	temp=[questions.p04 componentsSeparatedByCharactersInSet:set];
	
			if(questions.p04!=nil)
				row.value = temp[0];
			else
			   row.value = @"Não";
		 [section addFormRow:row];
	
	
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////p05///////////////////////////////////////////////
	
	  section = [XLFormSectionDescriptor formSectionWithTitle:@"5) Você tem algum problema ósseo ou muscular que poderia ser agravado com a prática de atividade física?"];
	  [form addFormSection:section];
	
		// Selector Action Sheet
		 row = [XLFormRowDescriptor formRowDescriptorWithTag:@"p05" rowType:XLFormRowDescriptorTypeSelectorActionSheet title:@"Sua Escolha:"];
		 row.selectorOptions = @[[XLFormOptionsObject formOptionsObjectWithValue:@"Não" displayText:@"Não"],
										 [XLFormOptionsObject formOptionsObjectWithValue:@"Sim" displayText:@"Sim"],
										 
										 ];
		 row.value = [XLFormOptionsObject formOptionsObjectWithValue:@"Não" displayText:@"Não"];
		 if(questions.p05!=nil)
	      	temp=[questions.p05 componentsSeparatedByCharactersInSet:set];
	
			if(questions.p05!=nil)
				row.value = temp[0];
			else
			   row.value = @"Não";
		 [section addFormRow:row];
	
	
	
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////p06///////////////////////////////////////////////
	
	  section = [XLFormSectionDescriptor formSectionWithTitle:@"6) Algum médico já lhe recomendou o uso de medicamentos para a sua pressão arterial, para circulação ou coração?"];
	  [form addFormSection:section];
	
		// Selector Action Sheet
		 row = [XLFormRowDescriptor formRowDescriptorWithTag:@"p06" rowType:XLFormRowDescriptorTypeSelectorActionSheet title:@"Sua Escolha:"];
		 row.selectorOptions = @[[XLFormOptionsObject formOptionsObjectWithValue:@"Não" displayText:@"Não"],
										 [XLFormOptionsObject formOptionsObjectWithValue:@"Sim" displayText:@"Sim"],
										 
										 ];
		 row.value = [XLFormOptionsObject formOptionsObjectWithValue:@"Não" displayText:@"Não"];
		 if(questions.p06!=nil)
	      	temp=[questions.p05 componentsSeparatedByCharactersInSet:set];
	
			if(questions.p06!=nil)
				row.value = temp[0];
			else
			   row.value = @"Não";
		 [section addFormRow:row];
	
	
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////p07///////////////////////////////////////////////
	
	  section = [XLFormSectionDescriptor formSectionWithTitle:@"7) Você tem consciência, através da sua própria experiência ou aconselhamento médico, de alguma outra razão física que impeça sua prática de atividade física sem supervisão médica?"];
	  [form addFormSection:section];
	
		// Selector Action Sheet
		 row = [XLFormRowDescriptor formRowDescriptorWithTag:@"p07" rowType:XLFormRowDescriptorTypeSelectorActionSheet title:@"Sua Escolha:"];
		 row.selectorOptions = @[[XLFormOptionsObject formOptionsObjectWithValue:@"Não" displayText:@"Não"],
										 [XLFormOptionsObject formOptionsObjectWithValue:@"Sim" displayText:@"Sim"],
										 
										 ];
		 row.value = [XLFormOptionsObject formOptionsObjectWithValue:@"Não" displayText:@"Não"];
		 if(questions.p07!=nil)
	      	temp=[questions.p07 componentsSeparatedByCharactersInSet:set];
	
			if(questions.p07!=nil)
				row.value = temp[0];
			else
			   row.value = @"Não";
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
	

	
	
	 NSDictionary *dict2 = [self httpParameters];
	

	QuestionsP *questions = (QuestionsP *) [coreDataService getDataFromQuestionsPTable:training_id];
	questions.qp01=@"Alguma vez um médico lhe disse que você possui um problema do coração e lhe recomendou que só fizesse atividade física sob supervisão médica?";
	questions.qp02=@"Você sente dor no peito, causada pela prática de atividade física?";
	questions.qp03=@"Você sentiu dor no peito no último mês?";
	questions.qp04=@"Você tende a perder a consciência ou cair, como resultado de tonteira ou desmaio?";
	questions.qp05=@"Você tem algum problema ósseo ou muscular que poderia ser agravado com a prática de atividade física?";
	questions.qp06=@"Algum médico já lhe recomendou o uso de medicamentos para a sua pressão arterial, para circulação ou coração?";
	questions.qp07=@"Você tem consciência, através da sua própria experiência ou aconselhamento médico, de alguma outra razão física que impeça sua prática de atividade física sem supervisão médica?";
	questions.qp08=@"";
	questions.qp09=@"";
	questions.qp10=@"";
	questions.qp11=@"";
	questions.qp12=@"";
	questions.qp13=@"";
	questions.qp14=@"";
	questions.qp15=@"";
	questions.qp16=@"";
	questions.qp17=@"";
	questions.qp18=@"";
	questions.qp19=@"";
	questions.qp20=@"";
	
	questions.p01=[utils checkString:[dict2 objectForKey:@"p01"]];
	questions.p02=[utils checkString:[dict2 objectForKey:@"p02"]];
	questions.p03=[utils checkString:[dict2 objectForKey:@"p03"]];
	questions.p04=[utils checkString:[dict2 objectForKey:@"p04"]];
	questions.p05=[utils checkString:[dict2 objectForKey:@"p05"]];
	questions.p06=[utils checkString:[dict2 objectForKey:@"p06"]];
	questions.p07=[dict2 objectForKey:@"p07"];
	questions.p08=@"";
	questions.p09=@"";
	questions.p10=@"";
	questions.p11=@"";
	questions.p12=@"";
	questions.p13=@"";
	questions.p14=@"";
	questions.p15=@"";
	questions.p16=@"";
	questions.p17=@"";
	questions.p18=@"";
	questions.p19=@"";
	questions.p20=@"";
	questions.pstatus=STR_ANDAMENTO;
	
	
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
																					  
                                                                 [self enviarParQ];
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

- (void)enviarParQ
{
	 QuestionsP *questions = (QuestionsP *) [coreDataService getDataFromQuestionsPTable:training_id];

    [SVProgressHUD showWithStatus:@"Enviando suas respostas" maskType:SVProgressHUDMaskTypeGradient];
	
    // Cria um operation manager para realizar a solicitação via POST.
  //  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	// [manager.requestSerializer setTimeoutInterval:AFHHTTP_TIMEOUT];
	
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
											@"qp01":questions.qp01 ,
											@"qp02":questions.qp02 ,
											@"qp03":questions.qp03 ,
											@"qp04":questions.qp04 ,
											@"qp05":questions.qp05 ,
											@"qp06":questions.qp06 ,
											@"qp07":questions.qp07 ,
											@"qp08":questions.qp08 ,
											@"qp09":questions.qp09 ,
											@"qp10":questions.qp10 ,
											@"qp11":questions.qp11 ,
											@"qp12":questions.qp12 ,
											@"qp13":questions.qp13 ,
											@"qp14":questions.qp14 ,
											@"qp15":questions.qp15 ,
											@"qp16":questions.qp16 ,
											@"qp17":questions.qp17 ,
											@"qp18":questions.qp18 ,
											@"qp19":questions.qp19 ,
											@"qp20":questions.qp20 ,
											@"ap01":questions.p01 ,
											@"ap02":questions.p02 ,
											@"ap03":questions.p03 ,
											@"ap04":questions.p04 ,
											@"ap05":questions.p05 ,
											@"ap06":questions.p06 ,
											@"ap07":questions.p07 ,
											@"ap08":questions.p08 ,
											@"ap09":questions.p09 ,
											@"ap10":questions.p10 ,
											@"ap11":questions.p11 ,
											@"ap12":questions.p12 ,
											@"ap13":questions.p13 ,
											@"ap14":questions.p14 ,
											@"ap15":questions.p15 ,
											@"ap16":questions.p16 ,
											@"ap17":questions.p17 ,
											@"ap18":questions.p18 ,
											@"ap19":questions.p19 ,
											@"ap20":questions.p20
											
											
                                 };
	
	
    // Realiza o POST das informações e aguarda o retorno.
     AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
			[manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
			NSString *path=[[NSString alloc]initWithFormat:@"%@",urlString];
			[manager POST:[NSURL URLWithString:path].absoluteString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
         if (![[responseObject objectForKey:@"response_error"] boolValue])
        {
			  
            questions.pstatus=STR_CONCLUIDO;
			  
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
