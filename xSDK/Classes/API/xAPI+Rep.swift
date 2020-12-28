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
        // 响应成功
        if response.result.isSuccess {
            if let data = response.result.value {
                self.returnResponse(record: record,
                                    response: response,
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
            let code = response.response?.statusCode ?? -1
            let msg = error.localizedDescription
            xWarning("响应失败，进行兼容操作: code = \(code), \(msg)")
            // 尝试捕获响应失败后的数据
            if self.tryCatchResponseError(code: code, data: response.data) == false {
                self.logResponseError(record: record,
                                      response: response)
                failure("❎ \(error.localizedDescription)")
                return
            }
        }
        // 捕获失败，最终处理
        guard let data = response.data, data.count > 0 else {
            self.logDataError(record: record,
                              isReqSuccess: false,
                              response: response)
            failure("接口返回的Data解析出错")
            return
        }
        // 排查不出错误，而且数据解析成功，当成功处理
        self.returnResponse(record: record,
                            response: response,
                            data: data,
                            success: success,
                            failure: failure)
    }
    
    // MARK: - 响应数据处理
    /// 响应数据处理
    public static func returnResponse(record : xAPIRecord,
                                      response : DataResponse<Any>,
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
        // 解析失败
        self.logDataError(record: record,
                          isReqSuccess: false,
                          response: response)
        failure("数据解析失败")
    }
    
}
