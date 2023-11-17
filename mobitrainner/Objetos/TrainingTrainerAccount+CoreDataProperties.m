//
//  TrainingTrainerAccount+CoreDataProperties.m
//  mobitrainer
//
//  Created by Rubens Rosa on 22/11/2017.
//  Copyright © 2017 4mobi. All rights reserved.
//
//

#import "TrainingTrainerAccount+CoreDataProperties.h"

@implementation TrainingTrainerAccount (CoreDataProperties)

+ (NSFetchRequest<TrainingTrainerAccount *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TrainingTrainerAccount"];
}

@dynamic difficulty;
@dynamic fullDescription;
@dynamic name;
@dynamic publickey;
@dynamic trainingID;
@dynamic treineeID;

@end
