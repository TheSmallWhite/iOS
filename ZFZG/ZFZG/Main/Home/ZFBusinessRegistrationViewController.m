//
//  ZFBusinessRegistrationViewController.m
//  ZFZG
//
//  Created by Lee on 2021/1/24.
//

#import "ZFBusinessRegistrationViewController.h"
#import "QQScanNativeViewController.h"
#import "StyleDIY.h"
#import "ZFMerchantManager.h"

@interface ZFBusinessRegistrationViewController ()<LBXScanViewControllerDelegate, ZFMerchantManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *posSNCodeField;
@property (weak, nonatomic) IBOutlet UITextField *businessNameField;
@property (weak, nonatomic) IBOutlet UITextField *businessPhoneField;
@property (weak, nonatomic) IBOutlet UIButton *scanBtn;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UIButton *skipBtn;

@end

@implementation ZFBusinessRegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [ZFMerchantManager shareManager].delegate = self;
    self.skipBtn.layer.cornerRadius = 8;
    self.skipBtn.layer.borderColor = MainColorBlue.CGColor;
    self.skipBtn.layer.borderWidth = 1;
    
    self.commitBtn.layer.cornerRadius = 8;
    self.commitBtn.layer.masksToBounds = YES;
}
- (void)setNavBarView{
    [super setNavBarView];
    self.navigationItem.title = @"商户登记";
}
- (IBAction)scanBtnDidClick:(UIButton *)sender {
    QQScanNativeViewController *vc = [QQScanNativeViewController new];
    vc.style = [StyleDIY qqStyle];
    vc.orientation = [StyleDIY videoOrientation];
    vc.listScanTypes = @[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    vc.cameraInvokeMsg = @"相机启动中";
    vc.isOpenInterestRect = YES;
    vc.continuous = YES;

    vc.scanResultBlock = ^(NSString *code) {
        self.posSNCodeField.text = code;
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)commitBtnDidClick:(UIButton *)sender {
    if ([NSObject isBlank:self.posSNCodeField.text] || [NSObject isBlank:self.businessNameField.text] || [NSObject isBlank:self.businessPhoneField.text]) {
        [MBProgressHUD showToast:@"填写内容不能为空"];
        return;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:2];
    [parameters setValue:self.posSNCodeField.text forKey:@"outer_device_no"];
    [parameters setValue:self.businessNameField.text forKey:@"concat_name"];
    [parameters setValue:self.businessPhoneField.text forKey:@"concat_phone"];
    WeakSelf(self);
    [[BasicNetWorking sharedSessionManager] POST:merchantEdit parameters:parameters success:^(id responseObject) {
        [weakself addBusiness];
        } failure:^(NSError *error) {
            
        }];
}
- (IBAction)skipBtnDidClick:(UIButton *)sender {
    [self addBusiness];
}
- (void)addBusiness{
    [[BasicNetWorking sharedSessionManager] GET:me parameters:nil success:^(id responseObject) {
    NSDictionary *data = [ZFGetDataFromResponseTool getData:responseObject];
        if (data.count) {
            NSString *uid = data[@"agent"][@"uid"];
            [[ZFMerchantManager shareManager] presentWithAccount:@"xieguangsheng" viewController:self other:[NSString stringWithFormat:@"%@", uid]];
        }
    } failure:^(NSError *error) {
        
    }];
    
    
}
- (void)merchantManagerReturnError:(NSString *)msg{
    [MBProgressHUD showToast:msg];
}
- (void)merchantManagerReturnSuccess:(NSDictionary *)merchantInfo other:(NSString *)other{

    if ([NSObject isBlank:merchantInfo[@"merchantCode"]]) {
        [MBProgressHUD showToast:@"数据异常"];
        return;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:2];
    [parameters setValue:merchantInfo[@"merchantCode"] forKey:@"outer_mer_id"];
    [parameters setValue:merchantInfo[@"merchantName"] forKey:@"outer_mer_name"];
    NSString *merchantStepProgess = merchantInfo[@"merchantStepProgess"];
    if ([merchantStepProgess isEqual:@"0"] || [merchantStepProgess isEqual:@"2"]) {
        [parameters setValue:@"0" forKey:@"status"];
    }else if ([merchantStepProgess isEqual:@"1"] || [merchantStepProgess isEqual:@"3"]) {
        [parameters setValue:@"3" forKey:@"status"];
    }
//            取出之前上传失败的数据
    NSDictionary *dict = [ZFSaveValueTool getDefaults:uploadFaileBusinessInfos];
    NSMutableDictionary *saveDict = [NSMutableDictionary dictionaryWithCapacity:2];
    if (![NSObject isBlank:dict]) {
        [saveDict addEntriesFromDictionary:dict];
    }
    WeakSelf(self);
    [[BasicNetWorking sharedSessionManager] POST:merchantSignin parameters:parameters success:^(id responseObject) {
            if ([saveDict.allKeys containsObject:merchantInfo[@"merchantCode"]]) {
                [saveDict removeObjectForKey:merchantInfo[@"merchantCode"]];
                [ZFSaveValueTool saveDefaults:uploadFaileBusinessInfos Value:saveDict];
            }
            if ([parameters[@"status"] isEqual:@"3"]){
//                [self dismissViewControllerAnimated:YES completion:nil];
                [weakself.navigationController popToRootViewControllerAnimated:YES];
            }
        } failure:^(NSError *error) {
//            保存数据，再次打开app时上传
            [saveDict setValue:merchantInfo forKey:merchantInfo[@"merchantCode"]];
            
            [ZFSaveValueTool saveDefaults:uploadFaileBusinessInfos Value:saveDict];
        }];
    
}
@end
