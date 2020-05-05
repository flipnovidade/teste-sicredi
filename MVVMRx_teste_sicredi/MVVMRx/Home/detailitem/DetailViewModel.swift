
import Foundation
import RxSwift
import RxCocoa

class DetailViewModel {
    
    public enum HomeError {
        case internetError(String)
        case serverMessage(String)
    }
    
    public let track: PublishSubject<Track> = PublishSubject()
    public let loading: PublishSubject<Bool> = PublishSubject()
    public let error : PublishSubject<HomeError> = PublishSubject()
    
    private let disposable = DisposeBag()

    public let trackPost: PublishSubject = PublishSubject<Any>()
    
    public func requestDataTrack(eventId: String){
        
        self.loading.onNext(true)
        APIManager.requestData(url: "events/\(eventId)", method: .get, parameters: nil, completion: { (result) in
            self.loading.onNext(false)
            switch result {
                case .success(let returnJson) :
    
                        let object = Track(data: try! returnJson.rawData())
                        //let object = Track(json: returnJson.dictionaryObject!)
                        self.track.onNext(object!)
                    
                case .failure(let failure) :
                    switch failure {
                        case .connectionError:
                            self.error.onNext(.internetError("Check your Internet connection."))
                        case .authorizationError(let errorJson):
                            self.error.onNext(.serverMessage(errorJson["message"].stringValue))
                        default:
                            self.error.onNext(.serverMessage("Unknown Error"))
                    }
            }
        })
        
    }
    
    
    public func postDataTrack(eventId: String, name: String, email: String){
        
        let parameters: [String: Any] = [
            "eventId": "\(eventId)",
            "name": "\(name)",
            "email": "\(email)"
        ]
        
        self.loading.onNext(true)
        APIManager.requestData(url: "checkin", method: .post, parameters: parameters, completion: { (result) in
            self.loading.onNext(false)
            switch result {
            case .success( _) :
                self.trackPost.onCompleted()
                
            case .failure(let failure) :
                switch failure {
                    case .connectionError:
                        self.error.onNext(.internetError("Check your Internet connection."))
                    case .authorizationError(let errorJson):
                        self.error.onNext(.serverMessage(errorJson["message"].stringValue))
                    default:
                        self.error.onNext(.serverMessage("Unknown Error"))
                }
            }
        })
        
    }
    
    func jsonToString(json: Any) -> String{
        
        do {
            let data1 = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
            let convertedString = String(data: data1, encoding: String.Encoding.utf8) as NSString? ?? ""
            debugPrint(convertedString)
            return convertedString as String
        } catch let myJSONError {
            print(":::myJSONError 1: \(myJSONError)")
            return ""
        }
       
    }
    
    func jsonToData(json: Any) -> Data? {
        do {
            return try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
        } catch let myJSONError {
            print(":::myJSONError 2: \(myJSONError)")
            return nil;
        }
        
    }
    
}
