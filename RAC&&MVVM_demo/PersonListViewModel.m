//
//  PersonListViewModel.m
//  RAC&&MVVM_demo
//
//  Created by m on 2017/3/11.
//  Copyright © 2017年 XLJ. All rights reserved.
//

#import "PersonListViewModel.h"

@implementation PersonListViewModel
-(RACSignal *)loadPersons
{
    
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
//        NSLog(@"signal");
        
        //发送不同的信号
        _personList = @[].mutableCopy;
        
        //异步加载数据
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [NSThread sleepForTimeInterval:1.0];
            
            for (NSInteger i = 0; i < 20; i++) {
                Person *person = [[Person alloc] init];
                
                person.name = [@"marlonxlj -" stringByAppendingFormat:@"%zd",i];
                person.age = 15 + arc4random_uniform(20);
                
                [_personList addObject:person];
            }
            
//            NSLog(@"%@", _personList);
            
            //完成回调
            dispatch_async(dispatch_get_main_queue(), ^{
                BOOL isError = NO;
                if (isError) {
                    [subscriber sendError:[NSError errorWithDomain:@"marlonxj" code:1000 userInfo:@{@"error message":@"异常错误"}]];
                }else{
                    [subscriber sendNext:self];
                }
                
                //发送完成信号
                
                [subscriber sendCompleted];

            });
        });

       
            return nil;
        
    }];
    
//    NSLog(@"%s",__FUNCTION__);
    
}
@end
