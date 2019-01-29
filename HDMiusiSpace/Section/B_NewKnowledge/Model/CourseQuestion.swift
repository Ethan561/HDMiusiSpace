//
//  CourseQuestion.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/24.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

struct CourseQuestion: Codable {
    var status: Int
    var msg: String
    var data: CourseQuestionData
}

struct CourseQuestionData: Codable {
    var isBuy, isFree, answerNum: Int
    var url: String
    var list: [CourseQuestionList]
    
    enum CodingKeys: String, CodingKey {
        case isBuy = "is_buy"
        case isFree = "is_free"
        case answerNum = "answer_num"
        case url, list
    }
}

struct CourseQuestionList: Codable {
    var uid: Int
    var avatar, nickname, title, content: String
    var questionID: Int
    var createdAt: String
    var likes, isLike: TStrInt?
    var returnInfo: [QuestionReturnInfo]
    var showAll = false

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
    var video: String
    var timeLong: TStrInt
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
