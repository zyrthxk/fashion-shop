import { Link } from "react-router";
export default function NotFoundPage() {
  return (
    <section className="wrap">
      <h1 className="text-h1">Không tìm thấy trang</h1>
      <p className="mt-[8px] text-ink-2">Trang bạn tìm không tồn tại hoặc đã bị xóa.</p>
      <Link to="/" className="mt-[16px] inline-block underline">
        Về trang chủ
      </Link>
    </section>
  );
}
