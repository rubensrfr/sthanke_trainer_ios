//
//  Blog+CoreDataProperties.m
//  
//
//  Created by Rubens Rosa on 02/03/2018.
//  Copyright © 2018 4mobi. All rights reserved.
//
//

#import "Blog+CoreDataProperties.h"

@implementation Blog (CoreDataProperties)

+ (NSFetchRequest<Blog *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Blog"];
}

@dynamic blogURL;
@dynamic hasBlog;

@end
