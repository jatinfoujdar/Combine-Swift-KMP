import Foundation

class ApiFoundation: NSObject {
   let baseUrl = "https://api.restful-api.dev"
    let sourcePath = "/objects"
    
    private var sourceUrl: URL {
        return URL(string: baseUrl + sourcePath)!
    }
    
    func fetchDeviceDetail(){
        
    }
}
