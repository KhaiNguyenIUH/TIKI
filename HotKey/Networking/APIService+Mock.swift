// Networking/APIService.swift

extension APIService {
    func generateMockData() -> [HotKeyword] {
        var mockItems = [HotKeyword]()
        
        // Dữ liệu cơ bản để sử dụng cho mock data
        let baseIcons = [
            "https://salt.tikicdn.com/cache/750x750/ts/product/fa/1d/33/98a0ed962d4b27b6526a93fac7aab192.png",
            "https://salt.tikicdn.com/cache/750x750/ts/product/65/c2/29/b5f8f3fe5e04758a05cf00cea66b4aa8.png",
            "https://salt.tikicdn.com/cache/750x750/ts/product/d9/43/f7/bc379f2bf06eca29f8c2ee81dd6af0e9.jpg",
            "https://salt.tikicdn.com/cache/750x750/ts/product/87/24/ee/2086d71634cbe950e46929efcacb518d.png",
            "https://salt.tikicdn.com/cache/750x750/ts/product/c1/0f/bd/e63665fdbfd4f1e75b129d3655dbdfc9.png",
            "https://salt.tikicdn.com/cache/750x750/ts/product/18/33/57/05e0509a45969e8aecbbdc5ded11af81.jpeg",
            "https://salt.tikicdn.com/cache/750x750/ts/product/54/fa/fe/010d40204dad8481cd24018c2b2ffa24.jpg",
            "https://salt.tikicdn.com/cache/750x750/ts/product/14/ba/1b/ae038a66873894817f3bc8554607a395.jpg",
            "https://salt.tikicdn.com/cache/750x750/ts/product/a9/51/b4/0a0b01fab647f3446e8b5fb362db2479.png"
        ]
        
        let baseNames = [
            "iPhone",
            "Thiết Bị Số - Phụ Kiện Số",
            "Cross Border - Hàng Quốc Tế",
            "Công nghệ xả kho Giảm đến nữa giá",
            "Hàng xịn giá sốc",
            "Sách Combo 2 Cuốn : Tư Duy Ngược + Tư Duy Mở",
            "Apple Watch SE 2022 GPS Sport Band",
            "Giày",
            "Mẹ và bé"
        ]
        
        // Tạo 100 mục giả lập
        for i in 1...100 {
            let randomIndex = Int.random(in: 0..<baseNames.count)
            let mockItem = HotKeyword(
                name: "\(baseNames[randomIndex]) \(i)", // Đặt số thứ tự vào tên để tạo ra các mục khác nhau
                icon: baseIcons[randomIndex]
            )
            mockItems.append(mockItem)
        }
        
        return mockItems
    }
}
