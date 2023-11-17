//
//  ExerciseTypes+CoreDataProperties.m
//  mobitrainer
//
//  Created by Rubens Rosa on 27/11/2017.
//  Copyright © 2017 4mobi. All rights reserved.
//
//

#import "ExerciseTypes+CoreDataProperties.h"

@implementation ExerciseTypes (CoreDataProperties)

+ (NSFetchRequest<ExerciseTypes *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ExerciseTypes"];
}

@dynamic typeID;
@dynamic typeDescription;

@end
