
import UIKit

class ApiResponseModel: NSObject
{
    static let sharedInstance = ApiResponseModel()
    
    var Status: Int!
    var Message: String!
    var list: NSArray!
    var Count: Int!
    
    func getSuccessApiModel (dict: NSDictionary) -> ApiResponseModel
    {
        let apiResponseObj = ApiResponseModel()
        
        if let status = dict.value(forKey: "Status") as? Int
        {
            apiResponseObj.Status = status
        }
        else
        {
            apiResponseObj.Status = SERVER_ERROR_CODE
        }
        
        if let count = dict.value(forKey: "Count") as? Int
        {
            apiResponseObj.Count = count
        }
        else
        {
            apiResponseObj.Count = 0
        }
        
        if let message = dict.value(forKey: "Message") as? String
        {
            apiResponseObj.Message = message
        }
        else
        {
            apiResponseObj.Message = ""
        }
        
        if let list = dict.value(forKey: "list") as? NSArray
        {
            apiResponseObj.list = list
        }
        else
        {
            apiResponseObj.list = []
        }
        
        return apiResponseObj
    }
    
    func getFailureApiModel() -> ApiResponseModel
    {
        let apiResponseObj = ApiResponseModel()
        
        apiResponseObj.Status = SERVER_ERROR_CODE
        apiResponseObj.Count = 0
        apiResponseObj.list = []
        apiResponseObj.Message = ""
        
        return apiResponseObj
    }
    
    func getNoInternetApiModel() -> ApiResponseModel
    {
        let apiResponseObj = ApiResponseModel()
        
        apiResponseObj.Status = NO_INTERNET_ERROR_CODE
        apiResponseObj.Count = 0
        apiResponseObj.list = []
        apiResponseObj.Message = serverSideError
        
        return apiResponseObj
    }
}
