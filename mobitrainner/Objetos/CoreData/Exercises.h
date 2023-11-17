//
//  Exercises.h
//  
//
//  Created by Reginaldo Lopes on 03/07/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Exercises : NSManagedObject
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * relexercise_id;
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
@property (nonatomic, retain) NSNumber * isHistory;
@property (nonatomic, retain) NSString * muscle;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSString * trainingID;
@property (nonatomic, retain) NSString * treineeID;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * video;
@property (nonatomic, retain) NSString * load;
@property (nonatomic, retain) NSString * rest;
@property (nonatomic, retain) NSString * repeat;
@property (nonatomic, retain) NSString * serie;

@end
