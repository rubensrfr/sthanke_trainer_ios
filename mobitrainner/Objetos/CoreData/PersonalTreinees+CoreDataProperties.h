//
//  PersonalTreinees+CoreDataProperties.h
//  mobitrainer
//
//  Created by Rubens Rosa on 07/12/2017.
//  Copyright © 2017 4mobi. All rights reserved.
//
//

#import "PersonalTreinees+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface PersonalTreinees (CoreDataProperties)

+ (NSFetchRequest<PersonalTreinees *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *email;
@property (nullable, nonatomic, copy) NSString *firstName;
@property (nullable, nonatomic, copy) NSString *image;
@property (nullable, nonatomic, copy) NSString *lastName;
@property (nullable, nonatomic, copy) NSString *lastUpdate;
@property (nullable, nonatomic, copy) NSString *treineeID;
@property (nullable, nonatomic, copy) NSNumber *unreadMessages;
@property (nullable, nonatomic, copy) NSString *trainerID;
@property (nullable, nonatomic, copy) NSString *traineeStatus;

@end

NS_ASSUME_NONNULL_END
