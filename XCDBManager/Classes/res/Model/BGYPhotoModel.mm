//
//  BGYPhotoModel.m
//  BGYUni
//
//  Created by YuSong.Yan on 2022/3/8.
//

#import "BGYPhotoModel.h"
#import <WCDB/WCDB.h>
#import <list>
#import <BGYFoundation/NSFileManager+BGYExtention.h>
//#import "BGYPhotoModel+WCTTableCoding.h"
#import "BGYCategoryNode.h"
#import <BGYFoundation/BGYFoundation.h>
#import "NSData+BGY_Add.h"
@interface BGYPhotoModel ()<WCTTableCoding>{
    NSString *_thumbAbsolutePath;
}
@property (copy, nonatomic) NSString *absolutePath;

WCDB_PROPERTY(fileName)
WCDB_PROPERTY(relativePath)
WCDB_PROPERTY(address)
WCDB_PROPERTY(updateTime)
WCDB_PROPERTY(totalsize)
WCDB_PROPERTY(categoryId)
WCDB_PROPERTY(markText)
@end

@implementation BGYPhotoModel


WCDB_IMPLEMENTATION(BGYPhotoModel)

WCDB_SYNTHESIZE(BGYPhotoModel, fileName)
WCDB_SYNTHESIZE(BGYPhotoModel, relativePath)
WCDB_SYNTHESIZE(BGYPhotoModel, address)
WCDB_SYNTHESIZE(BGYPhotoModel, updateTime)
WCDB_SYNTHESIZE(BGYPhotoModel, totalsize)
WCDB_SYNTHESIZE(BGYPhotoModel, markText)

WCDB_SYNTHESIZE_DEFAULT(BGYPhotoModel, categoryId, [BGYCategoryNode unknowCategoryId])


WCDB_UNIQUE(BGYPhotoModel, fileName)

- (instancetype)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        
    }
    return self; 
}

- (NSString *)absolutePath {
    if (!_absolutePath) {
        _absolutePath = [[BGYPhotoModel cachedRoorDir] stringByAppendingString:self.relativePath];
    }
    return _absolutePath;
}


+ (NSString *)cachedRoorDir {
    NSString *path = [[NSFileManager BGY_cachesDirectoryPath] stringByAppendingString:@"/BGYPhotos"];
    if (![NSFileManager BGY_createDir:path] ) {
        BGYLog(@"Create images cache directory failed with:%@!", path);
    }
    return path;
}

- (NSString *)thumbFileName {
    return [NSString stringWithFormat:@"thumb_%@", self.fileName];
}

- (NSString *)thumbFileAbsolutePath {
    if (!_thumbAbsolutePath) {
        NSString *absoluteDir = [[self absolutePath] stringByDeletingLastPathComponent];
        _thumbAbsolutePath = [absoluteDir stringByAppendingFormat:@"/%@", [self thumbFileName]];
    }
    return _thumbAbsolutePath;
}

- (NSDictionary *)generateUniData {
    NSData *data = nil;
    if (self.image) {
        data = UIImageJPEGRepresentation(self.image, 0.1);
    }else{
        data = [NSData dataWithContentsOfFile:self.absolutePath];
    }
    NSString *base64Encode = [data base64EncodedString];
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    if (base64Encode) {
        [result setObject:base64Encode forKey:@"base64"];
    }
    if (self.absolutePath) {
        [result setObject:self.absolutePath forKey:@"realPath"];
    }
    if (self.markText) {
        [result setObject:self.markText forKey:@"mark"];
    }
    return result;
}
- (instancetype)initWithFileName:(NSString *)fileName
                        location:(NSString *)location
                    relativePath:(NSString *)relativePath
                      createTime:(NSTimeInterval)createTime
                           image:(nullable UIImage*)image
                            size:(double)size
                      categoryId:(NSInteger)catId {
    self = [super init];
    if (self) {
        self.fileName = fileName;
        self.address = location;
        self.relativePath = relativePath;
        self.updateTime = createTime;
        self.image = image;
        self.totalsize = size;
        self.categoryId = catId;
        
    }
    return self;
}


- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[BGYPhotoModel class]]) {
        BGYPhotoModel *photo = (BGYPhotoModel *)object;
        if ([photo.fileName isEqualToString: self.fileName]) {
            return YES;
        }
    }
    return NO;
}

@end
