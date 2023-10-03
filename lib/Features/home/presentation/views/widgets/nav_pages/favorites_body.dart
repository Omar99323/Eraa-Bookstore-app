import 'package:book_store_eraa/Core/utils/app_styles.dart';
import 'package:book_store_eraa/Features/home/data/models/book_model.dart';
import 'package:book_store_eraa/Features/home/presentation/manager/cubit/home_state.dart';
import 'package:book_store_eraa/Features/home/presentation/views/widgets/wishbook_componant.dart';
import 'package:flutter/material.dart';

class FavoritesBody extends StatelessWidget {
  const FavoritesBody({
    super.key,
    required this.wishlistBooks,
  });

  final List<BookModel> wishlistBooks;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: HomeStates is HomeWishListBooksLoading
            ? const Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : ListView.separated(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: wishlistBooks.isEmpty ? 1 : wishlistBooks.length,
                itemBuilder: (context, index) => wishlistBooks.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 300),
                        child: Text(
                          'No books in favorites for now!',
                          textAlign: TextAlign.center,
                          style: AppStyles.textStyle34w900,
                        ),
                      )
                    : wishlistBooks.length == 1
                        ? WishBookComponant(
                            bookModel: wishlistBooks[0],
                          )
                        : WishBookComponant(
                            bookModel: wishlistBooks[index],
                          ),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 20),
              ),
      ),
    );
  }
}
