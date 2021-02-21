//
//  Network Manager.swift
//  GM Coding Exercise
//
//  Created by Derek on 2/19/21.
//

import Foundation
final class NetworkManager{
    typealias AristParamaters =  Result<MediaResponse,Error>
    static var shared = NetworkManager()
    let session:DataTaskMaker
     init(session: DataTaskMaker = URLSession.shared){
        self.session = session
    }
}
protocol DataTaskMaker {
  func dataTask(with url: URL,
                completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}
extension URLSession: DataTaskMaker{ }
extension NetworkManager{
    func fetchArtist(artistName:String,completion: @escaping (AristParamaters) -> ()) {
        let urlString = "https://itunes.apple.com/search?media=music&entity=song&term=\(artistName)"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let err = error{
                completion(.failure(err))
            }
            guard let response = response as? HTTPURLResponse else { return }
            print(response.statusCode)
            guard let data = data else { return }
            
            do {
                let artistDataReturned = try JSONDecoder().decode(MediaResponse.self, from: data)
                completion(.success(artistDataReturned))
                print("\(artistDataReturned)")
            } catch let error as NSError {
                completion(.failure(error))
                print("Fetching error: \(error), \(error.userInfo)")
            }
        }.resume()
    }
}
