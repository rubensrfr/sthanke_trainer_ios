//
//  ExerciseTypes+CoreDataProperties.h
//  mobitrainer
//
//  Created by Rubens Rosa on 27/11/2017.
//  Copyright © 2017 4mobi. All rights reserved.
//
//

#import "ExerciseTypes+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ExerciseTypes (CoreDataProperties)

+ (NSFetchRequest<ExerciseTypes *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *typeID;
@property (nullable, nonatomic, copy) NSString *typeDescription;

@end

NS_ASSUME_NONNULL_END
