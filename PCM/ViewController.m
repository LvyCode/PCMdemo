//
//  ViewController.m
//  PCM
//
//  Created by lyy on 2017/8/20.
//  Copyright © 2017年 LVY. All rights reserved.
//

#import "ViewController.h"

#import <AVFoundation/AVFoundation.h>
#import "XDYPCMPlayer.h"
#import "XDYPCMPublisher.h"

#define EVERY_READ_LENGTH 640 //每次从PCM文件读取的长度
@interface ViewController ()

{
    XDYPCMPlayer* player;
    FILE* pcmFile;
    void* pcmDataBuffer; //pcm读数据的缓冲区
    NSTimer* sendDataTimer;
}
@end

@implementation ViewController
- (void)dealloc
{
    [self releaseResource];
    
    NSLog(@"PlayerViewController dealloc...");
}

- (void)releaseResource
{
    if (sendDataTimer) {
        [sendDataTimer invalidate];
    }
    sendDataTimer = nil;
    
    if (player) {
        [player stop];
    }
    player = nil;
    
    if (pcmFile) {
        fclose(pcmFile);
    }
    pcmFile = NULL;
    
    if (pcmDataBuffer) {
        free(pcmDataBuffer);
    }
    pcmDataBuffer = NULL;
}
- (void)readNextPCMData:(NSTimer*)timer
{
    if (pcmFile != NULL && pcmDataBuffer != NULL) {
        int readLength = fread(pcmDataBuffer, 1, EVERY_READ_LENGTH, pcmFile); //读取PCM文件
        if (readLength > 0) {
            [player play:pcmDataBuffer length:readLength];
        }
        else {
            if (sendDataTimer) {
                [sendDataTimer invalidate];
            }
            sendDataTimer = nil;
            
            if (player) {
                [player stop];
            }
            
            if (pcmFile) {
                fclose(pcmFile);
            }
            pcmFile = NULL;
            
            if (pcmDataBuffer) {
                free(pcmDataBuffer);
            }
            pcmDataBuffer = NULL;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if (player != nil) {
        [player stop];
        player = nil;
    }
    player = [[XDYPCMPlayer alloc] init];
    
    NSLog(@"PlayerViewController PCMDataPlayer init...");
    if (sendDataTimer) {
        [sendDataTimer invalidate];
        sendDataTimer = nil;
    }
    else {
        
        NSString* filepath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"test.pcm"];
        NSLog(@"PlayerViewController filepath = %@", filepath);
        NSFileManager* manager = [NSFileManager defaultManager];
        NSLog(@"PlayerViewController file exist = %d", [manager fileExistsAtPath:filepath]);
        NSLog(@"PlayerViewController file size = %lld", [[manager attributesOfItemAtPath:filepath error:nil] fileSize]);
        
        pcmFile = fopen([filepath UTF8String], "r");
        if (pcmFile) {
            fseek(pcmFile, 0, SEEK_SET);
            pcmDataBuffer = malloc(EVERY_READ_LENGTH);
            NSLog(@"PlayerViewController PCM文件打开成功...");
        }
        else {
            NSLog(@"PlayerViewController PCM文件打开错误...");
            return;
        }
    }
    
    sendDataTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0 / 40.0)target:self selector:@selector(readNextPCMData:) userInfo:nil repeats:YES];
    

    XDYPCMPublisher *publisher = [[XDYPCMPublisher alloc]init];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
