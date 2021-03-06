//
//  ZFConst.h
//  ZFZG
//
//  Created by Lee on 2020/11/18.
//

#ifndef ZFConst_h
#define ZFConst_h

#pragma mark -- 本地存储的Key
static NSString *auth_token = @"auth_token";
static NSString *refresh_token = @"refresh_token";
static NSString *uploadFaileBusinessInfos = @"uploadFaileBusinessInfos";



#pragma mark -- 接口地址
/// 登录
static NSString *loginUrl = @"login";
/// 刷新token
static NSString *auth = @"auth";
/// 获取首页统计数量
static NSString *merchantNum = @"merchant/signin-sum";
/// 忘记密码-获取验证码
static NSString *smscode = @"smscode";
/// 忘记密码-获取重置密码的请求地址
static NSString *passwordMobile = @"password/mobile";
/// 用户修改密码
static NSString *userChangePwd = @"user/change-pwd";
/// 用户退出登录
static NSString *logout = @"logout";
/// 登录用户信息
static NSString *me = @"me";
/// 联系我们
static NSString *manageContacte = @"manage/contact";
/// 投诉建议
static NSString *manageAddadvise = @"manage/addadvise";
/// 查询进件列表
static NSString *merchantSigninList = @"merchant/signin-list";
/// 查询商户信息
static NSString *agentMerchant = @"agent/merchant";
/// 新增商户
static NSString *merchantEdit = @"merchant/edit";
/// 进件保存
static NSString *merchantSignin = @"merchant/signin";
#endif /* ZFConst_h */





