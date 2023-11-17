//
//  ExerciseIcons+CoreDataProperties.h
//  mobitrainer
//
//  Created by Rubens Rosa on 27/11/2017.
//  Copyright © 2017 4mobi. All rights reserved.
//
//

#import "ExerciseIcons+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ExerciseIcons (CoreDataProperties)

+ (NSFetchRequest<ExerciseIcons *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *iconID;
@property (nullable, nonatomic, copy) NSString *iconImage;

@end

NS_ASSUME_NONNULL_END
