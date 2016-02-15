//
//  KeapUser.h
//  Keap
//
//  Created by Michael Zuccarino on 2/15/16.
//
//

#import <Foundation/Foundation.h>

@interface KeapUser : NSObject

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *fullname;

+ (KeapUser *)username:(NSString *)username password:(NSString *)password fullname:(NSString *)fullname;

@end
