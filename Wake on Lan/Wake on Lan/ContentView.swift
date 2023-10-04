//
//  ContentView.swift
//  Wake on Lan
//
//  Created by Jakob Padtberg on 25.09.23.
//


import SwiftUI
import Foundation

@main
struct WakeOnLanApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var macAddress = ""
    @State private var broadcastAddress = ""
    
    var body: some View {
        VStack {
            Text("Wake-on-LAN Sender")
                .font(.title)
                .padding()
            
            TextField("Enter MAC Address", text: $macAddress)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Enter Broadcast Address", text: $broadcastAddress)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Send WoL Packet") {
                sendWoLPacket()
            }
            .padding()
        }
        .padding()
    }
    
    private func sendWoLPacket() {
        guard let mac = MACAddress(macAddress),
              let broadcast = IPAddress(broadcastAddress) else {
            // Handle invalid MAC or broadcast address input
            return
        }
        
        let wolPacket = WakeOnLANPacket(macAddress: mac)
        
        do {
            try wolPacket.send(broadcastAddress: broadcast)
            print("WoL packet sent successfully.")
        } catch {
            print("Error sending WoL packet: \(error.localizedDescription)")
        }
    }
}

struct MACAddress {
    internal var bytes: [UInt8]

    init?(_ string: String) {
        let components = string.split(separator: ":").compactMap { UInt8($0, radix: 16) }
        if components.count == 6 {
            bytes = components
        } else {
            return nil
        }
    }
}

struct IPAddress {
    internal var address: String

    init?(_ string: String) {
        address = string
    }
}

struct WakeOnLANPacket {
    internal var bytes: [UInt8]

    init(macAddress: MACAddress) {
        bytes = [UInt8](repeating: 0xFF, count: 6 * 16)
        for i in 0..<16 {
            for j in 0..<6 {
                bytes[i * 6 + j] = macAddress.bytes[j]
            }
        }
    }

    func send(broadcastAddress: IPAddress) throws {
        var addr = sockaddr_in()
        addr.sin_family = sa_family_t(AF_INET)
        addr.sin_port = in_port_t(9)
        addr.sin_addr.s_addr = inet_addr(broadcastAddress.address)

        let fd = socket(AF_INET, SOCK_DGRAM, 0)
     
            close(fd)
        }

        
        
    }

enum WakeOnLANError: Error {
    case sendError
}













