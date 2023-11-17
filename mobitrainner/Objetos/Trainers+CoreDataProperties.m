//
//  Trainers+CoreDataProperties.m
//  mobitrainer
//
//  Created by Rubens Rosa on 08/12/2017.
//  Copyright © 2017 4mobi. All rights reserved.
//
//

#import "Trainers+CoreDataProperties.h"

@implementation Trainers (CoreDataProperties)

+ (NSFetchRequest<Trainers *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Trainers"];
}

@dynamic trainerID;
@dynamic email;
@dynamic firstName;
@dynamic lastName;

@end
