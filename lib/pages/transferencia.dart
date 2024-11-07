// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:maqueta_deposito/config/rutas/routes.dart';
import 'package:maqueta_deposito/models/product.dart';
import 'package:maqueta_deposito/models/product2.dart';
import 'package:maqueta_deposito/widgets/custom_button.dart';
import 'package:maqueta_deposito/widgets/custom_form_dropdown.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class TransferenciaPage extends StatefulWidget {
  const TransferenciaPage({super.key});

  @override
  State<TransferenciaPage> createState() => _TransferenciaPageState();
}

class _TransferenciaPageState extends State<TransferenciaPage> {
  List listaAlmacenes = [
    'Almacen 1',
    'Almacen 2',
    'Almacen 3',
  ];
  late Product productoSeleccionado = Product.empty();
  List<Product> historial = [];
  String ticket = '';
  List<String> tickets = [];
  String? _barcode;
  String result = '';
  late bool visible;
  List<Product> product = [];
  int duracion = 30;
  bool arrancarContador = false;
  String token = '';
  List<Product> productosOffline = [];
  List<dynamic> productoScanner = [];
  List<dynamic> productoScannerVariante = [];
//   String modo = Config.MODO;
  final String _previousQuery = '';
  final TextEditingController cantidadController = TextEditingController();
  final TextEditingController ubicacionController = TextEditingController();

  List<dynamic> productosBuscados = [];
  bool estoyBuscando = true;

  List<Product2> productosMostrar = [
    Product2(nombre: 'Flores', cantidadPedida: 14, ubicacion: 'Gondola 12', cantidadPickeada: 0),
    Product2(nombre: 'Colores', cantidadPedida: 52, ubicacion: 'Gondola 2', cantidadPickeada: 0),
    Product2(nombre: 'Azucar', cantidadPedida: 32, ubicacion: 'Gondola 5', cantidadPickeada: 0),
  ];
  
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SafeArea(child: scaffoldScannerSearch(context, colors));
  }

  Scaffold  scaffoldScannerSearch(BuildContext context, ColorScheme colors) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Transferencia',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton.filledTonal(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(colors.primary)
          ),
          onPressed: () async {
            router.go('/almacen/menu');
          },
          icon: const Icon(Icons.arrow_back,),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        backgroundColor: colors.primary,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomDropdownFormMenu(
                hint: 'Seleccione Almacen Hasta',
                onChanged: (value) {setState(() {});},
                items: listaAlmacenes.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e)
                  );
                }).toList(),
              ),
              const SizedBox(height: 20,),
              Expanded(
                flex: 1,
                child: ListView.separated(
                  itemCount: productosMostrar.length,
                  itemBuilder: (context, i) {
                    var item = productosMostrar[i];
                    return CheckboxListTile(
                      value: item.isDisabled,
                      title: Text(item.nombre),
                      subtitle: Text('Stock: ${item.cantidadPedida.toString()}'),
                      onChanged: (value) {
                        setState(() {
                          item.isDisabled = value!;
                        });
                      }
                    );
                  }, 
                  separatorBuilder: (BuildContext context, int index) { 
                    return const Divider(
                      indent: 16,
                      endIndent: 16,
                    ); 
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            iconSize: 40,
              onPressed: () async {
                var res = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SimpleBarcodeScannerPage(),
                  ),
                );
                arrancarContador = false;
                if (res is String) {
                  result = res;
                  if (result != '-1') {
                    var productoAgregado = Product2.empty();
                    productoAgregado.nombre = result;
                    List<Product2> existeElProducto = productosMostrar.where((producto) => (producto.nombre == productoAgregado.nombre)).toList();
                    if (existeElProducto.isEmpty){
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('No existe el producto escaneado en el almacen seleccionado'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {
                      existeElProducto[0].isDisabled = !existeElProducto[0].isDisabled;
                    }
                    setState(() {});
                  }
                }
                setState(() {});
              },
              icon: const Icon(Icons.qr_code_2)
            ),
            CustomButton(
              tamano: 24,
              text: 'Transferir', 
              onPressed: () async {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Productos transeferidos correctamente.'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            )
        ],
      ),
    );
  }
}