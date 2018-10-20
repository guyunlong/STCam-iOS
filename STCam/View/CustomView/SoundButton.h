//
//  SoundButton.h
//  STCam
//
//  Created by guyunlong on 10/20/18.
//  Copyright © 2018 South. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, AudioType ){
    AudioType_Default,
    AudioType_SnapShot,
    AudioType_Click
};
@interface SoundButton : UIButton
@property(nonatomic,assign) AudioType type;
@end
