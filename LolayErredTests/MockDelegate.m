//
//  MockDelegate.m
//  LolayErred
//
//  Created by Patrick Ortiz on 1/23/14.
//  Copyright (c) 2014 Lolay. All rights reserved.
//

#import "MockDelegate.h"

@implementation MockDelegate

-(BOOL)errorManager:(LolayErrorManager *)errorManager shouldPresentError:(NSError *)error{
	return YES;
}

-(void)errorManager:(LolayErrorManager *)errorManager errorPresented:(NSError *)error{
	
}

@end
