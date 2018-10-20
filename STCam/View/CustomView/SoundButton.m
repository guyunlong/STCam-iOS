//
//  SoundButton.m
//  STCam
//
//  Created by guyunlong on 10/20/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "SoundButton.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
@interface SoundButton()

{
    SystemSoundID soundFileObject;
}
@end

@implementation SoundButton

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent*)event
{
    if (_type == AudioType_SnapShot) {
        [self playSoundEffect:@"soundsnapshot"type:@"wav"];
    }
    else if(_type == AudioType_Click){
        [self playSoundEffect:@"soundkeypress"type:@"wav"];
    }
    [super touchesBegan:touches withEvent:event];
}
//1108 photoShutter.caf photoShutter.caf CameraShutter 
//1117 begin_video_record.caf begin_video_record.caf BeginVideoRecording Available since 3.0
//1118 end_video_record.caf end_video_record.caf EndVideoRecording Available since 3.0 
- (void)playSoundEffect:(NSString*)name type:(NSString*)type

{
//    //得到音效文件的地址
//    NSString*soundFilePath =[[NSBundle mainBundle]pathForResource:name ofType:type];
//    //将地址字符串转换成url
//    NSURL*soundURL = [NSURL fileURLWithPath:soundFilePath];
//    //生成系统音效id
//    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &soundFileObject);
////    //播放系统音效
//    [[MPMusicPlayerController applicationMusicPlayer] setVolume:1.0];
//
//    AudioServicesPlaySystemSound(soundFileObject);
    
    AudioServicesPlaySystemSound(1108);
    
}


@end
