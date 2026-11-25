class Urls {
  static const String _baseUrl = 'https://ecom-rs8e.onrender.com/api';

  // Auth
  static const String loginUrl = '$_baseUrl/auth/login';
  static const String signupUrl = '$_baseUrl/auth/signup';
  static const String verifyOtpUrl = '$_baseUrl/auth/verify-otp';
  static const String resendOtpUrl = '$_baseUrl/auth/resend-otp';
  static const String profileUrl = '$_baseUrl/auth/profile';

  // Home & Products
  static const String slidesUrl = '$_baseUrl/slides';
  static const String categoriesUrl = '$_baseUrl/categories';
  static const String productsUrl = '$_baseUrl/products';
  static String productByIdUrl(String id) => '$_baseUrl/products/id/$id';
  static String productsByCategory(String catId) => '$_baseUrl/products?category=$catId';
  static String productsByTag(String tag) => '$_baseUrl/products?tag=$tag';

  // Reviews
  static String reviewsByProduct(String productId) => '$_baseUrl/reviews?product=$productId';
  static const String createReviewUrl = '$_baseUrl/review';

  // Cart & Wishlist
  static const String cartUrl = '$_baseUrl/cart';
  static String cartItemUrl(String id) => '$_baseUrl/cart/$id';
  static const String wishlistUrl = '$_baseUrl/wishlist';
  static String wishlistItemUrl(String id) => '$_baseUrl/wishlist/$id';

  // Order & Payment
  static const String createOrderUrl = '$_baseUrl/order';
  static const String orderListUrl = '$_baseUrl/orders';
}