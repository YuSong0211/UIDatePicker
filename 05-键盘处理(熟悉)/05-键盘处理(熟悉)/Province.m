

#import "Province.h"

@implementation Province

+ (instancetype)provinceWithDict:(NSDictionary *)dict
{
    Province *p = [[self alloc] init];
    
    [p setValuesForKeysWithDictionary:dict];
    
    return p;
}

@end
