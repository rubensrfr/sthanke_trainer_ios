//
//  Design.h
//  
//
//  Created by Reginaldo Lopes on 03/07/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Design : NSManagedObject

@property (nonatomic, retain) NSNumber * blackStatusBar;
@property (nonatomic, retain) NSString * navColor;
@property (nonatomic, retain) NSString * navTint;
@property (nonatomic, retain) NSString * navTitleColor;

@end
