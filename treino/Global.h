//
//  Global.h
//  treino
//
//  Created by Reginaldo Lopes on 25/11/14.
//  Copyright (c) 2014 4mobi. All rights reserved.
//

#ifndef treino_Global_h
#define treino_Global_h


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// APPLE DEFINES URL ///////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Secret Key gerada no painel do APP no iTunnes Connect.
#define APPLE_SHARED_KEY @"a89ede6e07274c27ba28f67b308bfade"  //VERIFY//

// URL usada em Produção para validar os recibos.
#define APPLE_URL_VERIFICATION @"https://buy.itunes.apple.com/verifyReceipt" //VERIFY//

//// URL usada em Desenvolvimento para validar os recibos.
#define APPLE_URL_VERIFICATION_SANDBOX @"https://sandbox.itunes.apple.com/verifyReceipt" //VERIFY///

#define API_KEY_TRAINER @"dbf7961037e89954fac7b44a87c73a2d" //RFR:3ba9e2809556e38dd8472c48de22f4f1" //VERIFY//
#define APPLICATION_ID @"S7ANKT"


#define AFHHTTP_TIMEOUT 15
#define NEED_UPDATE 1

#define LOAD_BOTTOM 0
#define LOAD_TOP 1


//                                        response_training_isnormaltraining.     response_training_isonlineadvisor
//
//1-TREINO PRATELEIRA                                   0                                                       0
//2-TREINO ASSESSORIA                                   0                                                       1
//3-TREINO NORMAL                                       1                                                       0
#define SHELF_TRAINING 1
#define ADVISOR_TRAINING 2
#define NORMAL_TRAINING 3


////////////////////////////////////////////////////////////////////////////////////////////////////
/// MENU BOX COLORS ////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////





////////////////////////////////////////////////////////////////////////////////////////////////////
/// USER CODES /////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#define USER_LEVEL_ADMINISTRATOR 1
#define USER_LEVEL_MASTERTRAINER 2
#define USER_LEVEL_TRAINER 3
#define USER_LEVEL_TRAINEE 4
#define USER_LEVEL_OPERATOR 5

////////////////////////////////////////////////////////////////////////////////////////////////////
/// MACROS /////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define IS_OS_9_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)

////////////////////////////////////////////////////////////////////////////////////////////////////
/// DEFAULT DEFINES ////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

// SO TYPE
#define kSO_TYPE  @"2"

// TEMPO UPDATE
#define kCHECK_UPDATE_TIMER 5

//  TEMPO DO TIMER MAIS TARDE
#define kCHECK_UPDATE_MAIS_TARDE_TIMER 360 // 60*6=360;

////////////////////////////////////////////////////////////////////////////////////////////////////
/// TEXTOS DEFAULTS ////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#define kTEXT_ALERT_TITLE @"STHANKE TRAINER"

#define kTEXT_BACK_BUTTON_DEFAULT @"Voltar"
#define kTEXT_SERVER_ERROR_DEFAULT @"Não foi possível concluir sua solicitação. \nTente novamente mais tarde!"
#define kTEXT_INTERNET_ERROR_DEFAULT @"Não é possível acessar os serviços. Verifique sua conexão com a Internet!"
#define kTEXT_LOGIN_ERROR_DEFAULT @"Não foi possível realizar o login. \nTente novamente mais tarde!"
#define KTEXT_ERROR_CLASS_CHECKIN @"Não foi possível registrar a presença. \nFora do horário permitido!"
#define KTEXT_ERROR_CLASS_TODAY @"Só é possível marcar presença em uma aula que acontece hoje!"
#define KTEXT_ACCOUNT_DELETED @"Seu acesso e dados foram excluídos com sucesso."

/*
 ERROS NOVO ALUNO:
 602  - apikey inválida
 805  - esse e-mail já está sendo utilizado
 613  - usuário sem permissão para fazer alterações
 1000 - excedeu o limite de alunos
 666  - erro ao inserir aluno
 615  - endereço de email inválido (formato)
*/

#define KTEXT_ERROR_EMAIL_INVALID @"Formato de email inválido!"
#define KTEXT_ERROR_EMAIL_USED @"O email digitado já está em uso!!"
#define KTEXT_ERROR_TRAINEE_NOT_FOUND @"Aluno inexistente!!"
#define KTEXT_ERROR_TRAINEES_EXCEEDED @"Excedeu o número de alunos do seu plano!"
#define KTEXT_ERROR_DATA @"Verifique os dados fornecidos"


////////////////////////////////////////////////////////////////////////////////////////////////////
/// URLS ///////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#define kBASE_URL_MOBITRAINER @"https://mobitrainer.com.br/"
//#define kBASE_URL_MOBITRAINER @"https://162.241.49.62/"
//#define kBASE_URL_MOBITRAINER @"http://sandbox.mobitrainer.com.br/"

#define kUPDATE_CHECK @"update8_00key"  // SEMPRE MUDAR QUANDO ATUALIZAR PARA UMA NOVA VERSÃO.



///////////////////////////////////////////////////////////////////////////////////////////
/// DEFAULT COLORS ////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////

#define kPRIMARY_COLOR    0x252529
#define STYLE_MAIN_COLOR kPRIMARY_COLOR
#define kSECONDARY_COLOR  0xEDBF2B
#define kNAVIGATION_MAIN_COLOR 0x434A4D
#define kNAVIGATION_TINT_COLOR 0xFFFFFF
#define kTAB_GLOBAL_COLOR 0xEDBF2B
#define kTAB_TINT_COLOR 0x000000
#define kDEFAULT_VIEW_BG_COLOR 0xD9D9D9
#define kAULAS_BAR_COLOR 0xEBEBEB
#define kTAB_UNSEL_TINT_COLOR 0x717171
#define NEW_STYLE 1
#define MENU_CLICK_COLOR 0xF6F6F6




///////////////////////////////////////////////////////////////////////////////////////////
/// YOUTUBE DEFINES ///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
//VERIFY//
#define KYOUTUBE_MAX_RESULT @"30"
#define kYOUTUBE_BASE_URL @"https://www.googleapis.com/youtube/v3/"
#define kYOUTUBE_API_KEY @"AIzaSyCVyYbXYsKjt6zh3-0ZUQ6JR7ifYlRgzlo"
#define kYOUTUBE_PLAYLIST_ID @"PLHhZnhJ7q3hoUxxegq2OOFr0_vEfpVYTP"


///////////////////////////////////////////////////////////////////////////////////////////
/// REDES SOCIAIS DEFINES ///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
//VERIFY//

#define FACEBOOK_NATIVE_LINK @"fb://profile/100000231474046"
#define FACEBOOK_URL_LINK @"https://www.facebook.com/rogerio.sthanke"
#define INSTAGRAM_URL_LINK @"instagram://user?username=sthanketrainer"
#define PHONE_URL_LINK @"011986653120"



#define SOBRE_TREINADOR_TITLE @"Sobre Rogério Sthanke"
#define NOME_COMPLETO @"Rogério Sthanke"
#define NOME_APLICATIVO @"STHANKE TRAINER"
#define PHONE_NUMBER @"(011)994203031"

#define BIO_EMAIL_RECIPIENT @"acessoriasthanke@gmail.com"
#define BIO_EMAIL_TITLE @"Contato pelo aplicativo iOS "
#define BIO_EMAIL_BODY @"Olá Rogério Sthanke,"


///////////////////////////////////////////////////////////////////////////////////////////
/// TEXTOS DEFAULTS ///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////

#define kTEXT_TITLE_ALERT_ERROR_DEFAULT @"Atenção"
#define kTEXT_LOADING_DEFAULT @"Atualizando..."
#define kTEXT_BODY_SERVER_ERROR_DEFAULT @"Não foi possível conectar, tente novamente mais tarde!"
#define kTEXT_NEED_ONLINE_DEFAULT @"Você deve estar online para realizar esta operação!"
#define KTEXT_NO_VIDEO_DEFAULT @"Não existem videos cadastrados!"

// DIMENSÃO DA IMAGEM DA NAVIGATION
#define kNAV_IMAGE_WIDTH  125
#define kNAV_IMAGE_HEIGHT 24

//Respostas Anaminese
#define PENDENTE  0
#define ANDAMENTO 1
#define CONCLUIDO 2
#define STR_PENDENTE  @"0"
#define STR_ANDAMENTO @"1"
#define STR_CONCLUIDO @"2"
#endif

////////////////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
