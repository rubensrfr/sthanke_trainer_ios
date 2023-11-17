//
//  Note.h
//  mobitrainer
//
//  Created by Reginaldo Lopes on 27/04/16.
//  Copyright © 2016 4mobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Notes : NSManagedObject

@property (nonatomic, retain) NSString *userID;
@property (nonatomic, retain) NSString *exerciseID;
@property (nonatomic, retain) NSString *textNote;
@property (nonatomic, retain) NSString *trainingID;

@end
