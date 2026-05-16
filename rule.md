# Quy tắc phát triển Pet Finder

## 1. Quy tắc chung

- Ứng dụng dùng Flutter, Firebase và Cloudinary.
- Trước khi triển khai task, phải đọc các thư mục và tệp trong .agent (nếu có) vì chúng chứa định nghĩa agent, skills và các quy tắc chi tiết cần tuân thủ.
- Viết code dễ đọc, tách rõ UI, state, repository/service và model.
- Không đặt secret key trong source code client.
- Không để client ghi dữ liệu nhạy cảm nếu chưa qua rule hoặc Cloud Functions.
- Mọi dữ liệu có `createdAt` và `updatedAt` phải dùng server timestamp.
- Mọi lỗi từ Firebase, Cloudinary và network phải có xử lý UI rõ ràng.
- Không commit file môi trường chứa secret.

## 2. Cấu trúc thư mục Flutter đề xuất

```txt
lib/
  app/
    app.dart
    router.dart
    theme.dart
  core/
    constants/
    errors/
    extensions/
    utils/
    widgets/
  features/
    auth/
      data/
      domain/
      presentation/
    profile/
      data/
      domain/
      presentation/
    pets/
      data/
      domain/
      presentation/
    reports/
      data/
      domain/
      presentation/
    map/
      data/
      domain/
      presentation/
    notifications/
      data/
      domain/
      presentation/
    reminders/
      data/
      domain/
      presentation/
  firebase_options.dart
  main.dart
```

## 3. Quy tắc đặt tên

- File Dart dùng `snake_case.dart`.
- Class, enum, extension dùng `PascalCase`.
- Variable, function, method dùng `camelCase`.
- Firestore collection dùng `snake_case`, ví dụ `lost_reports`.
- Firestore field dùng `camelCase`, ví dụ `ownerId`, `createdAt`.
- Trạng thái dùng enum ở Dart và string cố định ở Firestore.

Ví dụ trạng thái bài đăng:

```txt
active
possible_match
resolved
closed
reported
```

## 4. Quy tắc UI/UX

- Người dùng phải tạo bài báo mất hoặc báo tìm thấy trong ít bước nhất có thể.
- Form đăng bài phải hỗ trợ lưu nháp nếu có nhiều trường.
- Ảnh, vị trí, thời gian và thông tin liên hệ là dữ liệu quan trọng nhất của bài đăng.
- Không ép người dùng nhập quá nhiều ở MVP.
- Mọi màn hình cần có loading, empty state và error state.
- Nút liên hệ khẩn cấp phải dễ thấy trong trang chi tiết bài đăng.
- Với dữ liệu vị trí, phải hiển thị cảnh báo quyền riêng tư nếu vị trí quá chính xác.

## 5. Quy tắc Firebase Authentication

- Chỉ người dùng đã đăng nhập mới được tạo hồ sơ thú cưng, tạo bài đăng, báo nhìn thấy hoặc chat.
- Chỉ người tạo dữ liệu mới được sửa dữ liệu của họ, trừ admin/moderator.
- Nên xác minh số điện thoại trước khi cho đăng bài công khai hoặc liên hệ trực tiếp.
- Không dùng UID để suy đoán quyền admin ở client. Quyền admin phải nằm trong custom claims hoặc document role được bảo vệ.

## 6. Quy tắc Firestore

- Không đọc toàn bộ collection lớn ở client.
- Mọi danh sách phải dùng pagination.
- Query feed phải có index phù hợp.
- Dữ liệu vị trí cần chuẩn bị cho geospatial query. Nếu dùng geohash, lưu cả `geoPoint` và `geohash`.
- Không lưu ảnh base64 trong Firestore.
- Không lưu dữ liệu dư thừa nếu có thể lấy từ document liên quan, trừ các trường cần denormalize để tối ưu feed.
- Khi xóa bài, ưu tiên soft delete bằng `status` hoặc `deletedAt`.

## 7. Quy tắc bảo mật Firestore

Security Rules cần đảm bảo:

- User chỉ đọc được dữ liệu public hoặc dữ liệu của chính họ.
- User chỉ tạo/sửa hồ sơ thú cưng nếu `ownerId == request.auth.uid`.
- User chỉ tạo lost report nếu `ownerId == request.auth.uid`.
- User chỉ sửa report của chính họ.
- User không được tự sửa các field kiểm duyệt như `moderationStatus`, `reportedCount`, `isFeatured`.
- Moderator/admin mới được ẩn bài, khóa bài hoặc xử lý report.
- Tin nhắn chỉ đọc/ghi bởi thành viên trong chat.
- Sighting chỉ tạo bởi user đăng nhập.

## 8. Quy tắc Cloudinary

- Client không được chứa Cloudinary API secret.
- Nếu dùng unsigned upload preset, preset phải giới hạn folder, định dạng, kích thước và loại file.
- Với upload cần kiểm soát cao, dùng Cloud Functions để ký upload.
- Chỉ cho phép ảnh `jpg`, `jpeg`, `png`, `webp`.
- Giới hạn số ảnh mỗi hồ sơ và mỗi bài đăng.
- Ảnh phải được resize/compress trước hoặc dùng transformation của Cloudinary khi hiển thị.
- Lưu trong Firestore URL đã tối ưu hoặc public ID để có thể tạo URL biến thể.
- Khi bài hoặc hồ sơ bị xóa vĩnh viễn, cần có job dọn ảnh không dùng nữa.

## 9. Quy tắc thông báo

- Lưu FCM token theo user và thiết bị.
- Token hết hạn phải được dọn định kỳ.
- Không gửi thông báo từ client.
- Cloud Functions xử lý fan-out theo bán kính.
- Người dùng phải có quyền bật/tắt loại thông báo.
- Không gửi quá nhiều thông báo cho cùng một sự kiện.
- Nội dung notification không chứa số điện thoại hoặc vị trí quá cụ thể.

## 10. Quy tắc dữ liệu vị trí

- Chỉ xin quyền vị trí khi cần.
- Cho phép người dùng nhập địa chỉ thủ công nếu không cấp quyền GPS.
- Với bài công khai, cân nhắc làm mờ vị trí chính xác bằng bán kính hoặc địa chỉ tương đối.
- Không hiển thị vị trí nhà riêng của người dùng nếu không có xác nhận rõ.
- Sighting có thể lưu vị trí chính xác hơn, nhưng chỉ người liên quan nên xem chi tiết.

## 11. Quy tắc chống spam và lừa đảo

- Giới hạn số bài đăng mỗi user trong một khoảng thời gian.
- Giới hạn số lần báo nhìn thấy cho cùng một bài.
- Cho phép report bài viết, user và tin nhắn.
- Bài có nhiều report phải chuyển sang trạng thái cần kiểm duyệt.
- Không để app đứng ra giữ tiền hậu tạ trong MVP.
- Nếu có hậu tạ, chỉ lưu dạng ghi chú tự nguyện của chủ nuôi.
- Không khuyến khích chuyển tiền trước khi xác minh thú cưng.

## 12. Quy tắc model Dart

- Model phải có `fromJson` và `toJson` rõ ràng.
- Không parse Firestore document trực tiếp trong widget.
- Timestamp, GeoPoint và enum phải được convert ở data layer.
- Field nullable phải phản ánh đúng dữ liệu có thể thiếu.
- Không dùng dynamic tràn lan ngoài boundary parse dữ liệu.

## 13. Quy tắc state management

- Không gọi Firebase trực tiếp từ widget.
- Widget chỉ gọi controller/provider/bloc.
- Repository chịu trách nhiệm giao tiếp Firebase hoặc Cloudinary.
- State phải biểu diễn rõ `initial`, `loading`, `success`, `empty`, `failure`.
- Không dùng `setState` cho business logic phức tạp.

## 14. Quy tắc form và validation

- Tên thú cưng, loài, màu lông, vị trí và thời gian là thông tin quan trọng khi báo mất.
- Ảnh nên bắt buộc với bài báo mất và bài báo tìm thấy.
- Số điện thoại phải validate theo định dạng phù hợp.
- Không cho submit nhiều lần khi request đang chạy.
- Nếu upload ảnh thành công nhưng ghi Firestore thất bại, cần rollback hoặc đánh dấu ảnh tạm để dọn sau.

## 15. Quy tắc lỗi và logging

- Lỗi người dùng có thể tự sửa thì hiển thị message dễ hiểu.
- Lỗi hệ thống ghi Crashlytics hoặc logger phù hợp.
- Không log access token, phone, exact location hoặc URL ký upload có secret.
- Mọi thao tác quan trọng nên có try/catch ở repository hoặc use case.

## 16. Quy tắc test

- Unit test cho model parse, matching logic và validation.
- Widget test cho form đăng bài và empty/error state.
- Integration test cho flow đăng nhập, tạo pet profile, tạo lost report.
- Firestore security rules phải được test riêng nếu bắt đầu viết rules phức tạp.

## 17. Quy tắc hiệu năng

- Dùng pagination cho feed.
- Dùng ảnh thumbnail ở danh sách, ảnh lớn chỉ tải ở trang chi tiết.
- Cache ảnh bằng package phù hợp.
- Không rebuild toàn bộ màn hình khi chỉ một phần state thay đổi.
- Tránh query Firestore lặp lại khi quay lại màn hình.
- Dùng composite index cho query lọc theo status, type, createdAt, location/geohash.

## 18. Quy tắc release

- Tách môi trường dev, staging, production.
- Firebase project production không dùng chung với dev.
- Cloudinary folder hoặc cloud riêng cho từng môi trường.
- Trước release phải chạy `flutter analyze` và test tối thiểu.
- Không release nếu flow đăng bài, upload ảnh hoặc login bị lỗi.
- Theo dõi Crashlytics sau mỗi bản release.

## 19. Quy tắc mở rộng tính năng

- Không thêm AI matching khi dữ liệu bài đăng còn ít hoặc chưa sạch.
- Không thêm marketplace khi Lost & Found chưa ổn định.
- Không thêm thanh toán cho hậu tạ trong MVP.
- Không thêm quá nhiều tab nếu chưa có nội dung thật.
- Mỗi tính năng mới phải trả lời được: giúp tìm thú cưng nhanh hơn, tăng độ tin cậy, hoặc tăng lý do quay lại app.

## 20. Definition of Done

Một task được xem là hoàn thành khi:

- UI chạy được trên màn hình mục tiêu.
- Có loading, error và empty state nếu cần.
- Dữ liệu đọc/ghi đúng Firestore.
- Ảnh upload đúng Cloudinary nếu task liên quan đến ảnh.
- Không lộ secret ở client.
- Có xử lý quyền truy cập và lỗi mạng.
- Code đã được format.
- `flutter analyze` không có lỗi mới.
- Có test hoặc ghi rõ lý do chưa test được.

## 21. Router (Điều hướng)

- Sử dụng `go_router` làm router chính của ứng dụng.
- Đặt cấu hình router tập trung trong `lib/app/router.dart` và import vào `app.dart`.
- Sử dụng route names, path params và query params rõ ràng; tách các route public và các route cần xác thực.
- Bảo vệ route yêu cầu đăng nhập bằng `redirect` hoặc `refreshListenable` của `go_router` (không kiểm tra quyền trực tiếp bằng UID ở client).
- Hỗ trợ deep link và chia sẻ link bài viết (shareable links) qua `go_router` config.
- Viết unit test cho navigation logic khi có guard hoặc redirect.

## 22. Kiến trúc dự án

- Áp dụng Clean Architecture (feature-based) để phù hợp với quy mô và khả năng mở rộng của Pet Finder.
- Mỗi feature tách thành thư mục dưới `lib/features/<feature>/` với 3 layer chính:
  - `domain/`: entity, repository interface, usecases (business logic, không phụ thuộc vào framework).
  - `data/`: implementation của repository, models/DTO, mappers, data sources (Firebase, Cloudinary, local cache).
  - `presentation/`: UI, widgets, pages, bloc/cubit, viewmodels (chỉ phụ thuộc vào domain interfaces).
- Dùng repository pattern để tách nguồn dữ liệu; chỉ repository giao tiếp trực tiếp với Firebase/Cloudinary.
- Tách rõ các lớp mapper/DTO để tránh parse trực tiếp trong widget.
- Đặt các dependency injection (GetIt hoặc Riverpod's ProviderScope nếu cần) ở `app.dart` hoặc một module khởi tạo riêng.
- Viết unit test cho `usecase` và `repository` mock bằng interface.

## 23. Quản lý state

- Sử dụng `flutter_bloc` (Bloc + Cubit) làm chuẩn cho state management.
- Quy tắc chung:
  - Mỗi màn hình/feature chính có một hoặc vài Bloc/Cubit riêng nằm trong `presentation/bloc/`.
  - Bloc xử lý các event/phức tạp; Cubit dùng cho state đơn giản, local UI state.
  - Không thực hiện I/O trực tiếp trong Bloc: delegate cho `usecase` hoặc `repository`.
  - State nên là immutable và dễ test; biểu diễn rõ các trạng thái: `initial`, `loading`, `success`, `empty`, `failure`.
  - Dùng `bloc_test` để unit test các Bloc/Cubit.
- Tổ chức DI cho Bloc tại cấp feature hoặc page, không ở widget con sâu.
- Tránh đặt logic điều hướng trong Bloc; emit state rồi let UI handle navigation when listening to state.

## 24. Lưu dữ liệu local

- Dùng `SharedPreferences` cho key-value đơn giản (cấu hình, flags, small cache).
- Không lưu dữ liệu nhạy cảm (tokens, phone, exact location) vào `SharedPreferences` không mã hóa.
- Đóng gói `SharedPreferences` trong một lớp wrapper (ví dụ `LocalStorageService`) và expose interface để dễ mock trong test.
- Với preference đơn giản dùng chung toàn app như `localeCode`, `hasSeenOnboarding`, theme hoặc UI flags, dùng một service chung trong `core` (ví dụ `AppPreferences`), không tạo nhiều `FeatureStorage` chỉ để bọc `SharedPreferences`.
- Không lưu trạng thái đăng nhập bằng bool local như `isLoggedIn`; nguồn sự thật đăng nhập phải đến từ Firebase Authentication hoặc `AuthRepository/AuthCubit`.
- Tạo file `lib/core/local/local_storage.dart` (interface) và `lib/core/local/shared_prefs_storage.dart` (cài đặt `SharedPreferences`).
- Đặt tất cả keys vào một nơi tập trung (`core/constants/keys.dart`) để tránh xâu ký tự rải rác.
- Nếu cần lưu collection phức tạp hoặc offline-first, cân nhắc `Hive` hoặc `sembast` thay vì `SharedPreferences`.
- Khi migrate key hoặc schema local, cung cấp cơ chế migration và versioning.

## 25. Checklist khi scaffold code liên quan

- Tạo `lib/app/router.dart` với cấu hình `go_router` và các route guard cơ bản.
- Tạo mẫu feature theo Clean Architecture (`domain/data/presentation`) cho một feature mới.
- Thêm example `Bloc`/`Cubit` và `bloc_test` template.
- Thêm `LocalStorageService` wrapper và đăng ký dependency.
