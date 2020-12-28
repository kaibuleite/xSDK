//
//  xAPI+Rep.swift
//  xSDK
//
//  Created by Mac on 2020/12/28.
//

import UIKit
import Alamofire

extension xAPI {
    
    // MARK: - 校验返回结果
    public static func check(record : xAPIRecord,
                             response : DataResponse<Any>,
                             success : @escaping xHandlerApiRequestSuccess,
                             failure : @escaping xHandlerApiRequestFailure)
    {
        defer {
            for (i, v) in shared.requestRecordList.enumerated() {
                guard v.id == record.id else { continue }
                shared.requestRecordList.remove(at: i)
                break
            }
        }
        // 响应结果
        let result = response.result
        // 响应成功
        if result.isSuccess {
            if let data = result.value {
                self.returnResponse(record: record,
                                    data: data,
                                    success: success,
                                    failure: failure)
            }
            else {
                self.logDataError(record: record,
                                  isReqSuccess: true,
                                  response: response)
                failure("接口返回的Data解析出错")
            }
            return
        }
        // 响应失败
        if let error = response.error {
            let code = (error as NSError).code
            // 尝试捕获响应失败后的数据
            if self.tryCatchResponseError(code: code, data: response.data) == false {
                self.logResponseError(of: response)
                failure("❎ Response Code处理")
                return
            }
        }
        // 捕获失败，最终处理
        guard let data = response.data else {
            self.logDataError(record: record,
                              isReqSuccess: false,
                              response: response)
            failure("接口返回的Data解析出错")
            return
        }
        // 排查不出错误，而且数据解析成功，当成功处理
        self.returnResponse(record: record,
                            data: data,
                            success: success,
                            failure: failure)
    }
    
    // MARK: - 响应数据处理
    /// 响应数据处理
    public static func returnResponse(record : xAPIRecord,
                                      data : Any,
                                      success : @escaping xHandlerApiRequestSuccess,
                                      failure : @escaping xHandlerApiRequestFailure)
    {
        var result = self.formatterDefaultStyleResponseData(data, record: record)
        // 默认风格解析
        if result.status {
            success(result.data)
            return
        }
        // Restful风格解析
        result = self.formatterRestfulStyleResponseData(data, record: record)
        if result.status {
            success(result.data)
            return
        }
        // 其他风格解析
        result = self.formatterOtherStyleResponseData(data, record: record)
        if result.status {
            success(result.data)
            return
        }
        // 失败回调
        failure("数据解析失败")
    }
    
}
