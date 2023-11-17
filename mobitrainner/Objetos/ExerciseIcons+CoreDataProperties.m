//
//  ExerciseIcons+CoreDataProperties.m
//  mobitrainer
//
//  Created by Rubens Rosa on 27/11/2017.
//  Copyright © 2017 4mobi. All rights reserved.
//
//

#import "ExerciseIcons+CoreDataProperties.h"

@implementation ExerciseIcons (CoreDataProperties)

+ (NSFetchRequest<ExerciseIcons *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ExerciseIcons"];
}

@dynamic iconID;
@dynamic iconImage;

@end
