//
//  TransactionHelper.swift
//  NemSwift
//
//  Created by Kazuya Okada on 2017/11/22.
//  Copyright © 2017年 OpenApostille. All rights reserved.
//

import Foundation

public class TransactionHelper {
    public static let minimuxmTransferFee = 50_000
    public static let maximumXemTransferFee = 1_250_000
    
    private init(){ }
    
    public class Transaction {
        public let type: TransactionType
        public let network: Network
        public let publicKey: [UInt8]
        public var fee: UInt64
        
        public init(
            type: TransactionType,
            network: Network,
            publicKey: [UInt8],
            fee: UInt64) {
            self.type = type
            self.network = network
            self.publicKey = publicKey
            self.fee = fee
        }
        
        public func toByteArray() -> [UInt8] {
            let now = Date()
            Logger.d("Now: \(now)")
            
            return ConvertUtil.toByteArrayWithLittleEndian(type.transactionTypeBytes()) +
                ConvertUtil.toByteArrayWithLittleEndian(network.rawValue + type.versionBytes()) +
                ConvertUtil.toByteArrayWithLittleEndian(currentTimeFromGenesisTime(date: now)) +
                ConvertUtil.toByteArrayWithLittleEndian(UInt32(publicKey.count)) +
                publicKey +
                ConvertUtil.toByteArrayWithLittleEndian(fee) +
                ConvertUtil.toByteArrayWithLittleEndian(deadline(from: now))
        }
        
        func genesisDateTime() -> Date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            dateFormatter.timeZone = TimeZone(identifier: "UTC")
            
            return dateFormatter.date(from: "2015/03/29 00:06:25")!
        }
        
        func currentTimeFromGenesisTime(date: Date) -> UInt32 {
            return UInt32(-genesisDateTime().timeIntervalSince(date))
        }
        
        func deadline(from: Date) -> UInt32 {
            let timeStamp = currentTimeFromGenesisTime(date: from)
            
            // deadlineは24時間後にする
            return timeStamp + 60 * 60 * 24
        }
        


    }
    
    public enum TransactionType {
        case Transfer
        case ImportanceTransfer
        case MultisigAgregateModificationTransfer
        case MultisigSignature
        case Multisig
        case ProvisionNamespace
        case MosaicDefinitionCreation
        case MosaicSupplyChange
        
        public func transactionTypeBytes() -> UInt32 {
            switch self {
            case .Transfer: return 0x0101
            case .ImportanceTransfer: return 0x0801
            case .MultisigAgregateModificationTransfer: return 0x1001
            case .MultisigSignature: return 0x1002
            case .Multisig: return 0x1004
            case .ProvisionNamespace: return 0x2001
            case .MosaicDefinitionCreation: return 0x4001
            case .MosaicSupplyChange: return 0x4002
            }
        }
        
        public func versionBytes() -> UInt32 {
            switch self {
            case .ImportanceTransfer: return 1
            case .Multisig: return 1
            case .MultisigSignature: return 1
            case .ProvisionNamespace: return 1
            case .MosaicDefinitionCreation: return 1
            case .MosaicSupplyChange: return 1
            case .Transfer: return 2
            case .MultisigAgregateModificationTransfer: return 2
            }
        }
    }
    
    public enum Network: UInt32 {
        case mainnet = 0x68000000
        case testnet = 0x98000000
    }
    
}
