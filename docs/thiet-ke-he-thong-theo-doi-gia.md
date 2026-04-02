# TAI LIEU THIET KE HE THONG THEO DOI GIA VANG VA XANG DAU

## 1. Muc tieu

Xay dung he thong theo doi gia vang va gia xang dau gom:

- Frontend su dung VueJS.
- Backend su dung Java, uu tien Spring Boot.
- Xac thuc dang nhap bang OAuth2 voi Google va Facebook.
- Ho tro xem gia hien tai, lich su bien dong, tim kiem, loc du lieu, canh bao bien dong gia trong cac buoc sau.

Tai lieu nay dung de:

- Dinh huong kien truc tong the.
- Chia module can xay dung.
- Xac dinh API va du lieu.
- Lam checklist cho team FE/BE bat dau implement.

---

## 2. Pham vi chuc nang phien ban dau

### 2.1 Chuc nang nguoi dung

1. Xem dashboard tong quan:
   - Gia vang moi nhat.
   - Gia xang dau moi nhat.
   - Muc tang/giam so voi lan cap nhat truoc.
2. Xem chi tiet theo tung nhom:
   - Vang: SJC, 9999, nhan, vang the gioi quy doi.
   - Xang dau: RON95, E5 RON92, DO, dau hoa, mazut.
3. Xem lich su gia theo moc thoi gian:
   - Theo ngay.
   - Theo tuan.
   - Theo thang.
4. Dang nhap/dang xuat bang:
   - Google OAuth2.
   - Facebook OAuth2.
5. Quan ly ho so nguoi dung co ban:
   - Ten hien thi.
   - Email.
   - Anh dai dien.
   - Nha cung cap dang nhap.
6. Luu danh sach theo doi yeu thich:
   - Loai gia quan tam.
   - Bo loc mac dinh.

### 2.2 Chuc nang quan tri/noi bo

1. Dong bo du lieu gia tu nguon ben ngoai hoac nhap tay.
2. Quan ly danh muc:
   - Loai vang.
   - Loai xang dau.
   - Nguon du lieu.
3. Theo doi lich su dong bo va log loi.

---

## 3. Kien truc tong the

De xuat theo mo hinh 3 lop:

1. **Frontend (VueJS)**  
   Cung cap giao dien web cho nguoi dung.

2. **Backend API (Java Spring Boot)**  
   Xu ly nghiep vu, xac thuc, phan quyen, cung cap REST API.

3. **Database + Job dong bo du lieu**  
   Luu tru nguoi dung, gia hien tai, lich su gia, nguon du lieu.

### 3.1 So do luong tong quan

```text
[User Browser]
      |
      v
[VueJS Frontend]
      |
      v
[Spring Boot Backend]
   |        |         |
   |        |         +--> [OAuth2 Google/Facebook]
   |        |
   |        +------------> [PostgreSQL/MySQL]
   |
   +---------------------> [Scheduler / Import Service / External Price Sources]
```

### 3.2 Nguyen tac thiet ke

- FE va BE tach rieng de de scale va trien khai.
- Backend giu vai tro trung tam cho:
  - Dang nhap OAuth2.
  - Quan ly session/token.
  - Chuan hoa du lieu gia.
- Du lieu gia can tach:
  - Du lieu hien tai.
  - Du lieu lich su.
- De mo rong sau nay:
  - Them nha cung cap OAuth2.
  - Them loai hang hoa khac.
  - Them notification/email/telegram.

---

## 4. Thiet ke Frontend - VueJS

### 4.1 Cong nghe de xuat

- Vue 3
- Vite
- Vue Router
- Pinia
- Axios
- ECharts hoac Chart.js
- TailwindCSS hoac Vuetify

### 4.2 Cau truc thu muc FE de xuat

```text
frontend/
  src/
    api/
      auth.js
      goldPrice.js
      fuelPrice.js
      user.js
    assets/
    components/
      common/
        AppHeader.vue
        AppFooter.vue
        LoadingSpinner.vue
      dashboard/
        SummaryCard.vue
        PriceChart.vue
        FilterPanel.vue
      auth/
        LoginSocialButtons.vue
    composables/
      useAuth.js
      usePriceFilter.js
    layouts/
      MainLayout.vue
      AuthLayout.vue
    router/
      index.js
    stores/
      authStore.js
      goldPriceStore.js
      fuelPriceStore.js
    views/
      HomeView.vue
      GoldPriceView.vue
      FuelPriceView.vue
      WatchlistView.vue
      ProfileView.vue
      LoginView.vue
      NotFoundView.vue
    utils/
      format.js
      constants.js
    App.vue
    main.js
```

### 4.3 Man hinh can xay dung

#### a. Trang chu / Dashboard

- Hien thi gia vang noi bat.
- Hien thi gia xang dau noi bat.
- Bieu do bien dong gan day.
- Bo loc thoi gian.
- Section tin tuc/ghi chu cap nhat neu can.

#### b. Trang gia vang

- Bang gia theo tung loai vang.
- Bieu do lich su.
- Bo loc theo khu vuc/thuong hieu neu mo rong.

#### c. Trang gia xang dau

- Bang gia theo tung loai nhien lieu.
- So sanh gia hien tai va ky truoc.
- Bieu do bien dong.

#### d. Trang dang nhap

- Nut "Dang nhap voi Google".
- Nut "Dang nhap voi Facebook".
- Hien trang thai redirect dang nhap.

#### e. Trang ho so ca nhan

- Hien thong tin user.
- Nha cung cap dang nhap.
- Danh sach muc theo doi yeu thich.

### 4.4 Routing de xuat

```text
/                      -> Dashboard
/gold                  -> Gia vang
/fuel                  -> Gia xang dau
/watchlist             -> Danh sach theo doi (can dang nhap)
/profile               -> Ho so nguoi dung (can dang nhap)
/login                 -> Dang nhap
/oauth2/callback       -> Xu ly callback sau dang nhap
```

### 4.5 Quan ly state

Tach store theo chuc nang:

- `authStore`
  - user
  - accessToken hoac session state
  - isAuthenticated
- `goldPriceStore`
  - latestPrices
  - historyData
  - filters
- `fuelPriceStore`
  - latestPrices
  - historyData
  - filters

### 4.6 Luong dang nhap tren FE

Co 2 cach:

#### Cach 1 - Backend OAuth2 login (de xuat)

- User bam nut login Google/Facebook.
- FE redirect den backend:
  - `/oauth2/authorization/google`
  - `/oauth2/authorization/facebook`
- Backend xu ly OAuth2, sau khi thanh cong redirect ve FE:
  - `/oauth2/callback?token=...`
- FE luu token va goi API lay profile.

#### Cach 2 - FE nhan access token roi gui ve backend

Khong uu tien cho giai doan dau vi:

- Phuc tap hon trong xac minh token.
- Tang rui ro bao mat tren client.

=> **Nen dung Cach 1** de backend kiem soat toan bo luong dang nhap.

---

## 5. Thiet ke Backend - Java

### 5.1 Cong nghe de xuat

- Java 17+
- Spring Boot
- Spring Web
- Spring Security
- Spring OAuth2 Client
- Spring Data JPA
- PostgreSQL hoac MySQL
- Lombok
- Validation
- MapStruct (tuy chon)
- Flyway hoac Liquibase

### 5.2 Cau truc thu muc BE de xuat

```text
backend/
  src/main/java/com/example/pricetracker/
    config/
      SecurityConfig.java
      CorsConfig.java
      OAuth2LoginSuccessHandler.java
      JwtConfig.java
    controller/
      AuthController.java
      GoldPriceController.java
      FuelPriceController.java
      UserController.java
      WatchlistController.java
      AdminImportController.java
    service/
      AuthService.java
      GoldPriceService.java
      FuelPriceService.java
      UserService.java
      WatchlistService.java
      ImportPriceService.java
    repository/
      UserRepository.java
      RoleRepository.java
      GoldPriceRepository.java
      FuelPriceRepository.java
      PriceHistoryRepository.java
      WatchlistRepository.java
    entity/
      User.java
      Role.java
      OAuthAccount.java
      GoldPrice.java
      FuelPrice.java
      PriceHistory.java
      Watchlist.java
      DataSource.java
    dto/
      response/
      request/
    security/
      CustomOAuth2UserService.java
      CustomUserPrincipal.java
      JwtAuthenticationFilter.java
    scheduler/
      PriceSyncScheduler.java
    client/
      GoldPriceSourceClient.java
      FuelPriceSourceClient.java
    exception/
      GlobalExceptionHandler.java
```

### 5.3 Chia module chuc nang

#### a. Auth module

- Dang nhap bang Google/Facebook.
- Tao JWT hoac session sau khi dang nhap thanh cong.
- Lay thong tin user hien tai.
- Dang xuat.

#### b. User module

- Quan ly thong tin user.
- Mapping user voi provider OAuth2.

#### c. Gold price module

- Lay gia vang hien tai.
- Lay lich su gia vang.
- Loc theo loai.

#### d. Fuel price module

- Lay gia xang dau hien tai.
- Lay lich su gia xang dau.
- So sanh theo moc thoi gian.

#### e. Watchlist module

- Luu danh sach gia nguoi dung quan tam.
- Hien thi nhanh tren dashboard.

#### f. Admin import module

- Goi scheduler de dong bo du lieu.
- Trigger import thu cong.
- Ghi log ket qua import.

---

## 6. OAuth2 voi Google va Facebook

### 6.1 Luong dang nhap de xuat

1. User truy cap FE.
2. Bam login voi Google/Facebook.
3. FE redirect sang backend endpoint OAuth2.
4. Backend chuyen huong den Google/Facebook.
5. Sau khi user chap nhan:
   - Provider tra code ve backend.
6. Backend lay thong tin user tu provider.
7. Backend kiem tra:
   - User da ton tai chua.
   - Provider account da lien ket chua.
8. Backend tao hoac cap nhat user.
9. Backend phat hanh JWT hoac tao session.
10. Backend redirect ve FE callback.

### 6.2 Bang du lieu lien quan

#### `users`

- id
- email
- full_name
- avatar_url
- status
- created_at
- updated_at

#### `oauth_accounts`

- id
- user_id
- provider (`google`, `facebook`)
- provider_user_id
- provider_email
- access_token_hash (neu can luu)
- created_at
- updated_at

### 6.3 Bao mat can luu y

- Khong tin du lieu tu FE ma phai xac minh o backend.
- Dung HTTPS khi deploy.
- Gioi han redirect URI chinh xac.
- Ma hoa/khong luu raw token provider.
- Dung JWT ngan han neu theo token-based auth.
- Neu dung refresh token, luu an toan trong DB hoac cookie HttpOnly.
- CORS chi cho phep domain frontend hop le.

### 6.4 Chien luoc auth de xuat

**Lua chon de xuat:** Backend tra JWT cho FE.

- Access token song ngan.
- Refresh token co the dung de gia han.
- FE gui `Authorization: Bearer <token>`.

Hoac:

- Dung cookie HttpOnly + SameSite phu hop.
- Cac API duoc bao ve bang Spring Security.

Neu uu tien don gian giai doan dau:

- OAuth2 login -> backend tao JWT -> redirect ve FE callback.

---

## 7. Thiet ke du lieu

### 7.1 Bang gia vang

#### `gold_prices`

- id
- code
- name
- buy_price
- sell_price
- currency
- source_id
- effective_time
- created_at

Vi du:

- SJC_HCM
- SJC_HN
- GOLD_9999
- GOLD_RING_24K

### 7.2 Bang gia xang dau

#### `fuel_prices`

- id
- code
- name
- price
- unit
- source_id
- effective_time
- created_at

Vi du:

- RON95_III
- E5_RON92_II
- DIESEL
- KEROSENE

### 7.3 Bang lich su gia

Co 2 cach:

#### Cach 1 - Tach bang lich su rieng cho tung nhom

- `gold_price_history`
- `fuel_price_history`

#### Cach 2 - Dung bang tong hop

`price_history`

- id
- item_type (`gold`, `fuel`)
- item_code
- old_value
- new_value
- changed_at
- source_id

**De xuat:**  
Neu nghiep vu don gian, co the tach `gold_price_history` va `fuel_price_history` de query de hieu hon.

### 7.4 Bang danh sach theo doi

#### `watchlists`

- id
- user_id
- item_type
- item_code
- created_at

---

## 8. API de xuat

### 8.1 Auth API

#### Lay thong tin user dang nhap

```http
GET /api/auth/me
```

Response:

```json
{
  "id": 1,
  "email": "user@gmail.com",
  "fullName": "Nguyen Van A",
  "avatarUrl": "https://...",
  "provider": "google"
}
```

#### Dang xuat

```http
POST /api/auth/logout
```

### 8.2 Gold price API

#### Lay gia vang moi nhat

```http
GET /api/gold-prices/latest
```

#### Lay lich su gia vang

```http
GET /api/gold-prices/history?code=SJC_HCM&from=2026-04-01&to=2026-04-30
```

### 8.3 Fuel price API

#### Lay gia xang dau moi nhat

```http
GET /api/fuel-prices/latest
```

#### Lay lich su gia xang dau

```http
GET /api/fuel-prices/history?code=RON95_III&from=2026-04-01&to=2026-04-30
```

### 8.4 Watchlist API

#### Lay danh sach theo doi

```http
GET /api/watchlists
```

#### Them muc theo doi

```http
POST /api/watchlists
Content-Type: application/json
```

```json
{
  "itemType": "gold",
  "itemCode": "SJC_HCM"
}
```

#### Xoa muc theo doi

```http
DELETE /api/watchlists/{id}
```

### 8.5 Admin import API

#### Trigger dong bo gia

```http
POST /api/admin/import/prices
```

---

## 9. Nguon du lieu gia

Can xac dinh ro nguon du lieu ngay tu dau. Co 3 huong:

### Huong 1 - Nhap tay tu admin

- Don gian.
- Chu dong.
- Phu hop giai doan MVP.

### Huong 2 - Crawl/API tu ben thu ba

- Tu dong hoa.
- Can xu ly thay doi cau truc nguon.
- Rui ro phu thuoc ben ngoai.

### Huong 3 - Ket hop

- Mac dinh dong bo tu dong.
- Loi thi admin co the nhap tay.

**De xuat:**  
Bat dau voi **Huong 3** neu co nguon on dinh, neu chua co nguon thi di bang **Huong 1** truoc.

---

## 10. Scheduler va dong bo du lieu

### 10.1 Job de xuat

- Dong bo gia vang theo lich.
- Dong bo gia xang dau theo lich.
- Ghi log ket qua.
- Canh bao khi import that bai nhieu lan lien tiep.

### 10.2 Luong xu ly

1. Scheduler kich hoat job.
2. Goi client lay du lieu.
3. Parse va chuan hoa du lieu.
4. So sanh voi gia gan nhat.
5. Luu gia moi vao bang hien tai.
6. Ghi lich su thay doi.
7. Ghi log import.

---

## 11. Bao mat va phan quyen

### 11.1 Vai tro

- `ROLE_USER`
  - Xem du lieu cong khai.
  - Quan ly watchlist.
  - Xem profile.

- `ROLE_ADMIN`
  - Import du lieu.
  - Quan ly danh muc.
  - Xem log he thong.

### 11.2 Cac diem can bao ve

- Endpoint admin phai co role.
- Rate limit voi login/API neu can.
- Validate input o controller.
- Ghi audit log voi cac thao tac admin.

---

## 12. Trien khai va moi truong

### 12.1 Moi truong

- local
- staging
- production

### 12.2 Bien moi truong backend

Vi du:

```env
SERVER_PORT=8080
DB_URL=jdbc:postgresql://localhost:5432/price_tracker
DB_USERNAME=postgres
DB_PASSWORD=secret

GOOGLE_CLIENT_ID=xxx
GOOGLE_CLIENT_SECRET=xxx
FACEBOOK_CLIENT_ID=xxx
FACEBOOK_CLIENT_SECRET=xxx

JWT_SECRET=xxx
FRONTEND_URL=http://localhost:5173
```

### 12.3 CORS

- local: cho phep `http://localhost:5173`
- production: chi cho phep domain FE chinh thuc

---

## 13. Lo trinh implement de xuat

### Giai doan 1 - Khoi tao nen tang

- Tao project FE Vue 3 + Vite.
- Tao project BE Spring Boot.
- Cau hinh database.
- Cau hinh Spring Security + OAuth2 login Google/Facebook.
- Tao bang user, oauth account, role.

### Giai doan 2 - Nghiep vu gia co ban

- Tao API lay gia vang moi nhat.
- Tao API lay gia xang dau moi nhat.
- Tao giao dien dashboard.
- Tao trang chi tiet vang/xang dau.

### Giai doan 3 - Lich su va watchlist

- Luu lich su bien dong gia.
- Bieu do lich su.
- Watchlist theo user.

### Giai doan 4 - Van hanh

- Scheduler import du lieu.
- Trang admin import.
- Log va monitoring co ban.

### Giai doan 5 - Mo rong

- Notification khi gia vuot nguong.
- Bo loc nang cao.
- Xuat bao cao.
- Ho tro them nha cung cap dang nhap.

---

## 14. Checklist cong viec can lam

## 14.1 Frontend

- [ ] Khoi tao du an Vue 3 + Vite
- [ ] Cau hinh router
- [ ] Cau hinh Pinia
- [ ] Tao layout chung
- [ ] Tao dashboard
- [ ] Tao trang gia vang
- [ ] Tao trang gia xang dau
- [ ] Tao trang login
- [ ] Tao callback page xu ly token
- [ ] Tich hop API service
- [ ] Ve bieu do lich su
- [ ] Tao trang profile
- [ ] Tao trang watchlist

## 14.2 Backend

- [ ] Khoi tao du an Spring Boot
- [ ] Cau hinh Spring Security
- [ ] Cau hinh OAuth2 Google
- [ ] Cau hinh OAuth2 Facebook
- [ ] Tao entity user, role, oauth_account
- [ ] Tao entity gold_price, fuel_price
- [ ] Tao lich su gia
- [ ] Tao API auth/me
- [ ] Tao API gia vang
- [ ] Tao API gia xang dau
- [ ] Tao API watchlist
- [ ] Tao API admin import
- [ ] Cau hinh JWT hoac session
- [ ] Cau hinh CORS
- [ ] Them migration database

## 14.3 Van hanh

- [ ] Cau hinh environment
- [ ] Cau hinh logging
- [ ] Scheduler import gia
- [ ] Chuan bi file deploy
- [ ] Tao tai lieu API

---

## 15. De xuat huong khoi tao nhanh

Neu muon bat dau nhanh va an toan, nen lam theo thu tu nay:

1. Khoi tao backend Spring Boot voi:
   - Security
   - OAuth2 Client
   - JPA
   - PostgreSQL
2. Hoan thanh login Google truoc.
3. Them Facebook login sau khi luong login Google chay on.
4. Tao 2 API doc du lieu mau:
   - `/api/gold-prices/latest`
   - `/api/fuel-prices/latest`
5. Khoi tao FE Vue de hien thi dashboard.
6. Tich hop auth va profile.
7. Sau do moi them history, watchlist, import scheduler.

---

## 16. Ket luan

He thong nen duoc xay dung theo huong:

- FE VueJS tach rieng, toi uu hien thi dashboard va chart.
- BE Java Spring Boot xu ly nghiep vu va OAuth2.
- Dang nhap qua Google/Facebook duoc backend kiem soat.
- Du lieu gia tach thanh gia hien tai va lich su de de query va mo rong.
- Uu tien MVP truoc: dang nhap, dashboard, API gia hien tai, sau do moi mo rong lich su, watchlist va scheduler.

Tai lieu nay co the dung lam:

- ban thiet ke tong quan,
- checklist chia task cho FE/BE,
- co so de tiep tuc tao source code cho du an.
