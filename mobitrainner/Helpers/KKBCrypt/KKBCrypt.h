//
// KKBCrypt.h
//
// Created by Kadasiddha Kullolli on 11/12/2015.
// Copyright 2015 Kadasiddha Kullolli


#import <Foundation/Foundation.h>

#import "KKGC.h"		// For GC related macros
#import "KKRandom.h"	// For generating random salts


/*
 * The KKBCrypt utility class.
 * This class has been tested to work on iOS 9.2.
 */
@interface KKBCrypt : NSObject {
    
@private
    SInt32 *_p;
    SInt32 *_s;
}

+ (NSString *) hashPassword: (NSString *) password withSalt: (NSString *) salt;
+ (NSString *) generateSaltWithNumberOfRounds: (SInt32) numberOfRounds;

@end
