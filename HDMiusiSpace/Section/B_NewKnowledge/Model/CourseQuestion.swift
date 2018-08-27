//
//  CourseQuestion.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/24.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

struct CourseQuestion: Codable {
    let status: Int
    let msg: String
    let data: CourseQuestionData
}

struct CourseQuestionData: Codable {
    let isBuy, isFree, answerNum: Int
    let url: String
    let list: [CourseQuestionList]
    
    enum CodingKeys: String, CodingKey {
        case isBuy = "is_buy"
        case isFree = "is_free"
        case answerNum = "answer_num"
        case url, list
    }
}

struct CourseQuestionList: Codable {
    let uid: Int
    let avatar, nickname, title, content: String
    let questionID: Int
    let createdAt: String
    var likes, isLike: TStrInt?
    let returnInfo: [QuestionReturnInfo]
    
    enum CodingKeys: String, CodingKey {
        case uid, avatar, nickname, title, content
        case questionID = "question_id"
        case createdAt = "created_at"
        case likes
        case isLike = "is_like"
        case returnInfo = "return_info"
    }
}

struct QuestionReturnInfo: Codable {
    var teacherID: Int
    var teacherImg: String
    var teacherName: String
    var type: Int
    var content: String
    var video, timeLong: String
    var createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case teacherID = "teacher_id"
        case teacherImg = "teacher_img"
        case teacherName = "teacher_name"
        case type, content, video
        case timeLong = "time_long"
        case createdAt = "created_at"
    }
}
