//
//  LFCGzipUtility.h
//  SKATiledMap
//
//  Modified version of Clint Harris' (www.clintharris.net) implementation
//

//  TODO: what license can we use here, if any?

#import <Foundation/Foundation.h>
#import "zlib.h"

@interface LFCGzipUtility : NSObject

+ (NSData *)gzipData:(NSData *)pUncompressedData; // Compression
+ (NSData *)ungzipData:(NSData *)compressedData;  // Decompression

@end
