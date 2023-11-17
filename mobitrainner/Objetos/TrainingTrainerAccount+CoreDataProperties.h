//
//  TrainingTrainerAccount+CoreDataProperties.h
//  mobitrainer
//
//  Created by Rubens Rosa on 22/11/2017.
//  Copyright © 2017 4mobi. All rights reserved.
//
//

#import "TrainingTrainerAccount+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TrainingTrainerAccount (CoreDataProperties)

+ (NSFetchRequest<TrainingTrainerAccount *> *)fetchRequest;

@property (nonatomic, retain) NSNumber *difficulty;
@property (nullable, nonatomic, copy) NSString *fullDescription;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *publickey;
@property (nullable, nonatomic, copy) NSString *trainingID;
@property (nullable, nonatomic, copy) NSString *treineeID;

@end

NS_ASSUME_NONNULL_END
