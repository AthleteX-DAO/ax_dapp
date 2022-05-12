import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ax_dapp/service/Controller/Controller.dart';
import 'package:ax_dapp/service/Controller/Farms/Farm.dart';
import 'package:ax_dapp/service/GraphQL/GysrApi.dart';

class FarmController extends GetxController {
  // declaration of member variables
  final String owner = "0xe1bf752fd7480992345629bf3866f6618d57a7da"; // this is the address of pool contract owner

  Controller controller = Get.find();
  RxList<Farm> allFarms = RxList.empty();
  RxList<Farm> stakedFarms = RxList.empty();
  RxList<Farm> filteredAllFarms = RxList.empty();
  RxList<Farm> filteredStakedFarms = RxList.empty();

  FarmController() {
    // initialize async variables
    initialize();
  }

  /// This function is used to initialize async variables
  ///
  /// @return {void}
  Future<void> initialize() async {
    GysrApi gApi = GysrApi();
    final QueryResult allFarmsResult = await gApi.getAllFarms(owner);

    if (allFarmsResult.hasException) {
      print(allFarmsResult.exception.toString());
      return;
    }

    if (allFarmsResult.data!['pools'] == null) {
      print("[Console] No farms");
      return;
    }

    for (dynamic pool in allFarmsResult.data!['pools']!) {
      allFarms.add(Farm(pool));
      filteredAllFarms.add(Farm(pool));
    }

    print("[Contract-Count] ${allFarms.length}");

    String account = controller.publicAddress.value.hex.toLowerCase();
    // account = "0x571f8e570efe1fb0ba8ff75f4749b629a471f458"; // staked account for test
    // account = "0x22b3e4b38fb2f260302787b18b1401747eacf8d4"; // staked account for test
    final QueryResult stakedFarmsResult = await gApi.getStakedFarms(account);
    
    if (stakedFarmsResult.hasException) {
      print(stakedFarmsResult.exception.toString());
      return;
    }

    if (stakedFarmsResult.data!['user'] == null) {
      print('[Console] No staked farms');
      return;
    }

    for(dynamic position in stakedFarmsResult.data!['user']!['positions']) {
      stakedFarms.add(Farm(position['pool']));
      filteredStakedFarms.add(Farm(position['pool']));
    }


}

  /// This function is used to filter farms using keyword
  /// 
  /// @param {String} keyword for filtering farms
  /// @return {void} 
  void filterFarms(String keyword) {
    print("filterFarms");
    filteredAllFarms = RxList(allFarms.where((farm) => farm.strName.toUpperCase().contains(keyword.toUpperCase())).toList());
    filteredStakedFarms = RxList(stakedFarms.where((farm) => farm.strName.toUpperCase().contains(keyword.toUpperCase())).toList());
  }
}
