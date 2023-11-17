//
//  ExerciseList.h
//  mobitrainer
//
//  Created by Reginaldo Lopes on 06/11/15.
//  Copyright © 2015 4mobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExerciseList : NSObject

@property (nonatomic, retain) NSString * circuitID;
@property (nonatomic, retain) NSString * exerciseID;
@property (nonatomic, retain) NSString * fullDescription;
@property (nonatomic, retain) NSString * fullExecution;
@property (nonatomic, retain) NSString * icon;
@property (nonatomic, retain) NSString * image1;
@property (nonatomic, retain) NSString * image2;
@property (nonatomic, retain) NSString * instruction;
@property (nonatomic, retain) NSNumber * isCircuit;
@property (nonatomic, retain) NSNumber * isDone;
@property (nonatomic, retain) NSString * muscle;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSString * trainingID;
@property (nonatomic, retain) NSString * treineeID;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * video;

@end
