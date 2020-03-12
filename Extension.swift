//
//  Extension.swift
//  MovieApp_Ritesh
//
//  Created by Susheel on 09/09/19.
//  Copyright © 2019 openxcell. All rights reserved.
//

import UIKit
import AVKit
import Alamofire
import Foundation
import SwiftyJSON
import NVActivityIndicatorView
import Kingfisher

typealias ServiceResponse = (JSON, Error?) -> Void

// AppDelegate Shared Instance
var appDelegate: AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
}

// Check Network Rechable
var isReachable: Bool {
    return NetworkReachabilityManager()!.isReachable
}

/// App's name (if applicable).
public var appDisplayName: String? {
    // http://stackoverflow.com/questions/28254377/get-app-name-in-swift
    return Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
}

/// Link of current app in appstore
public var appStoreLink: String {
    return "https://itunes.apple.com/us/app/app-name/id1302095954?ls=1&mt=8"
}

/// Shared instance of current device.
public var currentDevice: UIDevice {
    return UIDevice.current
}

// Current orientation of device.
public var deviceOrientation: UIDeviceOrientation {
    return currentDevice.orientation
}

/// Screen width.
public var screenWidth: CGFloat {
    return UIScreen.main.bounds.width
}

/// Screen height.
public var screenHeight: CGFloat {
    return UIScreen.main.bounds.height
}

/// App's bundle ID (if applicable).
public var appBundleID: String? {
    return Bundle.main.bundleIdentifier
}

/// Application icon badge current number.
public var applicationIconBadgeNumber: Int {
    get {
        return UIApplication.shared.applicationIconBadgeNumber
    }
    set {
        UIApplication.shared.applicationIconBadgeNumber = newValue
    }
}

/// App's current version (if applicable).
public var appVersion: String {
    return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
}

/// Check if device is iPad.
public var isPad: Bool {
    return UIDevice.current.userInterfaceIdiom == .pad
}

/// Check if device is iPhone.
public var isPhone: Bool {
    return UIDevice.current.userInterfaceIdiom == .phone
}

/// Check if application is running on simulator (read-only).
public var isRunningOnSimulator: Bool {
    #if targetEnvironment(simulator)
    return true
    #else
    return false
    #endif
}

///Document directory
public var doumentDirectory:String {
    return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
}


/// Shared instance UIApplication.
public var sharedApplication: UIApplication {
    return UIApplication.shared
}

func callNumber(phoneNumber:String) {
    if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
        if (sharedApplication.canOpenURL(phoneCallURL)) {
            sharedApplication.open(phoneCallURL, options: [:], completionHandler: nil)
        }
    }
}

// Get Latitude
var token:String {
    return UserDefaults.standard.value(forKey: "token") as? String ?? ""
}

// Return TimeZone
var timezone: String {
    return TimeZone.current.identifier
}

// User Default
var userPref: UserDefaults {
    return UserDefaults.standard
}

var mainStoryboard: UIStoryboard {
    return UIStoryboard(name: "Main", bundle: nil)
}

func getWidth(_ text: String, _ fontSize: CGFloat) -> CGFloat {
    
    let label = UILabel()
    label.numberOfLines = 0
    label.font = UIFont(name: "Roboto-BoldCondensed", size: fontSize)
    label.text = text
    label.sizeToFit()
    return label.frame.size.width
}

func getHeight(_ text: String, _ font: UIFont = UIFont(name: "Futura-Medium", size: 16)!) -> CGFloat {
    let label = UILabel(frame: CGRect(x: 15, y: 0, width: screenWidth - 45, height: .greatestFiniteMagnitude))
    label.font = font
    label.text = text
    label.lineBreakMode = .byWordWrapping
    label.numberOfLines = 0
    label.sizeToFit()
    return ceil(label.frame.size.height)
}

// Definition:
extension Notification.Name {
    static let homePostNotification = Notification.Name("HomeReferesh")
    static let buyPostNotification = Notification.Name("BuyReferesh")
}

extension Date {
    func today() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: Calendar.current.startOfDay(for: self)))!
    }
    
    /// Convert Date To String
    public func toString(formates formate: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formate
        return dateFormatter.string(from: self)
    }
}

// Return LoggedIn userId
var isLoggedIn: Bool {
    return userPref.object(forKey: "UserInfo") != nil
}

public func Log<T>(_ object: T?, filename: String = #file, line: Int = #line, funcname: String = #function) {
    #if DEBUG
    guard let object = object else { return }
    print("***** \(Date()) \(filename.components(separatedBy: "/").last ?? "") (line: \(line)) :: \(funcname) :: \(object)")
    #endif
}

extension UIViewController: NVActivityIndicatorViewable /*,MFMailComposeViewControllerDelegate */ {
    
    //MARK:- Send Email
 /*   func sendEmail(_ subject:String,_ email:String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([email])
            mail.setSubject(subject)
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    } */
    
    func removeAllDeliverNotification() {
        UIApplication.shared.applicationIconBadgeNumber = 1
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    // Go Back Action
    @IBAction func goBack(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func showMenu(_ sender: UIButton) {
        let sidemenu = mainStoryboard.instantiateViewController(withIdentifier: "LeftMenuNavigationController")
        self.navigationController?.present(sidemenu, animated: true)
    }
    
    // Return AuthToken
    func getToken() -> String {
        let authToken = UserDefaults.standard.object(forKey: "token")
        return (authToken == nil ? "" : authToken as! String)
    }
    
    // Return DeviceToken
    func getDeviceToken() -> String {
        let deviceToken = UserDefaults.standard.object(forKey: "DeviceToken")
        return (deviceToken == nil ? "" : deviceToken as! String)
    }
    
    func showAlert(message: String){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.self.present(alert, animated: true, completion: nil)
    }
    
    // Showing Toast Message
   /* func showTostMessage(message: String, isSuccess:Bool = false) {
        self.view.endEditing(true)
        if message != "" {
            ToastView.appearance().backgroundColor = isSuccess ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0.8588235294, green: 0.3137254902, blue: 0.2901960784, alpha: 1)
            ToastView.appearance().textColor = isSuccess ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            ToastView.appearance().font = UIFont.init(name: "SFProText-Regular", size: 17.0)
            DispatchQueue.main.async {
                Toast(text: message).show()
            }
            print("Working")
        }
    } */
    
    func showConfirmation(title:String = "App Name",message:String,compleion:(() -> Void)?) {
        if message != "" {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "YES", style: .default, handler: { (alert) in
                guard compleion != nil else {
                    return
                }
                compleion!()
            }))
            alertController.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func randomString() -> String {
        let len: Int = 3
        let needle : NSString = "0123456789"
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for _ in 0..<len {
            let length = UInt32 (needle.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", needle.character(at: Int(rand)))
        }
        return randomString as String
    }
    
    // Show LoadingView When API is called
    func showLoading(_ color: UIColor = #colorLiteral(red: 0.163174212, green: 0.2325206101, blue: 0.3331266046, alpha: 1)) {
        let size = CGSize(width: 40, height:40)
        startAnimating(size, message: nil, type: .ballClipRotate, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0))
    }
    
    // Hide LoadingView
    func hideLoading() {
        stopAnimating()
    }
    
    func hideKeyboard() {
        DispatchQueue.main.async {
            self.view.endEditing(true)
        }
    }
    
    // Listing of All Font Installed/Supported by System
    func fontName() {
        for family in UIFont.familyNames {
            print("\(family)")
            
            for name in UIFont.fontNames(forFamilyName: family) {
                print("   \(name)")
            }
        }
    }
    
    // Give Alpha Animation to the Selected View
    func setAlphaAnimation(selectedView: UIView, alpha: CGFloat) {
        if alpha == 1 {
            selectedView.isHidden = false
        }
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            selectedView.alpha = alpha
        }) {
            (complete) -> Void in
            if alpha == 0 {
                selectedView.isHidden = true
            }
        }
    }
    
    /// Check if device is registered for remote notifications for current app (read-only).
    public static var isRegisteredForRemoteNotifications: Bool {
        return UIApplication.shared.isRegisteredForRemoteNotifications
    }
    
    // Check Location is Allowed or Not
  /*  func isAllowLocation() -> Bool {
        switch(CLLocationManager.authorizationStatus()) {
        case .notDetermined, .restricted, .denied:
            return false
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        }
    } */
    
    //MARK: - WebService Call
    func webServiceCall(_ url: String, param:[String:Any] = [String: Any](), isWithLoading: Bool = true, loaderColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), imageKey: [String] = ["image"], imageData: [Data] = [],imageName:[String] = [], videoKey: [String] = ["video"], videoData: [Data] = [Data](), audioKey: [String] = ["audio"], audioData: [Data] = [Data](), isNeedToken: Bool = false, methods: HTTPMethod = .post, completionHandler:@escaping ServiceResponse) {
        
        print("URL :- \(url)")
        print("Parameter :- \(param)")
        
        self.view.endEditing(true)
        
        if isReachable {
            
            if isWithLoading {
                showLoading(loaderColor)
            }
            
            var headers = HTTPHeaders()
            /* headers = [
             "Content-Type": "application/json"
             ] */
            
            if isNeedToken {
                    headers["Authorization"] = "Bearer \(token)"
            }
            
            print("HTTPHeaders :- \(headers) ")
            
            if imageData.count > 0 || videoData.count > 0 || audioData.count > 0 {
                
                Alamofire.upload (
                    multipartFormData: { multipartFormData in
                        
                        for (key, value) in param {
                            multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                        }
                        
                        for i in 0..<imageData.count {
                            if imageData[i].count > 0 {
                                let fileName = imageName.count > i ? imageName[i]:"file[\(i)]"
                                multipartFormData.append(imageData[i], withName: imageKey[i], fileName: "\(fileName).jpg", mimeType: "image/jpeg")
                            }
                        }
                        
                        for i in 0..<videoData.count {
                            if videoData[i].count > 0 {
                                multipartFormData.append(videoData[i], withName: videoKey[i], fileName: "file.mp4", mimeType: "video/mp4")
                            }
                        }
                        
                        for i in 0..<audioData.count {
                            if audioData[i].count > 0 {
                                multipartFormData.append(audioData[i], withName: audioKey[i], fileName: "file.m4a", mimeType: "audio/m4a")
                            }
                        }
                },
                    to: url,
                    headers : headers,
                    encodingCompletion: { encodingResult in
                        switch encodingResult {
                        case .success(let upload, _, _):
                            upload.responseJSON { result in
                                
                                /*
                                 print(result)
                                 print(result.result)
                                 */
                                
                                if let httpError = result.result.error {
                                    
                                    print(NSString(data: result.data!, encoding: String.Encoding.utf8.rawValue)!)
                                    print(httpError._code)
                                    
                                    let response: [String: Any] = [
                                        "errorCode": httpError._code,
                                        "status": false,
                                        "message": ValidationMessage.somethingwrong
                                    ]
                                    
                                    let json = JSON(response)
                                    completionHandler(json, nil)
                                    
                                    print("JSON: - \(json)")
                                }
                                
                                if  result.result.isSuccess {
                                    if let response = result.result.value {
                                        let json = JSON(response)
                                        completionHandler(json, nil)
                                        print("JSON: - \(json)")
                                    }
                                }
                                
                                if isWithLoading {
                                    self.hideLoading()
                                }
                            }
                        case .failure(let encodingError):
                            print(encodingError)
                        }
                })
            }
            else
            {
                Alamofire.request(url, method: methods ,parameters: param,headers: headers)
                    .responseJSON {  result in
                        
                        /*
                         print(result)
                         print(result.result)
                         */
                        
                        if let httpError = result.result.error {
                            print(NSString(data: result.data!, encoding: String.Encoding.utf8.rawValue)!)
                            print(httpError._code)
                            
                            let response: [String: Any] = [
                                "errorCode": httpError._code,
                                "status": false,
                                "message": ValidationMessage.somethingwrong
                            ]
                            
                            let json = JSON(response)
                            completionHandler(json, nil)
                            
                            print("JSON: - \(json)")
                        }
                        
                        if  result.result.isSuccess {
                            if let response = result.result.value {
                                let json = JSON(response)
                                completionHandler(json, nil)
                                print("JSON: - \(json)")
                            }
                        }
                        
                        if isWithLoading {
                            self.hideLoading()
                        }
                }
            }
        }
        else {
            let response: [String: Any] = [
                "errorCode": "",
                "status": false,
                "message": ValidationMessage.internetUnavailable
            ]
            
            let json = JSON(response)
            completionHandler(json, nil)
        }
    }
    
    func webServiceRawDataCall(_ url: String, parameter:[String:Any] = [String: Any](),headers : HTTPHeaders = HTTPHeaders(), isWithLoading: Bool = true, imageKey: [String] = ["image"], imageData: [Data] = [Data](), videoKey: [String] = ["video"], videoData: [Data] = [Data](), audioKey: [String] = ["audio"], audioData: [Data] = [Data](), isNeedToken: Bool = true, methods: HTTPMethod = .post, completionHandler:@escaping ServiceResponse) {
        
        let param = parameter
        //let paramArray : [String] = []
        
        print("URL :- \(url)")
        print("Parameter :- \(param)")
        print("Headers :- \(headers)")
        
        hideKeyboard()
        
        if isReachable {
            
            if isWithLoading {
                showLoading()
            }
            
            var headers = HTTPHeaders()
            /* headers = [
             "Content-Type": "application/json"
             ] */
            
            if isNeedToken {
                headers["Authorization"] = "Bearer \(token)" //(UserDefaults.standard.value(forKey: "access_token")!)"
            }
            
            print("HTTPHeaders :- \(headers) ")
            
            var request = URLRequest(url: URL(string: url)!)
            request.httpMethod = HTTPMethod.post.rawValue
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            let jsonData = try? JSONSerialization.data(withJSONObject:param, options: .prettyPrinted)
            let json = NSString(data: jsonData!, encoding: String.Encoding.utf8.rawValue)
            if let json = json {
                print(json)
            }
            request.httpBody =  jsonData//json!.data(using: String.Encoding.utf8.rawValue)
            
            SessionManager.default.session.configuration.timeoutIntervalForRequest = 120
            //Alamofire.sharedInstance.session.configuration.timeoutIntervalForRequest = 120
            Alamofire.request(request)//(url, method: methods, parameters: param, encoding: JSONEncoding.default, headers: headers)
                .responseJSON {  result in
                    
                    /*
                     print(result)
                     print(result.result)
                     */
                    if isWithLoading {
                        self.hideLoading()
                    }
                    
                    if let httpError = result.result.error {
                        print(NSString(data: result.data!, encoding: String.Encoding.utf8.rawValue)!)
                        print(httpError._code)
                        
                        let response: [String: Any] = [
                            "errorCode": httpError._code,
                            "status": false,
                            "error_description": ValidationMessage.somethingwrong
                        ]
                        
                        let json = JSON(response)
                        completionHandler(json, nil)
                        
                        //print("JSON: - \(json)")
                    }else if  result.result.isSuccess {
                        
                        if let response = result.result.value {
                            let json = JSON(response)
                            completionHandler(json, nil)
                            
                            //print("JSON: - \(json)")
                        }
                    }
            }
        }
    }
}

extension UITextView {
    func padding() {
        self.contentInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
}

extension UITextField {
    
    func padding(width:Int = 12) {
        let padding = UIView(frame: CGRect(x: 0, y: 5, width: 12, height: 12))
        self.rightView = padding
        self.rightViewMode = UITextField.ViewMode.always
        self.leftView = padding
        self.leftViewMode = UITextField.ViewMode.always
    }
    
    func setPlaceHolderTextColor(_ color: UIColor) {
        self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: color])
    }
    
    func placeholder(text value: String, color: UIColor = .red) {
        self.attributedPlaceholder = NSAttributedString(string: value, attributes: [ NSAttributedString.Key.foregroundColor : color])
    }
}

extension UISearchBar {
    
    var textField: UITextField? {
        return value(forKey: "searchField") as? UITextField
    }
    
    func setSearchIcon(image: UIImage) {
        setImage(image, for: .search, state: .normal)
    }
    
    func setClearIcon(image: UIImage) {
        setImage(image, for: .clear, state: .normal)
    }
}

extension UIColor {
    
    func toImage(size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        let rect:CGRect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
        self.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image! // was image
    }
    
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}

extension UILabel {
    var isTruncated: Bool {
        
        guard let labelText = text else {
            return false
        }
        
        let labelTextSize = (labelText as NSString).boundingRect(
            with: CGSize(width: frame.size.width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font],
            context: nil).size
        
        return labelTextSize.height > bounds.size.height
    }
    
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
    
    
    func indexOfAttributedTextCharacterAtPoint(point: CGPoint) -> Int {
        let textStorage = NSTextStorage(attributedString: self.attributedText!)
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer(size: self.frame.size)
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = self.numberOfLines
        textContainer.lineBreakMode = self.lineBreakMode
        layoutManager.addTextContainer(textContainer)
        let index = layoutManager.characterIndex(for: point, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return index
    }
    
    func getHeight(width:CGFloat) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = self.font
        label.text = text
        label.attributedText = attributedText
        label.sizeToFit()
        return label.frame.height
    }
}

extension Float {
    
    func makeCommaSeprator() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSize = 3
        return formatter.string(from: NSNumber(value: self)) ?? ""//NumberFormatter.localizedString(from: NSNumber(value: self), number: .decimal)
    }
    
    func makeAroundPointFifty() -> Float {
        var amount = Float(Int(self))
        if self > amount {
            let valueAbove = self - amount
            if valueAbove == 0.5 {
                return self
            } else if valueAbove > 0.5 {
                amount += 1
            } else {
                amount += 0.50
            }
        }
        return amount
    }
    
    func makeAroundPointFiftyLess() -> Float {
        var amount = Float(Int(self))
        if self > amount {
            let valueAbove = self - amount
            if valueAbove == 0.5 {
                return self
            } else if valueAbove > 0.5 {
                amount += 0.5
            }
        }
        return amount
    }
}

extension String {
    func containsOnlyDigits() -> Bool {
        let notDigits = NSCharacterSet.decimalDigits.inverted
        if rangeOfCharacter(from: notDigits, options: String.CompareOptions.literal, range: nil) == nil {
            return true
        }
        return false
    }
    
    // Check for Password Validation
    func isValidPassword() -> Bool {
        let passwordRegEx = "^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$&*]).{8,}$"
        let passwordValid = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        if passwordValid.evaluate(with: self) {
            return true
        }
        return false
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func isValidCapitalPassword() -> Bool {
        let passwordRegEx = ".*[A-Z]+.*"
        
        let passwordValid = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordValid.evaluate(with: self)
    }
    
    func isValidLowerPassword() -> Bool {
        let passwordRegEx = ".*[A-Z]+.*"
        
        let passwordValid = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordValid.evaluate(with: self)
    }
    
    func isValidNumberPassword() -> Bool {
        let passwordRegEx = ".*[0-9]+.*"
        
        let passwordValid = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordValid.evaluate(with: self)
    }
    
    func isValidSpecialCharPassword() -> Bool {
        let passwordRegEx = ".*[!&^%$#@()/]+.*"
        
        let passwordValid = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordValid.evaluate(with: self)
    }
    
    // Check for Valid Email Address
    func isValidEmail() -> Bool {
        let emailRegEx = "^[_A-Za-z0-9-]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self.trimming())
    }
    
    // Check for String is Empty
    func isEmpty() -> Bool {
        return self.trimming().isEmpty
    }
    
    // Return the string after trimming
    func trimming() -> String {
        let strText = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return strText
    }
    
    func toDate(_ format:String = "yyyy-MM-dd") -> Date {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.date(from: self) ?? Date()
    }
    
    var encodeEmoji: String? {
        let encodedStr = NSString(cString: self.cString(using: String.Encoding.nonLossyASCII)!, encoding: String.Encoding.utf8.rawValue)
        return encodedStr as String?
    }
    
    var decodeEmoji: String {
        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
        if data != nil {
            let valueUniCode = NSString(data: data!, encoding: String.Encoding.nonLossyASCII.rawValue) as String?
            if valueUniCode != nil {
                return valueUniCode!
            } else {
                return self
            }
        } else {
            return self
        }
    }
    
    func convertTimeStampToDate() -> Date {
        let jsonDate = "/Date(\(self))/"
        let prefix = "/Date("
        let suffix = ")/"
        let scanner = Scanner(string: jsonDate)
        
        // Check prefix:
        guard scanner.scanString(prefix, into: nil)  else { return Date() }
        
        // Read milliseconds part:
        var milliseconds : Int64 = 0
        guard scanner.scanInt64(&milliseconds) else { return Date() }
        // Milliseconds to seconds:
        var timeStamp = TimeInterval(milliseconds)/1000.0
        
        // Read optional timezone part:
        var timeZoneOffset : Int = 0
        if scanner.scanInt(&timeZoneOffset) {
            let hours = timeZoneOffset / 100
            let minutes = timeZoneOffset % 100
            // Adjust timestamp according to timezone:
            timeStamp += TimeInterval(3600 * hours + 60 * minutes)
        }
        
        // Check suffix:
        guard scanner.scanString(suffix, into: nil) else { return Date() }
        
        // Success! Create NSDate and return.
        return Date(timeIntervalSince1970: timeStamp)
    }
    
}

extension UITableView {
    // Set Text when no any Data found for TableView
    func setTextForBlankTableview(message : String, color: UIColor = #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1),font:String = "Futura-Medium") -> Void {
        let viewBg = UIView(frame: self.frame)
        let messageLabel: UILabel = UILabel(frame: CGRect(x: 17, y: 0, width: self.frame.size.width-34, height: self.frame.size.height))
        messageLabel.text = message
        messageLabel.textColor = color
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.init(name: font, size: 17.0)
        viewBg.addSubview(messageLabel)
        self.backgroundView = viewBg
    }
    
    func setTextForBlankTableFooter(message : String, color: UIColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1),height:CGFloat = 50) -> Void {
        let messageLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: height))
        messageLabel.text = message
        messageLabel.textColor = color
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.init(name: "Futura-Medium", size: 17.0)
        self.tableFooterView = messageLabel
    }
    
    // Set Loader in FooterView When pagination is enable
    func makeFooterView(color: UIColor = #colorLiteral(red: 0.1098039216, green: 0.8078431373, blue: 0.8078431373, alpha: 1)) {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        let act = NVActivityIndicatorView(frame: CGRect(x: UIScreen.main.bounds.width / 2 - 15, y: 10, width: 30, height: 30))
        act.color = color
        act.type = .ballClipRotate
        view.addSubview(act)
        act.startAnimating()
        self.tableFooterView = view
    }
    
    func makeHeaderView(color: UIColor = #colorLiteral(red: 0.1098039216, green: 0.8078431373, blue: 0.8078431373, alpha: 1)) {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        let act = NVActivityIndicatorView(frame: CGRect(x: UIScreen.main.bounds.width / 2 - 15, y: 10, width: 30, height: 30))
        act.color = color
        act.type = .ballClipRotate
        view.addSubview(act)
        act.startAnimating()
        self.tableHeaderView = view
    }
    
    // Remove Footer View From Tableview
    func removeFooterView() {
        self.tableFooterView = UITableViewHeaderFooterView.init()
    }
    
    func removeHeaderView() {
        self.tableHeaderView = UITableViewHeaderFooterView.init()
    }
    
    // Add Pull to Refresh
    func addPullToRefresh(color: UIColor = #colorLiteral(red: 0.137254902, green: 0.6705882353, blue: 0.6431372549, alpha: 1)) -> UIRefreshControl {
        let view = UIRefreshControl()
        view.tintColor = color
        self.addSubview(view)
        return view
    }
    
    func extraOperation(_ msg : String? = "NO RECORD(S) FOUND",_ count:Int,_ isWhiteColor: Bool = false) {
        removeFooterView()
        if count == 0 {
            if isWhiteColor {
                setTextForBlankTableview(message: msg!,color: UIColor.white)
            } else {
                setTextForBlankTableview(message: msg!)
            }
        } else {
            backgroundView = nil
        }
        reloadData()
    }
    
    func extraMessageOperation(_ count:Int) {
        removeFooterView()
        if count == 0 {
            setTextForBlankTableview(message: "NO RECORD FOUND")
        } else {
            backgroundView = nil
        }
        reloadData()
    }
}

extension UIImageView {
    
    // Download image and set into given imageview
    func setImage(image:String) {
        if image != "" {
//            let url = URL(string: "\(BasePath.ImagePath)\(image)")
            let url = URL(string: image)
            self.image = nil
            self.kf.indicatorType = .activity
            self.kf.setImage(with: url,placeholder: UIImage(named: "PlaceHolderImage"))
        } else {
            self.image = UIImage(named: "PlaceHolderImage")
        }
    }
}

extension UICollectionView {
    func setTextForBlankCollectionView(message : String, color: UIColor = #colorLiteral(red: 0.1529411765, green: 0.2588235294, blue: 0.3529411765, alpha: 1)) -> Void {
        let messageLabel: UILabel = UILabel(frame: CGRect(x: 17, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        messageLabel.text = message
        messageLabel.textColor = color
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.init(name: "Futura-Medium", size: 17.0)
        messageLabel.sizeToFit()
        self.backgroundView = messageLabel
    }
}

extension UIImage {
    
    // Rotate Image by given Degree
    public func imageRotatedByDegrees(degrees: CGFloat) -> UIImage {
        //Calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let t: CGAffineTransform = CGAffineTransform(rotationAngle: degrees * CGFloat.pi / 180)
        rotatedViewBox.transform = t
        let rotatedSize: CGSize = rotatedViewBox.frame.size
        //Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
        //Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        //Rotate the image context
        bitmap.rotate(by: (degrees * CGFloat.pi / 180))
        //Now, draw the rotated/scaled image into the context
        bitmap.scaleBy(x: 1.0, y: -1.0)
        bitmap.draw(self.cgImage!, in: CGRect(x: -self.size.width / 2, y: -self.size.height / 2, width: self.size.width, height: self.size.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    // Fix Orentation of Given Image
    func fixOrientation() -> UIImage {
        // No-op if the orientation is already correct
        if ( self.imageOrientation == UIImage.Orientation.up ) {
            return self;
        }
        
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        if ( self.imageOrientation == UIImage.Orientation.down || self.imageOrientation == UIImage.Orientation.downMirrored ) {
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        }
        
        if ( self.imageOrientation == UIImage.Orientation.left || self.imageOrientation == UIImage.Orientation.leftMirrored ) {
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2.0))
        }
        
        if ( self.imageOrientation == UIImage.Orientation.right || self.imageOrientation == UIImage.Orientation.rightMirrored ) {
            transform = transform.translatedBy(x: 0, y: self.size.height);
            transform = transform.rotated(by: CGFloat(-Double.pi / 2.0));
        }
        
        if ( self.imageOrientation == UIImage.Orientation.upMirrored || self.imageOrientation == UIImage.Orientation.downMirrored ) {
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        }
        
        if ( self.imageOrientation == UIImage.Orientation.leftMirrored || self.imageOrientation == UIImage.Orientation.rightMirrored ) {
            transform = transform.translatedBy(x: self.size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1);
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let ctx: CGContext = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height),
                                       bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0,
                                       space: self.cgImage!.colorSpace!,
                                       bitmapInfo: self.cgImage!.bitmapInfo.rawValue)!;
        
        ctx.concatenate(transform)
        
        if ( self.imageOrientation == UIImage.Orientation.left ||
            self.imageOrientation == UIImage.Orientation.leftMirrored ||
            self.imageOrientation == UIImage.Orientation.right ||
            self.imageOrientation == UIImage.Orientation.rightMirrored ) {
            ctx.draw(self.cgImage!, in: CGRect(x: 0,y: 0,width: self.size.height,height: self.size.width))
        } else {
            ctx.draw(self.cgImage!, in: CGRect(x: 0,y: 0,width: self.size.width,height: self.size.height))
        }
        
        // And now we just create a new UIImage from the drawing context and return it
        return UIImage(cgImage: ctx.makeImage()!)
    }
    
    /// Resizes an image to the specified size.
    ///
    /// - Parameters:
    ///     - size: the size we desire to resize the image to.
    ///     - roundedRadius: corner radius
    ///
    /// - Returns: the resized image with rounded corners.
    ///
    func imageWithSize(size: CGSize, roundedRadius radius: CGFloat) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        if let currentContext = UIGraphicsGetCurrentContext() {
            let rect = CGRect(origin: .zero, size: size)
            currentContext.addPath(UIBezierPath(roundedRect: rect,
                                                byRoundingCorners: .allCorners,
                                                cornerRadii: CGSize(width: radius, height: radius)).cgPath)
            currentContext.clip()
            
            //Don't use CGContextDrawImage, coordinate system origin in UIKit and Core Graphics are vertical oppsite.
            draw(in: rect)
            currentContext.drawPath(using: .fillStroke)
            let roundedCornerImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return roundedCornerImage
        }
        return nil
    }
}

open class CustomSlider : UISlider {
    @IBInspectable open var trackWidth:CGFloat = 2 {
        didSet {setNeedsDisplay()}
    }
    
    override open func trackRect(forBounds bounds: CGRect) -> CGRect {
        let defaultBounds = super.trackRect(forBounds: bounds)
        return CGRect(
            x: defaultBounds.origin.x,
            y: defaultBounds.origin.y + defaultBounds.size.height/2 - trackWidth/2,
            width: defaultBounds.size.width,
            height: trackWidth
        )
    }
}

//MARK: - Convertation Of Date

func getLabelHight(text:String,font: UIFont, width:CGFloat) -> CGFloat
{
    let label:UILabel = UILabel(frame: CGRect(x:0,y: 0,width: width,height: CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.font = font
    label.textAlignment = .center
    label.text = text
    label.sizeToFit()
    return label.frame.height
}

func getLabelWidth(text:String,font: UIFont, height:CGFloat) -> CGFloat
{
    let label:UILabel = UILabel(frame: CGRect(x:0,y: 0,width: CGFloat.greatestFiniteMagnitude,height: height))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.font = font
    label.textAlignment = .center
    label.text = text
    label.sizeToFit()
    return label.frame.width
}

func fileSize(forURL url: Any) -> Double {
    var fileURL: URL?
    var fileSize: Double = 0.0
    if (url is URL) || (url is String)
    {
        if (url is URL) {
            fileURL = url as? URL
        }
        else {
            fileURL = URL(fileURLWithPath: url as! String)
        }
        var fileSizeValue = 0.0
        try? fileSizeValue = (fileURL?.resourceValues(forKeys: [URLResourceKey.fileSizeKey]).allValues.first?.value as! Double?)!
        if fileSizeValue > 0.0 {
            fileSize = (Double(fileSizeValue) / (1024 * 1024))
        }
    }
    return fileSize
}

extension UIView {
    func addLine() {
        let labelLine = UILabel(frame: CGRect(x: 0, y: self.frame.size.height - 1.0, width: screenWidth, height: 1.0))
        labelLine.backgroundColor = UIColor.lightGray
        self.addSubview(labelLine)
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor
            layer.shadowOffset = CGSize(width: 0, height: 2)
            layer.shadowOpacity = 0.4
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}
