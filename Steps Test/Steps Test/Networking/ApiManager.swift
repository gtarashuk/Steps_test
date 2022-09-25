//
//  ApiManager.swift
//  Steps Test
//
//  Created by Grygorii Tarashchuk on 25.09.2022.
//

import Foundation
import Alamofire
import Network
import Localize_Swift

class APIManager {
    
    // MARK: - Vars & Lets
    
    private let sessionManager: Session

    let monitor = NWPathMonitor()
    var baseURL: String {
        return "https://jsonplaceholder.typicode.com/"
    }
    
    
    private static var sharedApiManager: APIManager = {
        let apiManager = APIManager(sessionManager: Session())
        
        return apiManager
    }()
    
    // MARK: - Accessors
    
    class func shared() -> APIManager {
        return sharedApiManager
    }
    
    // MARK: - Initialization
    
    private init(sessionManager: Session) {
        self.sessionManager = sessionManager
        //network monitor added to monitor availability
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("We're connected!")
            } else {
                print("No connection.")
                DispatchQueue.main.async {
                    let alertPopup = AlertPopUp(title: "error_popup_title".localized(), message: "error_no_internet".localized())
                    alertPopup.display()
                }
                
            }
            
            print(path.isExpensive)
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    
    //default completionHandler
    typealias CompletionHandler = (_ success:Any) -> Void
    
    
    // MARK: - Comments request
    // as query params we add start as starting id and limit for page
    //also we dont add order cause its unnecessary cause its asc by default
    func getComments(start: String, limit: String, completionHandler: @escaping (Comment) -> Void, errorHandler: @escaping(Error) -> Void) {
        guard let url = URL(string: baseURL + "comments?_start=\(start)&_limit=\(limit)") else {
            print("Error: cannot create URL")
            return
        }
        self.sessionManager.request(url,
                                    method: .get,
                                    encoding: JSONEncoding.default).responseDecodable(of:Comment.self) {
            response in
            if let commentsResponse = response.value {
                completionHandler(commentsResponse)
                return
            }else if let someError = response.error {
                errorHandler(someError)
                return
            }
            
        }
    }
    
    // as query params we add start as starting id and end index
    //also we dont add order cause its unnecessary cause its asc by default
    func getCommentsSlice(start: String, end: String, completionHandler: @escaping (Comment) -> Void, errorHandler: @escaping(Error) -> Void) {
        guard let url = URL(string: baseURL + "comments?_start=\(start)&_end=\(end)") else {
            print("Error: cannot create URL")
            return
        }
        self.sessionManager.request(url,
                                    method: .get,
                                    encoding: JSONEncoding.default).responseDecodable(of:Comment.self) {
            response in
            if let commentsResponse = response.value {
                completionHandler(commentsResponse)
                return
            }else if let someError = response.error {
                errorHandler(someError)
                return
            }
            
        }
    }
    
    func cancelPreviousRequest(){
        self.sessionManager.cancelAllRequests()
    }
    
}
