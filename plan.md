# Kế hoạch phát triển Pet Finder

## 1. Mục tiêu sản phẩm

Pet Finder không chỉ là ứng dụng đăng tin thú cưng thất lạc. Mục tiêu nên là một nền tảng cộng đồng giúp người nuôi:

- Tìm kiếm thú cưng bị thất lạc.
- Báo cáo thú cưng đi lạc hoặc được tìm thấy.
- Lưu hồ sơ thú cưng để dùng lâu dài.
- Nhận cảnh báo theo khu vực.
- Theo dõi lịch chăm sóc cơ bản.
- Kết nối cộng đồng, phòng khám, pet shop và nhóm cứu hộ.

Định vị đề xuất:

> Nền tảng cộng đồng giúp tìm kiếm, nhận diện, chăm sóc và kết nối người nuôi thú cưng.

## 2. Công nghệ sử dụng

- Flutter: xây dựng ứng dụng mobile đa nền tảng.
- Firebase Authentication: đăng nhập bằng email, số điện thoại hoặc tài khoản bên thứ ba.
- Cloud Firestore: lưu dữ liệu người dùng, thú cưng, bài đăng, báo cáo, tin nhắn và nhắc lịch.
- Firebase Cloud Messaging: gửi thông báo khi có bài thất lạc gần vị trí người dùng.
- Firebase Cloud Functions: xử lý logic phía server như tạo cảnh báo theo bán kính, chống spam, đồng bộ trạng thái.
- Firebase Analytics và Crashlytics: theo dõi hành vi và lỗi runtime.
- Cloudinary: lưu ảnh thú cưng, ảnh bài đăng, ảnh báo nhìn thấy và tối ưu ảnh theo kích thước thiết bị.

## 3. Module chính

### 3.1. Xác thực và hồ sơ người dùng

- Đăng ký, đăng nhập, đăng xuất.
- Quản lý tên, avatar, số điện thoại, khu vực sinh sống.
- Xác minh số điện thoại trước khi đăng bài hoặc liên hệ.
- Quản lý danh sách bài đã đăng, thú cưng đã lưu, thông báo và thiết lập riêng tư.

### 3.2. Hồ sơ thú cưng

- Tạo hồ sơ cho từng thú cưng.
- Lưu tên, loài, giống, giới tính, ngày sinh, màu lông, đặc điểm nhận dạng, microchip nếu có.
- Lưu nhiều ảnh qua Cloudinary.
- Lưu ghi chú y tế, lịch tiêm, tẩy giun, grooming.
- Cho phép bấm nhanh "Báo mất thú cưng này" để tạo bài đăng từ hồ sơ có sẵn.

### 3.3. Lost & Found

- Đăng tin mất thú cưng.
- Đăng tin tìm thấy thú cưng.
- Danh sách bài đăng theo vị trí gần người dùng.
- Bộ lọc theo loài, giống, màu, khu vực, thời gian và trạng thái.
- Chi tiết bài đăng với ảnh, mô tả, vị trí, thời gian, thông tin liên hệ.
- Nút báo "Tôi đã nhìn thấy" kèm vị trí, ảnh và ghi chú.
- Trạng thái bài đăng: `active`, `possible_match`, `resolved`, `closed`, `reported`.

### 3.4. Bản đồ cộng đồng

- Hiển thị thú cưng đang thất lạc.
- Hiển thị thú cưng được tìm thấy.
- Hiển thị các lần nhìn thấy gần đây.
- Hỗ trợ lớp dữ liệu phòng khám, pet shop, grooming và nhóm cứu hộ ở phase sau.
- Marker màu khác nhau theo loại dữ liệu và trạng thái.

### 3.5. Cảnh báo theo khu vực

- Khi có bài báo mất hoặc tìm thấy, hệ thống gửi thông báo cho người dùng trong bán kính cấu hình.
- MVP dùng bán kính mặc định 3-5 km.
- Phase sau cho phép người dùng chọn bán kính nhận thông báo.
- Cloud Functions chịu trách nhiệm tính toán người nhận thông báo, tránh gửi từ client.

### 3.6. Gợi ý trùng khớp

MVP chưa cần AI phức tạp. Trước mắt dùng matching bán tự động:

- Loài giống nhau.
- Màu lông gần giống.
- Giống hoặc từ khóa giống nhau.
- Vị trí trong bán kính gần.
- Thời gian mất và thời gian tìm thấy hợp lý.
- Đặc điểm nhận dạng trùng từ khóa.

Phase sau có thể thêm AI hoặc image embedding để so khớp ảnh thú cưng.

### 3.7. Chat và liên hệ

- MVP ưu tiên gọi nhanh hoặc mở Zalo/WhatsApp nếu người đăng cho phép.
- Phase sau thêm chat realtime trong app.
- Chat chỉ nên mở giữa người đăng và người báo nhìn thấy hoặc người nhặt được.
- Không hiển thị công khai số điện thoại nếu người dùng chọn ẩn.

### 3.8. Nhắc lịch chăm sóc

- Nhắc lịch tiêm phòng.
- Nhắc lịch tẩy giun.
- Nhắc lịch khám thú y.
- Nhắc lịch tắm/grooming.
- Nhật ký sức khỏe cơ bản.

Module này giúp người dùng mở app thường xuyên hơn, không chỉ khi mất thú cưng.

### 3.9. Cộng đồng và nhận nuôi

Để sau MVP chính.

- Bài viết hỏi đáp về chăm sóc thú cưng.
- Nhóm cộng đồng theo khu vực.
- Đăng tin tìm chủ mới.
- Nhóm cứu hộ đăng bài nhận nuôi.
- Form xin nhận nuôi và cam kết nhận nuôi.

## 4. Lộ trình MVP

### Phase 0: Nền tảng dự án

- Cấu hình Flutter project.
- Thêm Firebase vào Android/iOS.
- Cấu hình Cloudinary upload preset hoặc upload API an toàn qua Cloud Functions.
- Thiết lập routing, theme, folder structure.
- Thiết lập state management.
- Thiết lập môi trường dev, staging, production.

Kết quả: app chạy ổn, có cấu trúc sẵn để phát triển.

### Phase 1: MVP Lost & Found

- Đăng nhập, đăng ký, đăng xuất.
- Tạo và chỉnh sửa hồ sơ người dùng.
- Tạo hồ sơ thú cưng.
- Upload ảnh thú cưng lên Cloudinary.
- Tạo bài báo mất thú cưng.
- Tạo bài báo tìm thấy thú cưng.
- Danh sách bài đăng gần đây.
- Chi tiết bài đăng.
- Liên hệ nhanh qua điện thoại hoặc app chat ngoài.
- Đóng bài khi đã tìm thấy.

Kết quả: người dùng có thể đăng và tìm bài lost/found cơ bản.

### Phase 2: Bản đồ và cảnh báo

- Thêm vị trí cho bài đăng.
- Hiển thị bài đăng trên bản đồ.
- Tìm bài theo khoảng cách.
- Lưu FCM token của người dùng.
- Gửi push notification theo khu vực.
- Báo "Tôi đã nhìn thấy" kèm vị trí.

Kết quả: app có giá trị thực tế hơn nhờ vị trí và thông báo nhanh.

### Phase 3: Matching và kiểm duyệt

- Gợi ý bài mất có khả năng trùng với bài tìm thấy.
- Gợi ý bài tìm thấy có khả năng trùng với bài mất.
- Báo cáo bài viết sai hoặc lừa đảo.
- Admin/moderator duyệt hoặc ẩn bài.
- Giới hạn số bài đăng trong một khoảng thời gian để chống spam.

Kết quả: dữ liệu sạch hơn, tăng khả năng tìm đúng thú cưng.

### Phase 4: Retention và cộng đồng

- Nhắc lịch chăm sóc.
- Nhật ký sức khỏe.
- Lưu bài quan tâm.
- Chat realtime trong app.
- Trang cộng đồng theo khu vực.

Kết quả: người dùng có lý do quay lại app thường xuyên.

### Phase 5: Mở rộng kinh doanh

- Địa điểm phòng khám, pet shop, grooming trên bản đồ.
- Gói đẩy tin cho bài mất thú cưng.
- Alert bán kính mở rộng.
- In poster mất thú cưng dạng PDF.
- Affiliate sản phẩm thú cưng.
- Gói premium cho chủ nuôi nhiều thú cưng.

Kết quả: bắt đầu có hướng kiếm tiền sau khi cộng đồng và dữ liệu đủ mạnh.

## 5. Gợi ý cấu trúc dữ liệu Firestore

```txt
users/{userId}
  name
  phone
  email
  avatarUrl
  homeLocation
  notificationRadiusKm
  isPhoneVerified
  role
  createdAt
  updatedAt

pets/{petId}
  ownerId
  name
  type
  breed
  gender
  birthDate
  color
  photoUrls
  specialMarks
  microchipNumber
  medicalNotes
  createdAt
  updatedAt

lost_reports/{reportId}
  petId
  ownerId
  title
  description
  lastSeenGeoPoint
  lastSeenAddress
  lostAt
  rewardNote
  status
  contactPhone
  isContactPhoneVisible
  photoUrls
  createdAt
  updatedAt

found_reports/{reportId}
  reporterId
  type
  breedGuess
  color
  foundGeoPoint
  foundAddress
  foundAt
  description
  photoUrls
  status
  createdAt
  updatedAt

sightings/{sightingId}
  reportType
  reportId
  userId
  geoPoint
  address
  note
  photoUrls
  createdAt

match_suggestions/{matchId}
  lostReportId
  foundReportId
  score
  reasons
  status
  createdAt

chats/{chatId}
  reportType
  reportId
  members
  lastMessage
  updatedAt

chats/{chatId}/messages/{messageId}
  senderId
  text
  imageUrls
  createdAt

reminders/{reminderId}
  petId
  userId
  type
  title
  dueAt
  repeatType
  isDone
  createdAt
  updatedAt

reports/{moderationReportId}
  targetType
  targetId
  reporterId
  reason
  status
  createdAt
```

## 6. Màn hình ưu tiên

1. Splash.
2. Onboarding ngắn.
3. Login/Register.
4. Home feed Lost & Found.
5. Create Lost Report.
6. Create Found Report.
7. Report Detail.
8. Map.
9. Pet Profile List.
10. Pet Profile Detail.
11. Sighting Form.
12. Notifications.
13. User Profile.
14. Moderator/Admin screen nội bộ.

## 7. Chỉ số cần theo dõi

- Số người đăng ký.
- Số hồ sơ thú cưng được tạo.
- Số bài báo mất.
- Số bài báo tìm thấy.
- Số lượt báo nhìn thấy.
- Tỉ lệ bài được đóng với trạng thái đã tìm thấy.
- Thời gian trung bình từ lúc đăng đến lúc có sighting đầu tiên.
- Tỉ lệ người bật thông báo.
- Tỉ lệ người quay lại sau 7 ngày và 30 ngày.

## 8. Rủi ro cần kiểm soát

- Spam bài đăng.
- Lừa đảo tiền hậu tạ.
- Lộ số điện thoại hoặc vị trí nhạy cảm.
- Ảnh không phù hợp.
- Dữ liệu vị trí không chính xác.
- Chi phí Cloudinary/Firebase tăng khi upload ảnh nhiều.
- Tên "Pet Finder" có thể gần với thương hiệu "Petfinder" nếu publish quốc tế.

## 9. Nguyên tắc ưu tiên

- Làm Lost & Found thật tốt trước khi mở rộng nhận nuôi hoặc marketplace.
- Ưu tiên tốc độ đăng bài khi người dùng đang mất thú cưng.
- Ưu tiên dữ liệu vị trí, ảnh rõ, mô tả đặc điểm và liên hệ nhanh.
- Không đưa AI matching vào MVP nếu chưa có dữ liệu đủ sạch.
- Không kiếm tiền quá sớm bằng quảng cáo nếu cộng đồng chưa có giá trị.
