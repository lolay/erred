//
//  Copyright 2012 Lolay, Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <Foundation/Foundation.h>
#import "LolayErrorDelegate.h"

#define LolayErrorLocalizedTitleKey @"LolayErrorLocalizedTitleKey_"

@interface LolayErrorManager : NSObject <UIAlertViewDelegate>

@property (nonatomic, unsafe_unretained) id<LolayErrorDelegate> delegate;
@property (nonatomic, strong, readonly) NSString* domain;

- (id) initWithDomain:(NSString*) inDomain;

- (NSString*) titleForError:(NSError*) error;
- (NSString*) messageForError:(NSError*) error;
- (NSString*) buttonTextForError:(NSError*) error;
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
