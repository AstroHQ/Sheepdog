//
//  Sheepdog.m
//  Sheepdog
//
//  Created by Matt Ronge on 2/13/14.
//  Copyright (c) 2014 Astro HQ. All rights reserved.
//

#import "Sheepdog.h"

#pragma mark - Shared

static id __filter(id collection, Class type, BOOL (^block)(id obj)) {
    id results = [[type alloc] init];
    for (id obj in collection) {
        BOOL result = block(obj);
        if (result) {
            [results addObject:obj];
        }
    }
    return results;
}

static id __map(id collection, Class type, id (^block)(id obj)) {
    id results = [[type alloc] init];
    for (id obj in collection) {
        id result = block(obj);
        if (result) {
            [results addObject:result];
        }
    }
    return results;
}

static id __reduce(id collection, Class type, id initial, id (^block)(id left, id right)) {
    id last = initial;
    for (id obj in collection) {
        last = block(last, obj);
    }
    return last;
}

static BOOL __any(id collection, Class type, BOOL (^block)(id obj)) {
    id results = __filter(collection, type, block);
    return [results count] > 0;
}

static BOOL __every(id collection, Class type, BOOL (^block)(id obj)) {
    id results = __filter(collection, type, block);
    return [results count] == [collection count];
}

#pragma mark - Array

@implementation NSArray (Sheepdog)

- (NSArray *)filter:(BOOL (^)(id obj))block {
    return __filter(self, [NSMutableArray class], block);
}

- (id)reduce:(id)val block:(id (^)(id left, id right))block {
    return __reduce(self, [NSMutableArray class], val, block);
}

- (NSArray *)map:(id (^)(id obj))block {
    return __map(self, [NSMutableArray class], block);
}

- (NSArray *)sort {
    return [self sortedArrayUsingSelector:@selector(compare:)];
}

- (NSArray *)reverse {
    NSMutableArray *array = [self mutableCopy];
    int count = array.count;
    for (int i = 0; i < floor(count/2); i++) {
        id temp = array[i];
        array[i] = array[count - i - 1];
        array[count - i - 1] = temp;
    }
    return array;
}

- (NSArray *)distinct {
    return [[NSSet setWithArray:self] allObjects];
}

- (NSArray *)partition:(NSInteger)n {
    __block int i = 0;
    __block NSNumber *val = @(YES);
    return [self partitionBy:^id(id obj) {
        if (i % n == 0) {
            val = @(!val.boolValue);
        }
        i++;
        return val;
    }];
}

- (NSArray *)partitionBy:(id (^)(id obj))block {
    NSMutableArray *outer = [NSMutableArray array];
    NSMutableArray *inner = [NSMutableArray array];
    
    id lastValue = nil;
    int i = 0;
    for (id obj in self) {
        id value = block(obj);
        if (i == 0 || [value compare:lastValue] == NSOrderedSame) {
            [inner addObject:obj];
        } else {
            [outer addObject:inner];
            inner = [NSMutableArray array];
            [inner addObject:obj];
        }
        lastValue = value;
        i++;
    }
    if (inner.count > 0) {
        [outer addObject:inner];
    }
    
    return outer;
}

- (NSDictionary *)groupBy:(id (^)(id obj))block {
    NSMutableDictionary *outer = [NSMutableDictionary dictionary];
    return [self reduce:outer block:^NSMutableDictionary* (NSMutableDictionary *left, id right) {
        id key = block(right);
        NSMutableArray *inner = [outer objectForKey:key];
        if (!inner) {
            inner = [NSMutableArray array];
            [outer setObject:inner forKey:key];
        }
        [inner addObject:right];
        return outer;
    }];
}

- (BOOL)any:(BOOL (^)(id obj))block {
    return __any(self, [NSMutableArray class], block);
}

- (BOOL)every:(BOOL (^)(id obj))block {
    return __every(self, [NSMutableArray class], block);
}

- (id)max {
    if (self.count == 0) {
        return nil;
    }
    
    id result = [self reduce:[self firstObject]
                       block:^id (id left, id right) {
                           NSComparisonResult result = [left compare:right];
                           if (result == NSOrderedDescending) {
                               return left;
                           } else {
                               return right;
                           }
                       }];
    
    return result;
}

- (id)min {
    if (self.count == 0) {
        return nil;
    }
    
    id result = [self reduce:[self firstObject]
                       block:^id (id left, id right) {
                           NSComparisonResult result = [left compare:right];
                           if (result == NSOrderedDescending) {
                               return right;
                           } else {
                               return left;
                           }
                       }];
    
    return result;
}

@end

#pragma mark - Set

@implementation NSSet (Sheepdog)

- (NSSet *)filter:(BOOL (^)(id obj))block {
    return __filter(self, [NSMutableSet class], block);
}

- (id)reduce:(id)val block:(id (^)(id left, id right))block {
    return __reduce(self, [NSMutableSet class], val, block);
}

- (NSSet *)map:(id (^)(id obj))block {
    return __map(self, [NSMutableSet class], block);
}


- (BOOL)any:(BOOL (^)(id obj))block {
    return __any(self, [NSMutableSet class], block);
}

- (BOOL)every:(BOOL (^)(id obj))block {
    return __every(self, [NSMutableSet class], block);
}

- (id)max {
    if (self.count == 0) {
        return nil;
    }
    
    NSMutableSet *set = [self mutableCopy];
    id obj = [set anyObject];
    [set removeObject:obj];
    
    id result = [self reduce:obj
                       block:^id (id left, id right) {
                           NSComparisonResult result = [left compare:right];
                           if (result == NSOrderedDescending) {
                               return left;
                           } else {
                               return right;
                           }
                       }];
    
    return result;
}

- (id)min {
    if (self.count == 0) {
        return nil;
    }
    
    NSMutableSet *set = [self mutableCopy];
    id obj = [set anyObject];
    [set removeObject:obj];
    
    id result = [self reduce:obj
                       block:^id (id left, id right) {
                           NSComparisonResult result = [left compare:right];
                           if (result == NSOrderedDescending) {
                               return right;
                           } else {
                               return left;
                           }
                       }];
    
    return result;
}

@end