//
//  DummyDataStore.swift
//  ShudderChallenge
//
//  Created by Felix Changoo on 10/26/18.
//  Copyright © 2018 Felix Changoo. All rights reserved.
//
struct MovieManager {
    typealias movies = [Movie]
    typealias moviesCreatedHandler = (Result<movies>) -> ()
    
    static let sharedInstance = MovieManager()
    let networkManager = NetworkManager.shared
    var movieTypes: [String]
    
    //keys
    let farmKey = "farm"
    let secretKey = "secret"
    let serverIDKey = "server"
    let photoIDKey = "id"
    
    private init() {
        movieTypes = ["", "Horror", "Scary", "Cats", "Dogs"]
    }
   
    mutating func getMovies(movieSection: String, completionHandler completion: @escaping moviesCreatedHandler) {
        guard movieTypes.contains(movieSection) else {
            return
        }
            var movies = [Movie]()
            if(movieSection != "") {
                networkManager.getPhotosJSONDict(tag: movieSection, completionHandler: { result in
                    switch result {
                    case .Error(let error):
                        completion (.Error(error))
                        return
                    case .Success(let arrayOfPhotos):
                        
                        arrayOfPhotos.forEach({ $0
                            if let farmID = $0[self.farmKey] as? Int,
                            let serverID = $0[self.serverIDKey] as? String,
                            let photoID = $0[self.photoIDKey] as? String,
                                let secret = $0[self.secretKey] as? String {
                                let movieURLString = self.generateMovieImageURLString(farmID: farmID, serverID: serverID, photoID: photoID, secret: secret)
                                movies.append(Movie(urlString: movieURLString))
                            }
                        })
                        completion(.Success(movies))
                        return
                    }
                })
            } else {
                completion(.Success(movies)) //just return an empty movie array
                return
            }
    }
    
    private func generateMovieImageURLString(farmID: Int, serverID: String, photoID: String, secret: String) -> String {
        return "https://farm\(farmID).staticflickr.com/\(serverID)/\(photoID)_\(secret)_m.jpg"
    }
}
