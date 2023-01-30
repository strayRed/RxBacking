//
//  ViewSection.swift
//  RxBacking_Example
//
//  Created by strayRed on 2023/1/25.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import RxBacking
import ViewSizeExpansion

struct Section: AnimatableSectionModelType {
    
    var identity: String { title }
    
    typealias Identity = String
    
    var title: String
    
    var items: [Model]
    
    init(original: Section, items: [Model]) {
        self.title = original.title
        self.items = items
    }
    
    init(title: String, items: [Model]) {
        self.title = title
        self.items = items
    }
}


struct Model: AnimatableSectionItemType, ExpansionModel {
    
    var expansionState: ExpansionState = .collapsed
    
    var metricIdentity: AnyHashable {
        AnyHashable("\(identity)_\(expansionState.rawValue)")
    }
    
    var identity: String
    
    var content: String
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.identity == rhs.identity && lhs.metricIdentity == rhs.metricIdentity
    }
    
}

let staticSections: [Section] = [
    .init(title: "sectionA", items: [
        .init(identity: "a_1", content: "Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,"),
        .init(identity: "a_2", content: "Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,")]),
    .init(title: "sectionB", items: [
        .init(identity: "b_1", content: "Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,"),
        .init(identity: "b_2", content: "Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,t,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Tes")]),
    .init(title: "sectionC", items: [
        .init(identity: "c_1", content: "Test,Test,Test,Test,Test,Test,Test,Test,Test,TestTest,TestTest,TestTest,TestTest,Test,Test,Test,Test,Test,Test,Test,"),
        .init(identity: "c_2", content: "Test,Test,Test,Test,Test,Te,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,t,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Tes"),
        .init(identity: "c_3", content: "Test,Test,Test,Test,Test,Te,Test,Test,Test,Test,Te"),
        
        .init(identity: "c_4", content: "Test,Test,Test,Test,Test,Te,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,t,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Tes")
    
    ]),
    .init(title: "sectionD", items: [
        .init(identity: "d_1", content: "Test,Test,Test,Test,Test,Test,Test,Test,Test,TestTest,TestTest,TestTest,TestTest,Test,Test,Test,Test,Test,Test,Tesst,Test,TestTest,TestTest,TestTest,TestTest,Test,Test,Test,Test,Test,Test,Tesst,Test,TestTest,TestTest,TestTest,TestTest,Test,Test,Test,Test,Test,Test,Test,"),
        .init(identity: "d_2", content: "Test,Test,Test,Test,Test,Te,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,t,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Test,Tes")])]
