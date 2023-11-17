//
//  InAppTransactions+CoreDataProperties.h
//  andrequeiroz
//
//  Created by Rubens Rosa on 17/09/2018.
//  Copyright © 2018 4mobi. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface InAppTransactions: NSManagedObject


@property (nullable, nonatomic, copy) NSString *date;
@property (nullable, nonatomic, copy) NSString *expiration;
@property (nullable, nonatomic, copy) NSNumber *isnormaltraining;
@property (nullable, nonatomic, copy) NSNumber *isonlineadvisor;
@property (nullable, nonatomic, copy) NSNumber *isSync;
@property (nullable, nonatomic, copy) NSString *price;
@property (nullable, nonatomic, copy) NSString *product_id;
@property (nullable, nonatomic, copy) NSString *sale_video;
@property (nullable, nonatomic, copy) NSString *training_description;
@property (nullable, nonatomic, copy) NSString *training_id;
@property (nullable, nonatomic, copy) NSString *digitalproduct_id;
@property (nullable, nonatomic, copy) NSString *training_name;
@property (nullable, nonatomic, copy) NSString *transaction_id;
@property (nullable, nonatomic, copy) NSString *welcome_video;
@property (nullable, nonatomic, retain) NSNumber *showanamnese;
@property (nullable, nonatomic, retain) NSNumber *response_days;
@property (nullable, nonatomic, copy) NSString *image_product;
@property (nullable, nonatomic, copy) NSString *image_store;

@end
