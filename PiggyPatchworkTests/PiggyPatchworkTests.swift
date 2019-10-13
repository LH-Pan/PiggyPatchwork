//
//  PiggyPatchworkTests.swift
//  PiggyPatchworkTests
//
//  Created by 潘立祥 on 2019/10/10.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import XCTest
@testable import PiggyPatchwork

class PiggyPatchworkTests: XCTestCase {
    
    var sut: LobbyViewController!

    override func setUp() {
        super.setUp()
        
        sut = UIStoryboard(name: "Lobby", bundle: nil).instantiateInitialViewController() as? LobbyViewController
    }

    override func tearDown() {
        
        sut = nil
        
        super.tearDown()
    }
}
