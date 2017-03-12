//
//  Person.m
//  RAC&&MVVM_demo
//
//  Created by m on 2017/3/11.
//  Copyright © 2017年 XLJ. All rights reserved.
//

#import "Person.h"

@implementation Person

- (NSString *)description
{
    NSArray *keys = @[@"name",@"age"];
    
    return [self dictionaryWithValuesForKeys:keys].description;
}

@end
