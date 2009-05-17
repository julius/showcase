

#import <Foundation/Foundation.h>

#import "QSObject.h"

@interface QSObject (PropertyList)
+ (id)objectWithString:(NSString *)string name:(NSString *)aName type:(NSString *)aType;
- (id)initWithString:(NSString *)string name:(NSString *)aName type:(NSString *)aType;
+ (id)objectWithType:(NSString *)type value:(id)value name:(NSString *)newName;
- (id)initWithType:(NSString *)type value:(id)value name:(NSString *)newName;
+ (id)objectsWithDictionaryArray:(NSArray *)dictionaryArray;
+ (id)objectWithDictionary:(NSMutableDictionary *)dictionary;
- (id)initWithDictionary:(NSMutableDictionary *)dictionary;
@end
