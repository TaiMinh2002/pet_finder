# Pet Finder - Flow Documentation

## 1. Tổng quan ứng dụng
- **Pet Finder** là ứng dụng di động giúp người nuôi thú cưng tìm và báo cáo các trường hợp thú cưng bị thất lạc, đồng thời quản lý hồ sơ thú cưng và nhắc lịch chăm sóc.
- Mục tiêu chính: tạo một nền tảng cộng đồng để đăng tin mất / tìm thú cưng, nhận báo cảnh báo khu vực, lưu hồ sơ thú cưng và nhắc lịch chăm sóc.
- Đối tượng người dùng: chủ thú cưng muốn bảo vệ và theo dõi thú cưng của mình, người phát hiện thú cưng thất lạc và cộng đồng yêu thú cưng.
- Các nhóm tính năng chính: Khởi động & onboarding, Xác thực, Trang chủ, Báo cáo mất/đã tìm, Bản đồ cảnh báo, Quản lý thú cưng, Nhắc lịch chăm sóc, Thông báo, Chat & liên hệ, Cộng đồng, Hồ sơ & cài đặt, Ngôn ngữ.

## 2. Danh sách tính năng hiện tại
| Nhóm tính năng | Màn hình / tính năng | Mục đích | Trạng thái hiện tại |
|----------------|----------------------|----------|---------------------|
| Splash & Onboarding | SplashScreen, OnboardingScreen | Giới thiệu và hướng dẫn khởi đầu | Hoạt động |
| Authentication | WelcomeScreen, LoginScreen, SignUpScreen, ForgotPasswordScreen, OtpVerificationScreen, AccountSuccessScreen | Đăng nhập/đăng ký, khôi phục mật khẩu, xác thực OTP | Hoạt động |
| Home Dashboard | HomeDashboardScreen | Hiển thị feed báo cáo mất/đã tìm, truy cập nhanh các tính năng | Hoạt động |
| Lost & Found Report Flow | ReportFlowScreen (tạo báo cáo), ReportDetailScreen (chi tiết báo cáo) | Người dùng tạo và xem chi tiết báo cáo mất hoặc tìm thấy | Hoạt động |
| Map & Nearby Alerts | NearbyAlertsMapScreen | Hiển thị bản đồ các báo cáo gần vị trí người dùng | Hoạt động |
| My Pets | MyPetsListScreen, MyPetsEmptyScreen, AddPetProfileScreen, EditPetProfileScreen, PetProfileDetailScreen | Quản lý hồ sơ thú cưng, thêm/sửa/xem chi tiết | Hoạt động |
| Pet Care Reminders | RemindersOverviewScreen, AddReminderScreen, ReminderDetailScreen, ReminderCompletedScreen | Tạo và quản lý nhắc lịch chăm sóc cho thú cưng | Hoạt động |
| Notifications | NotificationsScreen | Hiển thị thông báo push (cảnh báo khu vực, cập nhật báo cáo) | Hoạt động |
| Chat & Contact | ChatListScreen, ChatDetailScreen | Liên hệ nhanh qua số điện thoại/Zalo hoặc chat nội bộ (công cụ mở rộng) | Hoạt động |
| Community | CommunityFeedScreen, CommunityPostDetailScreen, CreateCommunityPostScreen, CommunityEmptyScreen | Đọc/đăng bài viết cộng đồng, chia sẻ kinh nghiệm chăm sóc | Hoạt động |
| Profile & Settings | ProfileOverviewScreen, EditProfileScreen, SettingsScreen, LanguageScreen, HelpSupportScreen, SavedReportsScreen, MyReportsScreen | Quản lý thông tin người dùng, cài đặt ứng dụng | Hoạt động |
| Language / Multilingual | LanguageScreen | Chọn ngôn ngữ hiển thị | Hoạt động |

## 3. Chi tiết từng tính năng
### Splash & Onboarding
**Mục đích**: Giới thiệu nhanh ứng dụng và quyết định chuyển hướng người dùng tới màn hình onboarding hoặc login tùy thuộc trạng thái đăng nhập.
**Màn hình liên quan**: SplashScreen → OnboardingScreen → (nếu chưa đăng nhập) WelcomeScreen → Login/SignUp.
**Luồng chạy**:
```
SplashScreen
  ↓ (kết thúc animation)
OnboardingScreen (có các slide giới thiệu)
  ↓ (khi người dùng bấm "Bắt đầu")
WelcomeScreen (chọn đăng nhập hoặc đăng ký)
```

### Authentication
**Mục đích**: Cho phép người dùng đăng ký, đăng nhập, khôi phục mật khẩu và xác thực OTP.
**Màn hình liên quan**: WelcomeScreen, LoginScreen, SignUpScreen, ForgotPasswordScreen, OtpVerificationScreen, AccountSuccessScreen.
**Luồng chạy**:
```
WelcomeScreen
  ├─> LoginScreen → OtpVerificationScreen (nếu cần) → HomeDashboard
  └─> SignUpScreen → OtpVerificationScreen → AccountSuccessScreen → HomeDashboard
```

### Home Dashboard
**Mục đích**: Trung tâm điều hướng, hiển thị feed các báo cáo mất/đã tìm gần nhất và các shortcut tới các tính năng khác.
**Màn hình liên quan**: HomeDashboardScreen.
**Luồng chạy**: Người dùng mở app (đã đăng nhập) → HomeDashboardScreen → có thể đi tới: ReportCreate, MapNearby, MyPetsList, Notifications, CommunityFeed, RemindersOverview, ProfileOverview.

### Lost & Found Report Flow
**Mục đích**: Người dùng tạo báo cáo mất hoặc tìm thấy thú cưng, sau đó xem chi tiết và tương tác (báo đã nhìn thấy, liên hệ).
**Màn hình liên quan**: ReportFlowScreen, ReportDetailScreen.
**Luồng chạy**:
```
HomeDashboard → ReportCreate (ReportFlowScreen)
  → Nhập thông tin: ảnh, mô tả, vị trí, thời gian, thông tin liên hệ
  → Lưu → ReportDetailScreen (chi tiết báo cáo)
  → Người khác có thể mở ReportDetailScreen → Bấm "Tôi đã nhìn thấy" → (gửi sighting)
```

### Map & Nearby Alerts
**Mục đích**: Hiển thị trên bản đồ các báo cáo mất và tìm thấy trong bán kính cấu hình, giúp người dùng nhanh chóng nhận cảnh báo khu vực.
**Màn hình liên quan**: NearbyAlertsMapScreen.
**Luồng chạy**:
```
HomeDashboard → MapNearby (NearbyAlertsMapScreen)
  → Bản đồ với các marker màu sắc khác nhau (mất, tìm thấy, sighting)
  → Nhấn marker → xem chi tiết báo cáo → chuyển tới ReportDetailScreen
```

### My Pets
**Mục đích**: Quản lý hồ sơ cá nhân cho từng thú cưng, cho phép tạo, sửa, xem chi tiết và nhanh chóng tạo báo cáo mất từ hồ sơ.
**Màn hình liên quan**: MyPetsListScreen, MyPetsEmptyScreen, AddPetProfileScreen, EditPetProfileScreen, PetProfileDetailScreen.
**Luồng chạy**:
```
HomeDashboard → PetsList (MyPetsListScreen)
  ├─> Nếu không có thú cưng → MyPetsEmptyScreen → AddPetProfileScreen
  ├─> Nhấn một thú cưng → PetProfileDetailScreen (xem chi tiết, nút "Báo mất")
  └─> EditPetProfileScreen (chỉnh sửa thông tin)
```

### Pet Care Reminders
**Mục đích**: Tạo và quản lý nhắc lịch tiêm phòng, tẩy giun, khám sức khỏe cho thú cưng.
**Màn hình liên quan**: RemindersOverviewScreen, AddReminderScreen, ReminderDetailScreen, ReminderCompletedScreen.
**Luồng chạy**:
```
ProfileOverview → RemindersOverviewScreen
  → Thêm nhắc (AddReminderScreen) → Hiển thị trong danh sách → Khi đến hạn → ReminderCompletedScreen
```

### Notifications
**Mục đích**: Thông báo push về báo cáo mới trong bán kính, cập nhật trạng thái báo cáo, nhắc nhở lịch chăm sóc.
**Màn hình liên quan**: NotificationsScreen.
**Luồng chạy**: Khi có sự kiện (mới báo cáo, sighting, reminder) → FCM push → Người dùng mở NotificationsScreen để xem danh sách.

### Chat & Contact
**Mục đích**: Cung cấp kênh liên hệ nhanh (gọi/Zalo) hoặc chat nội bộ giữa người đăng và người báo nhìn thấy.
**Màn hình liên quan**: ChatListScreen, ChatDetailScreen.
**Luồng chạy**:
```
ReportDetailScreen → (nút "Liên hệ") → ChatListScreen → chọn chat → ChatDetailScreen
```

### Community
**Mục đích**: Tạo, đọc, chia sẻ bài viết cộng đồng về chăm sóc, hỏi đáp, chia sẻ kinh nghiệm.
**Màn hình liên quan**: CommunityFeedScreen, CommunityPostDetailScreen, CreateCommunityPostScreen, CommunityEmptyScreen.
**Luồng chạy**:
```
HomeDashboard → CommunityFeedScreen (danh sách bài viết)
  → Tạo bài mới → CreateCommunityPostScreen → Đăng → Trở lại feed
  → Nhấn bài → CommunityPostDetailScreen → (có thể comment, thích)
```

### Profile & Settings
**Mục đích**: Quản lý thông tin cá nhân, cài đặt ứng dụng, ngôn ngữ, trợ giúp, lưu báo cáo đã lưu và báo cáo của mình.
**Màn hình liên quan**: ProfileOverviewScreen, EditProfileScreen, SettingsScreen, LanguageScreen, HelpSupportScreen, SavedReportsScreen, MyReportsScreen.
**Luồng chạy**:
```
HomeDashboard → ProfileOverviewScreen
  → Edit Profile → EditProfileScreen
  → Settings → SettingsScreen → Language → LanguageScreen
  → Help & Support → HelpSupportScreen
  → Saved Reports → SavedReportsScreen
  → My Reports → MyReportsScreen
```

### Language / Multilingual
**Mục đích**: Cho phép người dùng chọn ngôn ngữ hiển thị ứng dụng.
**Màn hình liên quan**: LanguageScreen.
**Luòng chạy**: SettingsScreen → Language → LanguageScreen → chọn ngôn ngữ → quay lại.
