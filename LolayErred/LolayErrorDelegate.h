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

@class LolayErrorManager;

@protocol LolayErrorDelegate <NSObject>

@optional

- (BOOL) errorManager:(LolayErrorManager*) errorManager shouldPresentError:(NSError*) error;
- (void) errorManager:(LolayErrorManager*) errorManager errorPresented:(NSError*) error;

// Return string for the key
- (NSString*) errorManager:(LolayErrorManager*) errorManager localizedString:(NSString*) key;

// Return the title for a UIAlertView
- (NSString*) errorManager:(LolayErrorManager*) errorManager titleForError:(NSError*) error;
// Return the message for a UIAlertView
- (NSString*) errorManager:(LolayErrorManager*) errorManager messageForError:(NSError*) error;
// Return the button text for a UIAlertView
- (NSString*) errorManager:(LolayErrorManager*) errorManager buttonTextForError:(NSError*) error;

@end
