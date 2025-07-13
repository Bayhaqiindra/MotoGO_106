import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tugas_akhir/core/components/custom_text_field.dart';
import 'package:tugas_akhir/core/components/buttons.dart';
import 'package:tugas_akhir/core/components/dropdown_service_picker.dart';
import 'package:tugas_akhir/data/model/request/pelanggan/booking/booking_request_model.dart';
import 'package:tugas_akhir/data/model/response/admin/service/get_all_service_response_model.dart';
import 'package:tugas_akhir/presentation/pelanggan/booking/bloc/booking_bloc.dart';
import 'package:tugas_akhir/presentation/pelanggan/booking/widget/map_page.dart';
import 'package:tugas_akhir/presentation/pelanggan/home/home_screen.dart';

class BookingFormScreen extends StatefulWidget {
  const BookingFormScreen({super.key});

  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pickupController = TextEditingController();
  final _notesController = TextEditingController();

  Datum? _selectedService;
  String? _latitude;
  String? _longitude;

  @override
  void initState() {
    super.initState();
    print('BookingFormScreen: initState called. Fetching services...');
    context.read<BookingBloc>().add(FetchServices());
  }

  @override
  void dispose() {
    print('BookingFormScreen: dispose called. Disposing controllers...');
    _pickupController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _selectLocation() async {
    print('BookingFormScreen: _selectLocation called. Navigating to MapPage...');
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MapPage()),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _pickupController.text = result['address'] ?? '';
        _latitude = result['latitude'];
        _longitude = result['longitude'];
        print('BookingFormScreen: Location selected:');
        print('  Address: ${result['address']}');
        print('  Latitude: ${result['latitude']}');
        print('  Longitude: ${result['longitude']}');
      });
    } else {
      print('BookingFormScreen: MapPage navigation returned null (no location selected).');
    }
  }

  void _submit() {
    print('BookingFormScreen: _submit called.');
    if (_formKey.currentState!.validate() &&
        _selectedService != null &&
        _latitude != null &&
        _longitude != null) {
      print('BookingFormScreen: All form fields are valid and required data is present.');
      final request = BookingRequestModel(
        serviceId: _selectedService!.serviceId!,
        pickupLocation: _pickupController.text,
        customerNotes: _notesController.text,
        latitude: _latitude!,
        longitude: _longitude!,
      );
      print('BookingFormScreen: Booking request created:');
      print('  Service ID: ${request.serviceId}');
      print('  Pickup Location: ${request.pickupLocation}');
      print('  Customer Notes: ${request.customerNotes}');
      print('  Latitude: ${request.latitude}');
      print('  Longitude: ${request.longitude}');
      context.read<BookingBloc>().add(SubmitBooking(request));
      print('BookingFormScreen: SubmitBooking event dispatched.');
    } else {
      print('BookingFormScreen: Form validation failed or missing data. Showing snackbar.');
      print('  Form Valid: ${_formKey.currentState!.validate()}');
      print('  Selected Service: ${_selectedService != null}');
      print('  Latitude: ${_latitude != null}');
      print('  Longitude: ${_longitude != null}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi semua data terlebih dahulu')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('BookingFormScreen: build method called.');
    return Scaffold(
      appBar: AppBar(title: const Text('Form Booking Service')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<BookingBloc, BookingState>(
          listener: (context, state) {
            print('BookingFormScreen: Bloc listener - current state: $state');
            if (state is BookingSuccess) {
              print('BookingFormScreen: BookingSuccess state received. Showing success snackbar and popping.');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Booking berhasil!')),
              );
              Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()), // Ganti HomeScreen() dengan widget Home Anda
      (Route<dynamic> route) => false, // Ini menghapus semua rute sebelumnya dari stack
    );
            } else if (state is BookingFailure) {
              print('BookingFormScreen: BookingFailure state received. Error: ${state.error}. Showing error snackbar.');
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.error)));
            }
          },
          builder: (context, state) {
            print('BookingFormScreen: Bloc builder - current state: $state');
            if (state is BookingLoading || state is BookingInitial) {
              print('BookingFormScreen: Displaying CircularProgressIndicator (Loading/Initial state).');
              return const Center(child: CircularProgressIndicator());
            }

            final List<Datum> services = (state is BookingLoaded) ? state.services : [];
            if (state is BookingLoaded) {
              print('BookingFormScreen: BookingLoaded state received. Services count: ${services.length}');
            }

            return Form(
              key: _formKey,
              child: ListView(
                children: [
                  DropdownServicePicker(
                    services: services,
                    selectedService: _selectedService,
                    onChanged: (val) {
                      setState(() {
                        _selectedService = val;
                        print('BookingFormScreen: Service selected: ${_selectedService?.serviceName ?? "None"}');
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: _selectLocation,
                    child: AbsorbPointer(
                      child: CustomTextField(
                        controller: _pickupController,
                        label: 'Lokasi Penjemputan (Pilih di Map)',
                        validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
                        suffixIcon: const Icon(Icons.map),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _notesController,
                    label: 'Catatan (opsional)',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  Button.filled(onPressed: _submit, label: 'Kirim Booking'),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}