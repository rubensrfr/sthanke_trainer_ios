//
//  History.h
//  
//
//  Created by Reginaldo Lopes on 03/07/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface History : NSManagedObject

@property (nonatomic, retain) NSString * endDate;
@property (nonatomic, retain) NSNumber * isSync;
@property (nonatomic, retain) NSString * trainingID;
@property (nonatomic, retain) NSString * trainingName;
@property (nonatomic, retain) NSString * treineeID;
@property (nonatomic, retain) NSString * userDescription;
@property (nonatomic, retain) NSNumber * isClass;

@end
