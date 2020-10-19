//
//  Date+xExtension.swift
//  xSDK
//
//  Created by Mac on 2020/10/19.
//

import UIKit

extension Date {
    
    // MARK: - Handler
    public func year() -> Int
    {
        let ret = NSCalendar.current.component(.year, from: self)
        return ret
    }
    public func month() -> Int
    {
        let ret = NSCalendar.current.component(.month, from: self)
        return ret
    }
    public func day() -> Int
    {
        let ret = NSCalendar.current.component(.day, from: self)
        return ret
    }
    public func hour() -> Int
    {
        let ret = NSCalendar.current.component(.hour, from: self)
        return ret
    }
    public func minute() -> Int
    {
        let ret = NSCalendar.current.component(.minute, from: self)
        return ret
    }
    public func second() -> Int
    {
        let ret = NSCalendar.current.component(.second, from: self)
        return ret
    }
    public func nanosecond() -> Int
    {
        let ret = NSCalendar.current.component(.nanosecond, from: self)
        return ret
    }
    public func other(component : Calendar.Component) -> Int
    {
        let ret = NSCalendar.current.component(component, from: self)
        return ret
    }
    
}
