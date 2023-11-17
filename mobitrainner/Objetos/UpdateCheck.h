//
//  UpdateCheck.h
//  mobitrainner
//
//  Created by Reginaldo Lopes on 22/01/15.
//  Copyright (c) 2015 4mobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpdateCheck : NSObject

@property (nonatomic, retain) NSString *designLastUpdate;
@property (nonatomic, retain) NSString *blogLastUpdate;
@property (nonatomic, retain) NSString *trainerInfoLastUpdate;
@property (nonatomic, retain) NSString *featuredImagesLastUpdate;
@property (nonatomic, retain) NSString *trainingLastUpdate;
@property (nonatomic, retain) NSString *traineeLastUpdate;
@property (nonatomic, retain) NSString *userProfileLastUpdate;
@property (nonatomic, retain) NSString *chatLastUpdate;
@property (nonatomic, retain) NSString *radioLastUpdate;
@property (nonatomic, retain) NSString *classScheduleLastUpdate;

@end
