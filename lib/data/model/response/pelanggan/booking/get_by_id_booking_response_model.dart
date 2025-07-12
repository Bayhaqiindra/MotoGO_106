import 'package:tugas_akhir/data/model/response/pelanggan/booking/add_booking_response_model.dart';

class GetBookingByIdResponseModel {
  final BookingData data;

  GetBookingByIdResponseModel({required this.data});

  factory GetBookingByIdResponseModel.fromJson(Map<String, dynamic> json) {
    return GetBookingByIdResponseModel(
      data: BookingData.fromJson(json),
    );
  }
}
