//
//  TrendingService.swift
//  CryptoWallet
//
//  Created by Дмитрий Любченко on 26.04.2025.
//

import Foundation

struct TrendingService {
    func fetchTrending(currency:String, completion: @escaping (Currency)->()) {        
        let urlSession = URLSession.shared
        let decoder = JSONDecoder()
        
        guard let url = URL.init(string: "https://data.messari.io/api/v1/assets/\(currency)/metrics") else { return }
        let urlRequest = URLRequest(url: url)
        let task = urlSession.dataTask(with: urlRequest) { data, response, error in
            guard let data else { return }
            do {
                let currencyReponse = try decoder.decode(CurrencyResponse.self, from: data)
                let currencies = currencyReponse.data
                
                DispatchQueue.main.async {
                    completion(currencies)
                    print(currencies)
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
     
    func fetchCurrencyList(completion: @escaping ([Currency])->()) {
        let group = DispatchGroup()
        let semaphore = DispatchSemaphore(value: 1)
        var currencyList: [Currency] = []
        ["btc", "eth", "tron", "luna", "polkadot", "dogecoin", "tether", "stellar", "cardano", "xrp"].forEach { currency in
            group.enter()
            fetchTrending(currency: currency) {currency in
                semaphore.wait()
                currencyList.append(currency)
                semaphore.signal()
                group.leave()
            }
        }

        group.notify(queue: .main) {
            completion(currencyList)
            print("Completed all tasks")
        }
    }
}
