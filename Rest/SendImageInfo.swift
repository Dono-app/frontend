import Foundation
import UIKit

class SendImageInfo {
    
    let url = URL(string: "http://localhost:8080/build/webresources/listing")
    let CTVC = CardTableViewCell()
    var catId = ""
    var jsons = [[String:Any]]()
    var imgName:String = ""
    var card: Card?
    public var categoryCards = [Card]()
    func sendImageJson(name:String, location:String, contact:String) {
        
        var request = URLRequest(url: url!)
        
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("text/plain", forHTTPHeaderField: "Accept")
        
        
        let jasoni: [String: Any] = ["listingName": name, "userId": "1", "listingId": "2", "image": imgName, "categoryId": "1", "location": location, "rating": "3", "email": contact, "tel": "puhelinnumero05040", "description": "description"]
        
        
        
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
            }
        }
        task.resume()
    }
    
    var returnings: String = ""
    
    func getJSON() -> String {
        
        let serverUrl = URL(string:"http://localhost:8080/build/webresources/listing")!
        
        let task = URLSession.shared.dataTask(with: serverUrl) {data, response, error in
            
            if let error = error {
                print("errori \(error)")
            }
            guard let httpResponse  = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    return
            }
            if let data = data, let string = String(data: data, encoding: .utf8) {
                
                guard let jsoni = try? JSONSerialization.jsonObject(with: data, options: []) as! [[String:Any]] else {
                    fatalError("CategoryService: Failed to parse Category JSON")
                }
                
                self.jsons = jsoni
                for images in jsoni {
                    self.catId = (images["categoryId"] as? String)!
                    //print("se ottaa sen tietyn: ", self.catId)
                    
                }
                
                //print("kissa " , self.returnings)
                DispatchQueue.main.async {
                    
                }
            }
            self.returnings = self.catId
            
        }
        task.resume()
        return self.returnings
    }
}



