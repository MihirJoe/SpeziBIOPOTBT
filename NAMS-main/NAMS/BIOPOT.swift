//
//  BIOPOT.swift
//  NAMS
//
//  Created by Mihir Joshi on 11/13/23.
//

import SwiftUI
import CoreBluetooth

struct BIOPOT: View {
    @State private var biopot3Connected: Bool = false
    @State private var biopot3Data: [UInt8] = []

    func connectToBiopot3() {
        
        let biopot3Manager = Biopot3Manager()
        biopot3Manager.connectToBiopot3()
        
        biopot3Manager.didUpdateValueFor = { (characteristic, error) in
            if characteristic.uuid == CBUUID(string: "YOUR_CHARACTERISTIC_UUID") {
                if let data = characteristic.value {
                    
                    let biopot3Data = data.withUnsafeBytes { bytes -> [UInt8] in
                        return Array(UnsafeBufferPointer(start: bytes, count: data.count))
                    }
                    
                    self.biopot3Data = biopot3Data
                    self.biopot3Connected = true
                }
            }
        }
    }

    var body: some View {
        VStack {
            if biopot3Connected {
                Text("Biopot3 connected!")
                Text("Data: \(biopot3Data.rawValue)")
            } else {
                Text("Biopot3 not connected.")
                Button(action: connectToBiopot3) {
                    Text("Connect")
                }
            }
        }
    }
}

#Preview {
    BIOPOT()
}
