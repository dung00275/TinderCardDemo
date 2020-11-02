//  File name   : Picture.swift
//
//  Author      : Dung Vu
//  Created date: 11/1/20
//  Version     : 1.00
//  --------------------------------------------------------------
//  
//  --------------------------------------------------------------

import Foundation
struct Picture : Codable, ImageDisplayProtocol {
	let large : String?
	let medium : String?
	let thumbnail : String?
    
    var imageURL: String? {
        return medium
    }

	enum CodingKeys: String, CodingKey {

		case large = "large"
		case medium = "medium"
		case thumbnail = "thumbnail"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		large = try values.decodeIfPresent(String.self, forKey: .large)
		medium = try values.decodeIfPresent(String.self, forKey: .medium)
		thumbnail = try values.decodeIfPresent(String.self, forKey: .thumbnail)
	}

}
