//
//  XDYPCMPublisher.h
//  PCM
//
//  Created by lyy on 2017/8/20.
//  Copyright © 2017年 LVY. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AudioToolbox/AudioToolbox.h>

@interface XDYPCMPublisher : NSObject

@property(nonatomic,assign)AudioStreamBasicDescription streamFormat;

@end
