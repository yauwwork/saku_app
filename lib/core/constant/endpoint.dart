class Endpoint {
  Endpoint._();

  // ============================================================================
  // BASE URL
  // ============================================================================

  static const String baseUrl =
      "https://6a3e0e710443193a1a0b5852.mockapi.io";

  // ============================================================================
  // USERS
  // ============================================================================

  /// GET - Ambil semua user
  /// POST - Tambah user
  static const String users = "$baseUrl/users";

  /// GET - Detail user
  /// PUT - Update user
  /// DELETE - Hapus user
  static String userById(String id) => "$baseUrl/users/$id";

  // ============================================================================
  // TRANSACTION
  // ============================================================================

  /// GET - Ambil semua transaksi
  /// POST - Tambah transaksi
  static const String transactions = "$baseUrl/transaction";

  /// GET - Detail transaksi
  static String transactionById(String id) =>
      "$baseUrl/transaction/$id";

  /// PUT - Edit transaksi
  static String updateTransaction(String id) =>
      "$baseUrl/transaction/$id";

  /// DELETE - Hapus transaksi
  static String deleteTransaction(String id) =>
      "$baseUrl/transaction/$id";
}