import 'package:flutter/material.dart';
import 'package:tugas_akhir/data/model/response/admin/service/get_all_service_response_model.dart';

class DropdownServicePicker extends StatelessWidget {
  final List<Datum> services;
  final Datum? selectedService;
  final Function(Datum?) onChanged;

  const DropdownServicePicker({
    super.key,
    required this.services,
    required this.selectedService,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Datum>(
      value: selectedService,
      items: services
          .map(
            (service) => DropdownMenuItem(
              value: service,
              child: Text('${service.serviceName} - Rp${service.serviceCost}'),
            ),
          )
          .toList(),
      onChanged: onChanged,
      decoration: const InputDecoration(
        labelText: 'Pilih Layanan Service',
        border: OutlineInputBorder(),
      ),
      validator: (value) => value == null ? 'Pilih layanan terlebih dahulu' : null,
    );
  }
}
