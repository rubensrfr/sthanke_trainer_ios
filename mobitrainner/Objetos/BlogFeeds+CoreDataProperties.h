//
//  BlogFeeds+CoreDataProperties.h
//  
//
//  Created by Rubens Rosa on 02/03/2018.
//  Copyright © 2018 4mobi. All rights reserved.
//
//

#import "BlogFeeds+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface BlogFeeds (CoreDataProperties)

+ (NSFetchRequest<BlogFeeds *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSString *descricao;
@property (nullable, nonatomic, copy) NSString *guid;
@property (nullable, nonatomic, copy) NSString *link;
@property (nullable, nonatomic, copy) NSString *pubDate;
@property (nullable, nonatomic, copy) NSString *titulo;

@end

NS_ASSUME_NONNULL_END
