## Introduction

This is a simple class for compressing and extracting files. It works depend on minizip, which is a open source zip format library.

The major class name is ZipArchive, it’s easy to use, you can declare a instance and call initialize functions, and then call addFileToZip or UnzipFileTo to finish compression or uncompression.

## Details

Usage: Add all the files to you project, and and framework libz.1.2.3.dylib.

include ZipArchive.h using #import "ZipArchive/ZipArchive.h"

To create and add files to a zip

```objective-c
BOOL ret = [zip CreateZipFile2:l_zipfile];
// OR
BOOL ret = [zip CreateZipFile2:l_zipfile Password:@"your password"];
//if the Password is empty, will get the same effect as [zip CreateZipFile2:l_zipfile];

ret = [zip addFileToZip:l_photo newname:@"photo.jpg"];
if( ![zip CloseZipFile2] )
{
  // error handler here
}
[zip release];
```

Extract files in a zip file to special directory, if the directory does not exist, the class will create it automatically. also if you pass ‘overWrite’ as ‘YES’ it will overwrite files already exist. You can also implement the methods of ZipArchiveDelegate to give more choices for overwriting.

Example

```objective-c
ZipArchive *za = [[ZipArchive alloc] init];
if ([za UnzipOpenFile: @"/Volumes/data/testfolder/Archive.zip"]) {
    BOOL ret = [za UnzipFileTo: @"/Volumes/data/testfolde/extract" overWrite: YES];
    if (NO == ret){} [za UnzipCloseFile];
}
[za release];
```

within your header class adopt the <ZipArchiveDelegate> protocol

and implement these delegate methods in implementation

```objective-c
#pragma mark ziparchive delegate methods
-(void) ErrorMessage:(NSString*) msg{
    ENTER_METHOD;
}
-(BOOL) OverWriteOperation:(NSString*) file{
    return YES;
}

// optional
-(void) UnzipProgress:(uLong)myCurrentFileIndex total:(uLong)myTotalFileCount{
    ENTER_METHOD;
}

#define ENTER_METHOD NSLog(@">> %s", __func__)
````
