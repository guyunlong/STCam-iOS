//
//  PrefixHeader.pch
//
//
//  Created by sks on 16/3/14.
//  Copyright © 2016年. All rights reserved.
//

#import <Availability.h>

#ifndef __IPHONE_3_0
#warning "This project uses features only available in iOS SDK 3.0 and later."
#endif

#ifdef __OBJC__


#ifndef PrefixHeader_pch
#define PrefixHeader_pch
/*颜色*/
#define FFGreen [UIColor colorWithHexString:@"0x80e186"]
#define FFYellow [UIColor colorWithHexString:@"f18c32"]
#define FFRed [UIColor colorWithHexString:@"e30b20"]
#define iOS_Version [[[UIDevice currentDevice] systemVersion] floatValue]
#define FFDevice_Is_iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define FFDevice_Is_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define FFDevice_Is_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define FFDevice_Is_iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)


/*加载图片default*/
#define FFIconImage [UIImage imageNamed:@"head"]
#define FFCoverImage [UIImage imageNamed:@"cover"]
#define FFDefaultImage [UIImage imageWithColor:FFYellow withFrame:CGRectMake(0, 0, FFScreenWith, 200)]
#define FFLightGreyImage [UIImage imageWithColor:[UIColor colorWithHexString:@"0xdddddd"] withFrame:CGRectMake(0, 0, FFScreenWith, 200)]
#define FFLightGreenImage [UIImage imageWithColor:[UIColor colorWithHexString:@"0x80e186"] withFrame:CGRectMake(0, 0, FFScreenWith, 200)]
/**
 *  屏幕的宽
 * */
#define kScreenBounds [UIScreen mainScreen].bounds
#define kScreenWith [UIScreen mainScreen].bounds.size.width
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
/**
 *屏幕的高
 */
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#import "MBProgressHUD.h"
#import "UIColor+Expanded.h"
#import "UIImage+Common.h"
#import "UITableView+Common.h"
#import "NSString+Common.h"
#import "UIView+Common.h"
#import "NSDate+Helper.h"
#import "NSDate+Common.h"
#import "UIButton+Common.h"
#import <Masonry/Masonry.h>
#import "MASConstraint.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import "UITableView+Common.h"


#import "MBProgressHUD+Add.h"
#import "UIViewController+HUD.h"

#define  kMainColor [UIColor colorWithHexString:@"0x2197d8"]
#define  kDeepMainColor [UIColor colorWithHexString:@"0x41b7f8"]
#define  kLightGrayColor [UIColor colorWithHexString:@"0x969696"]
#define kHeightCoefficient kScreenHeight/667.0
#define kWidthCoefficient kScreenWidth/375.0

#define kPadding 10*kWidthCoefficient
#define kSafeAreaBottomHeight (kScreenHeight == 812.0 ? 34 : 0)
#define kSafeAreaHeaderHeight (kScreenHeight == 812.0 ? 44 : 20)
#define kButtonHeight 40*kWidthCoefficient
#endif /* PrefixHeader_pch */

#define serverIP @"211.149.199.247"
#define ServerPort  800

static int Msg_None = 0;
static int Msg_Login = 1;//用户登录
static int Msg_PlayLive = 2;//开始播放现场
static int Msg_StartPlayRecFile = 3;//播放录影文件
static int Msg_StopPlayRecFile = 4;//停止播放录影文件
static int Msg_GetRecFileLst = 5;//取得录影文件列表
static int Msg_GetDevRecFileHead = 6;//取得设备文件文件头信息
static int Msg_StartUploadFile = 7;//开始上传文件
static int Msg_AbortUploadFile = 8;//取消上传文件
static int Msg_StartUploadFileEx = 9;//开始上传文件tftp
static int Msg_StartTalk = 10;//开始对讲
static int Msg_StopTalk = 11;//停止对讲
static int Msg_PlayControl = 12;//播放控制
static int Msg_PTZControl = 13;//云台控制
static int Msg_Alarm = 14;//警报
static int Msg_ClearAlarm = 15;//关闭警报
static int Msg_GetTime = 16;//取得时间
static int Msg_SetTime = 17;//设置时间
static int Msg_SetDevReboot = 18;//重启设备
static int Msg_SetDevLoadDefault = 19;//系统回到缺省配置 Pkt.Value= 0 不恢复IP; Pkt.Value= 1 恢复IP
static int Msg_DevSnapShot = 20;//设备拍照
static int Msg_DevStartRec = 21;//设备开始录像
static int Msg_DevStopRec = 22;//设备停止录象
static int Msg_GetColors = 23;//取得亮度、对比度、色度、饱和度
static int Msg_SetColors = 24;//设置亮度、对比度、色度、饱和度
static int Msg_SetColorDefault = 25;
static int Msg_GetMulticastInfo = 26;
static int Msg_SetMulticastInfo = 27;
static int Msg_GetAllCfg = 28;//取得所有配置
static int Msg_SetAllCfg = 29;//设置所有配置
static int Msg_GetDevInfo = 30;//取得设备信息
static int Msg_SetDevInfo = 31;//设置设备信息
static int Msg_GetUserLst = 32;//取得用户列表
static int Msg_SetUserLst = 33;//设置用户列表
static int Msg_GetNetCfg = 34;//取得网络配置
static int Msg_SetNetCfg = 35;//设置网络配置
static int Msg_WiFiSearch = 36;
static int Msg_GetWiFiCfg = 37;//取得WiFi配置
static int Msg_SetWiFiCfg = 38;//设置WiFi配置
static int Msg_GetVideoCfg = 39;//取得视频配置
static int Msg_SetVideoCfg = 40;//设置视频配置
static int Msg_GetAudioCfg = 41;//取得音频配置
static int Msg_SetAudioCfg = 42;//设置音频配置
static int Msg_GetHideArea = 43;//秘录
static int Msg_SetHideArea = 44;//秘录
static int Msg_GetMDCfg = 45;//移动侦测配置
static int Msg_SetMDCfg = 46;//移动侦测配置
static int Msg_GetDiDoCfg__Disable = 47;
static int Msg_SetDiDoCfg__Disable = 48;
static int Msg_GetAlmCfg = 49;//取得Alarm配置
static int Msg_SetAlmCfg = 50;//设置Alarm配置
static int Msg_GetRS485Cfg__Disable = 51;
static int Msg_SetRS485Cfg__Disable = 52;
static int Msg_GetDiskCfg = 53;//设置Disk配置
static int Msg_SetDiskCfg = 54;//设置Disk配置
static int Msg_GetRecCfg = 55;//取得录影配置
static int Msg_SetRecCfg = 56;//设置录影配置
static int Msg_GetFTPCfg = 57;
static int Msg_SetFTPCfg = 58;
static int Msg_GetSMTPCfg = 59;
static int Msg_SetSMTPCfg = 60;
static int Msg_GetP2PCfg = 61;
static int Msg_SetP2PCfg = 62;
static int Msg_Ping = 63;
static int Msg_GetRFCfg__Disable = 64;
static int Msg_SetRFCfg__Disable = 65;
static int Msg_RFControl__Disable = 66;
static int Msg_RFPanic__Disable = 67;
static int Msg_EmailTest = 68;
static int Msg_FTPTest = 69;
static int Msg_GetWiFiSTALst = 70;
static int Msg_DeleteFromWiFiSTALst = 71;
static int Msg_IsExistsAlarm = 72;
static int Msg_DOControl = 73;
static int Msg_GetDOStatus = 74;
static int Msg_ReSerialNumber = 75;
static int Msg_HttpGet = 76;
static int Msg_DeleteFile = 77;
static int Msg_HIISPCfg_Save = 78;
static int Msg_HIISPCfg_Download = 79;
static int Msg_HIISPCfg_Load = 80;
static int Msg_HIISPCfg_Default = 81;
static int Msg_GetAllCfgEx = 82;
static int Msg_MulticastSetWIFI = 83;
static int Msg_GetSensors = 84;//读PH 浊度 温度等
static int Msg_DevIsRec = 85;
static int Msg_GetPicFileLst = 86;
static int Msg_GetSnapShotCfg = 87;
static int Msg_SetSnapShotCfg = 88;
static int Msg_GetRecCfgEx = 89;
static int Msg_SetRecCfgEx = 90;
static int Msg_GetRecStartTime = 91;
static int Msg_FormattfCard = 92;
static int Msg_CheckUpgradeBin = 93;
static int Msg_TestModeStart = 94;
static int Msg_TestModeStop = 95;
static int Msg_GetLightCfg = 96;
static int Msg_SetLightCfg = 97;
static int Msg_GetPushCfg = 98;
static int Msg_SetPushCfg = 99;
static int Msg_PlayWavFile = 100;


 static  int RESULT_FAIL = 0;//失败
 static  int RESULT_SUCCESS = 1;//成功
 static  int RESULT_SUCCESS_REBOOT = 2;//成功，需要重启

 static  int RESULT_USER_EXISTS = -1;//用户已存在
 static  int RESULT_USER_VERIFYCODE_ERROR = -2;//验证码错误
 static  int RESULT_USER_VERIFYCODE_TIMEOUT = -3;//验证码超时
 static  int RESULT_USER_ISBIND = -4;//用户已绑定
 static  int RESULT_USER_NOTEXISTS = -5;//用户不存在
 static  int RESULT_USER_LOGINED = -6;//已有用户登录
 static  int RESULT_USER_LOGOUT = -7;//强制用户退出登录



#endif

