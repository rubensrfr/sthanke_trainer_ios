//
//  CoreDataService.m
//  mobitrainner
//
//  Created by Reginaldo Lopes on 13/01/15.
//  Copyright (c) 2015 4mobi. All rights reserved.
//

#import "CoreDataService.h"

@implementation CoreDataService

@synthesize managedObjectContext;

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (void)initialize
{
    // Acessa o appDelegate para acessar os methodos do CoreData.
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    managedObjectContext = [appDelegate managedObjectContext];
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (NSManagedObjectContext *)getManagedContext
{
    return managedObjectContext;
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (void)saveData
{
    NSError *error = nil;
	
    [self.managedObjectContext save:&error];
	
    if(!([self.managedObjectContext save:&error]))
    {
        NSLog(@"LOG: %@", [error localizedDescription]);
    }
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (void)dropLastUpdatesTable
{
    NSError *error;
    NSFetchRequest * all = [[NSFetchRequest alloc] init];
	
    [all setEntity:[NSEntityDescription entityForName:@"LastUpdates" inManagedObjectContext:self.managedObjectContext]];
    [all setIncludesPropertyValues:NO]; //only fetch the managedObjectID
	
    NSArray *array = [self.managedObjectContext executeFetchRequest:all error:&error];
	
    // Se existirem dados para serem apagados....
    if ([array count] > 0)
    {
        //error handling goes here
        for (NSManagedObject *object in array)
        {
            [self.managedObjectContext deleteObject:object];
        }
		 
        if(!([self.managedObjectContext save:&error]))
        {
            // Handle Error here.
            NSLog(@"LOG: %@",[error localizedDescription]);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (void)dropUserTable
{
    NSError *error;
    NSFetchRequest * all = [[NSFetchRequest alloc] init];
	
    [all setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:self.managedObjectContext]];
    [all setIncludesPropertyValues:NO]; //only fetch the managedObjectID
	
    NSArray *array = [self.managedObjectContext executeFetchRequest:all error:&error];
	
    // Se existirem dados para serem apagados....
    if ([array count] > 0)
    {
        //error handling goes here
        for (NSManagedObject *object in array)
        {
            [self.managedObjectContext deleteObject:object];
        }
		 
        if(!([self.managedObjectContext save:&error]))
        {
            // Handle Error here.
            NSLog(@"LOG: %@",[error localizedDescription]);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (void)dropDesignTable
{
    NSError *error;
    NSFetchRequest *all = [[NSFetchRequest alloc] init];
	
    [all setEntity:[NSEntityDescription entityForName:@"Design" inManagedObjectContext:self.managedObjectContext]];
    [all setIncludesPropertyValues:NO]; //only fetch the managedObjectID
	
    NSArray *array = [self.managedObjectContext executeFetchRequest:all error:&error];
	
    // Se existirem dados para serem apagados....
    if ([array count] > 0)
    {
        //error handling goes here
        for (NSManagedObject *object in array)
        {
            [self.managedObjectContext deleteObject:object];
        }
		 
        if(!([self.managedObjectContext save:&error]))
        {
            // Handle Error here.
            NSLog(@"LOG: %@",[error localizedDescription]);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (void)dropRadioTable
{
    NSError *error;
    NSFetchRequest *all = [[NSFetchRequest alloc] init];
	
    [all setEntity:[NSEntityDescription entityForName:@"Radio" inManagedObjectContext:self.managedObjectContext]];
    [all setIncludesPropertyValues:NO]; //only fetch the managedObjectID
	
    NSArray *array = [self.managedObjectContext executeFetchRequest:all error:&error];
	
    // Se existirem dados para serem apagados....
    if ([array count] > 0)
    {
        //error handling goes here
        for (NSManagedObject *object in array)
        {
            [self.managedObjectContext deleteObject:object];
        }
		 
        if(!([self.managedObjectContext save:&error]))
        {
            // Handle Error here.
            NSLog(@"LOG: %@",[error localizedDescription]);
        }
    }
}


////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (void)dropChatTable
{
    NSError *error;
    NSFetchRequest *all = [[NSFetchRequest alloc] init];
	
    [all setEntity:[NSEntityDescription entityForName:@"Chat" inManagedObjectContext:self.managedObjectContext]];
    [all setIncludesPropertyValues:NO]; //only fetch the managedObjectID
	
    NSArray *array = [self.managedObjectContext executeFetchRequest:all error:&error];
	
    // Se existirem dados para serem apagados....
    if ([array count] > 0)
    {
        //error handling goes here
        for (NSManagedObject *object in array)
        {
            [self.managedObjectContext deleteObject:object];
        }
		 
        if(!([self.managedObjectContext save:&error]))
        {
            // Handle Error here.
            NSLog(@"LOG: %@",[error localizedDescription]);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (void)dropClassScheduleItemTable
{
    NSError *error;
    NSFetchRequest *all = [[NSFetchRequest alloc] init];
	
    [all setEntity:[NSEntityDescription entityForName:@"ClassScheduleItem" inManagedObjectContext:self.managedObjectContext]];
    [all setIncludesPropertyValues:NO]; //only fetch the managedObjectID
	
    NSArray *array = [self.managedObjectContext executeFetchRequest:all error:&error];
	
    // Se existirem dados para serem apagados....
    if ([array count] > 0)
    {
        //error handling goes here
        for (NSManagedObject *object in array)
        {
            [self.managedObjectContext deleteObject:object];
        }
		 
        if(!([self.managedObjectContext save:&error]))
        {
            // Handle Error here.
            NSLog(@"LOG: %@",[error localizedDescription]);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (void)dropClassScheduleTable
{
    NSError *error;
    NSFetchRequest *all = [[NSFetchRequest alloc] init];
	
    [all setEntity:[NSEntityDescription entityForName:@"ClassSchedule" inManagedObjectContext:self.managedObjectContext]];
    [all setIncludesPropertyValues:NO]; //only fetch the managedObjectID
	
    NSArray *array = [self.managedObjectContext executeFetchRequest:all error:&error];
	
    // Se existirem dados para serem apagados....
    if ([array count] > 0)
    {
        //error handling goes here
        for (NSManagedObject *object in array)
        {
            [self.managedObjectContext deleteObject:object];
        }
		 
        if(!([self.managedObjectContext save:&error]))
        {
            // Handle Error here.
            NSLog(@"LOG: %@",[error localizedDescription]);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (void)dropFeaturedImagesTable
{
    NSError *error;
    NSFetchRequest *all = [[NSFetchRequest alloc] init];
	
    [all setEntity:[NSEntityDescription entityForName:@"FeaturedImages" inManagedObjectContext:self.managedObjectContext]];
    [all setIncludesPropertyValues:NO]; //only fetch the managedObjectID
	
    NSArray *array = [self.managedObjectContext executeFetchRequest:all error:&error];
	
    // Se existirem dados para serem apagados....
    if ([array count] > 0)
    {
        //error handling goes here
        for (NSManagedObject *object in array)
        {
            [self.managedObjectContext deleteObject:object];
        }
		 
        if(!([self.managedObjectContext save:&error]))
        {
            // Handle Error here.
            NSLog(@"LOG: %@",[error localizedDescription]);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (void)dropBlogTable
{
    NSError *error;
    NSFetchRequest *all = [[NSFetchRequest alloc] init];
	
    [all setEntity:[NSEntityDescription entityForName:@"Blog" inManagedObjectContext:self.managedObjectContext]];
    [all setIncludesPropertyValues:NO]; //only fetch the managedObjectID
	
    NSArray *array = [self.managedObjectContext executeFetchRequest:all error:&error];
	
    // Se existirem dados para serem apagados....
    if ([array count] > 0)
    {
        //error handling goes here
        for (NSManagedObject *object in array)
        {
            [self.managedObjectContext deleteObject:object];
        }
		 
        if(!([self.managedObjectContext save:&error]))
        {
            // Handle Error here.
            NSLog(@"LOG: %@",[error localizedDescription]);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (void)dropTrainerInfoTable
{
    NSError *error;
    NSFetchRequest *all = [[NSFetchRequest alloc] init];
	
    [all setEntity:[NSEntityDescription entityForName:@"TrainerInfo" inManagedObjectContext:self.managedObjectContext]];
    [all setIncludesPropertyValues:NO]; //only fetch the managedObjectID
	
    NSArray *array = [self.managedObjectContext executeFetchRequest:all error:&error];
	
    // Se existirem dados para serem apagados....
    if ([array count] > 0)
    {
        //error handling goes here
        for (NSManagedObject *object in array)
        {
            [self.managedObjectContext deleteObject:object];
        }
		 
        if(!([self.managedObjectContext save:&error]))
        {
            // Handle Error here.
            NSLog(@"LOG: %@",[error localizedDescription]);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (void)dropExerciseTypesTable
{
    NSError *error;
    NSFetchRequest *all = [[NSFetchRequest alloc] init];
	
    [all setEntity:[NSEntityDescription entityForName:@"ExerciseTypes" inManagedObjectContext:self.managedObjectContext]];
    [all setIncludesPropertyValues:NO]; //only fetch the managedObjectID
	
    NSArray *array = [self.managedObjectContext executeFetchRequest:all error:&error];
	
    // Se existirem dados para serem apagados....
    if ([array count] > 0)
    {
        //error handling goes here
        for (NSManagedObject *object in array)
        {
            [self.managedObjectContext deleteObject:object];
        }
		 
        if(!([self.managedObjectContext save:&error]))
        {
            // Handle Error here.
            NSLog(@"LOG: %@",[error localizedDescription]);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (void)dropExerciseIconsTable
{
    NSError *error;
    NSFetchRequest *all = [[NSFetchRequest alloc] init];
	
    [all setEntity:[NSEntityDescription entityForName:@"ExerciseIcons" inManagedObjectContext:self.managedObjectContext]];
    [all setIncludesPropertyValues:NO]; //only fetch the managedObjectID
	
    NSArray *array = [self.managedObjectContext executeFetchRequest:all error:&error];
	
    // Se existirem dados para serem apagados....
    if ([array count] > 0)
    {
        //error handling goes here
        for (NSManagedObject *object in array)
        {
            [self.managedObjectContext deleteObject:object];
        }
		 
        if(!([self.managedObjectContext save:&error]))
        {
            // Handle Error here.
            NSLog(@"LOG: %@",[error localizedDescription]);
        }
    }
}
- (void)dropTrainingTable
{
    NSError *error;
    NSFetchRequest *all = [[NSFetchRequest alloc] init];
	
    [all setEntity:[NSEntityDescription entityForName:@"Training" inManagedObjectContext:self.managedObjectContext]];
    [all setIncludesPropertyValues:NO]; //only fetch the managedObjectID
	
    NSArray *array = [self.managedObjectContext executeFetchRequest:all error:&error];
	
    // Se existirem dados para serem apagados....
    if ([array count] > 0)
    {
        //error handling goes here
        for (NSManagedObject *object in array)
        {
            [self.managedObjectContext deleteObject:object];
        }
		 
        if(!([self.managedObjectContext save:&error]))
        {
            // Handle Error here.
            NSLog(@"LOG: %@",[error localizedDescription]);
        }
    }
}

- (void)deleteTrainingWithTrainingID:(NSString *)training_id
{
	    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Training"];
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"training_id==%@",training_id];
    NSArray *arrayFiltered = [mutableFetchResults filteredArrayUsingPredicate:predicate];
	
    // Se existirem dados para serem apagados....
    if ([arrayFiltered count] > 0)
    {
        //error handling goes here
        for (NSManagedObject *object in arrayFiltered)
        {
            [self.managedObjectContext deleteObject:object];
        }
		 
        if(!([self.managedObjectContext save:&error]))
        {
            // Handle Error here.
            NSLog(@"LOG: %@",[error localizedDescription]);
        }
    }
}
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (void)dropExercisesTable
{
    NSError *error;
    NSFetchRequest *all = [[NSFetchRequest alloc] init];
	
    [all setEntity:[NSEntityDescription entityForName:@"Exercises" inManagedObjectContext:self.managedObjectContext]];
    [all setIncludesPropertyValues:NO]; //only fetch the managedObjectID
	
    NSArray *array = [self.managedObjectContext executeFetchRequest:all error:&error];
	
    // Se existirem dados para serem apagados....
    if ([array count] > 0)
    {
        //error handling goes here
        for (NSManagedObject *object in array)
        {
            [self.managedObjectContext deleteObject:object];
        }
		 
        if(!([self.managedObjectContext save:&error]))
        {
            // Handle Error here.
            NSLog(@"LOG: %@",[error localizedDescription]);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (void)dropTrainingTrainerAccountTable
{
    NSError *error;
    NSFetchRequest *all = [[NSFetchRequest alloc] init];
	
    [all setEntity:[NSEntityDescription entityForName:@"TrainingTrainerAccount" inManagedObjectContext:self.managedObjectContext]];
    [all setIncludesPropertyValues:NO]; //only fetch the managedObjectID
	
    NSArray *array = [self.managedObjectContext executeFetchRequest:all error:&error];
	
    // Se existirem dados para serem apagados....
    if ([array count] > 0)
    {
        //error handling goes here
        for (NSManagedObject *object in array)
        {
            [self.managedObjectContext deleteObject:object];
        }
		 
        if(!([self.managedObjectContext save:&error]))
        {
            // Handle Error here.
            NSLog(@"LOG: %@",[error localizedDescription]);
        }
    }
}


////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (void)dropAllTrainersAccountTable
{
    NSError *error;
    NSFetchRequest *all = [[NSFetchRequest alloc] init];
	
    [all setEntity:[NSEntityDescription entityForName:@"Trainers" inManagedObjectContext:self.managedObjectContext]];
    [all setIncludesPropertyValues:NO]; //only fetch the managedObjectID
	
    NSArray *array = [self.managedObjectContext executeFetchRequest:all error:&error];
	
    // Se existirem dados para serem apagados....
    if ([array count] > 0)
    {
        //error handling goes here
        for (NSManagedObject *object in array)
        {
            [self.managedObjectContext deleteObject:object];
        }
		 
        if(!([self.managedObjectContext save:&error]))
        {
            // Handle Error here.
            NSLog(@"LOG: %@",[error localizedDescription]);
        }
    }
}
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (void)dropNotesTable
{
    NSError *error;
    NSFetchRequest *all = [[NSFetchRequest alloc] init];
	
    [all setEntity:[NSEntityDescription entityForName:@"Notes" inManagedObjectContext:self.managedObjectContext]];
    [all setIncludesPropertyValues:NO]; //only fetch the managedObjectID
	
    NSArray *array = [self.managedObjectContext executeFetchRequest:all error:&error];
	
    // Se existirem dados para serem apagados....
    if ([array count] > 0)
    {
        //error handling goes here
        for (NSManagedObject *object in array)
        {
            [self.managedObjectContext deleteObject:object];
        }
		 
        if(!([self.managedObjectContext save:&error]))
        {
            // Handle Error here.
            NSLog(@"LOG: %@",[error localizedDescription]);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (void)deleteDataFromExerciseTableByExerciseID:(NSString *)exID AndTrainingID:(NSString *)trID
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Exercises"];
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"exerciseID==%@ && trainingID==%@",exID,trID];
    NSArray *arrayFiltered = [mutableFetchResults filteredArrayUsingPredicate:predicate];
	
    if (arrayFiltered.count > 0)
    {
        for (NSManagedObject *obj in arrayFiltered)
        {
            [self.managedObjectContext deleteObject:obj];
        }
		 
        if(!([self.managedObjectContext save:&error]))
        {
            // Handle Error here.
            NSLog(@"LOG: %@", [error localizedDescription]);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (void)deleteDataFromExerciseTableByTrainingID:(NSString *)treinoID
{


    NSError *error = nil;
    NSFetchRequest *fetchRequestSeries = [NSFetchRequest fetchRequestWithEntityName:@"Training"];
    NSMutableArray *mutableFetchResultsSeries = [[self.managedObjectContext executeFetchRequest:fetchRequestSeries error:&error] mutableCopy];
	
    NSPredicate *predicateSeries = [NSPredicate predicateWithFormat:@"training_id==%@",treinoID];
    NSArray *filteredArray = [mutableFetchResultsSeries filteredArrayUsingPredicate:predicateSeries];
    for(int i=0;i<[filteredArray count];i++)
    {
	 	 Training *training = (Training *)[filteredArray objectAtIndex:i];
		
		 
    		NSFetchRequest *fetchRequestExercises = [NSFetchRequest fetchRequestWithEntityName:@"Exercises"];
         NSMutableArray *mutableFetchResultsExercises = [[self.managedObjectContext executeFetchRequest:fetchRequestExercises error:&error] mutableCopy];
         NSPredicate *predicate = [NSPredicate predicateWithFormat:@"trainingID==%@",training.trainingID];
         NSArray *arrayFilteredExercises = [mutableFetchResultsExercises filteredArrayUsingPredicate:predicate];
		 
         if (mutableFetchResultsExercises.count > 0)
         {
            for (NSManagedObject *obj in arrayFilteredExercises)
            {
                [self.managedObjectContext deleteObject:obj];
            }
		 
				 if(!([self.managedObjectContext save:&error]))
            {
               // Handle Error here.
                NSLog(@"LOG: %@", [error localizedDescription]);
            }
         }
		}
}



- (NSString *)getTrainingID:(NSString *)training_id
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Training"];
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
	
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"training_id==%@",training_id];
    NSArray *filteredArray = [mutableFetchResults filteredArrayUsingPredicate:predicate];
    if([filteredArray count]>0)
    {
	 	Training *training = (Training *)[filteredArray objectAtIndex:0];
	    return training.trainingID;
	 }
	 else
	 	return @"";
}


////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (NSMutableArray *)getDataFromExercisesTypes
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"ExerciseTypes"];
	 [fetchRequest setReturnsObjectsAsFaults:NO];
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];

	 NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"typeDescription" ascending:YES];
    NSArray *sortedArray = [mutableFetchResults sortedArrayUsingDescriptors:@[sort]];
	
    [mutableFetchResults removeAllObjects];
    mutableFetchResults = [[NSMutableArray alloc] initWithArray:sortedArray];
	

    return mutableFetchResults;
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (NSMutableArray *)getDataFromExercisesIcons
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"ExerciseIcons"];
	 [fetchRequest setReturnsObjectsAsFaults:NO];
	 NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];

	  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"iconImage" ascending:YES];
     NSArray *sortedArray = [mutableFetchResults sortedArrayUsingDescriptors:@[sort]];
	
	
    [mutableFetchResults removeAllObjects];
    mutableFetchResults = [[NSMutableArray alloc] initWithArray:sortedArray];
	
	

    return mutableFetchResults;
}




////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (NSArray *)getDataFromTrainingTrainerAccount
{
    NSError *error = nil;
	
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"TrainingTrainerAccount"];
	
	 NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	
    [fetchRequest setSortDescriptors:sortDescriptors];
	
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
	 return mutableFetchResults;
}


////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (NSString *)getTrainerNamebyID:(NSString *)trainerID
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Trainers"];
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
	
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"trainerID==%@",trainerID];
    NSArray *filteredArray = [mutableFetchResults filteredArrayUsingPredicate:predicate];
    if([filteredArray count]>0)
    {
	 	Trainers *trainer = (Trainers *)[filteredArray objectAtIndex:0];
	    return [[trainer.firstName stringByAppendingString:@" "]stringByAppendingString:trainer.lastName] ;
	 }
	 else
	 	return @"";
}



////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (NSArray *)getDataFromExercisesTableWithExerciseID:(NSString *)exID AndTrainingID:(NSString *)trID
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Exercises"];
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
	
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"exerciseID==%@ && trainingID==%@",exID,trID];
    NSArray *filteredArray = [mutableFetchResults filteredArrayUsingPredicate:predicate];
	
    return filteredArray;
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (void)dropPersonalTreineesTable
{
    NSError *error;
    NSFetchRequest *all = [[NSFetchRequest alloc] init];
	
    [all setEntity:[NSEntityDescription entityForName:@"PersonalTreinees" inManagedObjectContext:self.managedObjectContext]];
    [all setIncludesPropertyValues:NO]; //only fetch the managedObjectID
	
    NSArray *array = [self.managedObjectContext executeFetchRequest:all error:&error];
	
    // Se existirem dados para serem apagados....
    if ([array count] > 0)
    {
        //error handling goes here
        for (NSManagedObject *object in array)
        {
            [self.managedObjectContext deleteObject:object];
        }
		 
        if(!([self.managedObjectContext save:&error]))
        {
            // Handle Error here.
            NSLog(@"LOG: %@",[error localizedDescription]);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (void)dropHistoryTable
{
    NSError *error;
    NSFetchRequest *all = [[NSFetchRequest alloc] init];
	
    [all setEntity:[NSEntityDescription entityForName:@"History" inManagedObjectContext:self.managedObjectContext]];
    [all setIncludesPropertyValues:NO]; //only fetch the managedObjectID
	
    NSArray *array = [self.managedObjectContext executeFetchRequest:all error:&error];
	
    // Se existirem dados para serem apagados....
    if ([array count] > 0)
    {
        //error handling goes here
        for (NSManagedObject *object in array)
        {
            [self.managedObjectContext deleteObject:object];
        }
		 
        if(!([self.managedObjectContext save:&error]))
        {
            // Handle Error here.
            NSLog(@"LOG: %@",[error localizedDescription]);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (void)deleteHistoryDatabyTrainee:(NSString *)traineeid
{
    NSError *error;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"History"];

	
    NSArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"treineeID==%@ ",traineeid];

    NSArray *filteredArray = [mutableFetchResults filteredArrayUsingPredicate:predicate];

	
	
    // Se existirem dados para serem apagados....
    if ([filteredArray count] > 0)
    {
        //error handling goes here
        for (NSManagedObject *object in filteredArray)
        {
			  
            [self.managedObjectContext deleteObject:object];
        }
		 
        if(!([self.managedObjectContext save:&error]))
        {
            // Handle Error here.
            NSLog(@"LOG: %@",[error localizedDescription]);
        }
    }
}


////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (NSArray *)getDataFromClassScheduleItemTableByWeekDay:(NSInteger)weekday
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"ClassScheduleItem"];
	
    NSArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
	
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"weekday==%d",[[NSNumber numberWithInteger:weekday] integerValue]];
	
    NSArray *filteredArray = [mutableFetchResults filteredArrayUsingPredicate:predicate];
	
    return filteredArray;
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (LastUpdates *)getDataFromLastUpdatesTable
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"LastUpdates"];
    NSArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
	
    LastUpdates *lastUpdate;
	
    if([mutableFetchResults count]>0)
        lastUpdate = (LastUpdates *) [mutableFetchResults objectAtIndex:0];
	
    return lastUpdate;

}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (void)setDefaultDataFromLastUpdatesTable
{
    NSError *error = nil;
    NSFetchRequest *fetchRequestDesign = [NSFetchRequest fetchRequestWithEntityName:@"LastUpdates"];
    NSMutableArray *mutableFetchResultsDesign = [[self.managedObjectContext executeFetchRequest:fetchRequestDesign error:&error] mutableCopy];

    if ([mutableFetchResultsDesign count] == 0)
    {
        LastUpdates *lastUpdates = (LastUpdates *) [NSEntityDescription insertNewObjectForEntityForName:@"LastUpdates"
                                                                                 inManagedObjectContext:self.managedObjectContext];
		 
        lastUpdates.design = @"1969-01-01 00:00:00";
        lastUpdates.blog = @"1969-01-01 00:00:00";
        lastUpdates.trainerInfo = @"1969-01-01 00:00:00";
        lastUpdates.featuredImages = @"1969-01-01 00:00:00";
        lastUpdates.training = @"1969-01-01 00:00:00";
        lastUpdates.trainee = @"1969-01-01 00:00:00";
        lastUpdates.userProfile = @"1969-01-01 00:00:00";
        lastUpdates.chat = @"1969-01-01 00:00:00";
        lastUpdates.radio = @"1969-01-01 00:00:00";
		 
        NSError *error;
        [self.managedObjectContext save:&error];
		 
        if(!([self.managedObjectContext save:&error]))
        {
            // Handle Error here.
            NSLog(@"LOG: %@", [error localizedDescription]);
        }
    }

    NSFetchRequest *fetchRequestFeaturedImages = [NSFetchRequest fetchRequestWithEntityName:@"FeaturedImages"];
    NSMutableArray *mutableFetchResultsFeaturedImages = [[self.managedObjectContext executeFetchRequest:fetchRequestFeaturedImages error:&error] mutableCopy];
	
     if ([mutableFetchResultsFeaturedImages count] == 0)
     {
         FeaturedImages *featuredImages = (FeaturedImages *) [NSEntityDescription insertNewObjectForEntityForName:@"FeaturedImages" inManagedObjectContext:self.managedObjectContext];
		  
         featuredImages.isVerified = [NSNumber numberWithBool:NO];
		  
         NSError *error;
         [self.managedObjectContext save:&error];
		  
         if(!([self.managedObjectContext save:&error]))
         {
             // Handle Error here.
             NSLog(@"LOG: %@", [error localizedDescription]);
         }
    }
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (User *)getDataFromUserTable
{
    NSError *error;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
	
    User *userData;
	
    if([mutableFetchResults count]>0)
        userData = (User *) [mutableFetchResults objectAtIndex:0];
	
    return userData;
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (NSArray *)getDataFromUserTableByOwner:(NSString *)trainerID
{
    NSError *error;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"PersonalTreinees"];
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
	
    //User *userData;
	
    //if([mutableFetchResults count]>0)
      //  userData = (User *) [mutableFetchResults objectAtIndex:0];
	
    NSPredicate *predicate;
	 predicate = [NSPredicate predicateWithFormat:@"trainerID==%@ && traineeStatus==%@",trainerID,@"1"];
    NSArray *filteredArray = [mutableFetchResults filteredArrayUsingPredicate:predicate];

    return filteredArray;
}



////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (NSMutableArray *)getDataFromPersonalTreineesTable
{
    // Verifica se o objeto existe...
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"PersonalTreinees"];
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
	
    NSMutableArray *array = [[NSMutableArray alloc] init];
	
    for (NSInteger i = 0; i < [mutableFetchResults count]; i++)
    {
        PersonalTreinees *pTreinee = (PersonalTreinees *) [mutableFetchResults objectAtIndex:i];
	   // Filtra alunos não bloqueados
		if([pTreinee.traineeStatus isEqualToString:@"1"])
        [array addObject:pTreinee];
    }
	
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES];
    NSArray *sortedArray = [array sortedArrayUsingDescriptors:@[sort]];
	
    [array removeAllObjects];
    array = [[NSMutableArray alloc] initWithArray:sortedArray];
	
    return array;
}


////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (NSMutableArray *)getDataFromPersonalTreineesTableBlocked
{
    // Verifica se o objeto existe...
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"PersonalTreinees"];
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
	
    NSMutableArray *array = [[NSMutableArray alloc] init];
	
    for (NSInteger i = 0; i < [mutableFetchResults count]; i++)
    {
        PersonalTreinees *pTreinee = (PersonalTreinees *) [mutableFetchResults objectAtIndex:i];
	   // Filtra alunos não bloqueados
		if([pTreinee.traineeStatus isEqualToString:@"0"])
        [array addObject:pTreinee];
    }
	
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES];
    NSArray *sortedArray = [array sortedArrayUsingDescriptors:@[sort]];
	
    [array removeAllObjects];
    array = [[NSMutableArray alloc] initWithArray:sortedArray];
	
    return array;
}


////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (PersonalTreinees *)getDataFromPersonalTreineesTableByTreineeID:(NSString *)trainerID
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"PersonalTreinees"];
	
    NSArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
	
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"treineeID==%@ ",trainerID];
	
    NSArray *filteredArray = [mutableFetchResults filteredArrayUsingPredicate:predicate];
	
    return [filteredArray objectAtIndex:0];
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (NSArray *)getDataFromHistoryTable
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"History"];
    NSArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];

    return mutableFetchResults;
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (NSArray *)getDataFromHistoryTableWithUserID:(NSString *)userID
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"History"];
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
	
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"treineeID==%@",userID];
    NSArray *filteredArray = [mutableFetchResults filteredArrayUsingPredicate:predicate];
	
    return filteredArray;
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (NSArray *)getDataFromHistoryTableWithIsSync:(BOOL)isSync IsClass:(BOOL)isClass
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"History"];
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSync==%d && isClass==%d",isSync,isClass];
	
    NSArray *arrayFiltered = [mutableFetchResults filteredArrayUsingPredicate:predicate];
	
    return arrayFiltered;
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (NSArray *)getDataFromHistoryTableWithID:(NSString *)classScheduleID
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"History"];
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"trainingID==%@",classScheduleID];
	
    NSArray *arrayFiltered = [mutableFetchResults filteredArrayUsingPredicate:predicate];
	
    return arrayFiltered;
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (NSMutableArray *)getDataFromTrainingTableWithTrainingId:(NSString *)training_id
{
    // Verifica se o objeto existe...
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Training"];
	
    NSError *error = nil;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
	
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	
    [fetchRequest setSortDescriptors:sortDescriptors];
	
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"training_id==%@",training_id];
	
    NSArray *arrayFiltered = [mutableFetchResults filteredArrayUsingPredicate:predicate];
	
    NSMutableArray *arrayTraining = [[NSMutableArray alloc] init];
	
    for (NSInteger i = 0; i < [arrayFiltered count]; i++)
    {
		 
        Training *training = (Training *) [arrayFiltered objectAtIndex:i];
		  [arrayTraining addObject:training];
	}
	
    return arrayTraining;
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (NSMutableArray *)getDataFromTrainingTable:(BOOL)isHistory withStatus:(NSString *)OnOff
{
    // Verifica se o objeto existe...
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Training"];
	
    NSError *error = nil;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
	
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	
    [fetchRequest setSortDescriptors:sortDescriptors];
	
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isHistory==%d && training_id==%@",isHistory,@"0"];
	
    NSArray *arrayFiltered = [mutableFetchResults filteredArrayUsingPredicate:predicate];
	
    NSMutableArray *arrayTraining = [[NSMutableArray alloc] init];
	
    for (NSInteger i = 0; i < [arrayFiltered count]; i++)
    {
		 
        Training *training = (Training *) [arrayFiltered objectAtIndex:i];
		  if([training.serieOnOffStatus isEqualToString:@"1"])
		     [arrayTraining addObject:training];
    }
	
    return arrayTraining;
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (NSMutableArray *)getDataFromTrainingTableWithUserID:(NSString *)userID withStatus:(NSString *)OnOff
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Training"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"treineeID==%@",userID];
    NSArray *arrayFiltered = [mutableFetchResults filteredArrayUsingPredicate:predicate];
	
	
    NSMutableArray *arrayTraining = [[NSMutableArray alloc] init];
	
    if ([arrayFiltered count] > 0)
    {
        for (NSInteger i = 0; i < [arrayFiltered count]; i++)
        {
            Training *training = (Training *) [arrayFiltered objectAtIndex:i];
			  
            //Verifica se é série ativa
            if([training.serieOnOffStatus isEqualToString:OnOff])
                [arrayTraining addObject:training];
        }
    }
	
    return arrayTraining;
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (Design *)getDataFromDesignTable
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Design"];
    NSArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if([mutableFetchResults count]>0)
    	return [mutableFetchResults objectAtIndex:0];
	 else
	 	return nil;
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (Blog *)getDataFromBlogTable
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Blog"];
    NSArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if([mutableFetchResults count] >0)
    	return [mutableFetchResults objectAtIndex:0];
    else
    	return nil;
}


////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (NSMutableArray *)getDataFromBlogFeedsTable
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"BlogFeeds"];
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
	
    return mutableFetchResults;
}


////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (void)dropBlogFeedsTable
{
    NSError *error;
    NSFetchRequest *all = [[NSFetchRequest alloc] init];
	
    [all setEntity:[NSEntityDescription entityForName:@"BlogFeeds" inManagedObjectContext:self.managedObjectContext]];
    [all setIncludesPropertyValues:NO]; //only fetch the managedObjectID
	
    NSArray *array = [self.managedObjectContext executeFetchRequest:all error:&error];
	
    // Se existirem dados para serem apagados....
    if ([array count] > 0)
    {
        //error handling goes here
        for (NSManagedObject *object in array)
        {
            [self.managedObjectContext deleteObject:object];
        }
		 
        if(!([self.managedObjectContext save:&error]))
        {
            // Handle Error here.
            NSLog(@"LOG: %@",[error localizedDescription]);
        }
    }
}


////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (NSMutableArray *)getDataFromInAppProductsTable
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"InAppProducts"];
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
	
    return mutableFetchResults;
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (QuestionsE *)getDataFromQuestionsETable:(NSString *)training_id
{
    // Verifica se o objeto existe...
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"QuestionsE"];
	
    NSError *error = nil;
	
	
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"training_id==%@",training_id];
	
    NSArray *arrayFiltered = [mutableFetchResults filteredArrayUsingPredicate:predicate];
	
	
	 QuestionsE *questionsE;
    for (NSInteger i = 0; i < [arrayFiltered count]; i++)
    {
		 
        questionsE = (QuestionsE *) [arrayFiltered objectAtIndex:i];
		
	 }
	
    return questionsE;
}



- (QuestionsD *)getDataFromQuestionsDTable:(NSString *)training_id
{
    // Verifica se o objeto existe...
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"QuestionsD"];
	
    NSError *error = nil;
	
	
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"training_id==%@",training_id];
	
    NSArray *arrayFiltered = [mutableFetchResults filteredArrayUsingPredicate:predicate];
	
	
	 QuestionsD *questionsD;
    for (NSInteger i = 0; i < [arrayFiltered count]; i++)
    {
		 
        questionsD = (QuestionsD *) [arrayFiltered objectAtIndex:i];
		 
	 }
	
    return questionsD;
}
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (QuestionsP *)getDataFromQuestionsPTable:(NSString *)training_id
{
    // Verifica se o objeto existe...
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"QuestionsP"];
	
    NSError *error = nil;
	
	
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"training_id==%@",training_id];
	
    NSArray *arrayFiltered = [mutableFetchResults filteredArrayUsingPredicate:predicate];
	
	 QuestionsP *questionsP;
    for (NSInteger i = 0; i < [arrayFiltered count]; i++)
    {
		 
        questionsP = (QuestionsP *) [arrayFiltered objectAtIndex:i];
		 
	 }
	
    return questionsP;
}
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (QuestionsQ *)getDataFromQuestionsQTable:(NSString *)training_id
{
    // Verifica se o objeto existe...
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"QuestionsQ"];
	
    NSError *error = nil;
	
	
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"training_id==%@",training_id];
	
    NSArray *arrayFiltered = [mutableFetchResults filteredArrayUsingPredicate:predicate];
	
	
	 QuestionsQ *questionsQ;
    for (NSInteger i = 0; i < [arrayFiltered count]; i++)
    {
		 
        questionsQ = (QuestionsQ *) [arrayFiltered objectAtIndex:i];
		 
	 }
	
    return questionsQ;
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (void)dropInAppProductsTable
{
    NSError *error;
    NSFetchRequest *all = [[NSFetchRequest alloc] init];
	
    [all setEntity:[NSEntityDescription entityForName:@"InAppProducts" inManagedObjectContext:self.managedObjectContext]];
    [all setIncludesPropertyValues:NO]; //only fetch the managedObjectID
	
    NSArray *array = [self.managedObjectContext executeFetchRequest:all error:&error];
	
    // Se existirem dados para serem apagados....
    if ([array count] > 0)
    {
        //error handling goes here
        for (NSManagedObject *object in array)
        {
            [self.managedObjectContext deleteObject:object];
        }
		 
        if(!([self.managedObjectContext save:&error]))
        {
            // Handle Error here.
            NSLog(@"LOG: %@",[error localizedDescription]);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (NSMutableArray *)getDataFromInAppTransactionsTable
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"InAppTransactions"];
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
	
    return mutableFetchResults;
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (void)insertUpdateDataInAppTransactionsTable:(transactionClass *)transaction
{
	 NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"InAppTransactions"];
	NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"transaction_id==%@",transaction.transaction_id];
	
    NSArray *arrayFiltered = [mutableFetchResults filteredArrayUsingPredicate:predicate];
	
	 if(0)//[arrayFiltered count] > 0) //Transaction Existe, então atualiza
	 {
	 		InAppTransactions *thisTransaction = (InAppTransactions *) [arrayFiltered objectAtIndex:0];
		   thisTransaction.training_id =transaction.training_id;
			thisTransaction.digitalproduct_id = transaction.digitalproduct_id;
	 		thisTransaction.training_name = transaction.training_name;
	 		thisTransaction.training_description = transaction.training_description;
	 		thisTransaction.isonlineadvisor = transaction.isonlineadvisor;
	 		thisTransaction.isnormaltraining = transaction.isnormaltraining;
	 		thisTransaction.sale_video = transaction.sale_video;
	 		thisTransaction.welcome_video = transaction.welcome_video;
		   thisTransaction.price = transaction.price;
			thisTransaction.date = transaction.date;
			thisTransaction.expiration = transaction.expiration;
			thisTransaction.showanamnese = transaction.showanamnese;
			thisTransaction.response_days = transaction.response_days;
		   thisTransaction.image_store = transaction.image_store;
		   thisTransaction.image_product = transaction.image_product;
		 
	 		// SALVA O OBJETO.
        if(!([self.managedObjectContext save:&error]))
        {
            // Handle Error here.
            NSLog(@"LOG: %@", [error localizedDescription]);
        }
	}
	else
	{
		InAppTransactions *newtransaction = (InAppTransactions *)[NSEntityDescription insertNewObjectForEntityForName:@"InAppTransactions"
                                                                   inManagedObjectContext:self.managedObjectContext];
	

		newtransaction.training_id=transaction.training_id;
		newtransaction.digitalproduct_id = transaction.digitalproduct_id;
		newtransaction.product_id = transaction.product_id;
		newtransaction.transaction_id = transaction.transaction_id;
		newtransaction.date = transaction.date;
		newtransaction.expiration = transaction.expiration;
		newtransaction.sale_video = transaction.sale_video;
		newtransaction.welcome_video = transaction.welcome_video;
		newtransaction.training_name = transaction.training_name ;
		newtransaction.training_description = transaction.training_description;
		newtransaction.price = transaction.price;
		newtransaction.isonlineadvisor = transaction.isonlineadvisor;
		newtransaction.isnormaltraining = transaction.isnormaltraining;
		newtransaction.isSync = [NSNumber numberWithBool:TRUE];
		newtransaction.showanamnese = transaction.showanamnese;
		newtransaction.response_days = transaction.response_days;
		newtransaction.image_store = transaction.image_store;
		newtransaction.image_product = transaction.image_product;
		
		// SALVA O OBJETO.
        if(!([self.managedObjectContext save:&error]))
        {
            // Handle Error here.
            NSLog(@"LOG: %@", [error localizedDescription]);
        }
	}
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (void)dropInAppTransactionsTable
{
    NSError *error;
    NSFetchRequest *all = [[NSFetchRequest alloc] init];
	
    [all setEntity:[NSEntityDescription entityForName:@"InAppTransactions" inManagedObjectContext:self.managedObjectContext]];
    [all setIncludesPropertyValues:NO]; //only fetch the managedObjectID
	
    NSArray *array = [self.managedObjectContext executeFetchRequest:all error:&error];
	
    // Se existirem dados para serem apagados....
    if ([array count] > 0)
    {
        //error handling goes here
        for (NSManagedObject *object in array)
        {
            [self.managedObjectContext deleteObject:object];
        }
		 
        if(!([self.managedObjectContext save:&error]))
        {
            // Handle Error here.
            NSLog(@"LOG: %@",[error localizedDescription]);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
- (void)dropQuestionsETable
{
    NSError *error;
    NSFetchRequest *all = [[NSFetchRequest alloc] init];
	
    [all setEntity:[NSEntityDescription entityForName:@"QuestionsE" inManagedObjectContext:self.managedObjectContext]];
    [all setIncludesPropertyValues:NO]; //only fetch the managedObjectID
	
    NSArray *array = [self.managedObjectContext executeFetchRequest:all error:&error];
	
    // Se existirem dados para serem apagados....
    if ([array count] > 0)
    {
        //error handling goes here
        for (NSManagedObject *object in array)
        {
            [self.managedObjectContext deleteObject:object];
        }
		 
        if(!([self.managedObjectContext save:&error]))
        {
            // Handle Error here.
            NSLog(@"LOG: %@",[error localizedDescription]);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
- (void)dropQuestionsPTable
{
    NSError *error;
    NSFetchRequest *all = [[NSFetchRequest alloc] init];
	
    [all setEntity:[NSEntityDescription entityForName:@"QuestionsP" inManagedObjectContext:self.managedObjectContext]];
    [all setIncludesPropertyValues:NO]; //only fetch the managedObjectID
	
    NSArray *array = [self.managedObjectContext executeFetchRequest:all error:&error];
	
    // Se existirem dados para serem apagados....
    if ([array count] > 0)
    {
        //error handling goes here
        for (NSManagedObject *object in array)
        {
            [self.managedObjectContext deleteObject:object];
        }
		 
        if(!([self.managedObjectContext save:&error]))
        {
            // Handle Error here.
            NSLog(@"LOG: %@",[error localizedDescription]);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
- (void)dropQuestionsQTable
{
    NSError *error;
    NSFetchRequest *all = [[NSFetchRequest alloc] init];
	
    [all setEntity:[NSEntityDescription entityForName:@"QuestionsQ" inManagedObjectContext:self.managedObjectContext]];
    [all setIncludesPropertyValues:NO]; //only fetch the managedObjectID
	
    NSArray *array = [self.managedObjectContext executeFetchRequest:all error:&error];
	
    // Se existirem dados para serem apagados....
    if ([array count] > 0)
    {
        //error handling goes here
        for (NSManagedObject *object in array)
        {
            [self.managedObjectContext deleteObject:object];
        }
		 
        if(!([self.managedObjectContext save:&error]))
        {
            // Handle Error here.
            NSLog(@"LOG: %@",[error localizedDescription]);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
- (void)dropQuestionsDTable
{
    NSError *error;
    NSFetchRequest *all = [[NSFetchRequest alloc] init];
	
    [all setEntity:[NSEntityDescription entityForName:@"QuestionsD" inManagedObjectContext:self.managedObjectContext]];
    [all setIncludesPropertyValues:NO]; //only fetch the managedObjectID
	
    NSArray *array = [self.managedObjectContext executeFetchRequest:all error:&error];
	
    // Se existirem dados para serem apagados....
    if ([array count] > 0)
    {
        //error handling goes here
        for (NSManagedObject *object in array)
        {
            [self.managedObjectContext deleteObject:object];
        }
		 
        if(!([self.managedObjectContext save:&error]))
        {
            // Handle Error here.
            NSLog(@"LOG: %@",[error localizedDescription]);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)getTrainingIdFromProductsTableWithProductId:(NSString *)product_id
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"InAppProducts"];
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"product_id==%@",product_id];
	
    NSArray *arrayFiltered = [mutableFetchResults filteredArrayUsingPredicate:predicate];
	
	 if([arrayFiltered count] > 0)
    {
        InAppProducts *thisproduct = (InAppProducts *) [arrayFiltered objectAtIndex:0];
        return thisproduct.training_id;
    }
    else
    {
        return nil;
    }
	
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
- (InAppProducts * )getInAppProductDataWithProductId:(NSString *)product_id
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"InAppProducts"];
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"product_id==%@",product_id];
	
    NSArray *arrayFiltered = [mutableFetchResults filteredArrayUsingPredicate:predicate];
	
	 if([arrayFiltered count] > 0)
    {
        InAppProducts *thisproduct = (InAppProducts *) [arrayFiltered objectAtIndex:0];
        return thisproduct;
    }
    else
    {
        return nil;
    }
	
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)getNameFromProductsTableWithProductId:(NSString *)product_id
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"InAppProducts"];
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"product_id==%@",product_id];
	
    NSArray *arrayFiltered = [mutableFetchResults filteredArrayUsingPredicate:predicate];
	
	 if([arrayFiltered count] > 0)
    {
        InAppProducts *thisproduct = (InAppProducts *) [arrayFiltered objectAtIndex:0];
        return thisproduct.titulo;
    }
    else
    {
        return nil;
    }
	
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)getDescriptionFromProductsTableWithProductId:(NSString *)product_id
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"InAppProducts"];
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"product_id==%@",product_id];
	
    NSArray *arrayFiltered = [mutableFetchResults filteredArrayUsingPredicate:predicate];
	
	 if([arrayFiltered count] > 0)
    {
        InAppProducts *thisproduct = (InAppProducts *) [arrayFiltered objectAtIndex:0];
        return thisproduct.descricao;
    }
    else
    {
        return nil;
    }
	
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

//                                        response_training_isnormaltraining.     response_training_isonlineadvisor
//
//1-TREINO PRATELEIRA                                   0                                                       0
//2-TREINO ASSESSORIA                                   0                                                       1
//3-TREINO NORMAL                                       1                                                       0



- (int)getTypeFromProductsTableWithProductId:(NSString *)product_id
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"InAppProducts"];
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"product_id==%@",product_id];
	
    NSArray *arrayFiltered = [mutableFetchResults filteredArrayUsingPredicate:predicate];
	
	 if([arrayFiltered count] > 0)
    {
        InAppProducts *thisproduct = (InAppProducts *) [arrayFiltered objectAtIndex:0];
        if([thisproduct.isonlineadvisor boolValue]==FALSE)
        		return SHELF_TRAINING ;
       else
        		return ADVISOR_TRAINING;
		 
    }
	
	 return 0;
	
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
- (NSArray *)getDataFromTransactionsTableWithIsSync:(BOOL)isSync isonlineadvisor:(BOOL)isonlineadvisor
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"InAppTransactions"];
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSync==%d && isonlineadvisor==%d",isSync,isonlineadvisor];
	
    NSArray *arrayFiltered = [mutableFetchResults filteredArrayUsingPredicate:predicate];
	
    return arrayFiltered;
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
- (InAppTransactions * )getInAppTransactionDataWithProductId:(NSString *)product_id
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"InAppTransactions"];
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"product_id==%@",product_id];
	
    NSArray *arrayFiltered = [mutableFetchResults filteredArrayUsingPredicate:predicate];
	
	 if([arrayFiltered count] > 0)
    {
        InAppTransactions *thistransaction = (InAppProducts *) [arrayFiltered objectAtIndex:0];
        return thistransaction;
    }
    else
    {
        return nil;
    }
	
}


////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
- (BOOL )checkValiditTransactionDateWithProductId:(NSString *)product_id
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"InAppTransactions"];
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isonlineadvisor==%d",1];
	
    NSArray *arrayFiltered = [mutableFetchResults filteredArrayUsingPredicate:predicate];
	
	 NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	 [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
	 NSDate *today= [NSDate date];
	 if([arrayFiltered count] > 0)
    {
        for(int i=0;i<[arrayFiltered count];i++)
        {
			  InAppTransactions *thistransaction = (InAppTransactions *) [arrayFiltered objectAtIndex:i];
			  if([thistransaction.product_id isEqualToString:product_id])
			  {
				  NSDate *expirationDate = [dateFormatter dateFromString:thistransaction.expiration];
				  //Retorna TRUE se pelo menos uma compra produto tem data válida e não deve deixar comprar
				  if([today compare:expirationDate]==NSOrderedAscending)
				  {
					  NSLog(@"today is less");
					  return TRUE;
				  }
			  }
		  }
		}
		return NO; //Pode comprar
	
	
}
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (Radio *)getDataFromRadioTable
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Radio"];
    NSArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
	
    return [mutableFetchResults objectAtIndex:0];
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (Chat *)getDataFromChatTable
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Chat"];
    NSArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if([mutableFetchResults count]>0)
    	return [mutableFetchResults objectAtIndex:0];
    else
    	return nil;
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (ClassSchedule *)getDataFromClassScheduleTable
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"ClassSchedule"];
    NSArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
	
    return [mutableFetchResults objectAtIndex:0];
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (NSArray *)getDataFromMessageTableWithUserID:(NSString *)userID TrainerID:(NSString *)trainerID
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Messages"];
	
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"created" ascending:FALSE];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];

    NSArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"senderID==%@ && receiverID==%@ || senderID==%@ && receiverID==%@ ",trainerID,userID,userID, trainerID];
	
    NSArray *filteredArray = [mutableFetchResults filteredArrayUsingPredicate:predicate];

    return filteredArray;
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (NSArray *)getDataFromMessageTableWithMessageID:(NSString *)messageID
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Messages"];
    NSArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
	
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"messageID==%@",messageID];
    NSArray *filteredArray = [mutableFetchResults filteredArrayUsingPredicate:predicate];
	
    return filteredArray;
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (TrainerInfo *)getDataFromTrainerInfoTable
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"TrainerInfo"];
    NSArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
	
    if([mutableFetchResults count]>0)
    	return [mutableFetchResults objectAtIndex:0];
    else
    	return nil;
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (NSArray *)getDataFromFeaturedImagesTable
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"FeaturedImages"];
    NSArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
	
    return mutableFetchResults;
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (void)deleteDataFromTrainingTableByTreineeID:(NSString *)treineeID
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Training"];
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"treineeID==%@",treineeID];
    NSArray *arrayFiltered = [mutableFetchResults filteredArrayUsingPredicate:predicate];
	
    if (arrayFiltered.count > 0)
    {
        for (NSManagedObject *obj in arrayFiltered)
        {
            [self.managedObjectContext deleteObject:obj];
        }
		 
        if(!([self.managedObjectContext save:&error]))
        {
            // Handle Error here.
            NSLog(@"LOG: %@", [error localizedDescription]);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (void)deleteDataFromExercisesTableByTreineeID:(NSString *)treineeID
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Exercises"];
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"treineeID==%@",treineeID];
    NSArray *arrayFiltered = [mutableFetchResults filteredArrayUsingPredicate:predicate];
	
    if (arrayFiltered.count > 0)
    {
        for (NSManagedObject *obj in arrayFiltered)
        {
            [self.managedObjectContext deleteObject:obj];
        }
		 
        if(!([self.managedObjectContext save:&error]))
        {
            // Handle Error here.
            NSLog(@"LOG: %@", [error localizedDescription]);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (Notes *)getDataFromNotesTableByUserID:(NSString *)userID TrainingID:(NSString *)trainingID ExerciseID:(NSString *)exerciseID
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Notes"];
    NSArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID==%@&&trainingID=%@&&exerciseID==%@",userID,trainingID,exerciseID];
    NSArray *filteredArray = [mutableFetchResults filteredArrayUsingPredicate:predicate];
	
    Notes *note = nil;

    if([filteredArray count] > 0)
    {
        note = (Notes *) [filteredArray objectAtIndex:0];
        return note;
    }
    else
    {
        return nil;
    }
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

-(void)setNoteWithUserID:(NSString *)userID TrainingID:(NSString *)trainingID ExerciseID:(NSString *)exerciseID Note:(NSString *)textNote
{
    NSError *error = nil;
    Notes *note = (Notes *)[self getDataFromNotesTableByUserID:userID
                                                    TrainingID:trainingID
                                                    ExerciseID:exerciseID];
	
    if (note == nil)
    {
        // NÃO EXITE A NOTA
        Notes *noteInsert = (Notes *)[NSEntityDescription insertNewObjectForEntityForName:@"Notes"
                                                                   inManagedObjectContext:self.managedObjectContext];
		 
        noteInsert.userID = userID;
        noteInsert.trainingID = trainingID;
        noteInsert.exerciseID = exerciseID;
        noteInsert.textNote = textNote;
		 
        // SALVA O OBJETO.
        if(!([self.managedObjectContext save:&error]))
        {
            // Handle Error here.
            NSLog(@"LOG: %@", [error localizedDescription]);
        }
    }
    else
    {
        note.userID = userID;
        note.trainingID = trainingID;
        note.exerciseID = exerciseID;
        note.textNote = textNote;
		 
        // SALVA O OBJETO.
        if(!([self.managedObjectContext save:&error]))
        {
            // Handle Error here.
            NSLog(@"LOG: %@", [error localizedDescription]);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (void)deleteDataFromTrainingTable:(BOOL)isHistory
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Training"];
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
	
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isHistory==%d",isHistory];
	
    NSArray *arrayFiltered = [mutableFetchResults filteredArrayUsingPredicate:predicate];
	
    if (arrayFiltered.count > 0)
    {
        for (NSManagedObject *obj in arrayFiltered)
        {
            [self.managedObjectContext deleteObject:obj];
        }
		 
        if(!([self.managedObjectContext save:&error]))
        {
            // Handle Error here.
            NSLog(@"LOG: %@", [error localizedDescription]);
        }
    }
}
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (void)deleteDataFromExercisesTableByTrainingID:(NSString *)trainingID ExerciseID:(NSString *)exerciseID
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Exercises"];
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"treineeID==%@",trainingID];
    NSArray *arrayFiltered = [mutableFetchResults filteredArrayUsingPredicate:predicate];
	
    if (arrayFiltered.count > 0)
    {
        for (NSManagedObject *obj in arrayFiltered)
        {
            [self.managedObjectContext deleteObject:obj];
        }
		 
        if(!([self.managedObjectContext save:&error]))
        {
            // Handle Error here.
            NSLog(@"LOG: %@", [error localizedDescription]);
        }
    }
}


////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (void)deleteDataFromExercisesTable:(BOOL)isHistory
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Exercises"];
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
	
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isHistory==%d",isHistory];

    NSArray *arrayFiltered = [mutableFetchResults filteredArrayUsingPredicate:predicate];
	
    if (arrayFiltered.count > 0)
    {
        for (NSManagedObject *obj in arrayFiltered)
        {
            [self.managedObjectContext deleteObject:obj];
        }
		 
        if(!([self.managedObjectContext save:&error]))
        {
            // Handle Error here.
            NSLog(@"LOG: %@", [error localizedDescription]);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (void)deleteSpecifiExerciseFromTrainingTable:(NSManagedObject*) obj
{
    [self.managedObjectContext deleteObject:obj];
	
}
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
#if 0
-(void)setExerciseNewInstruction:(NSString *)userID TrainingID:(NSString *)trainingID ExerciseID:(NSString *)exerciseID Note:(NSString *)Instruction
{
    NSError *error = nil;
    Exercises *exercise = (Exercises *)[self getDataFromExercisesTableWithExerciseID:
                                                    ExerciseID:exerciseID
                                                    TrainingID:trainingID
                                                    ];
	
    if (note == nil)
    {
        // NÃO EXITE A NOTA
        Notes *noteInsert = (Notes *)[NSEntityDescription insertNewObjectForEntityForName:@"Notes"
                                                                   inManagedObjectContext:self.managedObjectContext];
		 
        noteInsert.userID = userID;
        noteInsert.trainingID = trainingID;
        noteInsert.exerciseID = exerciseID;
        noteInsert.textNote = textNote;
		 
        // SALVA O OBJETO.
        if(!([self.managedObjectContext save:&error]))
        {
            // Handle Error here.
            NSLog(@"LOG: %@", [error localizedDescription]);
        }
    }
    else
    {
        note.userID = userID;
        note.trainingID = trainingID;
        note.exerciseID = exerciseID;
        note.textNote = textNote;
		 
        // SALVA O OBJETO.
        if(!([self.managedObjectContext save:&error]))
        {
            // Handle Error here.
            NSLog(@"LOG: %@", [error localizedDescription]);
        }
    }
}

#endif

@end

////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
