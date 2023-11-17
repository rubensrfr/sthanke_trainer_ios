//
//  InAppProducts+CoreDataProperties.h
//  andrequeiroz
//
//  Created by Rubens Rosa on 17/09/2018.
//  Copyright © 2018 4mobi. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface InAppProducts : NSManagedObject



@property (nullable, nonatomic, copy) NSString *descricao;
@property (nullable, nonatomic, copy) NSString *image_product;
@property (nullable, nonatomic, copy) NSString *image_store;
@property (nullable, nonatomic, copy) NSNumber *isonlineadvisor;
@property (nullable, nonatomic, copy) NSString *preco;
@property (nullable, nonatomic, copy) NSString *product_id;
@property (nullable, nonatomic, retain) NSNumber *response_days;
@property (nullable, nonatomic, copy) NSNumber *status;
@property (nullable, nonatomic, copy) NSString *titulo;
@property (nullable, nonatomic, copy) NSString *training_id;
@property (nullable, nonatomic, copy) NSString *video;

@end
