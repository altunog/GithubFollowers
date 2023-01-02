//
//  Follower.swift
//  GithubFollowers
//
//  Created by Oğuz Kaan Altun on 1.01.2023.
//

import Foundation

struct Follower: Codable, Hashable {
    var login: String
    var avatarUrl: String
}
