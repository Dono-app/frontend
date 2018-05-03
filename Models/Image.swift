import UIKit

class Image {
    //MARk: Properties
    var imageName: String
    var img: UIImage
    var categoryName: String
    
    //MARK: Initializer
    init(categoryName: String, img: UIImage){
        self.categoryName = categoryName
        
        //Set current timestamp as name
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        let result = formatter.string(from: date)
        
        self.imageName = result
        self.img = img
    }
    
    init(categoryName: String, imgInBase64: String, imageName: String){
        self.categoryName = categoryName
        self.imageName = imageName
        self.img = Image.convertBase64ToImage(imgString: imgInBase64)
    }
    
    //MARK: Private Methods
    //Convert String to Base64
    static func convertImageToBase64(img: UIImage) -> String {
        let imgData = UIImagePNGRepresentation(img)
        guard let base64String = imgData?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: NSData.Base64EncodingOptions.RawValue(0))) else{
            fatalError("Image model:Unable to encode")
        }
        return base64String
    }
    
    //Convert Base64 to String
    static func convertBase64ToImage(imgString: String) -> UIImage {
        let imgData = Data(base64Encoded: imgString, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!
        return UIImage(data: imgData)!
    }
}
