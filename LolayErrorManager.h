//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface LolayErrorManager : NSObject <UIAlertViewDelegate>

- (id) initWithDomain:(NSString*) inDomain;
					   
- (void) presentError:(NSError*) error;
- (void) presentErrors:(NSArray*) errors;
- (void) presentError:(NSInteger) code description:(NSString*) description recoverySuggestion:(NSString*) recoverySuggestion;
- (NSError*) createError:(NSInteger) code description:(NSString*) description recoverySuggestion:(NSString*) recoverySuggestion;

@end