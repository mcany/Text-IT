//
//  FileSystemItem.h
//  text-it
//
//  Created by Mertcan Yigin on 7/20/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//



@interface FileSystemItem : NSObject
{
    NSString *relativePath;
    FileSystemItem *parent;
    NSMutableArray *children;
    
    NSString *fileName;
}

+ (FileSystemItem *)rootItem: (NSString *) directoryName;
- (NSInteger)numberOfChildren;// Returns -1 for leaf nodes
- (FileSystemItem *)childAtIndex:(NSInteger)n; // Invalid to call on leaf nodes
- (NSString *)fullPath;
- (NSString *)relativePath;
- (NSString *)fileName;

@end
