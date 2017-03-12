//
//  PersonListViewModel.h
//  RAC&&MVVM_demo
//
//  Created by m on 2017/3/11.
//  Copyright © 2017年 XLJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"
#import <ReactiveObjC/ReactiveObjC.h>
///列表数据模型，负责加载数据,包含网络数据、本地数据
@interface PersonListViewModel : NSObject
///联系人数组
@property (nonatomic, strong) NSMutableArray <Person *>*personList;
///加载联系人
- (RACSignal *)loadPersons;
@end
