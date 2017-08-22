//
//  PCMDataPlayer.h
//  PCM
//
//  Created by lyy on 2017/8/20.
//  Copyright © 2017年 LVY. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

#define QUEUE_BUFFER_SIZE 6 //队列缓冲个数
#define MIN_SIZE_PER_FRAME 2000 //每帧最小数据长度

@interface XDYPCMPlayer : NSObject {
    
    AudioStreamBasicDescription audioDescription; ///音频参数
    AudioQueueRef audioQueue; //音频播放队列
    AudioQueueBufferRef audioQueueBuffers[QUEUE_BUFFER_SIZE]; //音频缓存
    BOOL audioQueueUsed[QUEUE_BUFFER_SIZE];

    NSLock* sysnLock;
}

/*
 *  @brief  重置播放器
 *
 *  @since v1.0
 */
- (void)reset;

/*
 *
 *  @brief  停止播放
 *
 *  @since v1.0
 */
- (void)stop;

/*
 *
 *  @brief  播放PCM数据
 *
 *  @param pcmData pcm字节数据
 *
 *  @since v1.0
 */
- (void)play:(void*)pcmData length:(unsigned int)length;


@end
