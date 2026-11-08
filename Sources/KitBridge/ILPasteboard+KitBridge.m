#include <TargetConditionals.h>
#if !TARGET_OS_WATCH
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

#import "ILPasteboard+KitBridge.h"
#import "ILImage+KitBridge.h"

@implementation ILPasteboard (KitBridge)

#if IL_APP_KIT
/// Convert an NSPasteboardItem into a UIPasteboard item dictionary
+ (NSDictionary<NSString*,id>*) dictionaryForItem:(NSPasteboardItem*) item {
    NSMutableDictionary<NSString*,id>* itemDict = NSMutableDictionary.new;

    for (NSString* type in item.types) {
        itemDict[type] = [item dataForType:type];
    }

    return itemDict;
}

+ (NSPasteboardItem*) itemForDictionary:(NSDictionary<NSString*,id>*) itemDictionary {
    NSPasteboardItem* item = NSPasteboardItem.new;

    for (NSString* type in itemDictionary) {
        id itemValue = itemDictionary[type];
        if ([itemValue isKindOfClass:NSString.class]) {
            [item setString:(NSString*)itemValue forType:type];
        }
        else if ([itemValue isKindOfClass:NSDictionary.class] || [itemValue isKindOfClass:NSArray.class]) {
            [item setPropertyList:itemValue forType:type];
        }
        else if ([itemValue isKindOfClass:NSData.class]) {
            [item setData:(NSData*)itemValue forType:type];
        }
        else {
            NSLog(@"can't convert type: %@ itemValue: %@ in +ILPasteboard.itemForDictionary:", type, itemValue);
        }
    }

    return item;
}

// MARK: - UIPasteboard
+ (nullable instancetype) pasteboardWithName:(NSString*) name create:(BOOL) create {
    /// TODO: check for existance of pasteboard name and honor create

    return [NSPasteboard pasteboardWithName:name];
}

+ (void) removePasteboardWithName:(NSString*) name {
    ILPasteboard* board = [ILPasteboard pasteboardWithName:name create:NO];
    if (board) {
        [board clearContents];
        [board releaseGlobally];
    }
}

// MARK: - Determining types of pasteboard items
- (NSArray<NSString*>*) pasteboardTypes {
    return self.types;
}

- (BOOL) containsPasteboardTypes:(NSArray<NSString*>*)types {
    BOOL contains = NO;

    for (NSString* type in types) {
        UTType* searchType = [UTType typeWithIdentifier:type];
        if (searchType) { // FIXME: make the array types UTTypes
            for (NSString* myType in self.types) {
                contains = [[UTType typeWithIdentifier:myType] conformsToType:searchType];
                if (contains) {
                    break; // for .. self.types
                }
            }

            if (contains) {
                break; // for .. types
            }
        }
    }

    return contains;
}

// MARK: - Getting and setting pasteboard items
- (NSInteger) numberOfItems {
    return self.items.count;
}

- (NSArray<NSDictionary<NSString*,id>*>*) items {
    NSMutableArray<NSDictionary<NSString*,id>*>* itemArray = NSMutableArray.new;
    for (NSPasteboardItem* item in self.pasteboardItems) {
        [itemArray addObject:[ILPasteboard dictionaryForItem:item]];
    }

    return itemArray;
}

- (void) setItems:(NSArray<NSDictionary<NSString*,id>*>*) items {
    [self setItems:items options:nil];
}

// XXX: this writes all the items to the first pasteboard item using setData:forType & c.
- (void) addItems:(NSArray<NSDictionary<NSString *,id> *> *)items {
    for (NSDictionary<NSString*,id>* item in items) {
        for (NSString* type in item.allKeys) {
            [self setValue:item[type] forPasteboardType:type];
        }
    }
}

// XXX: this ignores the options
- (void) setItems:(NSArray<NSDictionary<NSString *,id> *> *)items options:(NSDictionary<NSString*,id>* _Nullable) options {
    [self prepareForNewContentsWithOptions:0];
    [self addItems:items];
}

- (nullable NSData*) dataForPasteboardType:(NSString*) type {
    return [self dataForType:type];
}

- (void) setData:(NSData*) data forPasteboardType:(NSString*) type {
    [self setData:data forType:type];
}

- (nullable id) valueForPasteboadType:(NSString*) type {
    id value = nil;

    if ((value = [self stringForType:type])) {}
    else if ((value = [self propertyListForType:type])) {}
    else if ((value = [self dataForType:type])) {}

    return value;
}

- (void) setValue:(id) value forPasteboardType:(NSString*) type {
    if ([value isKindOfClass:NSData.class]) {
        [self setData:(NSData*)value forType:type];
    }
    else if ([value isKindOfClass:NSString.class]) {
        [self setString:(NSString*)value forType:type];
    }
    else if ([value isKindOfClass:NSDictionary.class] || [value isKindOfClass:NSArray.class]) {
        [self setPropertyList:value forType:type];
    }
    else if ([value isKindOfClass:NSURL.class]) {
        [self setURL:value];
    }
    else {
        NSLog(@"WARNING: can't convert type: %@ value: %@ in -ILPastebaord_setValue:forPasteboardType:", type, value);
    }
}

// MARK: - Getting and setting pasteboard items of standard data types

- (nullable NSString*) string {
    NSString* string = [self stringForType:NSPasteboardTypeString];
    if (!string && self.hasStrings) {
        string = self.strings[0];
    }

    return string;
}

- (void) setString:(NSString*) string {
    [self setString:string forType:NSPasteboardTypeString];
}

- (nullable NSArray<NSString*>*) strings {
    return [self valueForKey:@"ILPasteboardTypeStringArray"];
}

- (void) setStrings:(NSArray<NSString*>*) stringArray {
    [self setValue:stringArray forKey:@"ILPasteboardTypeStringArray"];
}

- (nullable ILImage*) image {
    NSData* imageData = [self dataForType:NSPasteboardTypePNG];
    if (!imageData) {
        imageData = [self dataForType:NSPasteboardTypeTIFF];
    }

    ILImage* image = nil;
    if (imageData) {
        image = [ILImage.alloc initWithData:imageData];
    }

    if (!image && self.hasImages) {
        image = self.images[0];
    }

    return image;
}

- (void) setImage:(ILImage*) image {
    NSData* imageData = image.TIFFRepresentation;
    [self setData:imageData forType:NSPasteboardTypeTIFF];
}

- (nullable NSArray<ILImage*>*) images {
    return [self valueForKey:@"ILPasteboardTypeImageArray"];
}

- (void) setImages:(NSArray<ILImage*>*) imageArray {
    [self setValue:imageArray forKey:@"ILPasteboardTypeImageArray"];
}

- (nullable NSURL*) URL {
    return [NSURL URLFromPasteboard:self];
}

- (void) setURL:(NSURL*) url {
    [self writeObjects:@[url]];
}

- (nullable NSArray<NSURL*>*) URLs {
    return @[self.URL]; // TODO: filter all the objects for URLs
}

- (void) setURLs:(NSArray<NSURL*>*) URLs {
    [self writeObjects:URLs];
}

- (nullable ILColor*) color {
    ILColor* color = [ILColor colorFromPasteboard:self];
    if (!color && self.hasColors) {
        color = self.colors[0];
    }

    return color;
}

- (void) setColor:(ILColor*) color {
    [color writeToPasteboard:self];
}

- (nullable NSArray<ILColor*>*) colors {
    return [self valueForKey:@"ILPasteboardTypeColorArray"];
}

- (void) setColors:(NSArray<ILColor*>*) colorArray {
    [self setValue:colorArray forKey:@"ILPasteboardTypeColorArray"];
}

// MARK: - Checking Data Types

- (BOOL) hasImages {
    return [self containsPasteboardTypes:@[NSPasteboardTypePNG, NSPasteboardTypeTIFF, @"ILPasteboardTypeImageArray"]];
}

- (BOOL) hasStrings {
    return [self containsPasteboardTypes:@[NSPasteboardTypeString, @"ILPasteboardTypeStringArray"]];
}

- (BOOL) hasURLs {
    return [self containsPasteboardTypes:@[NSPasteboardTypeURL, @"ILPasteboardTypeURLArray"]];
}

- (BOOL) hasColors {
    return [self containsPasteboardTypes:@[NSPasteboardTypeColor, @"ILPasteboardTypeColorArray"]];
}
#elif IL_UI_KIT

// MARK: - NSPasteboard

- (void) clearContents {
    self.items = @[];
}
#endif

// MARK: - ILPasteboard

- (BOOL) isClear {
    BOOL isClear = NO;
    if (self.items.count == 0 // no items, that's clear
    || (self.items.count == 1 && self.items[0].allKeys.count == 0)) { // one item with a dict with no keys, on iOS that's clear
        isClear = YES;
    }

    return isClear;
}

- (BOOL) hasItems {
    BOOL hasInfo = NO;

#if IL_APP_KIT
    for (NSDictionary<NSString*,id>* item in self.items) {
        for (NSString* key in item.allKeys) {
            if ([key rangeOfString:@"dyn." options:NSAnchoredSearch].location == NSNotFound) { // there is at least one non-dynaic item
                hasInfo = YES;
                break; // for key in item.allKeys
            }
        }

        if (hasInfo) {
            break; // for item in self.items
        }
    }
#elif IL_UI_KIT
    hasInfo = (self.itemProviders != nil);
#endif

    return hasInfo;
}

- (BOOL) isEqualToPasteboard:(ILPasteboard*) pasteboard {
    BOOL isEqual = [self isEqual:pasteboard]; // check for object equality first and on iOS

#if IL_APP_KIT
    if (!isEqual && (self.items.count == pasteboard.items.count)) { // count doesn't match, don't compare items
        NSUInteger itemIndex = 0;
        for (NSDictionary<NSString*,id>* item in self.items) {
            NSDictionary<NSString*,id>* otherItem = pasteboard.items[itemIndex++]; // items must be in identical order
            for (NSString* itemType in item.allKeys) {
                id value = item[itemType];
                id otherValue = otherItem[itemType];

                if ([value isKindOfClass:NSData.class] && [otherValue isKindOfClass:NSData.class]) {
                    NSData* valueData = (NSData*)value;
                    NSData* otherData = (NSData*)otherValue;
                    // isEqualToData: does not always work correctly with os_dispatch_data
                    isEqual = !memcmp(valueData.bytes, otherData.bytes, MIN(valueData.length, otherData.length));
                }
                else if ([value isKindOfClass:ILImage.class]) {
                    isEqual = [(ILImage*)value isEqualToImage:(ILImage*)otherValue];
                }
                else {
                    isEqual = [value isEqual:otherValue];
                }

                if (!isEqual) {
                    break; // for .. item.allKeys
                }
            }

            if (!isEqual) {
                break; // for .. self.items
            }
        }
    }
    else {
        isEqual = NO;
    }
#endif

    return isEqual;
}

- (ILPasteboard*) deepCopy {
    NSMutableArray* itemCopies = NSMutableArray.new;

    for (NSDictionary* item in self.items) {
        NSMutableDictionary* itemTypes = NSMutableDictionary.new;

        for (NSString* itemType in item.allKeys) {
            id value = item[itemType];

            if ([value conformsToProtocol:@protocol(NSCopying)]) {
                itemTypes[itemType] = [value copy];
            }
            else {
                NSLog(@"WARNING: can't copy item type: %@ value: %@ in -ILPasteboard.deepCopy", itemType, value);
                itemTypes[itemType] = value;
            }
        }

        [itemCopies addObject:itemTypes];
    }

    ILPasteboard* deepCopy = ILPasteboard.pasteboardWithUniqueName;
    deepCopy.items = itemCopies;

    return deepCopy;
}

// MARK: - NSObject

- (NSString*) description {
    return [NSString stringWithFormat:@"<%@ %p items: %@>", NSStringFromClass(self.class), self, self.items];
}

// MARK: - NSCopying

- (instancetype) copyWithZone:(NSZone *)zone {
    ILPasteboard* copy = ILPasteboard.pasteboardWithUniqueName;
    copy.items = self.items; // ???: make a deep copy of these items?

    return copy;
}

// MARK: - NSCoding

- (void) encodeWithCoder:(NSCoder *)coder {
    NSData* encodedPasteboard = [NSKeyedArchiver archivedDataWithRootObject:self.items requiringSecureCoding:YES error:nil];
    [coder encodeDataObject:encodedPasteboard];
}

- (instancetype) initWithCoder:(NSCoder *)coder {
    if ((self = ILPasteboard.pasteboardWithUniqueName)) {
        self.items = [coder decodeTopLevelObjectAndReturnError:nil];
    }

    return self;
}

@end
#endif // !TARGET_OS_WATCH
