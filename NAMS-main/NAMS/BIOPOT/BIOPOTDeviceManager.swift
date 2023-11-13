//
//  BIOPOTDeviceManager.swift
//  NAMS
//
//  Created by Mihir Joshi on 11/12/23.
//

import Foundation
import CoreBluetooth

class Biopot3Manager: NSObject, CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
    }

    private var centralManager: CBCentralManager!
    private var biopot3Peripheral: CBPeripheral!
    private var dataCharacteristic: CBCharacteristic!
    var didUpdateValueFor: (_ characteristic: CBCharacteristic, _ error: Error?) -> Void = { _, _ in }
     

    
    override init() {
        super.init()

        // Create a new CBCentralManager object.
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    // Start scanning for Bluetooth devices.
    func connectToBiopot3() {
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }

    // Called when the central manager discovers a new Bluetooth device.
    @nonobjc func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {

        // Check if the discovered device is the Biopot3 device.
        if peripheral.name == "Biopot3" {

            // Stop scanning for devices.
            centralManager.stopScan()

            // Connect to the Biopot3 device.
            centralManager.connect(peripheral, options: nil)

            // Store the Biopot3 peripheral object.
            biopot3Peripheral = peripheral
        }
    }

    // Called when the central manager connects to a Bluetooth device.
    @nonobjc func didConnect(peripheral: CBPeripheral) {

        // Discover the services on the Biopot3 device.
        biopot3Peripheral.discoverServices(nil)
    }

    // Called when the central manager discovers services on a Bluetooth device.
    func didDiscover(services: [CBService], error: Error?) {

        // Find the service that contains the data characteristic.
        for service in biopot3Peripheral.services! {
            if service.uuid == CBUUID(string: "YOUR_SERVICE_UUID") {

                // Discover the characteristics on the service.
                biopot3Peripheral.discoverCharacteristics([CBUUID(string: "YOUR_CHARACTERISTIC_UUID")], for: service)
            }
        }
    }

    // Called when the central manager discovers characteristics on a Bluetooth device.
    func didDiscover(characteristics: [CBCharacteristic], for: CBService, error: Error?) {

        // Find the data characteristic.
        for characteristic in characteristics {
            if characteristic.uuid == CBUUID(string: "YOUR_CHARACTERISTIC_UUID") {

                // Store the data characteristic object.
                dataCharacteristic = characteristic

                // Enable notifications for the data characteristic.
                biopot3Peripheral.setNotifyValue(true, for: dataCharacteristic)
            }
        }
    }

    // Called when the central manager receives a notification from a Bluetooth device.
    func didUpdateValueFor(characteristic: CBCharacteristic, error: Error?) {

        // Check if the notification is for the data characteristic.
        if characteristic == dataCharacteristic {

            // Capture the data from the characteristic.
            if let data = characteristic.value {

                // Do something with the captured data here.
                print(data)
            }
        }
    }
    
    
}

