//
//  ExerciseList.m
//  mobitrainer
//
//  Created by Reginaldo Lopes on 06/11/15.
//  Copyright © 2015 4mobi. All rights reserved.
//

#import "ExerciseList.h"

@implementation ExerciseList

@synthesize circuitID;
@synthesize exerciseID;
@synthesize fullDescription;
@synthesize fullExecution;
@synthesize icon;
@synthesize image1;
@synthesize image2;
@synthesize instruction;
@synthesize isCircuit;
@synthesize isDone;
@synthesize muscle;
@synthesize name;
@synthesize order;
@synthesize trainingID;
@synthesize treineeID;
@synthesize type;
@synthesize video;

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    
    if(self)
    {
        self.circuitID = [decoder decodeObjectForKey:@"circuitID"];
        self.exerciseID = [decoder decodeObjectForKey:@"exerciseID"];
        self.fullDescription = [decoder decodeObjectForKey:@"fullDescription"];
        self.fullExecution = [decoder decodeObjectForKey:@"fullExecution"];
        self.icon = [decoder decodeObjectForKey:@"icon"];
        self.image1 = [decoder decodeObjectForKey:@"image1"];
        self.image2 = [decoder decodeObjectForKey:@"image2"];
        self.instruction = [decoder decodeObjectForKey:@"instruction"];
        self.isCircuit = [decoder decodeObjectForKey:@"isCircuit"];
        self.isDone = [decoder decodeObjectForKey:@"isDone"];
        self.muscle = [decoder decodeObjectForKey:@"muscle"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.order = [decoder decodeObjectForKey:@"order"];
        self.trainingID = [decoder decodeObjectForKey:@"trainingID"];
        self.treineeID = [decoder decodeObjectForKey:@"treineeID"];
        self.type = [decoder decodeObjectForKey:@"type"];
        self.video = [decoder decodeObjectForKey:@"video"];
    }
    
    return self;
}

-(void) encodeWithCoder: (NSCoder *) encoder
{
    [encoder encodeObject:self.circuitID forKey:@"circuitID"];
    [encoder encodeObject:self.exerciseID forKey:@"exerciseID"];
    [encoder encodeObject:self.fullDescription forKey:@"fullDescription"];
    [encoder encodeObject:self.fullExecution forKey:@"fullExecution"];
    [encoder encodeObject:self.icon forKey:@"icon"];
    [encoder encodeObject:self.image1 forKey:@"image1"];
    [encoder encodeObject:self.image2 forKey:@"image2"];
    [encoder encodeObject:self.instruction forKey:@"instruction"];
    [encoder encodeObject:self.isCircuit forKey:@"isCircuit"];
    [encoder encodeObject:self.isDone forKey:@"isDone"];
    [encoder encodeObject:self.muscle forKey:@"muscle"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.order forKey:@"order"];
    [encoder encodeObject:self.trainingID forKey:@"trainingID"];
    [encoder encodeObject:self.treineeID forKey:@"treineeID"];
    [encoder encodeObject:self.type forKey:@"type"];
    [encoder encodeObject:self.video forKey:@"video"];
}

@end
