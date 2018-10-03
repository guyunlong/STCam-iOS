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
@property(nonatomic,strong)NSString* user;
@property(nonatomic,strong)NSString* password;
-(RACSignal *)racLogin;
@end
