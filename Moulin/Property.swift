//
//  Property.swift
//  Moulin
//
//  Created by asai.yuki on 2015/12/27.
//  Copyright © 2015年 yukiasai. All rights reserved.
//

import Foundation

public class Property<T: ValueType>: PropertyType {
    public typealias Value = T
    public typealias ValueChanged = (Property<Value>, Value?) -> Void
    
    public var value: Value? {
        didSet {
            valueChanged?(self, value)
        }
    }
    
    var key: String?
    var keyCase: Case?
    var valueChanged: ValueChanged?
    
    public init(_ value: Value? = nil, key: String? = nil, keyCase: Case? = nil, valueChanged: ValueChanged? = nil) {
        self.value = value
        self.key = key
        self.keyCase = keyCase
        self.valueChanged = valueChanged
    }
    
    public func fromJSON(json: AnyObject) {
        if json is NSNull {
            self.value = nil
            return
        }
        
        if json is T {
            self.value = json as? Value
            return
        }
        
        let value = T()
        if let convertible = value as? JSONConvertible {
            convertible.fromJSON(json)
            self.value = value
        }
    }
    
    public func toJSON() -> AnyObject? {
        if let convertible = value as? JSONConvertible {
            return convertible.toJSON()
        }
        return value as? AnyObject
    }
}
