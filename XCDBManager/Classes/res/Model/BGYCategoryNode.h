//
//  BGYCategoryNode.h
//  BGYUni
//
//  Created by YuSong.Yan on 2022/3/9.
//

#import <Foundation/Foundation.h>
#import "BGYPhotoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BGYCategoryNode : NSObject  <NSCopying, NSMutableCopying>

@property (assign, nonatomic) NSInteger  cid;
@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic, nullable) NSArray <BGYCategoryNode*>* children;
@property (assign, nonatomic) NSInteger  father;
@property (assign, nonatomic) NSInteger  leval;

@property (assign, nonatomic) BOOL  isPublic; //用于描述是否下级公共
@property (strong, nonatomic, nullable) NSArray <BGYPhotoModel *>* photos;

- (instancetype)initWithCid:(NSInteger)cid name:(NSString *)name children:(nullable NSArray<BGYCategoryNode *>*)children father:(NSInteger)fatherid;

+ (instancetype)rootNode;
+ (NSInteger)unknowCategoryId;
- (BOOL)hasFather;
@end

NS_ASSUME_NONNULL_END
