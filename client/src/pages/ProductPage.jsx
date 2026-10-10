import { useParams } from "react-router";
export default function ProductPage() {
  const { slug } = useParams();

  return (
    <section className="wrap">
      <h1 className="text-h1">San pham</h1>
      <p className="mt-[8px]">Slug dang xem: {slug}</p>
    </section>
  );
}
