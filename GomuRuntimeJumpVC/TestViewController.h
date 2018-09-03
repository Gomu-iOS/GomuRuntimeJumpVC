//
//  TestViewController.h
//  GomuRuntimeJumpVC
//
//  Created by 庞彬 on 2018/9/3.
//  Copyright © 2018年 Gomu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestViewController : UIViewController

// 注：根据下面的两个属性，可以从服务器获取对应的频道列表数据
/** 频道ID */
@property (nonatomic, copy) NSString *ID;
/** 频道type */
@property (nonatomic, copy) NSString *type;

@end
