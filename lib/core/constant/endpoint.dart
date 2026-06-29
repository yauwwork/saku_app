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
static String transactions(String userId) =>
    "$baseUrl/users/$userId/transaction";

static String transactionById(
  String userId,
  String transactionId,
) =>
    "$baseUrl/users/$userId/transaction/$transactionId";

static String updateTransaction(
  String userId,
  String transactionId,
) =>
    "$baseUrl/users/$userId/transaction/$transactionId";

static String deleteTransaction(
  String userId,
  String transactionId,
) =>
    "$baseUrl/users/$userId/transaction/$transactionId";
}