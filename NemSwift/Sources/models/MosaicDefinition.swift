//
//  MosaicDefinition.swift
//  NemSwift
//
//  Created by Kazuya Okada on 2017/12/01.
//  Copyright © 2017年 OpenApostille. All rights reserved.
//

import Foundation

struct MosaicDefinition: Decodable {
    let creator: String
    let id: MosaicId
    let description: String
    let properties: [MosaicProperty]
    let levy: MosaicLevy?
}
