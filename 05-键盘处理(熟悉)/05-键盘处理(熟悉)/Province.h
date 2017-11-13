<<<<<<< Updated upstream
=======

>>>>>>> Stashed changes

#import <Foundation/Foundation.h>

@interface Province : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray *cities;


+ (instancetype)provinceWithDict:(NSDictionary *)dict;

@end
