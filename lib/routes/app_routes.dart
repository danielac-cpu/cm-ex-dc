import 'package:flutter/material.dart';
import '../screen/auth/login_screen.dart';
import '../screen/auth/register_screen.dart';
import '../screen/home/home_screen.dart';
import '../screen/products/products_list_screen.dart';
import '../screen/products/product_edit_screen.dart';
import '../screen/products/product_detail_screen.dart';
import '../screen/categories/categories_list_screen.dart';
import '../screen/categories/category_edit_screen.dart';
import '../screen/categories/category_detail_screen.dart';
import '../screen/suppliers/suppliers_list_screen.dart';
import '../screen/suppliers/supplier_edit_screen.dart';
import '../screen/suppliers/supplier_detail_screen.dart';

class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';

  static const products = '/products';
  static const productEdit = '/products/edit';
  static const productDetail = '/products/detail';

  static const categories = '/categories';
  static const categoryEdit = '/categories/edit';
  static const categoryDetail = '/categories/detail';

  static const suppliers = '/suppliers';
  static const supplierEdit = '/suppliers/edit';
  static const supplierDetail = '/suppliers/detail';

  static Map<String, WidgetBuilder> routes = {
    login: (_) => const LoginScreen(),
    register: (_) => const RegisterScreen(),
    home: (_) => const HomeScreen(),

    products: (_) => const ProductsListScreen(),
    productEdit: (_) => const ProductEditScreen(),
    productDetail: (_) => const ProductDetailScreen(),

    categories: (_) => const CategoriesListScreen(),
    categoryEdit: (_) => const CategoryEditScreen(),
    categoryDetail: (_) => const CategoryDetailScreen(),

    suppliers: (_) => const SuppliersListScreen(),
    supplierEdit: (_) => const SupplierEditScreen(),
    supplierDetail: (_) => const SupplierDetailScreen(),
  };
}
