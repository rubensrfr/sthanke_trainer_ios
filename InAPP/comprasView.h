//
//  comprasView.h
//  Tips4Life
//
//  Created by Rubens Rosa on 18/08/14.
//  Copyright (c) 2014 Rubens Rosa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface comprasView : NSObject

@property (strong, nonatomic) NSString *productId;
@property (strong, nonatomic) NSString *transactionId;

@property (strong, nonatomic) NSString *titulo;
@property (strong, nonatomic) NSString *descricao;
@property (strong, nonatomic) NSString *preco;
@property (strong, nonatomic) NSString *data;
@property (strong, nonatomic) NSString *dias;
@property (nonatomic) int status;


@end
