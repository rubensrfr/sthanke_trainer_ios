//
// KKRandom.h
//
// Created by Kadasiddha Kullolli on 11/12/2015.
// Copyright 2015 Kadasiddha Kullolli


#import <Foundation/Foundation.h>


/*
 * Utility class for generating random data.
 */
@interface KKRandom : NSObject

+ (BOOL) generateNumberBetweenLow: (NSInteger) low andHigh: (NSInteger) high intoReceiver: (NSInteger *) receiver;
+ (BOOL) generateNumberSequenceOfLength: (NSUInteger) length into: (NSInteger[]) sequence betweenLow: (NSInteger) low andHigh: (NSInteger) high withOnlyUniqueValues: (BOOL) onlyUniqueValues;
+ (BOOL) chooseNumberFromSequence: (NSInteger[]) sequence ofLength: (NSUInteger) length intoReceiver: (NSInteger *) receiver;
+ (BOOL) isNumber: (NSInteger) number inSequence: (NSInteger[]) sequence ofLength: (NSUInteger) length;
+ (NSData *) generateRandomSignedDataOfLength: (NSUInteger) length;
+ (NSData *) generateRandomDataOfLength: (NSUInteger) length;
+ (NSString *) generateRandomStringOfLength: (NSUInteger) length;
+ (NSString *) generateRandomStringOfLength: (NSUInteger) length withOnlyCharacters: (NSString *) characters;

+ (NSDate *) generateRandomDateBetweenDaysAgo: (NSInteger)daysAgo andDaysFromNow: (NSInteger)daysFromNow;

@end