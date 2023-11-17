//
//  assessoriaViewController.h
//
//
//  Created by Rubens Rosa on 11/04/2018.
//  Copyright © 2018 4mobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"
#import "UtilityClass.h"
#import "SVProgressHUD.h"
#import "CoreDataService.h"
#import "questionsCell.h"
#import "UIImageView+AFNetworking.h"
#import "dadosPessoaisViewController.h"
#import "preferenciasViewController.h"
#import "parQViewController.h"
#import "questionaryViewController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "YTPlayerView.h"

@interface welcomeViewController : UIViewController <YTPlayerViewDelegate>
{
    CoreDataService *coreDataService;
    UtilityClass *utils;
    NSString *estatus;
    NSString *pstatus;
    NSString *qstatus;
    NSString *dstatus;
}

- (IBAction)btnVideoClicado:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imgVideoThumb;

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, retain) NSString  *training_id;
@property (nonatomic, retain) NSString  *product_id;
@property (nonatomic, retain) NSString  *welcome_video;
@property (nonatomic, retain) NSString  *response_days;
@property (nonatomic, strong) NSString *productImage;
@property (weak, nonatomic) IBOutlet UIButton *videoBtnOL;
@property (weak, nonatomic) IBOutlet UITextView *productText;
@property(nonatomic, strong) IBOutlet YTPlayerView *playerView;


@end

/*
API - comandos questionário anamnese
API - Comandos anamnese

Inserir dados
URL: http://mobitrainer.com.br/api/anamnese/setanswers
Parâmetros:

Obrigatórios:
    - apikey - apikey do aplicativo (conta do master)
    - trainee_email - email do aluno
    - inapptraining_id - o id do treino (quem fornece essa informação é o comando inapp/purchases -> "response_id")

Opcionais:
    - Os ids definidos na tabela excel
      Precisei alterar o nome do parâmetro para padronizar e ficar mais fácil (sorry)

Erros:
    - 602 apikey inválida
    - 803 usuário não encontrado
    - 666 erro inesperado
    - 620 o treino não é do tipo assessoria
    - 621 o ID do treino é inválido


Recuperar dados
URL: http://mobitrainer.com.br/api/anamnese/getanswers
Parâmetros:

Obrigatórios:
    - apikey - apikey do aplicativo (conta do master)
    - trainee_email - email do aluno
    - inapptraining_id - o id do treino (quem fornece essa informação é o comando inapp/purchases -> "response_id")

Retorno:
    - Lista JSON completa dos itens ("answers")

Erros:
    - 602 apikey inválida
    - 803 usuário não encontrado
    - 620 o treino não é do tipo assessoria
    - 621 o ID do treino é inválido
    - 622 o usuário ainda não respondeu a anamnese para esse treino (se comprou outro, acho interessante o aplicativo ver que não tem e pedir do anterior para usar os mesmos dados pré respondidos e enviar o nov)
*/
