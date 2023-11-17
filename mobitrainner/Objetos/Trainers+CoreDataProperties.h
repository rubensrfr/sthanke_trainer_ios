//
//  Trainers+CoreDataProperties.h
//  mobitrainer
//
//  Created by Rubens Rosa on 08/12/2017.
//  Copyright © 2017 4mobi. All rights reserved.
//
//

#import "Trainers+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Trainers (CoreDataProperties)

+ (NSFetchRequest<Trainers *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *trainerID;
@property (nullable, nonatomic, copy) NSString *email;
@property (nullable, nonatomic, copy) NSString *firstName;
@property (nullable, nonatomic, copy) NSString *lastName;

@end

NS_ASSUME_NONNULL_END
