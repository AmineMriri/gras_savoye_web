// Future<void> fetchDoctors(int page, int pageSize) async {
//   try {
//     selectedDbValue = await getSelectedValue();
//     setState(() {
//       isLoading = true;
//       isError = false;
//
//       // _currentPage = 1;
//       // _totalPages = 1;
//       // _totalCount = 0;
//     });
//
//     final listDoctorsResponse =
//      await doctorViewModel.getDoctors(page, pageSize,'backoffice_Gras_2');
//
//     // await doctorViewModel.getDoctors(page, pageSize, selectedDbValue!);
//     if (listDoctorsResponse.resCode == 1) {
//       setState(() {
//         doctorsList = listDoctorsResponse.doctors;
//         _totalPages = listDoctorsResponse.totalPages ?? 0;
//         _totalCount = listDoctorsResponse.totalCount ?? 0;
//         isLoading = false;
//         isError = false;
//       });
//     } else {
//       setState(() {
//         isLoading = false;
//         isError = true;
//       });
//     }
//   } catch (error) {
//     print("Error: $error");
//     setState(() {
//       isLoading = false;
//       isError = true;
//     });
//   }
// }