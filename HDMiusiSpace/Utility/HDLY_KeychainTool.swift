//
//  HDLY_KeychainTool.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2019/2/13.
//  Copyright © 2019 hengdawb. All rights reserved.
//

import UIKit
import KeychainAccess

final class HDLY_KeychainTool: NSObject {
    
    
    static let shared = HDLY_KeychainTool()
    
    let keychain = Keychain(service: "com.hengdawb.smart.HDMiusiSpace")
    
    private override init() {
        super.init()
        config()
    }
    
    //初始化设置
    func config() {

    }
    
    //MARK: --- Save Value ----
    
    func saveStringValue(key: String, value: String) {
        do {
            try keychain.set(value, key: key)
        }
        catch let error {
            print(error)
        }
    }
    
    func saveDataValue(key: String, value: Data) {
        do {
            try keychain.set(value, key: key)
        }
        catch let error {
            print(error)
        }
    }
    
     //MARK: --- Get Value ----
    
    func getStringValue(key: String) -> String? {
        let value = keychain[string: key]
        return value
    }
    
    func getDataValue(key: String) -> Data? {
        let value = keychain[data: key]
        return value
    }
    
    
    func getAllStoredKeys() -> Array<String> {
        let keys = keychain.allKeys()
        for key in keys {
            print("key: \(key)")
        }
        return keys
    }
    
    func getAllStoredItems() -> Array<Dictionary<String,Any>> {
        let items = keychain.allItems()
        for item in items {
            print("item: \(item)")
        }
        return items
    }
    
    
    
     //MARK: --- Removing an item ----
    
    func removeItem(key: String) {
        do {
            try keychain.remove(key)
        } catch let error {
            print("error: \(error)")
        }

    }
    
    func removeAllItems() {
        do {
            try keychain.removeAll()
        } catch let error {
            print("error: \(error)")
        }
    }
    
    //MARK: ---
    func isContainsKey(_ key: String) -> Bool {
        let isContain = try? keychain.contains(key)
        return isContain ?? false
    }

    
}











