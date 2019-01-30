//
//  Question.swift
//  Personal Quiz
//
//  Created by Давид on 27/01/2019.
//  Copyright © 2019 Давид. All rights reserved.
//

struct Question {
    var text: String
    var type: ResponseType
    var answers: [Answer]
}

enum ResponseType {
    case single, multiple, ranged
}

struct Answer {
    var text: String
    var type: AnimalType
}

enum AnimalType: Character {
    case dog = "🐶", cat = "🐱", rabbit = "🐰", turtle = "🐢"
    
    var defenition: String {              // вычислимое свойство
        switch self {
        case .dog:
            return "Вы любите бывать в компании. Вы всегда окружены друзьями. Вам нравится играть и быть лучшим другом для всех."
        case .cat:
            return "Вы гуляете сами по себе. Вам нравится свобода и самостоятельность"
        case .rabbit:
            return "Вам нравитс все мягкое. Вы здоровы и полны энергии"
        case .turtle:
            return "Вы мудры не по годам. Медленный и задумчивый выигрывает гонку. Тише едешь, дальше будешь"
        }
    }
}
