//
//  NSObject+transactionClass.h
//  
//
//  Created by Rubens Rosa on 23/03/2018.
//  Copyright © 2018 4mobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface transactionClass:NSObject

@property (strong, nonatomic) NSString *training_id;
@property (nonatomic, retain) NSString *digitalproduct_id;
@property (strong, nonatomic) NSString *product_id;
@property (strong, nonatomic) NSString *transaction_id;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *expiration;
@property (strong, nonatomic) NSString *sale_video;
@property (strong, nonatomic) NSString *welcome_video;
@property (strong, nonatomic) NSString *training_description;
@property (strong, nonatomic) NSString *training_name;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSNumber *isonlineadvisor;
@property (strong, nonatomic) NSNumber *isnormaltraining;
@property (strong, nonatomic) NSNumber *isSync;
@property (strong, nonatomic) NSNumber *showanamnese;
@property (strong, nonatomic) NSNumber *response_days;
@property (strong, nonatomic) NSString *image_product;
@property (strong, nonatomic) NSString *image_store;
@end
