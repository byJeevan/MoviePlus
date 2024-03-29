//
//  NetworkManager.swift
//  NetworkLayer
//
//  Created by Malcolm Kumwenda on 2018/03/11.
//  Copyright © 2018 Malcolm Kumwenda. All rights reserved.
//

import Foundation

enum NetworkResponse:String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

enum Result<String>{
    case success
    case failure(String)
}

struct NetworkManager {
    static let environment : NetworkEnvironment = .staging
    let router = Router<MovieApi>()
    
    
    func getMovieDetail(movieId:Int, completion: @escaping (_ movie: MovieDetailModel?,_ error: String?)->()){
        
        router.request(.movieDetail(movieId: movieId)) { (data, response, error) in
            if error != nil {
                completion(nil, "Please check your network connection.")
            }
           
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        //TODO : util that decode
                        print(responseData)
                        let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                        print(jsonData)
                        let model = try JSONDecoder().decode(MovieDetailModel.self, from: responseData)
                        completion(model, nil)
                    }catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }

            
            
        }
        
    }
    
    func getTopRatedMovies(page: Int, completion: @escaping (_ movie: MovieBaseModel?,_ error: String?)->()){
       
        router.request(.topRated) { data, response, error in
            
            if error != nil {
                completion(nil, "Please check your network connection.")
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        //TODO : util that decode
                        print(responseData)
                        let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                        print(jsonData)
                        let model = try JSONDecoder().decode(MovieBaseModel.self, from: responseData)
                        completion(model,nil)
                    }catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
        
    }
    
    
    func getUpcomingMovies(page: Int, completion: @escaping (_ movie: MovieBaseModel?,_ error: String?)->()){
       
        router.request(.upcoming) { data, response, error in
            
            if error != nil {
                completion(nil, "Please check your network connection.")
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        //TODO : util that decode 
                        print(responseData)
                        let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                        print(jsonData)
                        let apiResponse = try JSONDecoder().decode(MovieBaseModel.self, from: responseData)
                        completion(apiResponse,nil)
                    }catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
        
    }

	func searchForMovie(key:String, page: Int, completion: @escaping (_ movie: MovieBaseModel?,_ error: String?)->()){

		router.request(.searchMovie(searchKey: key)) { data, response, error in

			if error != nil {
				completion(nil, "Please check your network connection.")
			}

			if let response = response as? HTTPURLResponse {
				let result = self.handleNetworkResponse(response)
				switch result {
				case .success:
					guard let responseData = data else {
						completion(nil, NetworkResponse.noData.rawValue)
						return
					}
					do {
						//TODO : util that decode
						print(responseData)
						let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
						print(jsonData)
						let apiResponse = try JSONDecoder().decode(MovieBaseModel.self, from: responseData)
						completion(apiResponse,nil)
					}catch {
						print(error)
						completion(nil, NetworkResponse.unableToDecode.rawValue)
					}
				case .failure(let networkFailureError):
					completion(nil, networkFailureError)
				}
			}
		}

	}

    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}
