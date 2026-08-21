#if __has_include(<KitBridge/KitBridgeDefines.h>)
#import <KitBridge/KitBridgeDefines.h>
#else
#import "KitBridgeDefines.h"
#endif

/// The pasteboard you use to perform ordinary cut, copy, and paste operations
#if IL_UI_KIT
#define ILPasteboardNameGeneral UIPasteboardNameGeneral
#elif IL_APP_KIT
#define ILPasteboardNameGeneral NSPasteboardNameGeneral
#endif

NS_ASSUME_NONNULL_BEGIN

// MARK: -

@interface ILPasteboard (KitBridge) <NSCopying, NSCoding>

#if IL_APP_KIT
// MARK: - UIPasteboard
+ (nullable instancetype) pasteboardWithName:(NSString*) name create:(BOOL) create;
+ (void) removePasteboardWithName:(NSString*) name;

// MARK: - Determining types of pasteboard items
@property(nonatomic, readonly) NSArray<NSString*>* pasteboardTypes;

// TODO: pasteboardTypesForItemSet:
- (BOOL) containsPasteboardTypes:(NSArray<NSString*>*) types;
// TODO: containsPasteboardTypes:inItemSet:
// TODO: itemSetWithPasteboardTypes:

// MARK: - Getting and setting pasteboard items
@property(nonatomic, readonly) NSInteger numberOfItems;
@property(nonatomic, copy) NSArray<NSDictionary<NSString*,id>*>* items;

- (void) addItems:(NSArray<NSDictionary<NSString*,id>*>*) items;
- (void) setItems:(NSArray<NSDictionary<NSString*,id>*>*) items options:(nullable NSDictionary<NSString*,id>*) options;
- (nullable NSData*) dataForPasteboardType:(NSString*) pasteboardType;
// TODO: dataForPasteboardType:inItemSet:
- (void) setData:(NSData*) data forPasteboardType:(NSString*) type;
- (nullable id) valueForPasteboadType:(NSString*) type;
// TODO: valuesForPasteboardType:inItemSet:
- (void) setValue:(id) value forPasteboardType:(NSString*) type;

// MARK: - Getting and setting pasteboard items of standard data types
@property(nullable, nonatomic, copy) NSString* string;
@property(nullable, nonatomic, copy) NSArray<NSString*>* strings;
@property(nullable, nonatomic, copy) ILImage* image;
@property(nullable, nonatomic, copy) NSArray<ILImage*>* images;
@property(nullable, nonatomic, copy) NSURL* URL;
@property(nullable, nonatomic, copy) NSArray<NSURL*>* URLs;
@property(nullable, nonatomic, copy) ILColor* color;
@property(nullable, nonatomic, copy) NSArray<ILColor*>* colors;

// MARK: - Checking Data Types
@property(nonatomic, readonly) BOOL hasImages;
@property(nonatomic, readonly) BOOL hasStrings;
@property(nonatomic, readonly) BOOL hasURLs;
@property(nonatomic, readonly) BOOL hasColors;

// MARK: - Getting and setting item providers
// TODO: setItemProviders:localOnly:expirationDate:
// TODO: setObjects:
// TODO: setObjects:localOnly:expirationDate:
#elif IL_UI_KIT

- (void) clearContents;
#endif

// MARK: - ILPasteboard

/// TRUE if the pasteboard is empty, either newley created or freshly cleared
@property(nonatomic,readonly) BOOL isClear;

/// TRUE if the pasteboard has any non "dyn." items
@property(nonatomic,readonly) BOOL hasItems;

- (BOOL) isEqualToPasteboard:(ILPasteboard*) pasteboard;

- (ILPasteboard*) deepCopy;

@end

// MARK: -

// TODO: Implement ILPasteboard for tvOS

NS_ASSUME_NONNULL_END
