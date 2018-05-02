import Foundation

class SendImageInfo {
    
     let url = URL(string: "http://localhost:8080/lasikala1testi-war/webresources/listing")
    
    func sendImageJson(name:String, location:String, contact:String) {
       
        var request = URLRequest(url: url!)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("text/plain", forHTTPHeaderField: "Accept")
        
        let jasoni: [String: Any] = ["listingName": name, "userId": "1", "listingId": "2", "image": "imagenosoite", "categoryId": "3", "location": location, "rating": "3", "email": contact, "tel": "puhelinnumero05040", "description": "hienot setit"]
        
        
        
        try? request.httpBody = JSONSerialization.data(withJSONObject: jasoni, options: JSONSerialization.WritingOptions(rawValue: 0))
        
        let task = URLSession.shared.uploadTask(with: request, from: request.httpBody) { data, response, error in
            if let error = error {
                print ("error: \(error)")
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print ("response error \(response.statusCode)")
            }
            
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                    print ("server error")
                    return
            }
            
            if let data = data,
                let dataString = String(data: data, encoding: .utf8) {
                print ("got data: \(dataString)")
            }
        }
        task.resume()
    }
    
    var returnings: String = ""
    
    func getJSON() -> String {
        
        let serverUrl = URL(string:"http://localhost:8080/lasikala1testi-war/webresources/listing")!
        
        let task = URLSession.shared.dataTask(with: serverUrl) {data, response, error in
            
            if let error = error {
                print("errori \(error)")
            }
            guard let httpResponse  = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    return
            }
            if let data = data, let string = String(data: data, encoding: .utf8) {
                //print("data \(data) string: \(string)")
                
                
                
               var jsoni = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                print(jsoni)
              //  let imagePath = jsoni["image"]

                
                //print(imagePath)
                
                
                
                
                
                self.returnings = string
                DispatchQueue.main.async {
                    
                }
            }
            
        }
        task.resume()
        return returnings
    }
    
    
    
}


