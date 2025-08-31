//
//  QRScannerView.swift
//  stamp_zoo
//
//  Created by GEUNIL on 2025/07/05.
//

import SwiftUI
import AVFoundation

struct QRScannerView: UIViewRepresentable {
    let coordinator: QRScannerCoordinator
    
    init(coordinator: QRScannerCoordinator) {
        self.coordinator = coordinator
    }
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.black
        
        guard let captureSession = coordinator.setupCaptureSession() else {
            print("Failed to setup capture session, showing error view")
            return createErrorView()
        }
        
        print("Creating preview layer for capture session")
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.backgroundColor = UIColor.clear.cgColor
        
        // 명시적으로 프레임 설정 (300x300 크기)
        let initialFrame = CGRect(x: 0, y: 0, width: 300, height: 300)
        previewLayer.frame = initialFrame
        
        // 프리뷰 레이어를 뷰에 추가
        view.layer.addSublayer(previewLayer)
        
        // 태그를 설정해서 나중에 찾을 수 있게 함
        view.tag = 1001
        
        print("Preview layer added to view with frame: \(previewLayer.frame)")
        
        // 카메라 세션이 아직 시작되지 않았다면 지금 시작
        if !captureSession.isRunning {
            DispatchQueue.global(qos: .userInitiated).async {
                captureSession.startRunning()
                print("Started capture session from QRScannerView")
            }
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // 뷰가 업데이트될 때 프리뷰 레이어 크기 조정
        if let previewLayer = uiView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
            let newFrame = uiView.bounds
            print("UIView bounds: \(newFrame)")
            
            // frame이 0이면 300x300 크기로 설정
            let finalFrame = newFrame.width > 0 && newFrame.height > 0 ? newFrame : CGRect(x: 0, y: 0, width: 300, height: 300)
            
            print("Setting preview layer frame to: \(finalFrame)")
            
            DispatchQueue.main.async {
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                previewLayer.frame = finalFrame
                CATransaction.commit()
            }
        } else {
            print("Could not find preview layer in updateUIView")
        }
    }
    
    private func createErrorView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.black
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView(image: UIImage(systemName: "camera.fill"))
        imageView.tintColor = UIColor.white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = LocalizationHelper.shared.localizedText(
            korean: "카메라를 사용할 수 없습니다",
            english: "Camera not available",
            japanese: "カメラを使用できません",
            chinese: "无法使用相机"
        )
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 60),
            imageView.heightAnchor.constraint(equalToConstant: 60),
            
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20)
        ])
        
        return view
    }
}

// MARK: - QR Scanner Overlay View
struct QRScannerOverlayView: View {
    @Binding var isScanning: Bool
    let onTorchToggle: () -> Void
    let torchEnabled: Bool
    
    var body: some View {
        ZStack {
            // 반투명 배경
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // QR 스캔 가이드
                ZStack {
                    // 스캔 영역 (투명한 사각형)
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isScanning ? Color.green : Color.white, lineWidth: 3)
                        .frame(width: 250, height: 250)
                        .background(Color.clear)
                    
                    // 스캔 가이드 라인 (애니메이션)
                    if isScanning {
                        scanAnimationView()
                    }
                    
                    // 모서리 가이드
                    cornerGuides()
                }
                
                Spacer()
                
                // 하단 안내 텍스트
                VStack(spacing: 12) {
                    Text(LocalizationHelper.shared.localizedText(
                        korean: "QR 코드를 화면 중앙에 맞춰주세요",
                        english: "Align QR code to center of screen",
                        japanese: "QRコードを画面中央に合わせてください",
                        chinese: "将QR码对准屏幕中央"
                    ))
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color.black.opacity(0.7))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    // 토치 버튼
                    Button(action: onTorchToggle) {
                        Image(systemName: torchEnabled ? "flashlight.on.fill" : "flashlight.off.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(Color.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                }
                .padding(.bottom, 40)
            }
        }
    }
    
    @ViewBuilder
    private func scanAnimationView() -> some View {
        Rectangle()
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [Color.clear, Color.green, Color.clear]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(width: 240, height: 2)
            .modifier(ScanLineAnimation())
    }
    
    @ViewBuilder
    private func cornerGuides() -> some View {
        ZStack {
            ForEach(0..<4, id: \.self) { index in
                cornerGuide()
                    .rotationEffect(.degrees(Double(index * 90)))
            }
        }
    }
    
    @ViewBuilder
    private func cornerGuide() -> some View {
        VStack {
            HStack {
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 20, height: 3)
                Spacer()
            }
            Spacer()
        }
        .frame(width: 250, height: 250)
    }
}

// MARK: - Scan Line Animation
struct ScanLineAnimation: ViewModifier {
    @State private var isAnimating = false
    
    func body(content: Content) -> some View {
        content
            .offset(y: isAnimating ? 120 : -120)
            .onAppear {
                withAnimation(
                    Animation.linear(duration: 2.0)
                        .repeatForever(autoreverses: false)
                ) {
                    isAnimating = true
                }
            }
    }
}
