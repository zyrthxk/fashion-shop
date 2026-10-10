import { Link, NavLink, Outlet, ScrollRestoration } from "react-router";
const menu = [
  { to: "/danh-muc/nam", label: "Nam" },
  { to: "/danh-muc/nu", label: "Nu" },
  { to: "/danh-muc/sale", label: "Sale" },
  { to: "/san-pham/ao-thun-basic", label: "Thu trang SP" },
];

export default function RootLayout() {
  return (
    <>
      <header className="sticky top-0 z-50 border-b border-line bg-bg">
        <div className="wrap grid h-[72px] grid-cols-[1fr_auto_1fr] items-center">
          <nav className="flex gap-[24px] text-sm">
            {menu.map((item) => (
              <NavLink
                key={item.to}
                to={item.to}
                className={({ isActive }) =>
                  isActive
                    ? "font-semibold text-ink"
                    : "text-ink-2 transition-colors duration-120 ease-out hover:text-ink"
                }
              >
                {item.label}
              </NavLink>
            ))}
          </nav>

          <Link to="/" className="text-[20px] font-semibold tracking-[0.3em]">
            LANE
          </Link>

          <div className="flex justify-end gap-[24px] text-sm">
            <Link to="/tim-kiem">Tìm</Link>
            <Link to="/dang-nhap">Tài khoản</Link>
            <Link to="/gio-hang">Giỏ (0)</Link>
          </div>
        </div>
      </header>

      <main className="min-h-[70vh] py-[48px]">
        <Outlet />
      </main>

      <footer className="bg-ink py-[48px] text-sm text-on-ink">
        <div className="wrap">© 2026 LANE</div>
      </footer>

      <ScrollRestoration />
    </>
  );
}
