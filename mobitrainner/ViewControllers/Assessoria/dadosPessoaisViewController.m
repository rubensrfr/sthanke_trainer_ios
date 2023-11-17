//
//  dadosPessoaisViewController.m
//
//
//  Created by Rubens Rosa on 10/04/2018.
//  Copyright © 2018 4mobi. All rights reserved.
//


#import "dadosPessoaisViewController.h"
#import "XLFormWeekDaysCell.h"

@interface dadosPessoaisViewController ()

@end

@implementation dadosPessoaisViewController


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
	  QuestionsD *questions = (QuestionsD *) [coreDataService getDataFromQuestionsDTable:training_id];
	
  form = [XLFormDescriptor formDescriptorWithTitle:@"QUESTIONÁRIO"];
	
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////q01//////////////////////////////////////////////////
  // First section
  section = [XLFormSectionDescriptor formSectionWithTitle:@"1) Dados Pessoais"];
  [form addFormSection:section];
  // Title
  row = [XLFormRowDescriptor formRowDescriptorWithTag:@"d01" rowType:XLFormRowDescriptorTypeText title:@"Nome:" ];
  //[row.cellConfigAtConfigure setObject:@"Nome" forKey:@"textField.placeholder"];
  if(questions.d01!=nil)
		row.value = questions.d01;
	else
		row.value = @"";
	[section addFormRow:row];
	
	 // Title
 row = [XLFormRowDescriptor formRowDescriptorWithTag:@"d02" rowType:XLFormRowDescriptorTypeText title:@"Sobrenome:"];
  //[row.cellConfigAtConfigure setObject:@"Sobrenome" forKey:@"textField.placeholder"];
  if(questions.d02!=nil)
		row.value = questions.d02;
	else
		row.value = @"";
	[section addFormRow:row];
	
	// Email
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"d03" rowType:XLFormRowDescriptorTypeEmail title:@"Email:"];
   // [row.cellConfigAtConfigure setObject:@"Email" forKey:@"textField.placeholder"];
    // validate the email
    [row addValidator:[XLFormValidator emailValidator]];
    if(questions.d03!=nil)
		row.value = questions.d03;
	else
		row.value = @"";
    [section addFormRow:row];
	
		 // Title
 	row = [XLFormRowDescriptor formRowDescriptorWithTag:@"d04" rowType:XLFormRowDescriptorTypeDateInline title:@"Nascimento"];
//  [row.cellConfigAtConfigure setObject:@"Nascimento" forKey:@"textField.placeholder"];
  if(questions.d04!=nil)
  {
  		// Formata a data para ser apresentada.
    NSDateFormatter *df1 = [[NSDateFormatter alloc] init];
    [df1 setDateFormat: @"yyyy-MM-dd"];
    row.value = [df1 dateFromString:questions.d04];
  }
	else
		row.value = [NSDate new];
	[section addFormRow:row];
	
	
	
	
	// Selector Action Sheet
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"d05" rowType:XLFormRowDescriptorTypeSelectorActionSheet title:@"Sexo:"];
    row.selectorOptions = @[[XLFormOptionsObject formOptionsObjectWithValue:@"Feminino" displayText:@"Feminino"],
    								 [XLFormOptionsObject formOptionsObjectWithValue:@"Masculino" displayText:@"Masculino"],
                            ];
	    if(questions.d05!=nil)
				row.value = [XLFormOptionsObject formOptionsObjectWithValue:questions.d05 displayText:questions.d05];
			else
				row.value = [XLFormOptionsObject formOptionsObjectWithValue:@"Feminino" displayText:@"Feminino"];
	
		 [section addFormRow:row];
	
	
	// Selector Action Sheet
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"d06" rowType:XLFormRowDescriptorTypeSelectorActionSheet title:@"Estado Civil:"];
    row.selectorOptions = @[[XLFormOptionsObject formOptionsObjectWithValue:@"Solteiro" displayText:@"Solteiro"],
    								 [XLFormOptionsObject formOptionsObjectWithValue:@"Casado" displayText:@"Casado"],
                            ];
	    if(questions.d05!=nil)
				row.value = [XLFormOptionsObject formOptionsObjectWithValue:questions.d06 displayText:questions.d06];
			else
				row.value = [XLFormOptionsObject formOptionsObjectWithValue:@"Solteiro" displayText:@"Solteiro"];
	
		 [section addFormRow:row];
	
	row = [XLFormRowDescriptor formRowDescriptorWithTag:@"d07" rowType:XLFormRowDescriptorTypeText title:@"Profissão"];
  [row.cellConfigAtConfigure setObject:@"Profissão" forKey:@"textField.placeholder"];
  if(questions.d07!=nil)
		row.value = questions.d07;
	else
		row.value = @"";
	[section addFormRow:row];
	
	
	
	// Telefone Fixo
	SHSPhoneNumberFormatter *formatter1 = [[SHSPhoneNumberFormatter alloc] init];
	[formatter1 setDefaultOutputPattern:@"(###) ####-####" imagePath:nil];
	row = [XLFormRowDescriptor formRowDescriptorWithTag:@"d08" rowType:XLFormRowDescriptorTypeDecimal title:@"Telefone Fixo:"];
   [row.cellConfigAtConfigure setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
	row.valueFormatter = formatter1;
	row.useValueFormatterDuringInput = YES;
	
  if(questions.d08!=nil)
		row.value = questions.d08;
	else
		row.value = @"";
	[section addFormRow:row];
	
	// Telefone Celular
	SHSPhoneNumberFormatter *formatter2 = [[SHSPhoneNumberFormatter alloc] init];
	[formatter2 setDefaultOutputPattern:@"(###) #####-####" imagePath:nil];
	row = [XLFormRowDescriptor formRowDescriptorWithTag:@"d09" rowType:XLFormRowDescriptorTypeDecimal title:@"Telefone Celular:"];
   [row.cellConfigAtConfigure setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
	row.valueFormatter = formatter2;
	row.useValueFormatterDuringInput = YES;
	
  if(questions.d09!=nil)
		row.value = questions.d09;
	else
		row.value = @"";
	[section addFormRow:row];
	
	
	// Decimal
	row = [XLFormRowDescriptor formRowDescriptorWithTag:@"d10" rowType:XLFormRowDescriptorTypeDecimal title:@"Seu peso:"];
  [row.cellConfigAtConfigure setObject:@"(Kg)" forKey:@"textField.placeholder"];
  if(questions.d10!=nil)
		row.value = questions.d10;
	else
		row.value = @"";
	[section addFormRow:row];
	
	// Decimal
	row = [XLFormRowDescriptor formRowDescriptorWithTag:@"d11" rowType:XLFormRowDescriptorTypeDecimal title:@"Sua altura:"];
  [row.cellConfigAtConfigure setObject:@"(m)" forKey:@"textField.placeholder"];
  if(questions.d11!=nil)
		row.value = questions.d11;
	else
		row.value = @"";
	[section addFormRow:row];
	
	// First section
  section = [XLFormSectionDescriptor formSectionWithTitle:@"2) Endereço Completo"];
  [form addFormSection:section];
  // Title
  row = [XLFormRowDescriptor formRowDescriptorWithTag:@"d12" rowType:XLFormRowDescriptorTypeText title:@"Logradouro:"];
 // [row.cellConfigAtConfigure setObject:@"Rua/Av:" forKey:@"textField.placeholder"];
  if(questions.d12!=nil)
		row.value = questions.d12;
	else
		row.value = @"";
	[section addFormRow:row];
	
	// Title
  row = [XLFormRowDescriptor formRowDescriptorWithTag:@"d13" rowType:XLFormRowDescriptorTypeText title:@"Bairro:"];
 // [row.cellConfigAtConfigure setObject:@"Rua/Av:" forKey:@"textField.placeholder"];
  if(questions.d13!=nil)
		row.value = questions.d13;
	else
		row.value = @"";
	[section addFormRow:row];
	
	// Title
  row = [XLFormRowDescriptor formRowDescriptorWithTag:@"d14" rowType:XLFormRowDescriptorTypeText title:@"Cidade:"];
 // [row.cellConfigAtConfigure setObject:@"Rua/Av:" forKey:@"textField.placeholder"];
  if(questions.d14!=nil)
		row.value = questions.d14;
	else
		row.value = @"";
	[section addFormRow:row];
	
	// Title
  row = [XLFormRowDescriptor formRowDescriptorWithTag:@"d15" rowType:XLFormRowDescriptorTypeText title:@"Estado:"];
 // [row.cellConfigAtConfigure setObject:@"Rua/Av:" forKey:@"textField.placeholder"];
  if(questions.d15!=nil)
		row.value = questions.d15;
	else
		row.value = @"";
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
	

	QuestionsD *questions = (QuestionsD *) [coreDataService getDataFromQuestionsDTable:training_id];
	questions.qd01=@"Nome";
	questions.qd02=@"Sobrenome";
	questions.qd03=@"E-mail";
	questions.qd04=@"Data de nascimento";
	questions.qd05=@"Sexo";
	questions.qd06=@"Estado civil";
	questions.qd07=@"Profissão";
	questions.qd08=@"Telefone Fixo";
	questions.qd09=@"Telefone Celular";
	questions.qd10=@"Peso";
	questions.qd11=@"Altura";
	questions.qd12=@"Endereço";
	questions.qd13=@"Bairro";
	questions.qd14=@"Cidade";
	questions.qd15=@"Estado";
	questions.qd16=@"Filhos";
	questions.qd17=@"Principais Objetivos";
	questions.qd18=@"";
	questions.qd19=@"";
	questions.qd20=@"";
	
	
	questions.d01=[dict2 objectForKey:@"d01"];
	questions.d02=[dict2 objectForKey:@"d02"];
	questions.d03=[dict2 objectForKey:@"d03"];
	
	
	// Formata a data para enviar ao servidor.
   NSDateFormatter *df = [[NSDateFormatter alloc] init];
   [df setDateFormat: @"yyyy-MM-dd"];
   questions.d04 = [df stringFromDate:[dict2 objectForKey:@"d04"]];
	questions.d05=[dict2 objectForKey:@"d05"];
	questions.d06=[dict2 objectForKey:@"d06"];
	questions.d07=[dict2 objectForKey:@"d07"];
	questions.d08=[[NSString alloc] initWithFormat:@"%@", [dict2 objectForKey:@"d08"]];
	questions.d09=[[NSString alloc] initWithFormat:@"%@", [dict2 objectForKey:@"d09"]];
	questions.d10=[[NSString alloc] initWithFormat:@"%@", [dict2 objectForKey:@"d10"]];
	questions.d11=[[NSString alloc] initWithFormat:@"%@", [dict2 objectForKey:@"d11"]];
	questions.d12=[dict2 objectForKey:@"d12"];;
	questions.d13=[dict2 objectForKey:@"d13"];;
	questions.d14=[dict2 objectForKey:@"d14"];;
	questions.d15=[dict2 objectForKey:@"d15"];;
	questions.d16=@"";
	questions.d17=@"";
	questions.d18=@"";
	questions.d19=@"";
	questions.d20=@"";
	questions.dstatus=STR_ANDAMENTO;
	
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
																					  
                                                                 [self enviarDadosPessoais];
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

- (void)enviarDadosPessoais
{
	 QuestionsD *questions = (QuestionsD *) [coreDataService getDataFromQuestionsDTable:training_id];

    [SVProgressHUD showWithStatus:@"Enviando suas respostas" maskType:SVProgressHUDMaskTypeGradient];
	
    // Cria um operation manager para realizar a solicitação via POST.
 //   AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
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
											@"qd01":questions.qd01 ,
											@"qd02":questions.qd02 ,
											@"qd03":questions.qd03 ,
											@"qd04":questions.qd04 ,
											@"qd05":questions.qd05 ,
											@"qd06":questions.qd06 ,
											@"qd07":questions.qd07 ,
											@"qd08":questions.qd08 ,
											@"qd09":questions.qd09 ,
											@"qd10":questions.qd10 ,
											@"qd11":questions.qd11 ,
											@"qd12":questions.qd12 ,
											@"qd13":questions.qd13 ,
											@"qd14":questions.qd14 ,
											@"qd15":questions.qd15 ,
											@"qd16":questions.qd16 ,
											@"qd17":questions.qd17 ,
											@"qd18":questions.qd18 ,
											@"qd19":questions.qd19 ,
											@"qd20":questions.qd20 ,
											@"ad01":questions.d01 ,
											@"ad02":questions.d02 ,
											@"ad03":questions.d03 ,
											@"ad04":questions.d04 ,
											@"ad05":questions.d05 ,
											@"ad06":questions.d06 ,
											@"ad07":questions.d07 ,
											@"ad08":questions.d08 ,
											@"ad09":questions.d09 ,
											@"ad10":questions.d10 ,
											@"ad11":questions.d11 ,
											@"ad12":questions.d12 ,
											@"ad13":questions.d13 ,
											@"ad14":questions.d14 ,
											@"ad15":questions.d15 ,
											@"ad16":questions.d16 ,
											@"ad17":questions.d17 ,
											@"ad18":questions.d18 ,
											@"ad19":questions.d19 ,
											@"ad20":questions.d20
											
											
                                 };
	
	
    // Realiza o POST das informações e aguarda o retorno.
     AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
			[manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
			NSString *path=[[NSString alloc]initWithFormat:@"%@",urlString];
			[manager POST:[NSURL URLWithString:path].absoluteString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
         { 
         if (![[responseObject objectForKey:@"response_error"] boolValue])
        {
			  
            questions.dstatus=STR_CONCLUIDO;
			  
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


