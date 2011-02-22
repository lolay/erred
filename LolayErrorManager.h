//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//
#import <Foundation/Foundation.h>

#define LolayErrorLocalizedTitleKey @"LolayErrorLocalizedTitleKey_"

@interface LolayErrorManager : NSObject <UIAlertViewDelegate>

- (id) initWithDomain:(NSString*) inDomain;
					   
- (void) presentError:(NSError*) error;
- (void) presentErrors:(NSArray*) errors;
- (void) presentError:(NSInteger) code description:(NSString*) description recoverySuggestion:(NSString*) recoverySuggestion;
- (void) presentError:(NSInteger) code description:(NSString*) description recoverySuggestion:(NSString*) recoverySuggestion title:(NSString*) title;
- (NSError*) createError:(NSInteger) code description:(NSString*) description recoverySuggestion:(NSString*) recoverySuggestion;
- (NSError*) createError:(NSInteger) code description:(NSString*) description recoverySuggestion:(NSString*) recoverySuggestion title:(NSString*) title;

@end