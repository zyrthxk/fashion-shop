#!/usr/bin/env bash
# =============================================================
#  Tạo nhãn, milestone, issue và GitHub Project cho dự án LANE
#  Chạy trong thư mục ~/projects/fashion-shop, SAU KHI đã push repo lên GitHub
#  Cách chạy:  bash scripts/setup-github.sh
# =============================================================
set -euo pipefail

REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner)
echo "Repo: $REPO"

# ---------- 1. Nhãn ----------
echo "== Tạo nhãn =="
gh label create frontend --color 1D76DB --description "Giao diện React" --force
gh label create backend  --color 0E8A16 --description "Express, MongoDB" --force
gh label create docs     --color C5DEF5 --description "Tài liệu, thiết kế" --force
gh label create setup    --color BFD4F2 --description "Cấu hình, công cụ" --force
gh label create learn    --color FBCA04 --description "Có kiến thức mới phải học" --force
gh label create bug      --color D73A4A --description "Lỗi" --force

# ---------- 2. Milestone: mỗi giai đoạn một cái ----------
# Lịch 6 ngày/tuần (nghỉ Chủ nhật), 4 tiếng/ngày, bắt đầu giai đoạn 1 vào thứ Hai 05/10/2026
# Hạn chót = 23:59 giờ Việt Nam = 16:59:59 UTC
echo "== Tạo milestone =="
create_ms() {
  gh api "repos/$REPO/milestones" \
    -f title="$1" -f due_on="$2T16:59:59Z" -f description="$3" > /dev/null
  echo "  ✓ $1  (hạn $2)"
}
create_ms "GĐ0 · Chuẩn bị"              2026-10-04 "User story, ERD, giao diện, API, repo"
create_ms "GĐ1 · Giao diện dữ liệu giả" 2026-10-14 "React + Vite, chưa có máy chủ"
create_ms "GĐ2 · API sản phẩm"          2026-10-24 "Express + MongoDB"
create_ms "GĐ3 · Nối frontend–backend"  2026-10-31 "fetch, async/await, TanStack Query"
create_ms "GĐ4 · Tài khoản, phân quyền" 2026-11-07 "JWT, bcrypt, cookie httpOnly"
create_ms "GĐ5 · Giỏ hàng, đặt hàng"    2026-11-18 "Transaction, tồn kho, mã giảm giá"
create_ms "GĐ6 · Thanh toán (MVP)"      2026-11-25 "COD, VNPay sandbox, IPN"
create_ms "GĐ7 · Trang quản trị"        2026-12-05 "CRUD, Cloudinary, dashboard"
create_ms "GĐ8 · Giữ chân khách"        2026-12-12 "Đánh giá, email, hiệu năng"
create_ms "GĐ9 · Kiểm thử, ra mắt"      2026-12-19 "Test, CI, Sentry, v1.0.0"

# ---------- 3. GitHub Project ----------
echo "== Tạo GitHub Project =="
PROJECT_NUM=$(gh project create --owner "@me" --title "LANE · Web thời trang" --format json --jq .number)
gh project link "$PROJECT_NUM" --owner "@me" --repo "$REPO" > /dev/null || true
echo "  ✓ Project số $PROJECT_NUM"

# ---------- 4. Issue ----------
# Chỉ tạo issue cho giai đoạn 0 (phần còn lại) và giai đoạn 1.
# Issue của giai đoạn sau sẽ tạo khi bắt đầu giai đoạn đó, để bảng việc không bị ngợp.
create_issue() {  # $1 tiêu đề, $2 nhãn, $3 milestone, $4 nội dung
  local url
  url=$(gh issue create --title "$1" --label "$2" --milestone "$3" --body "$4")
  gh project item-add "$PROJECT_NUM" --owner "@me" --url "$url" > /dev/null
  echo "  ✓ $1"
}

echo "== Tạo issue GĐ0 =="
M0="GĐ0 · Chuẩn bị"
create_issue "Cập nhật ERD theo api.md" "docs" "$M0" "$(cat <<'EOF'
Bổ sung các cột phát hiện ra khi viết `docs/api.md` (mục 13.4):

- [ ] CartItem: `priceAtAdd` int
- [ ] Address: `provinceCode` varchar(10), `wardCode` varchar(10)
- [ ] `OrderItem.size` đổi sang varchar(10)
- [ ] Xuất lại `docs/erd.png`

**Xong khi:** ERD khớp với api.md.
EOF
)"

echo "== Tạo issue GĐ1 =="
M1="GĐ1 · Giao diện dữ liệu giả"
create_issue "Design tokens, font và khung trang" "frontend,learn" "$M1" "$(cat <<'EOF'
- [ ] `src/styles/tokens.css`: màu, chữ, khoảng cách theo `docs/design.md` mục 1
- [ ] Nhúng Be Vietnam Pro + Playfair Display (có bộ ký tự vietnamese)
- [ ] Cài React Router, tạo các route rỗng theo `design.md` mục 7
- [ ] Layout chung: chỗ cho Header, nội dung, Footer

**Học được:** JSX, component, props, React Router.
**Xong khi:** bấm qua lại giữa các route rỗng được, font tiếng Việt hiển thị đúng.
EOF
)"
create_issue "Dữ liệu giả products.js" "frontend" "$M1" "$(cat <<'EOF'
- [ ] `src/data/products.js`: khoảng 30 sản phẩm, cấu trúc **giống hệt** API 18 và 20 trong `docs/api.md`
- [ ] `src/data/categories.js`: dạng cây như API 16
- [ ] Ảnh tạm từ Unsplash

**Xong khi:** sau này thay file này bằng API thật mà không phải sửa component.
EOF
)"
create_issue "Header, Footer, ProductCard" "frontend,learn" "$M1" "$(cat <<'EOF'
Theo `docs/design.md` mục 3.3, 3.4, 3.5.

- [ ] Header desktop và mobile, menu lớn (#9), tự ẩn khi cuộn (#8)
- [ ] Footer
- [ ] ProductCard: đổi ảnh khi rê chuột (#6), nhãn MỚI / SALE / HẾT HÀNG
- [ ] Định dạng giá bằng `Intl.NumberFormat('vi-VN')`

**Học được:** props, render có điều kiện, `map`, `useState`, `useEffect` cho sự kiện cuộn.
EOF
)"
create_issue "Trang chủ" "frontend" "$M1" "$(cat <<'EOF'
Theo `docs/design.md` mục 4.1.

- [ ] Banner + chữ trồi theo dòng (#2)
- [ ] Dải chữ chạy (#5), danh mục, hàng mới về (vuốt ngang), lookbook (#4), bán chạy (#3)

**Học được:** cài và dùng thư viện Motion, `whileInView`, stagger.
EOF
)"
create_issue "Trang danh mục: lọc và sắp xếp" "frontend,learn" "$M1" "$(cat <<'EOF'
Theo `docs/design.md` mục 4.2.

- [ ] Lọc theo size, màu, khoảng giá bằng `filter`; sắp xếp bằng `sort`
- [ ] Bộ lọc ghi lên URL bằng `useSearchParams` (`?size=M&mau=den`)
- [ ] Lưới tự xếp lại khi lọc (#11)
- [ ] Bộ lọc dạng ngăn kéo trên mobile, trạng thái không có kết quả

**Học được:** `useSearchParams`, dữ liệu suy ra từ state (không lưu state thừa).
**Xong khi:** gửi link có bộ lọc cho người khác, mở ra đúng kết quả.
EOF
)"
create_issue "Tìm kiếm có debounce" "frontend" "$M1" "$(cat <<'EOF'
- [ ] Lớp tìm kiếm toàn màn hình (#10)
- [ ] Debounce 300ms. Dùng lại hàm debounce đã viết ở tuần 2, hoặc viết thành hook `useDebounce`
- [ ] Trang `/tim-kiem?q=` dùng chung giao diện trang danh mục

**Học được:** custom hook, closure trong thực tế.
EOF
)"
create_issue "Trang chi tiết sản phẩm" "frontend,learn" "$M1" "$(cat <<'EOF'
Theo `docs/design.md` mục 4.3.

- [ ] Ảnh: xếp dọc trên desktop, băng chuyền trên mobile, phóng to khi rê (#28)
- [ ] Chọn màu và size (#12); size hết hàng; dòng "Chỉ còn n sản phẩm"
- [ ] Ô số lượng không vượt tồn kho
- [ ] Ảnh biến hình từ thẻ sang trang chi tiết (#1)
- [ ] Thanh mua hàng dính đáy trên mobile (#29)

**Học được:** `useParams`, state phụ thuộc nhau (đổi màu thì kiểm tra lại size), View Transitions.
EOF
)"
create_issue "Giỏ hàng (localStorage)" "frontend,learn" "$M1" "$(cat <<'EOF'
Theo `docs/design.md` mục 3.6, 4.4.

- [ ] CartContext + `useReducer`: thêm, sửa số lượng, đổi size, xóa
- [ ] Lưu và đọc localStorage chỉ gồm `productId`, `sku`, `quantity` (giống API 27/28)
- [ ] Ngăn kéo giỏ (#16), bay vào giỏ (#13), số nảy (#14), xóa món (#17), thanh miễn phí ship (#19)
- [ ] Trang `/gio-hang`

**Học được:** Context, `useReducer`, `reduce` để tính tổng, spread để sửa mảng không thay đổi mảng cũ.
**Xong khi:** thêm áo, tải lại trang, giỏ vẫn còn.
EOF
)"
create_issue "Trang 404 và rà soát mobile" "frontend" "$M1" "$(cat <<'EOF'
- [ ] Trang 404 theo `docs/design.md` mục 4.10
- [ ] Kiểm tra mọi trang ở chiều rộng 375px, 768px, 1280px
- [ ] Tắt bớt chuyển động khi bật "giảm chuyển động" (mục 2.3)
- [ ] Dùng được toàn bộ bằng bàn phím
EOF
)"

echo ""
echo "Xong! Mở project: gh project view $PROJECT_NUM --owner @me --web"