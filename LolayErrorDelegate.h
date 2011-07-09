//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//
@class LolayErrorManager;

@protocol LolayErrorDelegate <NSObject>

@optional

// Return string for the key
- (NSString*) errorManager:(LolayErrorManager*) errorManager localizedString:(NSString*) key;

// Return the title for a UIAlertView
- (NSString*) errorManager:(LolayErrorManager*) errorManager titleForError:(NSError*) error;
// Return the message for a UIAlertView
- (NSString*) errorManager:(LolayErrorManager*) errorManager messageForError:(NSError*) error;
// Return the button text for a UIAlertView
- (NSString*) errorManager:(LolayErrorManager*) errorManager buttonTextForError:(NSError*) error;

@end
