//
//  HDCache.swift
//  ShanXiMuseum
//
//  Created by liuyi on 2018/2/13.
//  Copyright © 2018年 liuyi. All rights reserved.
//

import Foundation
import Cache

class HDCache {
    
    static let `default` = HDCache()
    /// Manage storage
    private var storage: Storage<Data>?
    /// init
    init() {
        let diskConfig = DiskConfig(name: "HDNetCache")
        let memoryConfig = MemoryConfig(expiry: .never)
        do {
             storage = try? Storage(
                diskConfig: diskConfig,
                memoryConfig: memoryConfig,
                transformer: TransformerFactory.forData()
            )
        } catch {
            print(error)
        }
    }
    
    // 异步存储
    public func setObject(_ object: Data, forKey: String) {
        storage?.async.setObject(object, forKey: forKey, completion: { (_) in
        })
    }
    
    // 异步读取缓存
    public func object( forKey key: String, completion: @escaping (Cache.Result<Data>)->Void) {
        storage?.async.object(forKey: key, completion: completion)
    }
    
    // 根据key值清除缓存
    public func removeCache(_ cacheKey: String, completion: @escaping (Bool)->()) {
        storage?.async.removeObject(forKey: cacheKey, completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .value: completion(true)
                case .error: completion(false)
                }
            }
        })
    }
    
    // 清除所有缓存
    public func removeAllCache(completion: @escaping (Bool)->()) {
        storage?.async.removeAll(completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .value: completion(true)
                case .error: completion(false)
                }
            }
        })
    }
    
    public func cacheKey(_ url: String, _ params: Dictionary<String, Any>?) -> String {
        //只有URL
        guard let params = params else {
            return MD5(url)
        }
        //url+params
        guard let stringData = try? JSONSerialization.data(withJSONObject: params, options: []),
            let paramString = String(data: stringData, encoding: String.Encoding.utf8) else {
                return MD5(url)
        }
        let str = "\(url)" + "\(paramString)"
        return MD5(str)
    }
}
