@import Foundation;

@class Album, Artwork;


@interface ARAlbumEditOperation : NSOperation

- (instancetype)initWithAlbum:(Album *)album createModel:(BOOL)create toAdd:(NSArray<Artwork *> *)addedArtworks toRemove:(NSArray<Artwork *> *)removedArtworks;

/// Use this to get IDs for objects sent back to you
@property (readwrite, nonatomic, copy) void (^onCompletion)(void);

@property (nonatomic, assign, readonly) BOOL createAlbum;
@property (nonatomic, strong, readonly) Album *album;

@property (nonatomic, copy, readonly) NSSet<Artwork *> *artworksToUpload;
@property (nonatomic, copy, readonly) NSSet<Artwork *> *artworksToRemove;
@end
