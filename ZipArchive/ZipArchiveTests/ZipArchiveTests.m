//
//  ZipArchiveTests.m
//  ZipArchiveTests
//
//  Created by Vladimir Grichina on 10.12.11.
//  Copyright (c) 2011 Vladimir Grichina. All rights reserved.
//

#import "ZipArchiveTests.h"

#import "ZipArchive.h"

@implementation ZipArchiveTests


- (NSString *) tmpPath 
{
    return NSTemporaryDirectory();
}

- (NSString *) zipName
{
    return [[self tmpPath] stringByAppendingPathComponent:@"test.zip"];
}

- (NSString *) fileName 
{
    return [[self tmpPath] stringByAppendingPathComponent:@"test.txt"];
}

- (void) removeFiles
{
    [[NSFileManager defaultManager] removeItemAtPath:[self zipName] error:NULL];
    [[NSFileManager defaultManager] removeItemAtPath:[self fileName] error:NULL];
}

- (void) setUp
{
    [super setUp];

    [self removeFiles];
}

- (void) tearDown
{
    [self removeFiles];

    [super tearDown];
}

- (void) testCreate
{
    ZipArchive *zip = [ZipArchive new];

    STAssertTrue([zip CreateZipFile2:[self zipName]], @"ZIP can be created");

    [@"123" writeToFile:[self fileName] atomically:YES
               encoding:NSUTF8StringEncoding error:NULL];

    STAssertTrue([zip addFileToZip:[self fileName] newname:@"test.txt"], @"File can be added to ZIP");
    STAssertTrue([zip CloseZipFile2], @"ZIP can be closed");
    STAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:[self zipName]], @"ZIP file exists");
}

- (void) testExtract
{
    [self testCreate];
    [[NSFileManager defaultManager] removeItemAtPath:[self fileName] error:NULL];

    ZipArchive *zip = [ZipArchive new];
    STAssertTrue([zip UnzipOpenFile:[self zipName]], @"ZIP can be opened");
    STAssertTrue([zip UnzipFileTo:[self tmpPath] overWrite:YES], @"ZIP can be unzipped");
    STAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:[self fileName]], @"Extracted file exists");
    STAssertEqualObjects(@"123", [NSString stringWithContentsOfFile:[self fileName]
                                                     encoding:NSUTF8StringEncoding error: NULL],
                         @"File contents are as expected");
}


@end
