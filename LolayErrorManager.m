//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//
#import "LolayErrorManager.h"

@interface LolayErrorManager ()

@property (nonatomic, assign) BOOL showingError;
@property (nonatomic, retain) NSString* domain;

@end

@implementation LolayErrorManager

@synthesize showingError = showingError_;
@synthesize domain = domain_;

- (id) initWithDomain:(NSString*) inDomain {
	DLog(@"enter");
	self = [super init];
	
	if (self) {
		self.domain = inDomain;
		self.showingError = NO;
	}
	
	return self;
}

- (void) dealloc {
	self.domain = nil;
	
	[super dealloc];
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
		self.showingError = YES;
		
		NSString* message = error.localizedRecoverySuggestion != nil ?
		[[NSString stringWithFormat:@"%@\n%@\n(%@:%i)", error.localizedDescription, error.localizedRecoverySuggestion, error.domain, error.code] retain] :
		[[NSString stringWithFormat:@"%@\n(%@:%i)", error.localizedDescription, error.domain, error.code] retain];
		
		NSString* title = [error.userInfo objectForKey:LolayErrorLocalizedTitleKey];
		if (title.length == 0) {
			title = @"Whoops!";
		}
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[message release];
		[alert show];
		[alert release];
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
	NSString* titleKey = [NSString stringWithFormat:@"error-%i-localizedTitle", code];
	NSString* descriptionKey = [NSString stringWithFormat:@"error-%i-localizedDescription", code];
	NSString* recoveryKey = [NSString stringWithFormat:@"error-%i-recoverySuggestion", code];
	if (suffix) {
		titleKey = [titleKey stringByAppendingFormat:@"-%@", suffix];
		descriptionKey = [descriptionKey stringByAppendingFormat:@"-%@", suffix];
		recoveryKey = [recoveryKey stringByAppendingFormat:@"-%@", suffix];
	}
	
	NSString* title = NSLocalizedString(titleKey, @"Error title");
	NSString* description = NSLocalizedString(descriptionKey, @"Error Description");
	NSString* recoverySuggestion = NSLocalizedString(recoveryKey, @"Error Recovery Suggestion");
	
	if ([title length] == 0 || [title isEqualToString:titleKey]) {
		title = NSLocalizedString(@"error-localizedTitle", @"Error Default Title");
		
		if ([title length] == 0 || [title isEqualToString:@"error-localizedTitle"]) {
			title = nil;
		}
	}
	
	if ([description length] == 0 || [description isEqualToString:descriptionKey]) {
		description = NSLocalizedString(@"error-localizedDescription", @"Error Default Description");
		
		if ([description length] == 0 || [description isEqualToString:@"error-localizedDescription"]) {
			description = nil;
		}
	}
	
	if ([recoverySuggestion length] == 0 || [recoverySuggestion isEqualToString:recoveryKey]) {
		recoverySuggestion = NSLocalizedString(@"error-recoverySuggestion", @"Error Default Recovery Suggestion");
		
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	DLog(@"enter");
	self.showingError = NO;
}

@end