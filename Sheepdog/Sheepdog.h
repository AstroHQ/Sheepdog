//
//  Sheepdog.h
//  Sheepdog
//
//  Created by Matt Ronge on 2/13/14.
//  Copyright (c) 2014 Astro HQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Sheepdog)
- (NSArray *)filter:(BOOL (^)(id obj))block;
- (id)reduce:(id)val block:(id (^)(id left, id right))block;
- (NSArray *)map:(id (^)(id obj))block;

- (NSArray *)sort;
- (NSArray *)reverse;
- (NSArray *)distinct;

- (NSArray *)partition:(NSInteger)n;
- (NSArray *)partitionBy:(id (^)(id obj))block;
- (NSDictionary *)groupBy:(id (^)(id obj))block;

- (BOOL)any:(BOOL (^)(id obj))block;
- (BOOL)every:(BOOL (^)(id obj))block;

- (id)max;
- (id)min;
@end

@interface NSSet (Sheepdog)
- (NSSet *)filter:(BOOL (^)(id obj))block;
- (id)reduce:(id)val block:(id (^)(id left, id right))block;
- (NSSet *)map:(id (^)(id obj))block;

- (BOOL)any:(BOOL (^)(id obj))block;
- (BOOL)every:(BOOL (^)(id obj))block;

- (id)max;
- (id)min;
@end
