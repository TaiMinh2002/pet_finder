# Tính năng ứng dụng Pet Finder (theo code hiện tại)

Tài liệu này mô tả **các tính năng đang có trong `lib/`**, **tác dụng chi tiết**, và **luồng chạy màn hình** dựa trên cấu hình `go_router` trong `lib/app/router.dart` và các màn hình trong `lib/features/**`.

> Ghi chú quan trọng:
> - Hiện tại phần lớn dữ liệu đang là **mock/demo** qua `lib/features/mock/mock_data.dart`.
> - Điều hướng đăng nhập đang dùng **mock auth** qua `MockAuthController` trong `lib/app/router.dart` (chưa phải Firebase Auth).
> - Tài liệu này **bám đúng những màn hình có thật trong code**. Mọi đề xuất mở rộng sẽ được ghi rõ là “Đề xuất”.

---

## Tổng quan cấu trúc `lib/`

- **`lib/main.dart`**
  - Khởi tạo Flutter binding, load locale, rồi chạy `PetFinderApp`.
- **`lib/app/app.dart`**
  - `MaterialApp.router` + theme (`AppTheme.light`) + localization delegates + `routerConfig: appRouter`.
- **`lib/app/router.dart`**
  - Khai báo toàn bộ route (`AppRoute`) và guard/redirect theo trạng thái đăng nhập (mock).
- **`lib/core/`**
  - Nơi đặt các thành phần dùng chung: navigation helpers, localization helpers, widget dùng lại (button, card, bottom nav…).
- **`lib/app/theme/`**
  - Design system: colors, text styles, spacing, radius, shadows, gradients, theme.
- **`lib/features/`**
  - Mỗi tính năng (auth, reports, pets, map, chat, community, reminders, notifications, profile, language, onboarding…).
- **`lib/l10n/`**
  - App localization (`app_localizations*.dart`) và `.arb`.

---

## Luồng điều hướng tổng thể (theo `GoRouter`)

### Route guard: public vs authenticated

Trong `lib/app/router.dart` có 2 nhóm route:

- **Public (không cần đăng nhập)**: splash, onboarding, welcome/login/sign-up/forgot/otp/success.
- **Authenticated (cần đăng nhập)**: home, map, notifications, reports, pets, profile, chat, community, reminders…

Luật redirect hiện tại:

- **Chưa đăng nhập** mà vào route “cần đăng nhập” → bị redirect về `WelcomeScreen` (`/auth/welcome`).
- **Đã đăng nhập** mà vào route “public” → bị redirect về `HomeDashboardScreen` (`/home`).

### Trạng thái đăng nhập hiện tại là mock

- `MockAuthController` giữ flag `_isAuthenticated`.
- `mockAuth.signIn()` được gọi ở **`AccountSuccessScreen`** sau khi submit login/sign-up demo.
- `mockAuth.signOut()` được gọi ở **`ProfileOverviewScreen`** khi logout.

---

## User journey (mô tả theo hành trình người dùng)

Phần này mô tả hành trình điển hình từ lúc mở app → đăng nhập → sử dụng các tính năng chính.  
Các route được ghi theo `AppRoute` trong `lib/app/router.dart`.

### 1) Mở app lần đầu

1. App start → `SplashScreen` (`/`)
   - Tự chuyển sang onboarding sau ~2 giây (hoặc user chạm vào loading dots).
2. `OnboardingScreen` (`/onboarding`)
   - 3 trang onboarding (lost alert, map nearby, reunion).
   - Có nút **Skip** hoặc **Get started** → sang `WelcomeScreen`.
3. `WelcomeScreen` (`/auth/welcome`)
   - CTA:
     - “Tạo tài khoản” → `SignUpScreen` (`/auth/sign-up`)
     - “Đăng nhập” → `LoginScreen` (`/auth/login`)

Điều kiện:
- Nếu user đã “đăng nhập” (mock) mà quay lại onboarding/auth → router redirect về `/home`.

### 2) Đăng nhập / tạo tài khoản (demo)

Luồng đăng nhập demo (tương tự sign-up/otp demo):

1. `LoginScreen` (`/auth/login`)
   - Nhập email/phone + password (UI).
   - Submit → giả lập delay → điều hướng sang `AccountSuccessScreen`.
2. `AccountSuccessScreen` (`/auth/success`)
   - “Continue” → `mockAuth.signIn()` → snack bar → về `HomeDashboardScreen` (`/home`).

Điều kiện:
- Từ thời điểm `mockAuth.signIn()` → mọi route “authenticated” đều truy cập được.

Đề xuất:
- Tách `MockAuthController` ra khỏi `router.dart` (để tránh file router ôm state) và thay thế bằng auth thật (FirebaseAuth / repository + bloc/cubit) ở phase sau.

### 3) Trang Home (điểm vào của ứng dụng sau đăng nhập)

Màn hình: `HomeDashboardScreen` (`/home`)

Vai trò:
- Tổng hợp nhanh tình hình khu vực + các CTA để đi tới map, pets, community, reminders.
- Hiển thị “urgent alerts” dựa trên `MockData.reports` (lọc `PetReportType.lost`).

Điều hướng nổi bật:
- “View map” → `/map`
- Quick actions → `/map`, `/pets`, `/community`, `/reminders`
- Nút “+” giữa bottom nav → mở flow tạo report `/reports/create`

Bottom navigation (home context):
- Tab Home → `/home`
- Tab Map → `/map`
- Tab Pets → `/pets`
- Tab Profile → `/profile`
- Nút giữa “+” → `/reports/create`

### 4) Tạo report “Lost / Found” (luồng 7 bước)

Màn hình: `ReportFlowScreen` (`/reports/create`)

Route đặc biệt:
- Có thể truyền query param `type`:
  - `?type=lost` → khởi tạo lost
  - `?type=found` → khởi tạo found

Luồng bước (theo `ReportFlowScreen` + `report_flow_steps.dart`):
- Bước 1/7: chọn loại report (lost/found)
- Bước 2/7: upload photos (UI demo)
- Bước 3/7: thông tin thú (pet info)
- Bước 4/7: vị trí + thời gian
- Bước 5/7: thông tin liên hệ + hiển thị số điện thoại (privacy)
- Bước 6/7: review
- Bước 7/7: success → về home

Điều hướng:
- Back ở bước 0 → về home (qua `safeBackNamed(AppRoute.home)`).

Đề xuất:
- Hiện tại đây là “UI flow + draft local”. Phase tích hợp backend nên:
  - Lưu draft thật (local storage) nếu cần,
  - Submit repository → Firestore,
  - Upload ảnh → Cloudinary (không để secret trên client).

### 5) Xem chi tiết report

Màn hình: `ReportDetailScreen` (`/reports/:reportId`)

Nguồn dữ liệu:
- `MockData.tryResolveReport(reportId)`; nếu không tìm thấy → hiện error state + nút quay về home.

Tác vụ chính:
- Xem ảnh, badge lost/found/reunited, mô tả, key details (last update, area, status…).
- CTA:
  - **Contact**: nếu có chat ứng với report (`MockData.resolveChatForReport`) → mở `ChatDetailScreen`; nếu không có → mở `ChatListScreen`.
  - **View map**: mở `/map`.

### 6) Xem bản đồ cảnh báo gần đây (Map)

Màn hình: `NearbyAlertsMapScreen` (`/map`)

Vai trò:
- Hiển thị marker báo lost/found/urgent/reunited trên bản đồ.
- Xin quyền vị trí (qua `MapLocationService` + state `MapCubit/MapState`).
- Cho phép lọc marker (chips), tìm kiếm (search bar UI), xem preview strip, mở sheet chi tiết marker.

Luồng trạng thái:
- `initialize()` → loading → nếu có quyền → map; nếu từ chối/disabled → permission view.

Từ map đi tới:
- Notifications (tap icon trên `MapSearchBar`) → `/notifications`
- Xem chi tiết marker → route `/reports/:reportId`
- Nút “+” ở bottom nav → `/reports/create`

### 7) Pets: quản lý hồ sơ thú cưng

Màn hình chính: `MyPetsListScreen` (`/pets`)

Vai trò:
- Liệt kê danh sách pet từ `MockData.pets`.
- Nếu rỗng → hiển thị `PetsEmptyCard` (có CTA “Add”).

Từ danh sách pets:
- Add pet → `AddPetProfileScreen` (`/pets/add`)
- Xem chi tiết pet → `PetProfileDetailScreen` (`/pets/:petId`)
- “Report lost” nhanh từ card → `/reports/create?type=lost`
- Có nút “preview empty” → `/pets-empty` (màn demo empty state)

Chi tiết pet:
- `PetProfileDetailScreen` (`/pets/:petId`)
  - Hiển thị hero, thông tin cơ bản/ID/health, reminder tag.
  - CTA:
    - Edit pet → `/pets/:petId/edit`
    - Open reminders → `/reminders`
    - Emergency card: report lost nhanh → `/reports/create?type=lost`

Add pet:
- `AddPetProfileScreen` (`/pets/add`)
  - Form demo + delay save → snack bar → quay về `/pets`.

### 8) Reminders: nhắc lịch chăm sóc

Màn hình chính: `RemindersOverviewScreen` (`/reminders`)

Vai trò:
- Tập hợp reminders từ `MockData.reminders`.
- Nhóm theo bucket (Today / Tomorrow / This week / Later…).
- CTA add:
  - Nút “+” trên header hoặc nút add → `AddReminderScreen` (`/reminders/add`)

Add/Edit reminder:
- `AddReminderScreen` (`/reminders/add`)
- Edit route: `AddReminderScreen(reminderId)` qua `/reminders/:reminderId/edit`
  - Nếu có `reminderId` → load dữ liệu mock để edit.
  - Save demo → điều hướng về detail `/reminders/:reminderId`.

Reminder detail:
- `ReminderDetailScreen` (`/reminders/:reminderId`)
  - Nếu không tìm thấy reminder → error state, quay về overview.
  - CTA:
    - Complete → `/reminders/completed`
    - Edit → `/reminders/:reminderId/edit`
    - Delete → về `/reminders`

### 9) Notifications: xem thông báo và deep-link nội bộ

Màn hình: `NotificationsScreen` (`/notifications`)

Nguồn dữ liệu:
- `MockData.notifications`

Hành vi khi tap một notification:
- Nếu có `reminderId` → mở `ReminderDetailScreen` (`/reminders/:reminderId`)
- Nếu có `chatId` → mở `ChatDetailScreen` (`/chat/:chatId`)
- Nếu có `reportId` → mở `ReportDetailScreen` (`/reports/:reportId`)

Đề xuất:
- Phase sau có thể map notification payload (FCM) → route tương ứng để hỗ trợ deep-link từ hệ thống.

### 10) Chat: danh sách và hội thoại

Danh sách:
- `ChatListScreen` (`/chat`)
  - Lấy từ `MockData.chats`, sort theo unreadCount.
  - Tap conversation → `ChatDetailScreen` (`/chat/:chatId`) (thông qua widget tile).

Chi tiết:
- `ChatDetailScreen` (`/chat/:chatId`)
  - Nếu không có chat id hợp lệ → error state → quay về `/chat`.
  - Có quick actions (share location, send photo placeholder, call, view report).
  - Gửi message là demo (append local message + snack bar).

### 11) Community: feed, chi tiết bài viết, tạo bài

Feed:
- `CommunityFeedScreen` (`/community`)
  - Dữ liệu từ `MockData.communityPosts`.
  - Có filter theo `CommunityCategory`, có featured card.
  - CTA tạo bài:
    - FAB / icon → `CreateCommunityPostScreen` (`/community/create`)

Chi tiết:
- `CommunityPostDetailScreen` (`/community/:postId`)
  - Nếu post không tồn tại → error state → quay về feed.
  - Hiển thị bài + reaction row + comments + related posts.

Tạo bài:
- `CreateCommunityPostScreen` (`/community/create`)
  - Composer demo + publish (delay) → snack bar → quay về feed.

### 12) Profile: tổng quan tài khoản + khu vực “cài đặt”

Màn hình: `ProfileOverviewScreen` (`/profile`)

Vai trò:
- Hero card + stat grid (demo) + menu điều hướng tới:
  - My reports → `/profile/my-reports`
  - Saved reports → `/profile/saved-reports`
  - Notifications → `/notifications`
  - Settings → `/profile/settings`
  - Help & support → `/profile/help`
  - Logout → gọi `mockAuth.signOut()` và điều hướng về `/auth/welcome`

My reports:
- `MyReportsScreen` (`/profile/my-reports`)
  - Tab filter theo trạng thái: active / resolved / closed (lọc từ `MockData.myReports`).
  - Tap report card → `/reports/:reportId`

Saved reports:
- `SavedReportsScreen` (`/profile/saved-reports`)
  - Lọc theo `MockData.savedReportIds` trên `MockData.allReports`.
  - Tap report card → `/reports/:reportId`

Help & support:
- `HelpSupportScreen` (`/profile/help`)
  - Các card “contact support / report problem / safety / emergency tips” + FAQ.

Settings:
- `SettingsScreen` (`/profile/settings`)
  - Các toggle demo:
    - Nearby alerts
    - Chat notifications
    - Exact location
    - Dark mode (UI toggle, chưa gắn theme)
  - Language row → push route `/profile/language`
  - Save settings demo (delay) + snack bar.

Language:
- `LanguageScreen` (`/profile/language`)
  - Cho chọn `vi/en/ja/ko/zh`, có search.
  - Apply → `appLocaleController.updateLocale(...)` + snack bar.

---

## Danh sách route hiện có (tóm tắt)

### Public

- `/` → `SplashScreen`
- `/onboarding` → `OnboardingScreen`
- `/auth/welcome` → `WelcomeScreen`
- `/auth/login` → `LoginScreen`
- `/auth/sign-up` → `SignUpScreen`
- `/auth/forgot-password` → `ForgotPasswordScreen`
- `/auth/otp` → `OtpVerificationScreen`
- `/auth/success` → `AccountSuccessScreen` (điểm kích hoạt `mockAuth.signIn()`)

### Authenticated (cần đăng nhập mock)

- `/home` → `HomeDashboardScreen`
- `/map` → `NearbyAlertsMapScreen`
- `/notifications` → `NotificationsScreen`
- `/reports/create` → `ReportFlowScreen` (query `type=lost|found`)
- `/reports/:reportId` → `ReportDetailScreen`
- `/pets` → `MyPetsListScreen`
- `/pets/add` → `AddPetProfileScreen`
- `/pets/:petId` → `PetProfileDetailScreen`
- `/pets/:petId/edit` → `EditPetProfileScreen`
- `/pets-empty` → `MyPetsEmptyScreen`
- `/profile` → `ProfileOverviewScreen`
- `/profile/edit` → `EditProfileScreen`
- `/profile/settings` → `SettingsScreen`
- `/profile/language` → `LanguageScreen`
- `/profile/help` → `HelpSupportScreen`
- `/profile/saved-reports` → `SavedReportsScreen`
- `/profile/my-reports` → `MyReportsScreen`
- `/chat` → `ChatListScreen`
- `/chat/:chatId` → `ChatDetailScreen`
- `/community` → `CommunityFeedScreen`
- `/community/:postId` → `CommunityPostDetailScreen`
- `/community/create` → `CreateCommunityPostScreen`
- `/community-empty` → `CommunityEmptyScreen`
- `/reminders` → `RemindersOverviewScreen`
- `/reminders/add` → `AddReminderScreen`
- `/reminders/:reminderId` → `ReminderDetailScreen`
- `/reminders/:reminderId/edit` → `AddReminderScreen(reminderId)`
- `/reminders/completed` → `ReminderCompletedScreen`

---

## Những phần đang là “mock/demo” (rất quan trọng để hiểu đúng)

- **Auth**: `MockAuthController` trong `lib/app/router.dart`
  - Chỉ là một cờ boolean để mô phỏng đăng nhập/đăng xuất.
- **Dữ liệu hiển thị**: `lib/features/mock/mock_data.dart`
  - Pets, reports, myReports, savedReportIds, reminders, notifications, communityPosts, chats đều là dữ liệu cố định.
- **Các thao tác “submit/save/publish/send”**:
  - Nhiều màn dùng `Future.delayed(...)` + snack bar để mô phỏng thành công.
  - Chưa có repository/data layer thật để đọc/ghi Firestore/Cloudinary.

---

## Đề xuất (không có trong code hiện tại, chỉ là gợi ý)

- **Tách mock khỏi production code**
  - Đưa `MockData` và `MockAuthController` vào một layer “demo” rõ ràng (hoặc dùng DI) để dễ thay bằng dữ liệu thật.
- **Đưa business logic ra khỏi UI**
  - Các submit/save hiện đang nằm trong widget state; phase sau nên chuyển sang controller/cubit + repository.
- **Deep link thật**
  - Vì router đã có cấu trúc path param/query param khá rõ, phase FCM có thể map payload → `GoRouter` route để mở thẳng report/chat/reminder.

