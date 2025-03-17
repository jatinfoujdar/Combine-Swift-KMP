import Foundation

class ApiFoundation: NSObject {
    let baseUrl = "https://api.restful-api.dev"
    let sourcePath = "/objects"
    
    private var sourceUrl: URL {
        return URL(string: baseUrl + sourcePath)!
    }
    
    func fetchDeviceDetail(completion: @escaping (Result<[DeviceData], Error>) ->()){
        let urlRequest = URLRequest(url: sourceUrl)
        
        URLSession.shared.dataTask(with: urlRequest){(data, urlResponse, error ) in
            
            if let error = error{
                print("Network error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            if let httpResponse = urlResponse as? HTTPURLResponse, httpResponse.statusCode != 200{
                let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Received invalid response from server"])
                completion(.failure(error))
                return
            }
            
            guard let data = data else{
                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(error))
                return
            }
            do{
                let jsonDecoder = JSONDecoder()
                let deviceData = try jsonDecoder.decode([DeviceData].self, from: data)
                DispatchQueue.main.async{
                    completion(.success(deviceData))
                }
            }
            catch{
                print("Decoding error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
