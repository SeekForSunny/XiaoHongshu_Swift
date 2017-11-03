//
//  NetWokingTool.swift
//  XiaoHongshu_Swift
//
//  Created by SMART on 2017/7/8.
//  Copyright © 2017年 com.smart.swift. All rights reserved.
//

import UIKit
import AFNetworking

enum requestType {
    case get
    case post
}

class NetWokTool: NSObject {

    
    static func request(type:requestType,url:String,params:[String:Any],resultBlock:@escaping (Any?,Error?)->()) {
        
        let successBlock = { (task:URLSessionDataTask, response:Any?) in
            resultBlock(response, nil)
        }
        
        let failureBlock = { (task:URLSessionDataTask?, error:Error) in
            resultBlock(nil, error)
        }
        
        let manager = AFHTTPSessionManager()
        manager.responseSerializer.acceptableContentTypes = ["application/json", "text/json", "text/javascript", "text/html", "text/plain","charset=utf-8"]
        if type == .get {
            manager.get(url, parameters: params, progress: nil, success: successBlock,failure:failureBlock)
        }else{
            manager.post(url, parameters: params, progress: nil, success: successBlock,failure:failureBlock)
        }

    }
    
    
}
