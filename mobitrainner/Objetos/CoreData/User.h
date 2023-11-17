//
//  User.h
//  
//
//  Created by Reginaldo Lopes on 03/07/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * apiKey;
@property (nonatomic, retain) NSString * birthday;
@property (nonatomic, retain) NSString * createAt;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSString * trainerID;
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSNumber * weight;

@end
