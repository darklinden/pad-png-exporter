//
//  main.m
//  pad-png-exporter
//
//  Created by darklinden on 12/16/14.
//  Copyright (c) 2014 darklinden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "bin2bcs.h"
#import "bc2pngs.h"

typedef enum : int {
    OperationBin2Bc,
    OperationBc2Png
} ExportOperation;

void operateFile(NSString *path, ExportOperation op)
{
    switch (op) {
        case OperationBin2Bc:
        {
            if ([path.pathExtension.lowercaseString isEqualToString:@"bin"]) {
                process_bin_file(path.UTF8String);
            }
        }
            break;
        case OperationBc2Png:
        {
            if ([path.pathExtension.lowercaseString isEqualToString:@"bc"]) {
                process_bc_file(path.UTF8String);
            }
        }
            break;
        
            break;
    }
}

void enumFolder(NSString *folderPath, ExportOperation op)
{
    printf("enum folder: %s, operation: %d \n", folderPath.UTF8String, op);
    
    NSFileManager *fmgr = [NSFileManager defaultManager];
    
    NSError *err = nil;
    NSArray *array = [fmgr contentsOfDirectoryAtPath:folderPath error:&err];
    
    if (err) {
        printf("error with enum folder: %s err: %s \n", folderPath.UTF8String, err.description.UTF8String);
    }
    else {
        for (NSString *name in array) {
            NSString *path = [folderPath stringByAppendingPathComponent:name];
            BOOL isDirectory = NO;
            
            [fmgr fileExistsAtPath:path isDirectory:&isDirectory];
            if (isDirectory) {
                enumFolder(path, op);
            }
            else {
                operateFile(path, op);
            }
        }
    }
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        if (argc != 3) {
            return -1;
        }
        
        NSString *op = [NSString stringWithUTF8String:argv[1]];
        NSString *file = [NSString stringWithUTF8String:argv[2]];
        
        ExportOperation eop;
        if ([op isEqualToString:@"bc"]) {
            eop = OperationBin2Bc;
        }
        else {
            eop = OperationBc2Png;
        }
        
        BOOL isDirectory = NO;
        BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:file isDirectory:&isDirectory];
        
        if (exist) {
            if (isDirectory) {
                enumFolder(file, eop);
            }
            else {
                operateFile(file, eop);
            }
        }
        
    }
    return 0;
}
