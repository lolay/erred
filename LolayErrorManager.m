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

@synthesize showingError;
@synthesize domain;

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
	return [self presentError:code description:description recoverySuggestion:recoverySuggestion title:nil];
}

- (void) presentError:(NSInteger) code description:(NSString*) description recoverySuggestion:(NSString*) recoverySuggestion title:(NSString*) title {
	[self presentError:[self createError:code description:description recoverySuggestion:recoverySuggestion title:title]];
}

- (NSError*) createError:(NSInteger) code description:(NSString*) description recoverySuggestion:(NSString*) recoverySuggestion {
	return [self createError:code description:description recoverySuggestion:recoverySuggestion title:nil];
}

- (NSError*) createError:(NSInteger) code description:(NSString*) description recoverySuggestion:(NSString*) recoverySuggestion title:(NSString*) title {
	NSMutableDictionary* userInfo = [NSMutableDictionary new];
	if (description) {
		[userInfo setObject:description forKey:NSLocalizedDescriptionKey];
	}
	if (recoverySuggestion) {
		[userInfo setObject:recoverySuggestion forKey:NSLocalizedRecoverySuggestionErrorKey];
	}
	if (title) {
		[userInfo setObject:title forKey:LolayErrorLocalizedTitleKey];
	}
	
	return [NSError errorWithDomain:self.domain code:code userInfo:[userInfo autorelease]];
}

#pragma mark -
#pragma mark Alert View Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	DLog(@"enter");
	self.showingError = NO;
}

@end