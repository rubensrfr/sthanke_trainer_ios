//
//  PersonalTreinees+CoreDataProperties.m
//  mobitrainer
//
//  Created by Rubens Rosa on 07/12/2017.
//  Copyright © 2017 4mobi. All rights reserved.
//
//

#import "PersonalTreinees+CoreDataProperties.h"

@implementation PersonalTreinees (CoreDataProperties)

+ (NSFetchRequest<PersonalTreinees *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"PersonalTreinees"];
}

@dynamic email;
@dynamic firstName;
@dynamic image;
@dynamic lastName;
@dynamic lastUpdate;
@dynamic treineeID;
@dynamic unreadMessages;
@dynamic trainerID;
@dynamic traineeStatus;

@end
