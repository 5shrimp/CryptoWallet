//
//  Currency.swift
//  CryptoWallet
//
//  Created by Дмитрий Любченко on 26.04.2025.
//

import Foundation

struct CurrencyResponse: Decodable {
    var data: Currency

    private enum CodingKeys: String, CodingKey {
        case data
    }
}

struct Currency: Decodable {
    var name: String
    var symbol: String
    var marketData: MarketData
    var marketCapitalization: MarketCapitalization
    var supply: Supply

    private enum CodingKeys: String, CodingKey {
        case name
        case symbol
        case marketData = "market_data"
        case marketCapitalization = "marketcap"
        case supply
    }
}

struct MarketData: Decodable {
    var volumeLast24Hours: Double
    var percent: Double

    private enum CodingKeys: String, CodingKey {
        case volumeLast24Hours = "volume_last_24_hours"
        case percent = "percent_change_usd_last_1_hour"
    }
}

struct MarketCapitalization: Decodable {
    var capitalization: Double
    
    private enum CodingKeys: String, CodingKey {
        case capitalization = "current_marketcap_usd"
    }
}

struct Supply: Decodable {
    var circulating: Double
    
    private enum CodingKeys: String, CodingKey {
        case circulating 
    }
}

