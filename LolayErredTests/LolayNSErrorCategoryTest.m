//
//  LolayNSErrorCategoryTest.m
//  LolayErred
//
//  Created by Patrick Ortiz on 1/23/14.
//  Copyright (c) 2014 Lolay. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSError+Lolay.h"
@interface LolayNSErrorCategoryTest : XCTestCase

@property(nonatomic,strong) NSError *error1;
@property(nonatomic,strong) NSError *error2;
@property(nonatomic,strong) NSError *recursiveUnderlyingError;
@property(nonatomic,strong) NSError *underlyingError;
@end

@implementation LolayNSErrorCategoryTest

- (void)setUp
{
    [super setUp];
	self.error1 = [[NSError alloc] initWithDomain:@"LolayTest" code:1 userInfo:@{@"LolayErrorLocalizedTitleKey_":@"Error 1",NSLocalizedDescriptionKey:@"This is an error",NSLocalizedRecoverySuggestionErrorKey:@"Do Something"}];
	self.error2 = [[NSError alloc] initWithDomain:@"LolayTest" code:1 userInfo:@{@"LolayErrorLocalizedTitleKey_":@"Error 2",NSLocalizedDescriptionKey:@"This is an error",NSLocalizedRecoverySuggestionErrorKey:@"Do Something"}];
	self.underlyingError = [[NSError alloc] initWithDomain:@"LolayTest" code:1 userInfo:@{@"LolayErrorLocalizedTitleKey_":@"Error Underlying",NSLocalizedDescriptionKey:@"This is an underlying error",NSLocalizedRecoverySuggestionErrorKey:@"Do Something",NSUnderlyingErrorKey:self.error2}];
	self.recursiveUnderlyingError = [[NSError alloc] initWithDomain:@"LolayTest" code:1 userInfo:@{@"LolayErrorLocalizedTitleKey_":@"Error Recursive",NSLocalizedDescriptionKey:@"This is an underlying error",NSLocalizedRecoverySuggestionErrorKey:@"Do Something",NSUnderlyingErrorKey:self.underlyingError}];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.error1 = nil;
	self.error2 = nil;
	self.recursiveUnderlyingError = nil;
	self.underlyingError = nil;
	[super tearDown];
}

- (void)testNSErrorUnderlyingError
{
	NSError* testError = [self.underlyingError underlyingError];
	XCTAssertEqualObjects(testError, self.error2, @"Test that underlying error matches error2");
//    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

- (void)testNSErrorRecursiveUnderlyingError
{
	NSError* testError = [self.recursiveUnderlyingError recursiveUnderlyingError];
	XCTAssertEqualObjects(testError, self.error2, @"Test that underlying error matches error2");
    XCTAssert(YES, @"works");
}

- (void)testNSErrorUnderlyingErrorOrSelf
{
	NSError* testError1 = [self.recursiveUnderlyingError recursiveUnderlyingError];
	XCTAssertEqualObjects(testError1, self.error2, @"Test that underlying recursive error matches error2");
	
	NSError* testError2 = [self.error1 recursiveUnderlyingErrorOrSelf];
	XCTAssertEqualObjects(testError2, self.error1, @"Test that no recursive underlying error matches error1");
}
@end
