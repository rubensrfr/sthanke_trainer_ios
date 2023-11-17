//
//  FeaturedImages.h
//  
//
//  Created by Reginaldo Lopes on 03/07/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FeaturedImages : NSManagedObject

@property (nonatomic, retain) NSNumber * imagesCount;
@property (nonatomic, retain) NSNumber * isVerified;

@end
