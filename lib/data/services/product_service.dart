import '../../core/supabase/client.dart';
import '../../models/product.dart';

class ProductService {
  final _client = AppSupabase.client;
  static const String _tableName = 'products';

  /// Create a new product
  Future<Product> createProduct(Product product) async {
    final response = await _client
        .from(_tableName)
        .insert(product.toJson())
        .select()
        .single();
    return Product.fromJson(response);
  }

  /// Read all products
  Future<List<Product>> getProducts() async {
    final response = await _client
        .from(_tableName)
        .select()
        .order('name', ascending: true);
    
    return (response as List)
        .map((json) => Product.fromJson(json))
        .toList();
  }

  /// Read a single product by ID
  Future<Product?> getProductById(String id) async {
    final response = await _client
        .from(_tableName)
        .select()
        .eq('id', id)
        .maybeSingle();
    
    if (response == null) return null;
    return Product.fromJson(response);
  }

  /// Update an existing product
  Future<Product> updateProduct(String id, Map<String, dynamic> updates) async {
    final response = await _client
        .from(_tableName)
        .update(updates)
        .eq('id', id)
        .select()
        .single();
    return Product.fromJson(response);
  }

  /// Delete a product
  Future<void> deleteProduct(String id) async {
    await _client
        .from(_tableName)
        .delete()
        .eq('id', id);
  }

  /// Search products by category
  Future<List<Product>> getProductsByCategory(String category) async {
    final response = await _client
        .from(_tableName)
        .select()
        .eq('category', category);
    
    return (response as List)
        .map((json) => Product.fromJson(json))
        .toList();
  }
}
