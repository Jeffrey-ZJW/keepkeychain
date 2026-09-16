// Tweak.x
// 阻止 YOY (爱新机) 无差别删除 Keychain 里的 genp 项

#import <substrate.h>
#import <Security/Security.h>
#import <Foundation/Foundation.h>

static OSStatus (*orig_SecItemDelete)(CFDictionaryRef query);

static BOOL isYoyGenpWipe(CFDictionaryRef query) {
    if (!query) return NO;

    NSDictionary *dict = (__bridge NSDictionary *)query;
    NSString *desc = [dict description];

    BOOL isGenp  = ([desc rangeOfString:@"genp"].location != NSNotFound);
    BOOL hasAgrp = ([desc rangeOfString:@"agrp"].location != NSNotFound);
    BOOL hasAcct = ([desc rangeOfString:@"acct"].location != NSNotFound);
    BOOL hasSvce = ([desc rangeOfString:@"svce"].location != NSNotFound);

    return isGenp && !hasAgrp && !hasAcct && !hasSvce;
}

static OSStatus my_SecItemDelete(CFDictionaryRef query) {
    @autoreleasepool {
        if (isYoyGenpWipe(query)) {
            NSDictionary *dict = (__bridge NSDictionary *)query;
            NSLog(@"[KeepKeychain] BLOCKED YOY genp wipe: %@", dict);
            return errSecSuccess;
        }
    }
    return orig_SecItemDelete(query);
}

%ctor {
    @autoreleasepool {
        MSHookFunction((void *)SecItemDelete,
                       (void *)my_SecItemDelete,
                       (void **)&orig_SecItemDelete);
        NSLog(@"[KeepKeychain] hooked SecItemDelete");
    }
}
