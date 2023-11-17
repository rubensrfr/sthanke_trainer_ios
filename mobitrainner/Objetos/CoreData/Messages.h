//
//  Messages.h
//  mobitrainer
//
//  Created by Reginaldo Lopes on 27/08/15.
//  Copyright (c) 2015 4mobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Messages : NSManagedObject

@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSNumber * isSync;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSString * messageID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * receiverID;
@property (nonatomic, retain) NSString * senderID;
@property (nonatomic, retain) NSString * apiKey;

@end
