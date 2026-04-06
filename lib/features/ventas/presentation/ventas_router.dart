import 'package:go_router/go_router.dart';
import 'pages/ventas_list_page.dart';
import 'pages/registrar_venta_page.dart';
import 'pages/venta_detail_page.dart';

final ventasRoutes = [
  GoRoute(
    path: '/ventas',
    builder: (context, state) => const VentasListPage(),
    routes: [
      GoRoute(
        path: 'nuevo',
        builder: (context, state) => const RegistrarVentaPage(),
      ),
      GoRoute(
        path: ':id',
        builder: (context, state) {
          final ventaId = state.pathParameters['id']!;
          return VentaDetailPage(ventaId: ventaId);
        },
      ),
    ],
  ),
];
