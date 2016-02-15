//
//  KeapUser.m
//  Keap
//
//  Created by Michael Zuccarino on 2/15/16.
//
//

#import "KeapUser.h"

@interface KeapUser ()

@end

@implementation KeapUser

+ (KeapUser *)username:(NSString *)username password:(NSString *)password fullname:(NSString *)fullname {
    KeapUser *user = [KeapUser new];
    
    user.username = username;
    user.password = password;
    user.fullname = fullname;
    
    return user;
}

@end
