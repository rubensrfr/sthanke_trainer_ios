//
//  ClassScheduleItem.h
//  mobitrainer
//
//  Created by Reginaldo Lopes on 26/07/16.
//  Copyright © 2016 4mobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ClassScheduleItem : NSManagedObject

@property (nonatomic, retain) NSNumber *amount;
@property (nonatomic, retain) NSNumber *duration;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *objective;
@property (nonatomic, retain) NSString *room;
@property (nonatomic, retain) NSString *startAt;
@property (nonatomic, retain) NSString *teacher;
@property (nonatomic, retain) NSNumber *weekday;
@property (nonatomic, retain) NSNumber *classScheduleID;

@end
