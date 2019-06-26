//
//  HDLY_IAPStore.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/28.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit
import StoreKit
import SwiftyStoreKit

//###上线需修改地方####
//
//let VERIFY_RECEIPT_URL = "https://buy.itunes.apple.com/verifyReceipt"
//let ITMS_SANDBOX_VERIFY_RECEIPT_URL = "https://sandbox.itunes.apple.com/verifyReceipt"
let IAP_Is_Sandbox = "0"//是否是测试环境 1是, 0不是

final class HDLY_IAPStore: NSObject ,SKProductsRequestDelegate, SKPaymentTransactionObserver  {
    
    static let shared = HDLY_IAPStore()
    var productDict: NSMutableDictionary!
    var productArr:Array<Any>?
    
    override init() {
        super.init()
        
    }
    
    func setup() {
        
    }
    
    //1、根据产品ID数组 查询在线商品
    func requestProducts(_ productIdentifierArr: Array<String>?) {
        //
        addPaymentTransactionObserver()
        
        let set = NSSet(array: ["0060","0012","0018","888","spacecoin30"])
        let request = SKProductsRequest(productIdentifiers:set as! Set<String>)
        request.delegate = self;
        request.start()
        
    }
    
    //2、添加购买
    
    func buyProductPackages(productId: String) {
        //先判断是否支持内购
        if(SKPaymentQueue.canMakePayments()) {
            buyProduct(product: productDict[productId] as! SKProduct)
        }
        else {
            print("============不支持内购功能")
        }
    }
    
    func buyProduct(product: SKProduct){
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    //3、恢复内购
    func restoreTransactions() {
        
    }
    
    //4、添加票据校验
    func verifyPruchase() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HDLY_IAPStore_MyWalletCloseLoading_Noti"), object: nil)//通知我的钱包移除loading

        // 验证凭据，获取到苹果返回的交易凭据
        let receiptURL = Bundle.main.appStoreReceiptURL
        // 从沙盒中获取到购买凭据
        let receiptData = NSData(contentsOf: receiptURL!)
        let encodeStr = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
        guard let token  = HDDeclare.shared.api_token else {
            HDAlert.showAlertTipWith(type: .onlyText, text: "请先登录账号")
            return
        }
        
        let randomNum = Int(arc4random_uniform(8999999) + 1000000)
        let millisecond = Date().milliStamp
        let uuid = String.init(format: "%@%ld", millisecond,randomNum)
        //未验证成功订单本地永久保存
        HDLY_KeychainTool.shared.saveDataValue(key: uuid, value: receiptData! as Data)

        LOG("uuid:\(uuid)")
        
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .verifyTransaction(cate_id: 5, receipt_data: encodeStr!, password: "", is_sandbox: IAP_Is_Sandbox, uuid: uuid, api_token: token), showHud: false, loadingVC: UIViewController(), success: { (result) in
            
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("==== 内购校验成功验证 ==== ：\(String(describing: dic))")
            
            let statusCode:Int = dic?["status"] as! Int
            if statusCode == 1 {
                HDLY_KeychainTool.shared.removeItem(key: uuid)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HDLY_IAPStore_verifyPruchaseSuccess_Noti"), object: nil)//通知我的钱包界面刷新
            }
            
        }) { (errorCode, msg) in
            
        }
        
    }
    
    //keychain 本地订单校验
    func verifyPruchaseWithReceiptData(receiptData: NSData, key: String) {
        
        let encodeStr = receiptData.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
        guard let token  = HDDeclare.shared.api_token else {
            HDAlert.showAlertTipWith(type: .onlyText, text: "请先登录账号")
            return
        }
        let uuid = key
        LOG("uuid:\(uuid)")
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .verifyTransaction(cate_id: 5, receipt_data: encodeStr, password: "", is_sandbox: IAP_Is_Sandbox, uuid: uuid, api_token: token), showHud: false, loadingVC: UIViewController(), success: { (result) in
            
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("==== 内购校验成功验证 ==== ：\(String(describing: dic))")
            let statusCode:Int = dic?["status"] as! Int
            if statusCode == 1 {
                HDLY_KeychainTool.shared.removeItem(key: uuid)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HDLY_IAPStore_verifyPruchaseSuccess_Noti"), object: nil)//通知我的钱包界面刷新
            }
        }) { (errorCode, msg) in
            
        }
    }
    
    
    
    //添加订单状态观察者
    func addPaymentTransactionObserver() {
        SKPaymentQueue.default().add(self)
    }
    
    //移除订单状态观察者
    func removePaymentTransactionObserver() {
         SKPaymentQueue.default().remove(self)
    }
    
    
}

extension HDLY_IAPStore {
    
    //SKProductsRequestDelegate
    //返回查询的产品
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if (productDict == nil) {
            productDict = NSMutableDictionary(capacity: response.products.count)
        }
        
        for product in response.products {
            // 激活了对应的销售操作按钮，相当于商店的商品上架允许销售
            print("=======Product id=======\(product.productIdentifier)")
            print("===产品标题 ==========\(product.localizedTitle)")
            print("====产品描述信息==========\(product.localizedDescription)")
            print("=====价格: =========\(product.price)")
            if (product.productIdentifier == "spacecoin30")
            {
                if(SKPaymentQueue.canMakePayments()){
                    buyProduct(product: product)
                }
                else {
                    print("============不支持内购功能")
                }
            }
            // 填充商品字典
            productDict.setObject(product, forKey: product.productIdentifier as NSCopying)
        }
        
        self.productArr = response.products
    }
    
    
    //SKPaymentTransactionObserver
    //支付状态监控
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .deferred:
                print("延时处理")
                
            case .failed:
                print("支付失败")
                //应该移除交易队列
                queue.finishTransaction(transaction)
                HDAlert.showAlertTipWith(type: .onlyText, text: "支付失败")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HDLY_IAPStore_MyWalletCloseLoading_Noti"), object: nil)//通知我的钱包移除loading

            case .purchased:
                print("支付成功")
                //应该移除交易队列
                queue.finishTransaction(transaction)
                // 获取购买凭据
//                verifyPruchase()
//                self.verifyPruchase { (mydic, error) in
//                    print("verifyPruchase：\(String(describing: mydic))")
//                }
//                HDAlert.showAlertTipWith(type: .onlyText, text: "支付成功")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HDLY_IAPStore_MyWalletCloseLoading_Noti"), object: nil)//通知我的钱包移除loading

            case .purchasing:
                print("正在支付")
                
            case .restored:
                print("恢复购买")
                //应该移除交易队列
                queue.finishTransaction(transaction)
            }
        }
    }
    
    
    
    /*
    func verifyPruchase(completion:@escaping(NSDictionary?, NSError?) -> Void) {
        // 验证凭据，获取到苹果返回的交易凭据
        let receiptURL = Bundle.main.appStoreReceiptURL
        // 从沙盒中获取到购买凭据
        let receiptData = NSData(contentsOf: receiptURL!)
        #if DEBUG
        let url = NSURL(string: ITMS_SANDBOX_VERIFY_RECEIPT_URL)
        #else
        let url = NSURL(string: VERIFY_RECEIPT_URL)
        #endif
        let request = NSMutableURLRequest(url: url! as URL, cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "POST"
        let encodeStr = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
        //        let payload = NSString(string: "{\"receipt-data\" : \"" + encodeStr! + "\"}")
        let payload = NSString(string: "{\"receipt-data\" : \"" + encodeStr! + "\",\"password\" : \"5a894b28df534473a89061417b31585c\"}")
        let payloadData = payload.data(using: String.Encoding.utf8.rawValue)
        request.httpBody = payloadData;
        
        let dataTask = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            if error != nil
            {
                completion(nil,error as NSError?)
            }
            else
            {
                if (data==nil)
                {
                    completion(nil,error as NSError?)
                }
                do
                {
                    let jsonResult: NSDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    
                    if (jsonResult.count != 0)
                    {
                        // 比对字典中以下信息基本上可以保证数据安全
                        // bundle_id&application_version&product_id&transaction_id
                        // 验证成功
                        print(jsonResult)
                        let receipt = jsonResult["receipt"] as! NSDictionary
                        completion(receipt,nil)
                        
                        let receiptDic:NSDictionary = jsonResult.object(forKey: "receipt") as! NSDictionary
                        let inAppArr:NSArray = receiptDic.object(forKey: "in_app") as! NSArray
                        let myDic:NSDictionary = inAppArr[0] as! NSDictionary
                        let transactionID:String = myDic.object(forKey: "transaction_id") as! String
                        let productID:String = myDic.object(forKey: "product_id") as! String
                        let purchase_date = myDic.object(forKey: "purchase_date") as! String
                        print("\(transactionID) \(productID)  \(purchase_date)")
                        //bao cun
                    }
                }
                catch
                {
                    completion(nil,nil)
                }
            }
        }
        dataTask.resume()
    }*/
    
}


extension HDLY_IAPStore {
    //获取商品列表并保存
    func getList(_ productArr: Array<String>) {
        
        //let produceSet = NSSet(array: ["com.hengdawb.smart.HDMiusiSpace.30","com.hengdawb.smart.HDMiusiSpace.60","com.hengdawb.smart.HDMiusiSpace.108"])
        let produceSet = NSSet(array: productArr)

        SwiftyStoreKit.retrieveProductsInfo(produceSet as! Set<String>) { result in
            
            for product in result.retrievedProducts {
                // 激活了对应的销售操作按钮，相当于商店的商品上架允许销售
                print("=======Product id=======\(product.productIdentifier)")
                print("===产品标题 ==========\(product.localizedTitle)")
                print("====产品描述信息==========\(product.localizedDescription)")
                print("=====价格: =========\(product.price)")
                if (product.productIdentifier == "spacecoin30")
                {
                    if(SKPaymentQueue.canMakePayments()){
//                        buyProduct(product: product)
                        print("==内购功能可以使用 === ")
                    }
                    else {
                        print("============不支持内购功能")
                    }
                }
            }
            
            
//            if let product = result.retrievedProducts.first {
//                let priceString = product.localizedPrice!
//                print("Product: \(product.localizedDescription), price: \(priceString)")
//            } else if let invalidProductId = result.invalidProductIDs.first {
//                print("Invalid product identifier: \(invalidProductId)")
//            } else {
//                print("Error: \(String(describing: result.error))")
//            }
        }
    }
    
    //点击购买按钮操作
    func buyProduceWithProdectID(_ prodectID: String) {
//        let prodectID:String = "spacecoin30"
        let prodectID:String = prodectID
        
        SwiftyStoreKit.purchaseProduct(prodectID, quantity: 1, atomically: true) { result in
            switch result {
            case .success(let purchase):
                print("Purchase Success: \(purchase.productId)")
                
                self.verifyPruchase()
                //上传后台验证订单信息
                //                let receipt = HDIAPReceiptValidator(service: .sandbox)
                
                //                #if DEBUG
                //                let service: VerifyReceiptURLType = .production
                //                #else
                ////                let service: VerifyReceiptURLType = .production
                //                #endif
                /*
                
                let appleValidator = AppleReceiptValidator(service: .sandbox, sharedSecret: "your-shared-secret")
                
                let password = "公共秘钥在 itunesConnect App 内购买项目查看"
                SwiftyStoreKit.verifyReceipt(using: appleValidator, forceRefresh: true, completion: { (result) in
                    switch result {
                    case .success(let receipt):
                        print("receipt--->\(receipt)")
                        break
                    case .error(let error):
                        print("error--->\(error)")
                        break
                    }
                })*/
                
                
            case .error(let error):
                switch error.code {
                case .unknown: print("Unknown error. Please contact support")
                case .clientInvalid: print("Not allowed to make the payment")
                case .paymentCancelled: break
                case .paymentInvalid: print("The purchase identifier was invalid")
                case .paymentNotAllowed: print("The device is not allowed to make the payment")
                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                }
            }
        }
    }
    
    //恢复内购
    func restorePurchases() {
        
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            
            for purchase in results.restoredPurchases {
                let downloads = purchase.transaction.downloads
                if !downloads.isEmpty {
                    SwiftyStoreKit.start(downloads)
                } else if purchase.needsFinishTransaction {
                    // Deliver content from server, then:
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
            }
            //self.showAlert(self.alertForRestorePurchases(results))
        }
    }
    
}



