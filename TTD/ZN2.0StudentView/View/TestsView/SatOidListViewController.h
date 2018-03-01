//
//  SatOidListViewController.h
//  TTD
//
//  Created by quakoo on 2018/1/26.
//  Copyright © 2018年 totem. All rights reserved.
//

#import "TestBaseViewController.h"

@interface SatOidListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableV;

@property (nonatomic,strong)NSArray * datasout;

@end
