//
//  LoginViewModel.h
//  STCam
//
//  Created by guyunlong on 10/3/18.
//  Copyright © 2018 South. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
@interface LoginViewModel : NSObject
-(void)initConfig;
@property(nonatomic,strong)NSString* user;
@property(nonatomic,strong)NSString* password;
@property(nonatomic,assign)BOOL remember;
@property (nonatomic, strong) RACSignal *validLoginSignal;
-(RACSignal *)racLogin:(BOOL)forceLogin;
@end
