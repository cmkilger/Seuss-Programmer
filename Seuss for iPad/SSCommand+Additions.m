//
//  SSCommand+Additions.m
//  Seuss for iPad
//
//  Created by Cory Kilger on 7/28/12.
//  Copyright (c) 2012 Cory Kilger. All rights reserved.
//

#import "SSCommand+Additions.h"
#import "NSManagedObject+Additions.h"
#import "SSString.h"

@implementation SSCommand (Additions)

- (id)initWithFunction:(SUFunction *)function inContext:(NSManagedObjectContext *)context {
    self = [self initWithManagedObjectContext:context];
    if (self) {
        SUList * signature = SUFunctionGetSignature(function);
        SUListEnumerateWithBlock(signature, ^(SUTypeRef type, unsigned int index, int *stop) {
            SUList * words = type;
            NSMutableString * value = [[NSMutableString alloc] init];
            SUListEnumerateWithBlock(words, ^(SUTypeRef type, unsigned int index, int *stop) {
                SUString * word = type;
                if ([value length] > 0)
                    [value appendString:@" "];
                [value appendString:[NSString stringWithUTF8String:SUStringGetCString(word)]];
            });
            
            SSString * string = [[SSString alloc] initWithManagedObjectContext:context];
            string.order = index+1;
            string.value = value;
            
            [self addSignatureObject:string];
        });
    }
    return self;
}

- (NSString *)signatureKey {
    NSSortDescriptor * sort = [NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES];
    NSMutableString * key = [[NSMutableString alloc] init];
    for (SSString * string in [self.signature sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]]) {
        if ([key length] > 0)
            [key appendString:@":"];
        [key appendString:string.value];
    }
    return key;
}

@end
