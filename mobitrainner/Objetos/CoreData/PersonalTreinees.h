//
//  PersonalTreinees+CoreDataProperties.h
//  mobitrainer
//
//  Created by Reginaldo Lopes on 01/12/15.
//  Copyright © 2015 4mobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface PersonalTreinees : NSManagedObject

@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *image;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSString *lastUpdate;
@property (nonatomic, retain) NSString *treineeID;
@property (nonatomic, retain) NSNumber *unreadMessages;
@property (nullable, nonatomic, copy) NSString *trainerID;
@property (nullable, nonatomic, copy) NSString *traineeStatus;

@end

