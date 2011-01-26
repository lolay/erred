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

- (id) initWithDomain:(NSString*) inDomain {
	NSLog(@"[LolayErrorManager init] enter");
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

- (void) presentError:(NSError*) error {
	NSLog(@"[LolayErrorManager presentError] enter error=%@", error);
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
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whoops!" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
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
	[self presentError:[self createError:code description:description recoverySuggestion:recoverySuggestion]];
}

- (NSError*) createError:(NSInteger) code description:(NSString*) description recoverySuggestion:(NSString*) recoverySuggestion {
	return [NSError errorWithDomain:self.domain code:code userInfo:
			[NSDictionary dictionaryWithObjectsAndKeys:description, NSLocalizedDescriptionKey,
			 recoverySuggestion, NSLocalizedRecoverySuggestionErrorKey,
			 nil]];
}

#pragma mark -
#pragma mark Alert View Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSLog(@"[LolayErrorManager alertView] enter");
	self.showingError = NO;
}

@end