//
//  BlogFeeds+CoreDataProperties.m
//  
//
//  Created by Rubens Rosa on 02/03/2018.
//  Copyright © 2018 4mobi. All rights reserved.
//
//

#import "BlogFeeds+CoreDataProperties.h"

@implementation BlogFeeds (CoreDataProperties)

+ (NSFetchRequest<BlogFeeds *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"BlogFeeds"];
}

@dynamic content;
@dynamic descricao;
@dynamic guid;
@dynamic link;
@dynamic pubDate;
@dynamic titulo;

@end
