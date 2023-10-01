// ignore_for_file: missing_required_param
import 'package:book_store_eraa/Core/helpers/api.dart';
import 'package:book_store_eraa/Core/helpers/secure_storage.dart';
import 'package:book_store_eraa/Core/utils/endpoints.dart';
import 'package:book_store_eraa/Features/home/data/models/book_model.dart';
import 'package:book_store_eraa/Features/home/data/models/category_model.dart';
import 'package:book_store_eraa/Features/home/data/models/user_model.dart';
import 'package:book_store_eraa/Features/home/presentation/manager/cubit/home_state.dart';
import 'package:book_store_eraa/Features/home/presentation/views/widgets/nav_pages/Favorites_body.dart';
import 'package:book_store_eraa/Features/home/presentation/views/widgets/nav_pages/books_body.dart';
import 'package:book_store_eraa/Features/home/presentation/views/widgets/nav_pages/cart_body.dart';
import 'package:book_store_eraa/Features/home/presentation/views/widgets/nav_pages/home_body.dart';
import 'package:book_store_eraa/Features/home/presentation/views/widgets/nav_pages/profile_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitial());

  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey();
  List<BookModel> listofBestSeller = [];
  List<BookModel> listofNewArrival = [];
  List<BookModel> allBooks = [];
  List<BookModel> searchBooks = [];
  List<String> slinderImgs = [];
  List<CategoryModel> listofCategories = [];
  UserModel? userModel;
  bool searching = false;
  String? token;
  int navindex = 0;

  searchin() {
    searching = true;
    emit(HomeSearching());
  }
  endSearchin() {
    searching = false;
    emit(HomeSearching());
  }

  changeIndex(int index) {
    navindex = index;
    emit(HomeBottomNavBar());
  }

  logout() async {
    token = await SecureStorage.getData(key: 'token');
    await Api.post(
      url: EndPoints.baseUrl + EndPoints.logoutEndpoint,
      token: token,
    ).then((value) {
      SecureStorage.deleteData(key: 'token');
      emit(HomeLogout());
    });
  }

  getUserModel() async {
    userModel == null;
    token = await SecureStorage.getData(key: 'token');
    await Api.get(
      url: EndPoints.baseUrl + EndPoints.userProfileEndpoint,
      token: token,
    ).then((value) {
      userModel = UserModel.fromJson(value['data']);
    });
    emit(HomeUserModel());
  }

  List<Widget> screens() => [
        HomeBody(
          scaffoldkey: scaffoldkey,
          slinderImages: slinderImgs,
          bestSellerBooks: listofBestSeller,
          newArrivalBooks: listofNewArrival,
          categories: listofCategories,
          userModel: userModel!,
        ),
        BooksBody(
          allBooks: allBooks,
          searchBooks: searchBooks,
        ),
        const FavoritesBody(),
        const CartBody(),
        ProfileBody(userModel: userModel!),
      ];

  getSliders() async {
    slinderImgs.clear();
    token = await SecureStorage.getData(key: 'token');
    await Api.get(
      url: EndPoints.baseUrl + EndPoints.slidersEndpoint,
      token: token,
    ).then((value) {
      for (var element in value['data']['sliders']) {
        slinderImgs.add(element['image']);
      }
    });
    emit(HomeSlinder());
  }

  getAllBooks() async {
    allBooks.clear();
    token = await SecureStorage.getData(key: 'token');
    await Api.get(
      url: EndPoints.baseUrl + EndPoints.allBooksEndpoint,
      token: token,
    ).then((value) {
      for (var element in value['data']['products']) {
        allBooks.add(BookModel.fromJson(element));
      }
    });
    emit(HomeAllBooks());
  }
  

  search({required String name}) async {
    searchBooks.clear();
    emit(HomeSearchLoading());
    token = await SecureStorage.getData(key: 'token');
    await Api.get(
      url: EndPoints.baseUrl + EndPoints.searchEndpoint + name,
      token: token,
    ).then((value) {
      for (var element in value['data']['products']) {
        searchBooks.add(BookModel.fromJson(element));
      }
    });
    emit(HomeSearchSuccess());
  }

  getBestSeller() async {
    listofBestSeller.clear();
    token = await SecureStorage.getData(key: 'token');
    await Api.get(
      url: EndPoints.baseUrl + EndPoints.bestSellersEndpoint,
      token: token,
    ).then((value) {
      for (var element in value['data']['products']) {
        listofBestSeller.add(BookModel.fromJson(element));
      }
    });
    emit(HomeBestSeller());
  }

  getNewArrival() async {
    listofNewArrival.clear();
    token = await SecureStorage.getData(key: 'token');
    await Api.get(
      url: EndPoints.baseUrl + EndPoints.newArrivalsEndpoint,
      token: token,
    ).then((value) {
      for (var element in value['data']['products']) {
        listofNewArrival.add(BookModel.fromJson(element));
      }
      emit(HomeNewArrival());
    });
  }

  getCategories() async {
    listofCategories.clear();
    token = await SecureStorage.getData(key: 'token');
    await Api.get(
      url: EndPoints.baseUrl + EndPoints.categoriesEndpoint,
      token: token,
    ).then((value) {
      for (var element in value['data']['categories']) {
        listofCategories.add(CategoryModel.fromJson(element));
      }
      emit(HomeCategories());
    });
  }
}
