//
//  Blog+CoreDataProperties.h
//  
//
//  Created by Rubens Rosa on 02/03/2018.
//  Copyright © 2018 4mobi. All rights reserved.
//
//

#import "Blog+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Blog (CoreDataProperties)

+ (NSFetchRequest<Blog *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *blogURL;
@property (nullable, nonatomic, copy) NSNumber *hasBlog;

@end

NS_ASSUME_NONNULL_END
