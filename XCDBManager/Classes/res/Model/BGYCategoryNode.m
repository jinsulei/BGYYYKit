//
//  BGYCategoryNode.m
//  BGYUni
//
//  Created by YuSong.Yan on 2022/3/9.
//

#import "BGYCategoryNode.h"



@implementation BGYCategoryNode

- (instancetype)init {
    self = [super init];
    if (self) {
        self.father = [BGYCategoryNode unknowCategoryId];
    }
    return self;
}


- (instancetype)initWithCid:(NSInteger)cid name:(NSString *)name children:(NSArray<BGYCategoryNode *>*)children father:(NSInteger)fatherid {
    self = [super init];
    if (self) {
        self.cid = cid;
        self.name = name;
        self.children = children;
        self.father = fatherid;
    }
    return self;
}

+ (instancetype)rootNode {
    BGYCategoryNode *node = [[BGYCategoryNode alloc] init];
    node.cid = [BGYCategoryNode unknowCategoryId];
    node.name = @"公共";
    node.leval = 0;
    node.father = [BGYCategoryNode unknowCategoryId];
    return  node;
}

+ (NSInteger)unknowCategoryId {
    return -1;
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
        @"children": [BGYCategoryNode class]
    };
}

- (BOOL)hasFather {
    if (self.father == [BGYCategoryNode unknowCategoryId]) {
        return NO;
    }
    return YES;
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[BGYCategoryNode class]]) {
        BGYCategoryNode *node = (BGYCategoryNode *)object;
        if (node.cid == self.cid) {
            return YES;
        }
    }
    return NO;
}


- (id)copyWithZone:(NSZone *)zone {
    return  self;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    BGYCategoryNode *node = [[BGYCategoryNode alloc] initWithCid:self.cid name:self.name children:self.children father:self.father];
    node.leval = self.leval;
  return node;
}
@end
