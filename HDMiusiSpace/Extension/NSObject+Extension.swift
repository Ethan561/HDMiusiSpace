//
//  NSObject+Extension.swift
//  ShanXiMuseum
//
//  Created by liuyi on 2018/2/22.
//  Copyright © 2018年 liuyi. All rights reserved.
//

import Foundation

extension NSObject {
    
    var className : String {
        return String.init(describing: self).components(separatedBy: ".").last!.components(separatedBy: ":").first!
    }
    
    class  var className : String {
        return String.init(describing: self).components(separatedBy: ".").last!.components(separatedBy: ":").first!
    }
}

// MARK: - log日志
func LOG<T>( _ message: T, file: String = #file, method: String = #function, line: Int = #line){
    #if DEBUG
    print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    #endif
}




