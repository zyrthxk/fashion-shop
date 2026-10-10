import { createBrowserRouter } from "react-router";
import RootLayout from "./layouts/RootLayout.jsx";
import HomePage from "./pages/HomePage.jsx";
import CategoryPage from "./pages/CategoryPage.jsx";
import SearchPage from "./pages/SearchPage.jsx";
import ProductPage from "./pages/ProductPage.jsx";
import CartPage from "./pages/CartPage.jsx";
import CheckoutPage from "./pages/CheckoutPage.jsx";
import OrderResultPage from "./pages/OrderResultPage.jsx";
import AccountPage from "./pages/AccountPage.jsx";
import OrdersPage from "./pages/OrdersPage.jsx";
import OrderDetailPage from "./pages/OrderDetailPage.jsx";
import AddressesPage from "./pages/AddressesPage.jsx";
import LoginPage from "./pages/LoginPage.jsx";
import RegisterPage from "./pages/RegisterPage.jsx";
import ForgotPasswordPage from "./pages/ForgotPasswordPage.jsx";
import ResetPasswordPage from "./pages/ResetPasswordPage.jsx";
import NotFoundPage from "./pages/NotFoundPage.jsx";

export const router = createBrowserRouter([
  {
    path: "/",
    Component: RootLayout,
    children: [
      { index: true, Component: HomePage },
      { path: "danh-muc/:slug", Component: CategoryPage },
      { path: "tim-kiem", Component: SearchPage },
      { path: "san-pham/:slug", Component: ProductPage },
      { path: "gio-hang", Component: CartPage },
      { path: "thanh-toan", Component: CheckoutPage },
      { path: "dat-hang/thanh-cong", Component: OrderResultPage },
      { path: "tai-khoan", Component: AccountPage },
      { path: "tai-khoan/don-hang", Component: OrdersPage },
      { path: "tai-khoan/don-hang/:ma", Component: OrderDetailPage },
      { path: "tai-khoan/dia-chi", Component: AddressesPage },
      { path: "dang-nhap", Component: LoginPage },
      { path: "dang-ky", Component: RegisterPage },
      { path: "quen-mat-khau", Component: ForgotPasswordPage },
      { path: "dat-lai-mat-khau", Component: ResetPasswordPage },
      { path: "*", Component: NotFoundPage },
    ],
  },
]);
