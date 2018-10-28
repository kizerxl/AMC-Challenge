//
//  NetworkManager.swift
//  ShudderChallenge
//
//  Created by Felix Changoo on 10/27/18.
//  Copyright © 2018 Felix Changoo. All rights reserved.
//
import Alamofire

struct NetworkManager {
    typealias jsonDict = [String : AnyObject]
    typealias arrayOfPhotos = [jsonDict]
    typealias pokemonDescriptions = [[String : String]]
    typealias photoEntriesDownloadedHandler = (Result<arrayOfPhotos>) -> ()
    
    let baseURL = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key="
    let key = "3ef7ba0ad1972287ff90de8a9cded337"
    let endpointOptions = "&per_page=20&format=json&nojsoncallback=1"
    
    public static let shared = NetworkManager()
    
    private init() {}
    
    func getPhotosJSONDict(tag: String, completionHandler completion: @escaping photoEntriesDownloadedHandler) {
        let completeTagString = "&tags=\(tag)"
        let urlString = baseURL + key + completeTagString + endpointOptions
        let url = URL(string: urlString)!
        
        Alamofire.request(url).responseJSON { response in
            if let downloadedJSONDict = response.result.value as? jsonDict,
               let photosDict = downloadedJSONDict["photos"] as? jsonDict,
                let photoEntries = photosDict["photo"] as? arrayOfPhotos {
                completion(.Success(photoEntries))
            }  else {
                completion(.Error(.NoJSONDownloaded))
            }
        }
    }
}

enum Result<T> {
    case Success(T)
    case Error(Errors)
}

enum Errors: Error, CustomStringConvertible {
    case NoJSONDownloaded
    case NoModel
    
    var description: String {
        switch self {
        case .NoJSONDownloaded:
            return "NO JSON WAS DOWNLOADED"
        case .NoModel:
            return "NO MODEL CREATED"
        }
    }
}


