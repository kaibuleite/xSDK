//
//  xAppManager+Crack.swift
//  xSDK
//
//  Created by Mac on 2020/10/19.
//

import UIKit

extension xAppManager {
    
    // MARK: - Public Func
    /// 越狱检测（简单）
    public static func isCrack() -> Bool
    {
        /*
        if UIDevice.current.isSimulator {
            xLog("模拟器环境下不用检测")
            return false
        }
        if ([[UIDevice currentDevice] isSimulator]) return YES; // Simulator is not from appstore
            
            if (getgid() <= 10) return YES; // process ID shouldn't be root
            
            if ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"SignerIdentity"]) {
                return YES;
            }
            
            if (![self _yy_fileExistInMainBundle:@"_CodeSignature"]) {
                return YES;
            }
            
            if (![self _yy_fileExistInMainBundle:@"SC_Info"]) {
                return YES;
            }
            
            //if someone really want to crack your app, this method is useless..
            //you may change this method's name, encrypt the code and do more check..
            return NO;
         */
        return false
    }
}
