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

#import "LolayErrorManager.h"

@interface LolayErrorManager ()

@property (nonatomic, assign) BOOL showingError;
@property (nonatomic, strong, readwrite) NSString* domain;

@end

@implementation LolayErrorManager

@synthesize delegate = delegate_;
@synthesize showingError = showingError_;
@synthesize domain = domain_;

- (id) initWithDomain:(NSString*) inDomain {
	DLog(@"enter");
	self = [super init];
	
	if (self) {
		self.delegate = nil;
		self.domain = inDomain;
		self.showingError = NO;
	}
	
	return self;
}

- (NSString*) localizedString:(NSString*) key {
	if ([self.delegate respondsToSelector:@selector(errorManager:localizedString:)]) {
		return [self.delegate errorManager:self localizedString:key];
	}
	
	return NSLocalizedString(key, nil);
}

- (NSString*) titleForError:(NSError*) error {
	if ([self.delegate respondsToSelector:@selector(errorManager:titleForError:)]) {
		return [self.delegate errorManager:self titleForError:error];
	}
	
	NSString* title = [error.userInfo objectForKey:LolayErrorLocalizedTitleKey];
	if ([title length] == 0) {
		title = NSLocalizedString(@"error-localizedTitle", @"Error Title Text");
		if ([title length] == 0 || [title isEqualToString:@"error-localizedTitle"]) {
			title = @"Whoops!";
		}
	}
	return title;
}

- (NSString*) messageForError:(NSError*) error {
	if ([self.delegate respondsToSelector:@selector(errorManager:messageForError:)]) {
		return [self.delegate errorManager:self messageForError:error];
	}
	
	NSString* message = [error.localizedRecoverySuggestion length] > 0 ?
	[NSString stringWithFormat:@"%@\n%@\n(%@:%li)", error.localizedDescription, error.localizedRecoverySuggestion, error.domain, (long) error.code] :
	[NSString stringWithFormat:@"%@\n(%@:%li)", error.localizedDescription, error.domain, (long) error.code];
	return message;
}

- (NSString*) buttonTextForError:(NSError*) error {
	if ([self.delegate respondsToSelector:@selector(errorManager:buttonTextForError:)]) {
		return [self.delegate errorManager:self buttonTextForError:error];
	}
	
	NSString* buttonText = NSLocalizedString(@"error-buttonText", @"Error Button Text Button");
	if ([buttonText length] == 0 || [buttonText isEqualToString:@"error-buttonText"]) {
		buttonText = @"Ok";
	}
	return buttonText;
}

- (void) presentErrorCode:(NSInteger) code {
	[self presentErrorCode:code suffix:nil error:nil];
}

- (void) presentErrorCode:(NSInteger) code suffix:(NSString*) suffix {
	[self presentErrorCode:code suffix:suffix error:nil];
}

- (void) presentErrorCode:(NSInteger) code error:(NSError*) error {
	[self presentErrorCode:code suffix:nil error:error];
}

- (void) presentErrorCode:(NSInteger) code suffix:(NSString*) suffix error:(NSError*) error {
	[self presentError:[self createError:code suffix:suffix error:error]];
}

- (void) presentError:(NSError*) error {
	DLog(@"enter error=%@", error);
	if (error == nil) {
		return;
	}
	
	if ([NSThread isMainThread] == NO) {
		[self performSelectorOnMainThread:@selector(presentError:) withObject:error waitUntilDone:YES];
		return;
	}
	
	if (! self.showingError) {
		BOOL presentError = YES;
		if ([self.delegate respondsToSelector:@selector(errorManager:shouldPresentError:)]) {
			presentError = [self.delegate errorManager:self shouldPresentError:error];
		}
		
		if (presentError) {
			self.showingError = YES;
			
			NSString* title = [self titleForError:error];
			NSString* message = [self messageForError:error];
			NSString* buttonText = [self buttonTextForError:error];
			
			UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:buttonText otherButtonTitles:nil];
			[alert show];
			
			if (self.delegate && [self.delegate respondsToSelector:@selector(errorManager:errorPresented:)]) {
				[self.delegate errorManager:self errorPresented:error];
			}
		}
	}
}

- (void) presentErrors:(NSArray*) errors {
	if (errors == nil) {
		return;
	}
	
	for (NSError* error in errors) {
		[self presentError:error];
	}
}

- (void) presentError:(NSInteger) code description:(NSString*) description recoverySuggestion:(NSString*) recoverySuggestion {
	return [self presentError:code description:description recoverySuggestion:recoverySuggestion title:nil error:nil];
}

- (void) presentError:(NSInteger) code description:(NSString*) description recoverySuggestion:(NSString*) recoverySuggestion error:(NSError*) error {
	return [self presentError:code description:description recoverySuggestion:recoverySuggestion title:nil error:error];
}

- (void) presentError:(NSInteger) code description:(NSString*) description recoverySuggestion:(NSString*) recoverySuggestion title:(NSString*) title {
	[self presentError:[self createError:code description:description recoverySuggestion:recoverySuggestion title:title error:nil]];
}

- (void) presentError:(NSInteger) code description:(NSString*) description recoverySuggestion:(NSString*) recoverySuggestion title:(NSString*) title error:(NSError*) error {
	[self presentError:[self createError:code description:description recoverySuggestion:recoverySuggestion title:title error:error]];
}

- (NSError*) createError:(NSInteger) code {
	return [self createError:code error:nil];
}

- (NSError*) createError:(NSInteger) code suffix:(NSString*) suffix {
	return [self createError:code suffix:suffix error:nil];
}

- (NSError*) createError:(NSInteger) code error:(NSError*) error {
	return [self createError:code suffix:nil error:error];
}

- (NSError*) createError:(NSInteger) code suffix:(NSString*) suffix error:(NSError*) error {
	NSString* titleKey = [NSString stringWithFormat:@"error-%li-localizedTitle", (long) code];
	NSString* descriptionKey = [NSString stringWithFormat:@"error-%li-localizedDescription", (long) code];
	NSString* recoveryKey = [NSString stringWithFormat:@"error-%li-recoverySuggestion", (long) code];
	if (suffix) {
		titleKey = [titleKey stringByAppendingFormat:@"-%@", suffix];
		descriptionKey = [descriptionKey stringByAppendingFormat:@"-%@", suffix];
		recoveryKey = [recoveryKey stringByAppendingFormat:@"-%@", suffix];
	}
	
	NSString* title = [self localizedString:titleKey];
	NSString* description = [self localizedString:descriptionKey];
	NSString* recoverySuggestion = [self localizedString:recoveryKey];
	
	if ([title length] == 0 || [title isEqualToString:titleKey]) {
		title = [self localizedString:@"error-localizedTitle"];
		
		if ([title length] == 0 || [title isEqualToString:@"error-localizedTitle"]) {
			title = nil;
		}
	}
	
	if ([description length] == 0 || [description isEqualToString:descriptionKey]) {
		description = [self localizedString:@"error-localizedDescription"];
		
		if ([description length] == 0 || [description isEqualToString:@"error-localizedDescription"]) {
			description = nil;
		}
	}
	
	if ([recoverySuggestion length] == 0 || [recoverySuggestion isEqualToString:recoveryKey]) {
		recoverySuggestion = [self localizedString:@"error-recoverySuggestion"];
		
		if ([recoverySuggestion length] == 0 || [recoverySuggestion isEqualToString:@"error-recoverySuggestion"]) {
			recoverySuggestion = nil;
		}
	}
	
	return [self createError:code description:description recoverySuggestion:recoverySuggestion title:title error:error];
}

- (NSError*) createError:(NSInteger) code description:(NSString*) description recoverySuggestion:(NSString*) recoverySuggestion {
	return [self createError:code description:description recoverySuggestion:recoverySuggestion title:nil error:nil];
}

- (NSError*) createError:(NSInteger) code description:(NSString*) description recoverySuggestion:(NSString*) recoverySuggestion error:(NSError*) error {
	return [self createError:code description:description recoverySuggestion:recoverySuggestion title:nil error:error];
}

- (NSError*) createError:(NSInteger) code description:(NSString*) description recoverySuggestion:(NSString*) recoverySuggestion title:(NSString*) title {
	return [self createError:code description:description recoverySuggestion:recoverySuggestion title:title error:nil];
}

- (NSError*) createError:(NSInteger) code description:(NSString*) description recoverySuggestion:(NSString*) recoverySuggestion title:(NSString*) title error:(NSError*) error {
	NSMutableDictionary* userInfo = [NSMutableDictionary dictionaryWithCapacity:4];
	if (description) {
		[userInfo setObject:description forKey:NSLocalizedDescriptionKey];
	}
	if (recoverySuggestion) {
		[userInfo setObject:recoverySuggestion forKey:NSLocalizedRecoverySuggestionErrorKey];
	}
	if (title) {
		[userInfo setObject:title forKey:LolayErrorLocalizedTitleKey];
	}
	if (error) {
		[userInfo setObject:error forKey:NSUnderlyingErrorKey];
	}
	
	return [NSError errorWithDomain:self.domain code:code userInfo:userInfo];
}

#pragma mark -
#pragma mark Alert View Delegate Methods

- (void) alertView:(UIAlertView*) alertView clickedButtonAtIndex:(NSInteger) buttonIndex {
	DLog(@"enter");
	self.showingError = NO;
}

@end
