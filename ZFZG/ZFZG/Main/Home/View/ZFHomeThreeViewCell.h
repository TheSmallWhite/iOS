//
//  ZFHomeThreeViewCell.h
//  ZFZG
//
//  Created by Lee on 2021/1/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZFHomeThreeViewCell : UITableViewCell
@property (nonatomic, copy) void (^btnDidClickBlock)(void);
@end

NS_ASSUME_NONNULL_END
