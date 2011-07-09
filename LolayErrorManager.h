//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "LolayErrorDelegate.h"

#define LolayErrorLocalizedTitleKey @"LolayErrorLocalizedTitleKey_"

@interface LolayErrorManager : NSObject <UIAlertViewDelegate>

@property (nonatomic, assign) id<LolayErrorDelegate> delegate;

- (id) initWithDomain:(NSString*) inDomain;
					   
- (void) presentErrorCode:(NSInteger) code;
- (void) presentErrorCode:(NSInteger) code suffix:(NSString*) suffix;
- (void) presentErrorCode:(NSInteger) code error:(NSError*) error;
- (void) presentErrorCode:(NSInteger) code suffix:(NSString*) suffix error:(NSError*) error;
- (void) presentError:(NSError*) error;
- (void) presentErrors:(NSArray*) errors;
- (void) presentError:(NSInteger) code description:(NSString*) description recoverySuggestion:(NSString*) recoverySuggestion;
- (void) presentError:(NSInteger) code description:(NSString*) description recoverySuggestion:(NSString*) recoverySuggestion error:(NSError*) error;
- (void) presentError:(NSInteger) code description:(NSString*) description recoverySuggestion:(NSString*) recoverySuggestion title:(NSString*) title;
- (void) presentError:(NSInteger) code description:(NSString*) description recoverySuggestion:(NSString*) recoverySuggestion title:(NSString*) title error:(NSError*) error;
- (NSError*) createError:(NSInteger) code;
- (NSError*) createError:(NSInteger) code suffix:(NSString*) suffix;
- (NSError*) createError:(NSInteger) code error:(NSError*) error;
- (NSError*) createError:(NSInteger) code suffix:(NSString*) suffix error:(NSError*) error;
- (NSError*) createError:(NSInteger) code description:(NSString*) description recoverySuggestion:(NSString*) recoverySuggestion;
- (NSError*) createError:(NSInteger) code description:(NSString*) description recoverySuggestion:(NSString*) recoverySuggestion error:(NSError*) error;
- (NSError*) createError:(NSInteger) code description:(NSString*) description recoverySuggestion:(NSString*) recoverySuggestion title:(NSString*) title;
- (NSError*) createError:(NSInteger) code description:(NSString*) description recoverySuggestion:(NSString*) recoverySuggestion title:(NSString*) title error:(NSError*) error;

@end