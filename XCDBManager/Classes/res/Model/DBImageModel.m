//
//  DBImageModel.m
//  BGYUni
//
//  Created by lshenrong on 2021/11/10.
//

#import "DBImageModel.h"
#import "NSData+BGY_Add.h"
#import <BGYFoundation/NSFileManager+BGYExtention.h>
@interface DBImageModel (){
    NSString *_thumbAbsolutePath;
}
@property (copy, nonatomic) NSString *absolutePath;

@end

@implementation DBImageModel

- (instancetype)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSString *)absolutePath {
    if (!_absolutePath) {
        _absolutePath = [[DBImageModel cachedRoorDir] stringByAppendingString:self.relativePath];
    }
    return _absolutePath;
}


+ (NSString *)cachedRoorDir {
    return [NSFileManager BGY_cachesDirectoryPath];
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
    return result;
}

@end


