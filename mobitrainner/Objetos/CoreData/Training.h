//
//  Training.h
//  
//
//  Created by Reginaldo Lopes on 03/07/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Training : NSManagedObject
@property (nonatomic, retain) NSString * training_id;
@property (nonatomic, retain) NSString * digitalproduct_id;
@property (nonatomic, retain) NSString * publickey;
@property (nonatomic, retain) NSString * expireDate;
@property (nonatomic, retain) NSString * fullDescription;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSNumber * isHistory;
@property (nonatomic, retain) NSNumber * serieIsLock;
@property (nonatomic, retain) NSString * trainingID;
@property (nonatomic, retain) NSString * treineeID;
@property (nonatomic, retain) NSNumber * difficulty;
@property (nonatomic, retain) NSDate * serieDateInit;
@property (nonatomic, retain) NSDate * serieDateEnd;
@property (nonatomic, retain) NSString * serieOnOffStatus; //1=ON, 2=OFF

@end
