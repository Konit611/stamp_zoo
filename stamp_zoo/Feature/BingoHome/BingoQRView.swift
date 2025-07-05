//
//  BingoQRView.swift
//  stamp_zoo
//
//  Created by GEUNIL on 2025/07/05.
//

import SwiftUI

struct BingoQRView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isScanning = false
    @State private var scannedCode: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            // 배경 이미지
            Image("qr_background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(.all)
            
            VStack(spacing: 0) {
                // 상단 네비게이션 바 영역
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(Color.black)
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                Spacer()
                
                // QR 코드 스캔 영역
                VStack(spacing: 30) {
                    // QR 스캔 영역 (검은색 박스)
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.black)
                        .frame(width: 300, height: 300)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white, lineWidth: 2)
                        )
                    
                    // 촬영 버튼
                    Button(action: {
                        startScanning()
                    }) {
                        Text("촬영")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color(red: 0.1, green: 0.2, blue: 0.4))
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                    }
                    .padding(.horizontal, 40)
                }
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .alert(alertMessage, isPresented: $showingAlert) {
            Button(NSLocalizedString("done", comment: "")) {
                showingAlert = false
            }
        }
    }
    
    // MARK: - Private Functions
    private func startScanning() {
        isScanning.toggle()
        
        if isScanning {
            // 시뮬레이션: 2초 후 스캔 완료
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                isScanning = false
                alertMessage = NSLocalizedString("qr_scan_success", comment: "")
                showingAlert = true
            }
        }
    }
}

#Preview {
    NavigationView {
        BingoQRView()
    }
} 