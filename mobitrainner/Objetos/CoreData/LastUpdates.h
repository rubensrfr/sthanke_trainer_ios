//
//  LastUpdates.h
//  
//
//  Created by Reginaldo Lopes on 03/07/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LastUpdates : NSManagedObject

@property (nonatomic, retain) NSString * blog;
@property (nonatomic, retain) NSString * chat;
@property (nonatomic, retain) NSString * design;
@property (nonatomic, retain) NSString * featuredImages;
@property (nonatomic, retain) NSString * radio;
@property (nonatomic, retain) NSString * trainee;
@property (nonatomic, retain) NSString * trainerInfo;
@property (nonatomic, retain) NSString * training;
@property (nonatomic, retain) NSString * userProfile;
@property (nonatomic, retain) NSString * classschedule;

@end
