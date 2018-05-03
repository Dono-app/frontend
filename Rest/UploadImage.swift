import Foundation
import UIKit

class UploadImage {
    
    let sendi = SendImageInfo()
    var address : String = ""
    var images = [Image]()
    var card: Card?
    var card1: Card?
    public var fetchedCards = [Card]()
    public var categoryCards = [Card]()
    var jsons = [[String:Any]]()
    func upload(image: UIImage, listingName:String, category:String, condition: Int, location:String, contact:String) {
        var conditionToString = String(condition)
        let url = URL(string: "http://localhost:8080/build/webresources/upload")
        var request = URLRequest(url: url!)
        var imageAddress = randomString(len: 15)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("text/plain", forHTTPHeaderField: "Accept")
        
        let imgData = UIImagePNGRepresentation(image)
        
        let encodedImg = imgData?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: NSData.Base64EncodingOptions.RawValue(0)))
        
        let jsonContent = ["imageName": imageAddress, "img": encodedImg!, "categoryId": category, "listingName": listingName, "userId": "1", "image": "imgName", "location": location, "rating": conditionToString, "email": contact, "description": "hienot setit"]

        try? request.httpBody = JSONSerialization.data(withJSONObject: jsonContent, options: JSONSerialization.WritingOptions(rawValue: 0))
        
        let task = URLSession.shared.uploadTask(with: request, from: request.httpBody!) { data, response, error in
            if let error = error {
                print ("uploadi-error: \(error)")
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print ("uploadi-response: \(response.statusCode)")
            }
            
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                    print ("uploadi-server error")
                    return
            }
            
            if let data = data,
                let dataString = String(data: data, encoding: .utf8) {
                self.sendi.imgName = dataString
            }
        }
        task.resume()
    }
    
    func getAllImages(){
        guard  let url = URL(string: "http://localhost:8080/build/webresources/images") else {
            fatalError("ImageService: Failed to create URL: getAllImages")
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("ImageService: Client error: \(error)")
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    print("ImageService: Server error: getAllImages")
                    return
            }
            
            if let data = data {
                self.parseImageFromJson(jsonFile: data)
                DispatchQueue.main.async {
                    //self.notifyObservers()
                }
            }
        }
        task.resume()
    }
    func parseImageFromJson(jsonFile: Data){
        guard let json = try? JSONSerialization.jsonObject(with: jsonFile, options: []) as! [[String:Any]] else {
            fatalError("ImageService: Failed to parse json: Image")
        }
        self.jsons = json
        
        if !json.isEmpty{
            images.removeAll()
            for image in json {
                guard let name = image["imageName"] as? String,
                    let img = image["img"] as? String,
                    let categoryName = image["categoryId"] as? String,
                    let listingName = image["listingName"] as? String,
                    let rating = image["rating"] as? String,
                    let contact = image["email"] as? String,
                    let location = image["location"] as? String,
                    var ratingToInt = Int(rating)
                else{
                    fatalError("ImageService: Json error: name, img, catName")
                }
                
                let newImage = Image(categoryName: categoryName, imgInBase64: img, imageName: name)
                self.images.append(newImage)
                let photo = Image.convertBase64ToImage(imgString: img)
 
                card = Card(name: listingName, categoryId: categoryName, photo: photo, rating: ratingToInt, location: location, contact: contact)
                fetchedCards.append(card!)
            }
        }
    }
    func paskea(catNo : String) {
            for card in fetchedCards{
                if card.categoryId == catNo {
                        let name = card.name
                        let photo = card.photo
                        let rating = card.rating
                        let location = card.location
                        let contact = card.contact

                        card1 = Card(name: name, categoryId: catNo, photo: photo, rating: rating, location: location, contact: contact)
                        categoryCards.append(card1!)
                    }
            }
    }
  
    func randomString(len:Int) -> String {
        let charSet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var c = Array(charSet)
        var s:String = ""
        for n in (1...10) {
            s.append(c[Int(arc4random()) % c.count])
        }
        return s
    }
    
}


