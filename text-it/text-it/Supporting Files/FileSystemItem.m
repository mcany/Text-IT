//
//  FileSystemItem.m
//  text-it
//
//  Created by Mertcan Yigin on 7/20/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileSystemItem.h"

@implementation FileSystemItem

static FileSystemItem *rootItem = nil;
static NSMutableArray *leafNode = nil;

+ (void)initialize {
    if (self == [FileSystemItem class]) {
        leafNode = [[NSMutableArray alloc] init];
    }
}

- (id)initWithPath:(NSString *)path parent:(FileSystemItem *)parentItem {
    if (self = [super init]) {
        NSArray *myPath  = [path componentsSeparatedByString:@"/"];
        fileName = myPath[myPath.count - 1];
        relativePath = [path copy];
        parent = parentItem;
    }
    return self;
}

+ (FileSystemItem *)rootItem {
    if (rootItem == nil) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"Text-It"];

        rootItem = [[FileSystemItem alloc] initWithPath:filePath parent:nil];
    }
    return rootItem;
}


// Creates, caches, and returns the array of children
// Loads children incrementally
- (NSArray *)children {
    
    if (children == nil) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *fullPath = [self fullPath];
        BOOL isDir, valid;
        
        valid = [fileManager fileExistsAtPath:fullPath isDirectory:&isDir];
        
        if (valid && isDir) {
            NSArray *array = [fileManager contentsOfDirectoryAtPath:fullPath error:NULL];
            
            NSUInteger numChildren, i;
            
            numChildren = [array count];
            children = [[NSMutableArray alloc] initWithCapacity:numChildren];
            
            for (i = 0; i < numChildren; i++)
            {
                FileSystemItem *newChild = [[FileSystemItem alloc]
                                            initWithPath:[array objectAtIndex:i] parent:self];
                [children addObject:newChild];
            }
        }
        else {
            children = leafNode;
        }
    }
    return children;
}


- (NSString *)relativePath {
    return relativePath;
}



- (NSString *)fileName {
    return fileName;
}

- (NSString *)fullPath {
    // If no parent, return our own relative path
    if (parent == nil) {
        return relativePath;
    }
    
    // recurse up the hierarchy, prepending each parent’s path
    return [[parent fullPath] stringByAppendingPathComponent:relativePath];
}


- (FileSystemItem *)childAtIndex:(NSInteger)n {
    return [[self children] objectAtIndex:n];
}


- (NSInteger)numberOfChildren {
    NSArray *tmp = [self children];
    return (tmp == leafNode) ? (-1) : [tmp count];
}




@end