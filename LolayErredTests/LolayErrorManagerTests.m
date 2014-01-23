//
//  LolayErrorManagerTests.m
//  LolayErred
//
//  Created by Patrick Ortiz on 1/22/14.
//  Copyright (c) 2014 Lolay. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LolayErrorManager.h"
#import "NSError+Lolay.h"
#import "OCMock.h"
#import "MockDelegate.h"
@interface LolayErrorManagerTests : XCTestCase <UIAlertViewDelegate,LolayErrorDelegate>

@property(nonatomic,strong) LolayErrorManager *errorManager;
@property(nonatomic,strong) NSError* error;
@property(nonatomic,strong) NSDictionary *errorStrings;
@end

@implementation LolayErrorManagerTests

- (void) setUp
{
    [super setUp];
	self.errorManager = [[LolayErrorManager alloc] initWithDomain:@"LolayTest"];
	self.errorManager.delegate = self;
	self.errorStrings = @{@"error-localizedTitle":@"LOC_TITLE"
						  ,@"error-localizedDescription":@"LOC_DESCRIPTION"
						  ,@"error-recoverySuggestion":@"LOC_SUGGESTION"
						  ,@"error-1-localizedTitle":@"LOC_TITLE_CODE_1"
						  ,@"error-1-localizedDescription":@"LOC_DESCRIPTION_CODE_1"
						  ,@"error-1-recoverySuggestion":@"LOC_RECOVERY_CODE_1"
						  ,@"error-1-localizedTitle-LOL":@"LOC_TITLE_CODE_1_SUFFIX_LOL"
						  ,@"error-1-localizedDescription-LOL":@"LOC_DESCRIPTION_CODE_1_SUFFIX_LOL"
						  ,@"error-1-recoverySuggestion-LOL":@"LOC_RECOVERY_CODE_1_SUFFIX_LOL"
						  
						  };
	self.error = [[NSError alloc] initWithDomain:@"LolayTest" code:1 userInfo:@{@"LolayErrorLocalizedTitleKey_":@"Error Test",NSLocalizedDescriptionKey:@"This is an error",NSLocalizedRecoverySuggestionErrorKey:@"Do Something"}];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void) tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
	self.errorManager.delegate = nil;
	self.errorManager = nil;
	self.error = nil;
	self.errorStrings = nil;
    [super tearDown];
}

-(BOOL)isAlertViewShowing{
	for (UIWindow* window in [UIApplication sharedApplication].windows) {
		NSArray* subviews = window.subviews;
		if ([subviews count] > 1) {
			BOOL alert = [[subviews objectAtIndex:1] isKindOfClass:[UIAlertView class]];
			BOOL action = [[subviews objectAtIndex:1] isKindOfClass:[UIActionSheet class]];
			
			if (alert || action)
				return YES;
		}
	}
	return NO;
}

-(NSString*)errorManager:(LolayErrorManager*)errorManager localizedString:(NSString*)localizedString{
	NSString* returnString =[self.errorStrings objectForKey:localizedString]?[self.errorStrings objectForKey:localizedString]:@"NONE";
	return  returnString;
}

-(void)errorManager:(LolayErrorManager *)errorManager errorPresented:(NSError *)error{
	
}

-(BOOL)errorManager:(LolayErrorManager *)errorManager shouldPresentError:(NSError *)error{
	return YES;
}

- (void) testTitleForError
{
	NSString* errorTitle = [self.errorManager titleForError:self.error];
    XCTAssert([errorTitle isEqualToString:@"Error Test"], @"Title for error test");
}

- (void) testMessageForError
{
	int code = 1;
	NSString* errorMessageTest = [NSString stringWithFormat:@"%@\n%@\n(%@:%li)", @"This is an error", @"Do Something", @"LolayTest", (long) code];
	NSString* errorMessage = [self.errorManager messageForError:self.error];
    XCTAssert([errorMessage isEqualToString:errorMessageTest], @"Message for error test");
}

- (void) testButtonTextForError
{
	NSString* buttonTitleTest = @"Ok";
	NSString* buttonTitle = [self.errorManager buttonTextForError:self.error];
    XCTAssert([buttonTitle isEqualToString:buttonTitleTest], @"Button title for error test");
}




- (void) testPresentErrorCode
{
	id errorDelegate = [OCMockObject mockForClass:[MockDelegate class]];
    self.errorManager.delegate = errorDelegate;
	BOOL boolResult = YES;
	NSError *tError = [self.errorManager createError:1];
	[[[errorDelegate stub] andReturnValue:OCMOCK_VALUE(boolResult)] errorManager:[OCMArg any] shouldPresentError:[OCMArg any]];
	[[errorDelegate expect] errorManager:[OCMArg any] errorPresented:[OCMArg any]];
	[self.errorManager presentError:tError];
    [errorDelegate verify];
}
 /*
 - (void) presentErrorCode:(NSInteger) code suffix:(NSString*) suffix;
 - (void) presentErrorCode:(NSInteger) code error:(NSError*) error;
 - (void) presentErrorCode:(NSInteger) code suffix:(NSString*) suffix error:(NSError*) error;
 - (void) presentError:(NSError*) error;
 - (void) presentErrors:(NSArray*) errors;
 - (void) presentError:(NSInteger) code description:(NSString*) description recoverySuggestion:(NSString*) recoverySuggestion;
 - (void) presentError:(NSInteger) code description:(NSString*) description recoverySuggestion:(NSString*) recoverySuggestion error:(NSError*) error;
 - (void) presentError:(NSInteger) code description:(NSString*) description recoverySuggestion:(NSString*) recoverySuggestion title:(NSString*) title;
 - (void) presentError:(NSInteger) code description:(NSString*) description recoverySuggestion:(NSString*) recoverySuggestion title:(NSString*) title error:(NSError*) error;
*/
- (void) testPresentErrorCodeSuffix
{
    id errorDelegate = [OCMockObject mockForClass:[MockDelegate class]];
    self.errorManager.delegate = errorDelegate;
	BOOL boolResult = YES;
	NSError *tError = [self.errorManager createError:1 suffix:@"LOL"];
	[[[errorDelegate stub] andReturnValue:OCMOCK_VALUE(boolResult)] errorManager:[OCMArg any] shouldPresentError:[OCMArg any]];
	[[errorDelegate expect] errorManager:[OCMArg any] errorPresented:[OCMArg any]];
	[self.errorManager presentError:tError];
    [errorDelegate verify];
}

- (void) testPresentErrorCodeError
{
    id errorDelegate = [OCMockObject mockForClass:[MockDelegate class]];
    self.errorManager.delegate = errorDelegate;
	BOOL boolResult = YES;
	NSError *tError = [self.errorManager createError:1 error:self.error];
	[[[errorDelegate stub] andReturnValue:OCMOCK_VALUE(boolResult)] errorManager:[OCMArg any] shouldPresentError:[OCMArg any]];
	[[errorDelegate expect] errorManager:[OCMArg any] errorPresented:[OCMArg any]];
	[self.errorManager presentError:tError];
    [errorDelegate verify];
}

- (void) testPresentErrorCodeSuffixError
{
	id errorDelegate = [OCMockObject mockForClass:[MockDelegate class]];
    self.errorManager.delegate = errorDelegate;
	BOOL boolResult = YES;
	NSError *tError = [self.errorManager createError:1 suffix:@"LOL" error:self.error];
	[[[errorDelegate stub] andReturnValue:OCMOCK_VALUE(boolResult)] errorManager:[OCMArg any] shouldPresentError:[OCMArg any]];
	[[errorDelegate expect] errorManager:[OCMArg any] errorPresented:[OCMArg any]];
	[self.errorManager presentError:tError];
    [errorDelegate verify];
}

- (void) testPresentError
{
    id errorDelegate = [OCMockObject mockForClass:[MockDelegate class]];
    self.errorManager.delegate = errorDelegate;
	BOOL boolResult = YES;
	[[[errorDelegate stub] andReturnValue:OCMOCK_VALUE(boolResult)] errorManager:[OCMArg any] shouldPresentError:[OCMArg any]];
	[[errorDelegate expect] errorManager:[OCMArg any] errorPresented:[OCMArg any]];
	[self.errorManager presentError:self.error];
    [errorDelegate verify];
}

- (void) testPresentErrors
{
    id errorDelegate = [OCMockObject mockForClass:[MockDelegate class]];
    self.errorManager.delegate = errorDelegate;
	BOOL boolResult = YES;
	NSError *tError1 = [self.errorManager createError:1];
	NSError *tError2 = [self.errorManager createError:2];
	NSError *tError3 = [self.errorManager createError:3];
	NSArray *errorArray = @[tError1,tError2,tError3];
	[[[errorDelegate stub] andReturnValue:OCMOCK_VALUE(boolResult)] errorManager:[OCMArg any] shouldPresentError:[OCMArg any]];
	[[errorDelegate expect] errorManager:[OCMArg any] errorPresented:[OCMArg any]];
	[self.errorManager presentErrors:errorArray];
    [errorDelegate verify];
}

- (void) testPresentErrorCodeDescriptonRecovery
{
    id errorDelegate = [OCMockObject mockForClass:[MockDelegate class]];
    self.errorManager.delegate = errorDelegate;
	BOOL boolResult = YES;
	NSError *tError = [self.errorManager createError:1 description:@"DESCRIPTION" recoverySuggestion:@"RECOVERY"];
	[[[errorDelegate stub] andReturnValue:OCMOCK_VALUE(boolResult)] errorManager:[OCMArg any] shouldPresentError:[OCMArg any]];
	[[errorDelegate expect] errorManager:[OCMArg any] errorPresented:[OCMArg any]];
	[self.errorManager presentError:tError];
    [errorDelegate verify];
}

- (void) testPresentErrorCodeDescriptonRecoveryError
{
    id errorDelegate = [OCMockObject mockForClass:[MockDelegate class]];
    self.errorManager.delegate = errorDelegate;
	BOOL boolResult = YES;
	NSError *tError = [self.errorManager createError:1 description:@"DESCRIPTION" recoverySuggestion:@"RECOVERY" error:self.error];
	[[[errorDelegate stub] andReturnValue:OCMOCK_VALUE(boolResult)] errorManager:[OCMArg any] shouldPresentError:[OCMArg any]];
	[[errorDelegate expect] errorManager:[OCMArg any] errorPresented:[OCMArg any]];
	[self.errorManager presentError:tError];
    [errorDelegate verify];
}

- (void) testPresentErrorCodeDescriptonRecoveryTitle
{
	id errorDelegate = [OCMockObject mockForClass:[MockDelegate class]];
    self.errorManager.delegate = errorDelegate;
	BOOL boolResult = YES;
	NSError *tError = [self.errorManager createError:1 description:@"DESCRIPTION" recoverySuggestion:@"RECOVERY" title:@"TITLE"];
	[[[errorDelegate stub] andReturnValue:OCMOCK_VALUE(boolResult)] errorManager:[OCMArg any] shouldPresentError:[OCMArg any]];
	[[errorDelegate expect] errorManager:[OCMArg any] errorPresented:[OCMArg any]];
	[self.errorManager presentError:tError];
    [errorDelegate verify];
}

- (void) testPresentErrorCodeDescriptonRecoveryTitleError
{
    id errorDelegate = [OCMockObject mockForClass:[MockDelegate class]];
    self.errorManager.delegate = errorDelegate;
	BOOL boolResult = YES;
	NSError *tError = [self.errorManager createError:1 description:@"DESCRIPTION" recoverySuggestion:@"RECOVERY" title:@"TITLE" error:self.error];
	[[[errorDelegate stub] andReturnValue:OCMOCK_VALUE(boolResult)] errorManager:[OCMArg any] shouldPresentError:[OCMArg any]];
	[[errorDelegate expect] errorManager:[OCMArg any] errorPresented:[OCMArg any]];
	[self.errorManager presentError:tError];
    [errorDelegate verify];
}

- (void) testCreateError
{
	NSError* createdError =[self.errorManager createError:1];
	XCTAssert([createdError isKindOfClass:[NSError class]], @"Create Error Test");
	XCTAssertEqual(createdError.code ,1 ,@"Create Error Code Matches Code Given");
}

- (void) testCreateErrorCodeSuffix
{
	NSError* createdError;
	
	createdError = [self.errorManager createError:1 suffix:@"LOL"];
	XCTAssert([createdError isKindOfClass:[NSError class]], @"Create Error test");
	XCTAssertEqual(createdError.code ,1 ,@"Create Error Code Matches Code Given");
	XCTAssert([[createdError.userInfo objectForKey:NSLocalizedDescriptionKey] isEqualToString:@"LOC_DESCRIPTION_CODE_1_SUFFIX_LOL"] ,@"Create Error Suffix Matches Suffix Given");
	
	
	createdError = [self.errorManager createError:1 suffix:@"NOLOL"];
	XCTAssert([createdError isKindOfClass:[NSError class]], @"Create Error test");
	XCTAssertEqual(createdError.code ,1 ,@"Create Error Code Matches Code Given");
	XCTAssertFalse([[createdError.userInfo objectForKey:NSLocalizedDescriptionKey] isEqualToString:@"LOC_DESCRIPTION_CODE_1_SUFFIX_LOL"] ,@"Create Error Suffix Matches Suffix Given");
    
}
- (void) testCreateErrorCodeError
{
    NSError* createdError = [self.errorManager createError:1 error:self.error];
	XCTAssert([createdError isKindOfClass:[NSError class]], @"Create Error test");
	XCTAssertEqual(createdError.code ,1 ,@"Create Error Code Matches Code Given");
	XCTAssert([[createdError.userInfo objectForKey:NSLocalizedDescriptionKey] isEqualToString:@"LOC_DESCRIPTION_CODE_1"] ,@"Create Error Suffix Matches Suffix Given");
}
- (void) testCreateErrorCodeSuffixError
{
    NSError* createdError = [self.errorManager createError:1 error:self.error];
	XCTAssert([createdError isKindOfClass:[NSError class]], @"Create Error test");
	XCTAssertEqual(createdError.code ,1 ,@"Create Error Code Matches Code Given");
	XCTAssert([[createdError.userInfo objectForKey:NSLocalizedDescriptionKey] isEqualToString:@"LOC_DESCRIPTION_CODE_1"] ,@"Create Error Suffix Matches Suffix Given");
}
- (void) testCreateErrorCodeDescriptionRecovery
{
    NSError* createdError = [self.errorManager createError:1 description:@"D Test" recoverySuggestion:@"R Test"];
	XCTAssert([createdError isKindOfClass:[NSError class]], @"Create Error test");
	XCTAssertEqual(createdError.code ,1 ,@"Create Error Code Matches Code Given");
	XCTAssert([createdError.localizedDescription isEqualToString:@"D Test"] ,@"Create Error Description Matches Description Given");
}
- (void) testCreateErrorCodeDescriptionRecoveryError
{
    NSError* createdError = [self.errorManager createError:1 description:@"D Test" recoverySuggestion:@"R Test" error:self.error];
	XCTAssert([createdError isKindOfClass:[NSError class]], @"Create Error test");
	XCTAssertEqual(createdError.code ,1 ,@"Create Error Code Matches Code Given");
	XCTAssert([createdError.localizedDescription isEqualToString:@"D Test"] ,@"Create Error Description Matches Discription Given");
	XCTAssert([createdError.localizedRecoverySuggestion isEqualToString:@"R Test"] ,@"Create Error RecoverySuggestion Matches RecoverySuggestion Given");
}
- (void) testCreateErrorCodeDescriptionRecoveryTitle
{
    NSError* createdError = [self.errorManager createError:1 description:@"D Test" recoverySuggestion:@"R Test" title:@"T Test"];
	XCTAssert([createdError isKindOfClass:[NSError class]], @"Create Error test");
	XCTAssertEqual(createdError.code ,1 ,@"Create Error Code Matches Code Given");
	XCTAssert([createdError.localizedDescription isEqualToString:@"D Test"] ,@"Create Error Description Matches Discription Given");
	XCTAssert([createdError.localizedRecoverySuggestion isEqualToString:@"R Test"] ,@"Create Error RecoverySuggestion Matches RecoverySuggestion Given");
	XCTAssert([[createdError.userInfo objectForKey:@"LolayErrorLocalizedTitleKey_" ] isEqualToString:@"T Test"] ,@"Create Error RecoverySuggestion Matches RecoverySuggestion Given");
}

- (void) testCreateErrorCodeDescriptionRecoveryTitleError
{
    NSError* createdError = [self.errorManager createError:1 description:@"D Test" recoverySuggestion:@"R Test" title:@"T Test" error:self.error];
	XCTAssert([createdError isKindOfClass:[NSError class]], @"Create Error test");
	XCTAssertEqual(createdError.code ,1 ,@"Create Error Code Matches Code Given");
	XCTAssert([createdError.localizedDescription isEqualToString:@"D Test"] ,@"Create Error Description Matches Discription Given");
	XCTAssert([createdError.localizedRecoverySuggestion isEqualToString:@"R Test"] ,@"Create Error RecoverySuggestion Matches RecoverySuggestion Given");
	XCTAssert([[createdError.userInfo objectForKey:@"LolayErrorLocalizedTitleKey_" ] isEqualToString:@"T Test"] ,@"Create Error RecoverySuggestion Matches RecoverySuggestion Given");
}
/*
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

*/

@end
