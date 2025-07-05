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
        VStack(spacing: 30) {
            // 상단 안내 텍스트
            headerView()
            
            // QR 코드 스캔 영역
            qrScanAreaView()
            
            // 하단 안내 텍스트
            instructionView()
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .background(Color(.systemGray6))
        .navigationTitle(NSLocalizedString("qr_scan", comment: ""))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
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
            }
        }
        .alert(alertMessage, isPresented: $showingAlert) {
            Button(NSLocalizedString("done", comment: "")) {
                showingAlert = false
            }
        }
    }
    
    // MARK: - Header View
    private func headerView() -> some View {
        VStack(spacing: 15) {
            Image(systemName: "qrcode.viewfinder")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            Text(NSLocalizedString("qr_scan_title", comment: ""))
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            Text(NSLocalizedString("qr_scan_subtitle", comment: ""))
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 20)
    }
    
    // MARK: - QR Scan Area View
    private func qrScanAreaView() -> some View {
        VStack(spacing: 20) {
            // QR 스캔 영역 (실제 카메라 뷰 대신 플레이스홀더)
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.1))
                .frame(height: 250)
                .overlay(
                    VStack(spacing: 15) {
                        Image(systemName: "camera")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                        
                        Text(NSLocalizedString("camera_placeholder", comment: ""))
                            .font(.headline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.blue, lineWidth: 2)
                )
            
            // 스캔 버튼
            scanButton()
        }
        .padding(.horizontal, 10)
    }
    
    // MARK: - Scan Button
    private func scanButton() -> some View {
        Button(action: {
            startScanning()
        }) {
            HStack {
                Image(systemName: isScanning ? "stop.circle" : "camera")
                    .font(.title2)
                
                Text(isScanning ? NSLocalizedString("stop_scanning", comment: "") : NSLocalizedString("start_scanning", comment: ""))
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(isScanning ? Color.red : Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 25))
        }
        .disabled(false)
    }
    
    // MARK: - Instruction View
    private func instructionView() -> some View {
        VStack(spacing: 15) {
            Text(NSLocalizedString("qr_instructions", comment: ""))
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            VStack(alignment: .leading, spacing: 10) {
                instructionRow(
                    number: "1",
                    text: NSLocalizedString("qr_instruction_1", comment: ""),
                    icon: "location"
                )
                
                instructionRow(
                    number: "2",
                    text: NSLocalizedString("qr_instruction_2", comment: ""),
                    icon: "qrcode"
                )
                
                instructionRow(
                    number: "3",
                    text: NSLocalizedString("qr_instruction_3", comment: ""),
                    icon: "checkmark.circle"
                )
            }
            .padding(20)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
        }
    }
    
    // MARK: - Instruction Row
    private func instructionRow(number: String, text: String, icon: String) -> some View {
        HStack(spacing: 15) {
            // 번호 원
            Text(number)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
                .background(Color.blue)
                .clipShape(Circle())
            
            // 아이콘
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
                .frame(width: 25)
            
            // 텍스트
            Text(text)
                .font(.body)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
            
            Spacer()
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